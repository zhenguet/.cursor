# Refresh claude-mem for the TMV workspace: ensure the worker is running, report hook status,
# and regenerate .cursor/rules/claude-mem-context.mdc from the current memory database.
# claude-mem has no folder indexer; observations are captured passively by Cursor hooks.

param(
    [string]$Project,
    [int]$Port = 37777
)

$ErrorActionPreference = "Stop"

$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not $Project) { $Project = Split-Path $WorkspaceRoot -Leaf }

$Bun = Join-Path $env:USERPROFILE ".bun\bin\bun.exe"
$WorkerCandidates = @(
    (Join-Path $env:USERPROFILE ".claude\plugins\marketplaces\thedotmack\plugin\scripts\worker-service.cjs"),
    (Get-ChildItem (Join-Path $env:USERPROFILE ".claude\plugins\cache\thedotmack\claude-mem\*\scripts\worker-service.cjs") -ErrorAction SilentlyContinue |
        Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName)
)
$Worker = $WorkerCandidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if (-not (Test-Path $Bun)) { Write-Error "bun not found at $Bun" }
if (-not $Worker) { Write-Error "claude-mem worker-service.cjs not found under ~/.claude/plugins" }

Set-Location $WorkspaceRoot
Write-Host "=== claude-mem update: $WorkspaceRoot (project: $Project) ===" -ForegroundColor Cyan

Write-Host "`n--- worker" -ForegroundColor Cyan
& $Bun $Worker start
if ($LASTEXITCODE -ne 0) { Write-Error "claude-mem start failed (exit $LASTEXITCODE)" }

Write-Host "`n--- cursor hooks" -ForegroundColor Cyan
& $Bun $Worker cursor status

$Base = "http://127.0.0.1:$Port"
$Web = New-Object System.Net.WebClient
$Web.Encoding = [System.Text.Encoding]::UTF8

$ready = $false
for ($i = 0; $i -lt 30 -and -not $ready; $i++) {
    try { $null = $Web.DownloadString("$Base/api/readiness"); $ready = $true }
    catch { Start-Sleep -Seconds 1 }
}
if (-not $ready) { Write-Error "Worker did not become ready on $Base within 30s" }

Write-Host "`n--- context file" -ForegroundColor Cyan
$context = $Web.DownloadString("$Base/api/context/inject?project=$([uri]::EscapeDataString($Project))")
if (-not $context.Trim()) { Write-Error "Worker returned empty context for project '$Project'" }

$RulesDir = Join-Path $WorkspaceRoot ".cursor\rules"
$ContextFile = Join-Path $RulesDir "claude-mem-context.mdc"
New-Item -ItemType Directory -Force -Path $RulesDir | Out-Null

$body = @"
---
alwaysApply: true
description: "Claude-mem context from past sessions (auto-updated)"
---

# Memory Context from Past Sessions

The following context is from claude-mem, a persistent memory system that tracks your coding sessions.

$context

---
*Updated after last session. Use claude-mem's MCP search tools for more detailed queries.*
"@
[System.IO.File]::WriteAllText($ContextFile, $body, (New-Object System.Text.UTF8Encoding $false))
Write-Host "Wrote $ContextFile"

Write-Host "`n--- observer health" -ForegroundColor Cyan
$HealthFile = Join-Path $env:USERPROFILE ".claude-mem\observer-health.json"
if (Test-Path $HealthFile) {
    $health = Get-Content $HealthFile -Raw | ConvertFrom-Json
    if ($health.consecutiveFailures -gt 0) {
        Write-Host "Observer failing ($($health.consecutiveFailures) consecutive): $($health.lastErrorMessage)" -ForegroundColor Yellow
        if ($health.lastErrorAction) { Write-Host "Action: $($health.lastErrorAction)" -ForegroundColor Yellow }
    } else {
        Write-Host "Observer healthy"
    }
}

Write-Host "`nDone." -ForegroundColor Green
