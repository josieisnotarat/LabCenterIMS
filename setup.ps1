#requires -Version 5.1

[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [int]$SqlPort = 1433,
    [string]$DatabaseName = 'dbLabCenter',
    [string]$SqlAdminUser,
    [string]$SqlAdminPassword,
    [string]$AppDbUser = 'labcenter_app',
    [string]$AppDbPassword = 'LabCenter!AppPass'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-WarningMessage {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

$ScriptPath = $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptPath
Set-Location $RootDir

function Test-NodeJsAvailable {
    return [bool](Get-Command npm -ErrorAction SilentlyContinue)
}

function Add-NodeInstallPathsToPath {
    $candidateDirs = @(
        if ($env:ProgramFiles) { Join-Path $env:ProgramFiles 'nodejs' }
        if (${env:ProgramFiles(x86)}) { Join-Path ${env:ProgramFiles(x86)} 'nodejs' }
        if ($env:LocalAppData) { Join-Path $env:LocalAppData 'Programs\nodejs' }
    ) | Where-Object { $_ -and (Test-Path (Join-Path $_ 'npm.cmd')) }

    if (-not $candidateDirs) {
        return $false
    }

    $currentPathEntries = ($env:PATH -split ';') | Where-Object { $_ }
    $added = $false

    foreach ($dir in $candidateDirs) {
        $normalizedDir = $dir.TrimEnd('\')
        $alreadyPresent = $currentPathEntries | Where-Object { $_.TrimEnd('\\') -ieq $normalizedDir }
        if ($alreadyPresent) {
            continue
        }

        Write-Info "Temporarily adding Node.js directory '$dir' to PATH for this session."
        $env:PATH = "$dir;" + $env:PATH
        $added = $true
    }

    return $added
}

function Ensure-Command {
    param(
        [Parameter(Mandatory = $true)][string]$Command,
        [Parameter(Mandatory = $true)][string]$DisplayName
    )

    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        return
    }

    throw "Required command '$Command' was not found. Please install $DisplayName and then re-run this script."
}

function Get-CommandPath {
    param(
        [Parameter(Mandatory = $true)][string]$CommandName
    )

    $command = Get-Command $CommandName -ErrorAction SilentlyContinue
    if (-not $command) {
        return $null
    }

    $propertiesInPriorityOrder = @('Source', 'Path', 'Definition')
    foreach ($propertyName in $propertiesInPriorityOrder) {
        $property = $command.PSObject.Properties[$propertyName]
        if ($property -and $property.Value -and (Test-Path $property.Value)) {
            return $property.Value
        }
    }

    return $command.Name
}

function Ensure-NodeJs {
    if (Test-NodeJsAvailable) {
        return
    }

    $addedPath = Add-NodeInstallPathsToPath
    if (Test-NodeJsAvailable) {
        if ($addedPath) {
            Write-Info 'Detected an existing Node.js installation and added it to PATH for this session.'
        }
        return
    }

    Write-WarningMessage 'Node.js (npm) not detected. Attempting to install the LTS release via winget...'

    $wingetPath = Get-CommandPath 'winget'
    if (-not $wingetPath) {
        throw 'Node.js is required but could not be installed automatically because winget is unavailable. Install Node.js LTS from https://nodejs.org/en/download/ and re-run this script.'
    }

    $wingetArgs = @(
        'install',
        '--id', 'OpenJS.NodeJS.LTS',
        '-e',
        '--accept-package-agreements',
        '--accept-source-agreements'
    )

    Write-Info 'Installing Node.js LTS with winget. This may take a few minutes...'
    & $wingetPath @wingetArgs
    $wingetExitCode = $LASTEXITCODE

    $addedAfterInstall = Add-NodeInstallPathsToPath
    if (Test-NodeJsAvailable) {
        if ($wingetExitCode -ne 0) {
            Write-WarningMessage "winget reported exit code $wingetExitCode, but Node.js is now available. Continuing with setup."
        } elseif ($addedAfterInstall) {
            Write-Info 'Node.js installation completed and the install directory was added to PATH for this session.'
        } else {
            Write-Success 'Node.js installation completed.'
        }
        return
    }

    if ($wingetExitCode -ne 0) {
        throw "winget failed to install Node.js (exit code $wingetExitCode). Review the output above or install Node.js manually, then re-run this script."
    }

    throw 'Node.js installation completed but npm is still unavailable in this session. Close this PowerShell window, open a new one, and re-run the script (or install Node.js manually).'
}

Ensure-NodeJs
Ensure-Command -Command sqlcmd -DisplayName 'SQL Server Command Line Utilities (sqlcmd)'

if ([string]::IsNullOrWhiteSpace($SqlAdminUser)) {
    Write-Info 'Using Windows authentication for sqlcmd connections.'
    $authArgs = @('-E')
} else {
    if ([string]::IsNullOrWhiteSpace($SqlAdminPassword)) {
        throw 'You must provide -SqlAdminPassword when specifying -SqlAdminUser.'
    }
    Write-Info "Using SQL authentication for sqlcmd connections as '$SqlAdminUser'."
    $authArgs = @('-U', $SqlAdminUser, '-P', $SqlAdminPassword)
}

if ($SqlPort -le 0 -or $SqlPort -gt 65535) {
    throw 'SqlPort must be between 1 and 65535.'
}

$serverAddress = if ($SqlPort -eq 1433) { $SqlServer } else { "$SqlServer,$SqlPort" }

$SqlFile = Join-Path $RootDir 'LabCenterDatabase.sql'
if (-not (Test-Path $SqlFile)) {
    throw "Database script '$SqlFile' not found."
}

$escapedAppDbUserIdentifier = $AppDbUser -replace ']', ']]'
$escapedAppDbUserLiteral = $AppDbUser -replace "'", "''"
$escapedAppDbPasswordLiteral = $AppDbPassword -replace "'", "''"

Write-Info "Applying Lab Center database schema to '$serverAddress'..."
$sqlcmdArgs = @('-S', $serverAddress, '-b') + $authArgs + @('-i', $SqlFile)
& sqlcmd @sqlcmdArgs
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to apply the database schema. Review the sqlcmd output above for details.'
}
Write-Success 'Database schema applied successfully.'

$createLoginSql = @"
IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'$escapedAppDbUserLiteral')
BEGIN
    CREATE LOGIN [$escapedAppDbUserIdentifier] WITH PASSWORD = N'$escapedAppDbPasswordLiteral', CHECK_POLICY = OFF;
