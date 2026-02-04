Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

if (-not (Test-Path -Path 'package.json')) {
    Write-Host 'Creating package.json...'
    npm init -y | Out-Null
}

Write-Host 'Installing Electron and better-sqlite3...'
npm install electron better-sqlite3

Write-Host 'Setup complete. Run: npx electron electron/main.js'
