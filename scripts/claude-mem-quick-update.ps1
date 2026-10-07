# Ensure the claude-mem worker is running and report Cursor hook status for the TMV workspace.
# claude-mem has no folder indexer; prompts are captured passively by the user-level Cursor hooks.

param(
    [int]$Port = 37777
)

$ErrorActionPreference = "Stop"

$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path

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
Write-Host "=== claude-mem check: $WorkspaceRoot ===" -ForegroundColor Cyan

Write-Host "`n--- worker" -ForegroundColor Cyan
& $Bun $Worker start
if ($LASTEXITCODE -ne 0) { Write-Error "claude-mem start failed (exit $LASTEXITCODE)" }

Write-Host "`n--- cursor hooks" -ForegroundColor Cyan
& $Bun $Worker cursor status

$Base = "http://127.0.0.1:$Port"
$Web = New-Object System.Net.WebClient
$ready = $false
for ($i = 0; $i -lt 30 -and -not $ready; $i++) {
    try { $null = $Web.DownloadString("$Base/api/readiness"); $ready = $true }
    catch { Start-Sleep -Seconds 1 }
}
if (-not $ready) { Write-Error "Worker did not become ready on $Base within 30s" }

Write-Host "`nDone. Worker ready on $Base" -ForegroundColor Green