END;
"@

Write-Info "Ensuring SQL login '$AppDbUser' exists..."
$loginArgs = @('-S', $serverAddress, '-b') + $authArgs + @('-d', 'master', '-Q', $createLoginSql)
& sqlcmd @loginArgs
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to ensure the SQL login exists.'
}

$ensureUserSql = @"
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'$escapedAppDbUserLiteral')
BEGIN
    CREATE USER [$escapedAppDbUserIdentifier] FOR LOGIN [$escapedAppDbUserIdentifier];
END;
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    INNER JOIN sys.database_principals r ON r.principal_id = drm.role_principal_id AND r.name = N'db_owner'
    INNER JOIN sys.database_principals m ON m.principal_id = drm.member_principal_id AND m.name = N'$escapedAppDbUserLiteral'
)
BEGIN
    ALTER ROLE db_owner ADD MEMBER [$escapedAppDbUserIdentifier];
END;
"@

Write-Info "Granting database access for '$AppDbUser' on '$DatabaseName'..."
$grantArgs = @('-S', $serverAddress, '-b') + $authArgs + @('-d', $DatabaseName, '-Q', $ensureUserSql)
& sqlcmd @grantArgs
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to configure database permissions.'
}
Write-Success 'Database login configured.'

$envFile = Join-Path $RootDir '.env'
if (Test-Path $envFile) {
    $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $backupFile = "$envFile.bak.$timestamp"
    Write-WarningMessage ".env file already exists. Backing up to $backupFile."
    Copy-Item $envFile $backupFile -Force
}

$envContent = @"
DB_USER=$AppDbUser
DB_PASSWORD=$AppDbPassword
DB_SERVER=$SqlServer
DB_PORT=$SqlPort
DB_NAME=$DatabaseName
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=true
"@
$envContent | Set-Content -Path $envFile -Encoding UTF8
Write-Success "Wrote database connection settings to $envFile."

if (-not (Test-Path (Join-Path $RootDir 'node_modules'))) {
    Write-Info 'Installing Node.js dependencies (npm install)...'

    $npmExecutable = Get-CommandPath 'npm.cmd'
    if (-not $npmExecutable) {
        $npmExecutable = Get-CommandPath 'npm'
    }

    if (-not $npmExecutable) {
        throw 'npm could not be located even though Node.js should be installed. Install Node.js manually and re-run this script.'
    }

    & $npmExecutable 'install'
    if ($LASTEXITCODE -ne 0) {
        throw 'npm install failed. Review the output above for details.'
    }
    Write-Success 'Node dependencies installed.'
} else {
    Write-Info 'node_modules directory already present. Skipping npm install.'
}

Write-Info 'Starting the API server in a new PowerShell window...'
$escapedRootDirLiteral = $RootDir -replace "'", "''"
$startCommand = "Set-Location -LiteralPath '$escapedRootDirLiteral'; npm start"
Start-Process -FilePath 'powershell.exe' -ArgumentList '-NoExit', '-Command', $startCommand -WorkingDirectory $RootDir | Out-Null
Write-Success 'API server launch initiated.'

Write-Info 'Opening the Lab Center IMS in your default browser...'
Start-Sleep -Seconds 2
Start-Process 'http://localhost:3000/' | Out-Null

Write-Host ''
Write-Host 'Lab Center IMS setup complete.' -ForegroundColor Green
Write-Host 'If the browser does not open automatically, navigate to http://localhost:3000/'
Write-Host 'The API server is running in the separate PowerShell window that was launched by this script.'
