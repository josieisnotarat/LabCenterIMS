Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptPath = $MyInvocation.MyCommand.Path
if (-not $scriptPath) {
    throw 'Unable to resolve script path. Please run this script from a file (not pasted into the console).'
}

$RootDir = Split-Path -Parent (Split-Path -Parent $scriptPath)
Set-Location $RootDir

if (-not (Test-Path -Path 'package.json')) {
    Write-Host 'Creating package.json...'
    npm init -y | Out-Null
}

Write-Host 'Installing Electron and better-sqlite3...'
npm install electron better-sqlite3

Write-Host 'Installing @electron/rebuild...'
npm install -D @electron/rebuild

Write-Host 'Rebuilding better-sqlite3 for Electron...'
npx electron-rebuild -f -w better-sqlite3

Write-Host 'Setup complete. Run: npm start (or npx electron electron/main.js)'
