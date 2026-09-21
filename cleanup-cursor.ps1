# ============================================================
# Cursor Deep Cache Cleanup
# Windows / PowerShell
#
# Keeps:
#   - Settings
#   - Extensions
#   - Login/account data
#
# Removes:
#   - Cursor cache
#   - GPU / Code cache
#   - Cached extension VSIX
#   - All local Chat / Agent history
# ============================================================

$ErrorActionPreference = "SilentlyContinue"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Cursor Deep Cache Cleanup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------------------------
# 1. Close Cursor completely
# ------------------------------------------------------------

Write-Host "[1/6] Closing Cursor..." -ForegroundColor Yellow

Get-Process Cursor,CursorHelper -ErrorAction SilentlyContinue |
    Stop-Process -Force

Start-Sleep -Seconds 2

# ------------------------------------------------------------
# 2. Define paths
# ------------------------------------------------------------

$cursorRoot = "$env:APPDATA\Cursor"
$globalStorage = "$cursorRoot\User\globalStorage"
$stateDb = "$globalStorage\state.vscdb"
$stateBackup = "$globalStorage\state.vscdb.backup"

$cachePaths = @(
    "$cursorRoot\Cache",
    "$cursorRoot\CachedData",
    "$cursorRoot\Code Cache",
    "$cursorRoot\GPUCache",
    "$cursorRoot\CachedExtensionVSIXs"
)

# ------------------------------------------------------------
# 3. Backup state.vscdb
# ------------------------------------------------------------

Write-Host "[2/6] Backing up Cursor database..." -ForegroundColor Yellow

if (Test-Path $stateDb) {

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $manualBackup = "$globalStorage\state.vscdb.manual-backup-$timestamp"

    Copy-Item `
        -Path $stateDb `
        -Destination $manualBackup `
        -Force

    Write-Host "Backup created:" -ForegroundColor Green
    Write-Host $manualBackup
}
else {
    Write-Host "state.vscdb not found." -ForegroundColor DarkYellow
}

# ------------------------------------------------------------
# 4. Remove normal Cursor caches
# ------------------------------------------------------------

Write-Host "[3/6] Cleaning Cursor cache..." -ForegroundColor Yellow

foreach ($path in $cachePaths) {

    if (Test-Path $path) {

        Write-Host "Removing: $path"

        Remove-Item `
            -Path $path `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }
}

# ------------------------------------------------------------
# 5. Remove old state.vscdb.backup
# ------------------------------------------------------------

Write-Host "[4/6] Removing old database backup..." -ForegroundColor Yellow

if (Test-Path $stateBackup) {

    Remove-Item `
        -Path $stateBackup `
        -Force `
        -ErrorAction SilentlyContinue

    Write-Host "Removed: $stateBackup" -ForegroundColor Green
}

# ------------------------------------------------------------
# 6. Clean Chat / Agent database
# ------------------------------------------------------------

Write-Host "[5/6] Cleaning Chat / Agent data..." -ForegroundColor Yellow

if (!(Test-Path $stateDb)) {

    Write-Host "state.vscdb does not exist. Skipping." -ForegroundColor DarkYellow

}
else {

    # Find sqlite3
    $sqlite = Get-Command sqlite3.exe -ErrorAction SilentlyContinue

    if (!$sqlite) {

        Write-Host ""
        Write-Host "sqlite3.exe was not found." -ForegroundColor Red
        Write-Host ""
        Write-Host "Install SQLite with:" -ForegroundColor Yellow
        Write-Host "winget install SQLite.SQLite" -ForegroundColor White
        Write-Host ""

    }
    else {

        Write-Host "Cleaning Agent / Chat records..." -ForegroundColor Cyan

        $sql = @"
PRAGMA journal_mode=DELETE;
BEGIN IMMEDIATE;

DELETE FROM cursorDiskKV
WHERE key LIKE 'agentKv:%';

DELETE FROM cursorDiskKV
WHERE key LIKE 'bubbleId:%';

DELETE FROM cursorDiskKV
WHERE key LIKE 'checkpointId:%';

COMMIT;

VACUUM;
"@

        $tempSql = Join-Path $env:TEMP "cursor_cleanup.sql"

        Set-Content `
            -Path $tempSql `
            -Value $sql `
            -Encoding UTF8

        & $sqlite.Source $stateDb ".read $tempSql"

        Remove-Item `
            $tempSql `
            -Force `
            -ErrorAction SilentlyContinue

        Write-Host "Chat / Agent data cleaned." -ForegroundColor Green
    }
}

# ------------------------------------------------------------
# Final
# ------------------------------------------------------------

Write-Host ""
Write-Host "[6/6] Cleanup finished." -ForegroundColor Green
Write-Host ""

Write-Host "Your settings, extensions and login data were NOT deleted." -ForegroundColor Green
Write-Host "Local Cursor Chat / Agent history was deleted." -ForegroundColor Yellow
Write-Host ""

Write-Host "Backup location:" -ForegroundColor Cyan
Get-ChildItem `
    "$globalStorage\state.vscdb.manual-backup-*" `
    -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName

Write-Host ""
Write-Host "You can now start Cursor again." -ForegroundColor Cyan
Write-Host ""