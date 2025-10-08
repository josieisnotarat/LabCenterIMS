#requires -Version 5.1

[CmdletBinding()]
param(
    [string]$SqlServer = 'localhost',
    [int]$SqlPort = 1433,
    [string]$DatabaseName = 'dbLabCenter',
    [string]$SqlAdminUser,
    [string]$SqlAdminPassword,
    [string]$AppDbUser = 'labcenter_app',
    [string]$AppDbPassword = 'LabCenter!AppPass',
    [switch]$InstallSqlServerExpress
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

function Get-SqlInstanceNameFromServer {
    param([string]$Server)

    if (-not $Server) {
        return 'MSSQLSERVER'
    }

    $serverWithoutProtocol = $Server -ireplace '^tcp:', ''
    if ($serverWithoutProtocol -match '\\([^,]+)') {
        return $Matches[1]
    }

    return 'MSSQLSERVER'
}

function Get-SqlServiceName {
    param([string]$InstanceName)

    if ([string]::IsNullOrWhiteSpace($InstanceName) -or $InstanceName -ieq 'MSSQLSERVER') {
        return 'MSSQLSERVER'
    }

    return "MSSQL`$$InstanceName"
}

function Wait-ForServiceRunning {
    param(
        [Parameter(Mandatory = $true)][System.ServiceProcess.ServiceController]$Service,
        [TimeSpan]$Timeout = [TimeSpan]::FromMinutes(2)
    )

    if ($Service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) {
        return
    }

    try {
        if ($Service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Stopped -or
            $Service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::StopPending) {
            Start-Service -InputObject $Service -ErrorAction Stop
            $Service.Refresh()
        }

        $Service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running, $Timeout)
    } catch {
        throw "Failed to start SQL Server service '$($Service.ServiceName)'. Ensure you have permission to start services and retry."
    }

    if ($Service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Running) {
        throw "SQL Server service '$($Service.ServiceName)' is not running after installation."
    }
}

