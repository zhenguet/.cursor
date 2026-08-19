# Quick rebuild: incremental update per registered GIT repo only.
# Never runs build/update against the workspace root (non-git folder scan).
# Respects git ls-files (gitignored paths excluded) + CRG DEFAULT_IGNORE.

$ErrorActionPreference = "Stop"

$WorkspaceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$DataDir = Join-Path $WorkspaceRoot ".code-review-graph"

$repoLines = & code-review-graph repos 2>&1 | Where-Object {
    $_ -is [string] -and $_.Trim() -ne ""
}

if (-not $repoLines) {
    Write-Error "No repositories registered. Run: code-review-graph register <path>"
}

$updated = 0
$skipped = 0

foreach ($line in $repoLines) {
    $repo = $line.Trim()
    $gitDir = Join-Path $repo ".git"
    $svnDir = Join-Path $repo ".svn"

    if (-not (Test-Path $gitDir) -and -not (Test-Path $svnDir)) {
        Write-Host "SKIP (not a VCS repo): $repo" -ForegroundColor Yellow
        $skipped++
        continue
    }

    if ($repo -eq $WorkspaceRoot) {
        Write-Host "SKIP (workspace root - use per-repo paths): $repo" -ForegroundColor Yellow
        $skipped++
        continue
    }

    Write-Host "`n=== update --skip-flows: $(Split-Path $repo -Leaf) ===" -ForegroundColor Cyan
    & code-review-graph update --repo $repo --data-dir $DataDir --skip-flows
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed: $repo (exit $LASTEXITCODE)"
    }
    $updated++
}

Write-Host "`nDone. Updated $updated repo(s), skipped $skipped." -ForegroundColor Green

