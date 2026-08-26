# Incremental AST-only graphify refresh for the TMV workspace graph.
# Requires an existing graphify-out/graph.json (run `/graphify .` once first).

$ErrorActionPreference = "Stop"

$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$GraphJson = Join-Path $WorkspaceRoot "graphify-out\graph.json"

if (-not (Test-Path $GraphJson)) {
    Write-Error "No graph at $GraphJson. Run once from workspace root: graphify . --code-only"
}

Set-Location $WorkspaceRoot
Write-Host "=== graphify update (AST-only): $WorkspaceRoot ===" -ForegroundColor Cyan
graphify update .
if ($LASTEXITCODE -ne 0) {
    Write-Error "graphify update failed (exit $LASTEXITCODE)"
}

Write-Host "`nDone. Graph updated at graphify-out/graph.json" -ForegroundColor Green