function Install-SqlServerExpressInstance {
    param(
        [Parameter(Mandatory = $true)][string]$InstanceName
    )

    if ($InstanceName -ne 'SQLEXPRESS' -and $InstanceName -ne 'MSSQLSERVER') {
        throw "Automatic SQL Server installation only supports the default ('MSSQLSERVER') or SQLEXPRESS instances. Update the -SqlServer argument or install SQL Server manually."
    }

    $wingetPath = Get-CommandPath 'winget'
    if (-not $wingetPath) {
        throw 'SQL Server is not installed and winget is unavailable, so it cannot be installed automatically. Install SQL Server Express manually and re-run this script.'
    }

    $instanceArgument = if ($InstanceName -eq 'MSSQLSERVER') { '/INSTANCENAME=MSSQLSERVER' } else { "/INSTANCENAME=$InstanceName" }
    $overrideArgs = "/QS /IACCEPTSQLSERVERLICENSETERMS /ACTION=Install /FEATURES=SQLEngine $instanceArgument /SQLSVCACCOUNT=`"NT AUTHORITY\\NETWORK SERVICE`" /TCPENABLED=1 /NPENABLED=1"

    $wingetArgs = @(
        'install',
        '--id', 'Microsoft.SQLServer.2022.Express',
        '-e',
        '--accept-package-agreements',
        '--accept-source-agreements',
        '--silent',
        '--override',
        $overrideArgs
    )

    Write-Info 'Installing SQL Server 2022 Express via winget. This may take several minutes...'
    & $wingetPath @wingetArgs
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne 0) {
        throw "winget failed to install SQL Server Express (exit code $exitCode). Review the output above or install SQL Server manually."
    }

    Write-Success 'SQL Server Express installation completed.'
}

function Ensure-SqlServerInstance {
    param(
        [Parameter(Mandatory = $true)][string]$Server,
        [switch]$AllowInstall
    )

    $instanceName = Get-SqlInstanceNameFromServer -Server $Server
    $serviceName = Get-SqlServiceName -InstanceName $instanceName

    $service = $null
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop
    } catch {
        $service = $null
    }

    if (-not $service) {
        if (-not $AllowInstall) {
            return $false
        }

        Install-SqlServerExpressInstance -InstanceName $instanceName

        try {
            $service = Get-Service -Name $serviceName -ErrorAction Stop
        } catch {
            throw "SQL Server Express installation finished but service '$serviceName' was not found. Verify the installation or install SQL Server manually."
        }
    }

    Wait-ForServiceRunning -Service $service
    return $true
}

function Test-SqlServerConnection {
    param(
        [Parameter(Mandatory = $true)][string]$ServerAddress,
        [Parameter(Mandatory = $true)][string[]]$AuthArgs
    )

    $testArgs = @('-S', $ServerAddress, '-b', '-l', '5') + $AuthArgs + @('-d', 'master', '-Q', 'SELECT 1')
    & sqlcmd @testArgs 2>$null | Out-Null
    return $LASTEXITCODE -eq 0
}

function Write-SqlServerDiagnostics {
    $serviceNames = @('MSSQLSERVER', 'MSSQL$SQLEXPRESS')
    $detectedServices = @()

    foreach ($serviceName in $serviceNames) {
        try {
            $service = Get-Service -Name $serviceName -ErrorAction Stop
            if ($service) {
                $detectedServices += "${service.DisplayName} ($serviceName) - Status: $($service.Status)"
            }
        } catch {
            continue
        }
    }

    if ($detectedServices.Count -gt 0) {
        foreach ($serviceInfo in $detectedServices) {
            Write-WarningMessage "Detected SQL Server service: $serviceInfo"
        }
    } else {
        Write-WarningMessage 'No SQL Server Windows services were detected. Install SQL Server Developer or Express Edition and ensure the service is running.'
    }
}

if ($InstallSqlServerExpress -and -not $PSBoundParameters.ContainsKey('SqlServer')) {
    $SqlServer = 'localhost\SQLEXPRESS'
}

$instanceReady = Ensure-SqlServerInstance -Server $SqlServer -AllowInstall:$InstallSqlServerExpress
if (-not $instanceReady) {
    Write-WarningMessage "SQL Server service for '$SqlServer' was not found. Install SQL Server manually or re-run with -InstallSqlServerExpress to install SQL Server Express automatically."
}

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

if (-not (Test-SqlServerConnection -ServerAddress $serverAddress -AuthArgs $authArgs)) {
    Write-WarningMessage "Unable to establish a sqlcmd connection to '$serverAddress'."
    Write-WarningMessage 'Ensure SQL Server is installed, the service is running, and that the server name and port parameters are correct.'
    Write-WarningMessage "If you are using a named instance, re-run the script with -SqlServer 'localhost\\InstanceName' (for example localhost\\SQLEXPRESS) or specify -SqlPort when using a custom port."
    Write-WarningMessage 'You can manually test the connection by running: sqlcmd -S <server> -Q "SELECT 1"'
    Write-SqlServerDiagnostics
    throw 'SQL Server connection test failed. Start SQL Server and re-run this setup script.'
}

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

$envLines = [System.Collections.Generic.List[string]]::new()
$null = $envLines.Add("DB_USER=$AppDbUser")
$null = $envLines.Add("DB_PASSWORD=$AppDbPassword")
$null = $envLines.Add("DB_SERVER=$SqlServer")

$shouldIncludePort = $PSBoundParameters.ContainsKey('SqlPort') -or ($SqlServer -notmatch '\\')
if ($shouldIncludePort) {
    $null = $envLines.Add("DB_PORT=$SqlPort")
}

$null = $envLines.Add("DB_NAME=$DatabaseName")
$null = $envLines.Add('DB_ENCRYPT=false')
$null = $envLines.Add('DB_TRUST_SERVER_CERTIFICATE=true')

$envContent = [string]::Join([Environment]::NewLine, $envLines) + [Environment]::NewLine
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

    $npmCommandLine = "`"$npmExecutable`" install"
    $cmdArgs = @('/d', '/c', $npmCommandLine)
    & cmd.exe @cmdArgs
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
