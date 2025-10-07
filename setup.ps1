#requires -Version 5.1

[CmdletBinding()]
param()

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

function Ensure-Command {
    param(
        [Parameter(Mandatory = $true)][string]$Command,
        [string]$WingetId,
        [string]$DisplayName
    )

    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        return
    }

    if ($WingetId -and (Get-Command winget -ErrorAction SilentlyContinue)) {
        if (-not $DisplayName) {
            $DisplayName = $Command
        }
        Write-Info "Installing $DisplayName via winget..."
        winget install --id $WingetId --source winget --accept-package-agreements --accept-source-agreements | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "winget failed to install $DisplayName. Please install it manually and then re-run this script."
        }
    } else {
        if (-not $DisplayName) {
            $DisplayName = $Command
        }
        throw "Required command '$Command' is not available. Please install $DisplayName and re-run this script."
    }

    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        throw "Failed to install '$DisplayName'. Please install it manually, then restart your terminal and re-run this script."
    }
}

Ensure-Command -Command npm -WingetId 'OpenJS.NodeJS.LTS' -DisplayName 'Node.js'
Ensure-Command -Command docker -WingetId 'Docker.DockerDesktop' -DisplayName 'Docker Desktop'

docker info | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw 'Docker is installed but the daemon does not appear to be running. Please start Docker Desktop and try again.'
}

if (-not (Test-Path 'node_modules') -or -not (Test-Path 'node_modules/express') -or -not (Test-Path 'node_modules/mssql')) {
    Write-Info 'Installing Node dependencies...'
    npm install | Out-Null
    Write-Success 'Node dependencies installed.'
} else {
    Write-Info 'Node dependencies already present. Skipping npm install.'
}

$DbContainerName = if (![string]::IsNullOrWhiteSpace($env:DB_CONTAINER_NAME)) { $env:DB_CONTAINER_NAME } else { 'labcenter-sql' }
$DbImage = if (![string]::IsNullOrWhiteSpace($env:DB_IMAGE)) { $env:DB_IMAGE } else { 'mcr.microsoft.com/mssql/server:2022-latest' }
$DefaultSaPassword = 'YourStrong(!)Password'
$SaPassword = if (![string]::IsNullOrWhiteSpace($env:SA_PASSWORD)) { $env:SA_PASSWORD } else { $DefaultSaPassword }
$DbPort = if (![string]::IsNullOrWhiteSpace($env:DB_PORT)) { $env:DB_PORT } else { '1433' }
$DbName = if (![string]::IsNullOrWhiteSpace($env:DB_NAME)) { $env:DB_NAME } else { 'dbLabCenter' }
$AppDbUser = if (![string]::IsNullOrWhiteSpace($env:APP_DB_USER)) { $env:APP_DB_USER } else { 'labcenter_app' }
$AppDbPassword = if (![string]::IsNullOrWhiteSpace($env:APP_DB_PASSWORD)) { $env:APP_DB_PASSWORD } else { 'LabCenter!AppPass' }
$SqlFile = Join-Path $RootDir 'LabCenterDatabase.sql'
$EnvFile = Join-Path $RootDir '.env'

if (-not (Test-Path $SqlFile)) {
    throw "Database script '$SqlFile' not found."
}

Write-Info "Ensuring SQL Server container '$DbContainerName' is running..."

function Test-ContainerExists {
    param([string]$Name)
    $containers = docker ps -a --format '{{.Names}}'
    return $containers -contains $Name
}

function Test-ContainerRunning {
    param([string]$Name)
    $containers = docker ps --format '{{.Names}}'
    return $containers -contains $Name
}

if (Test-ContainerExists -Name $DbContainerName) {
    if (Test-ContainerRunning -Name $DbContainerName) {
        Write-Info "Container '$DbContainerName' is already running."
    } else {
        Write-Info "Starting existing SQL Server container..."
        docker start $DbContainerName | Out-Null
        Write-Success 'Container started.'
    }
} else {
    Write-Info "Creating new SQL Server container '$DbContainerName'."
    docker run -d --name $DbContainerName -e 'ACCEPT_EULA=Y' -e "MSSQL_SA_PASSWORD=$SaPassword" -p "$DbPort:1433" $DbImage | Out-Null
    Write-Success 'SQL Server container created.'
}

Write-Info 'Waiting for SQL Server to be ready...'
$ready = $false
for ($attempt = 0; $attempt -lt 30; $attempt++) {
    docker exec $DbContainerName /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SaPassword -Q 'SELECT 1' | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $ready = $true
        break
    }
    Start-Sleep -Seconds 2
}

if (-not $ready) {
    throw 'SQL Server did not become ready in time.'
}
Write-Success 'SQL Server is ready.'

Write-Info 'Applying database schema and seed data...'
Get-Content -Raw $SqlFile | docker exec -i $DbContainerName /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SaPassword -d master -b | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to apply database schema.'
}
Write-Success 'Database schema applied.'

Write-Info "Ensuring application database login '$AppDbUser' exists..."
docker exec $DbContainerName /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SaPassword -d master -Q "IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'$AppDbUser') BEGIN CREATE LOGIN [$AppDbUser] WITH PASSWORD = '$AppDbPassword', CHECK_POLICY = OFF; END" | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to ensure SQL login.'
}

$ensureUserSql = @"
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'$AppDbUser') BEGIN
    CREATE USER [$AppDbUser] FOR LOGIN [$AppDbUser];
END;
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    INNER JOIN sys.database_principals r ON r.principal_id = drm.role_principal_id AND r.name = N'db_owner'
    INNER JOIN sys.database_principals m ON m.principal_id = drm.member_principal_id AND m.name = N'$AppDbUser'
)
BEGIN
    ALTER ROLE db_owner ADD MEMBER [$AppDbUser];
END;
"@

docker exec $DbContainerName /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SaPassword -d $DbName -Q $ensureUserSql | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to configure database user permissions.'
}
Write-Success 'Database login configured.'

if (Test-Path $EnvFile) {
    $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $backupFile = "$EnvFile.bak.$timestamp"
    Write-WarningMessage ".env file already exists. Backing up to $backupFile."
    Copy-Item $EnvFile $backupFile -Force
}

@"
DB_USER=$AppDbUser
DB_PASSWORD=$AppDbPassword
DB_SERVER=localhost
DB_PORT=$DbPort
DB_NAME=$DbName
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=true
"@ | Set-Content -Path $EnvFile -Encoding UTF8

Write-Success "Wrote database connection details to $EnvFile."

Write-Host 'Next steps:'
Write-Host '  1. Start the API server with: npm start'
Write-Host '  2. Visit http://localhost:3000/ to use the Lab Center IMS UI.'
Write-Host ''
Write-Host 'Default application login:'
Write-Host '  Username: admin'
Write-Host '  Password: password123'

Write-Success 'Lab Center IMS environment setup complete.'
