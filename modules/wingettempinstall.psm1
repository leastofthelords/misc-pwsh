function installscriptsecondpart {
    param (
        [string] $id,
        [string] $appname,
        [string] $version
    )

    try {
        Write-Host "Installing..."
        winget install --id $id --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null

        Write-Host "Waiting for app to start..."

        do {
            Start-Sleep -Seconds 1
            $tempprocess = Get-Process -ErrorAction SilentlyContinue -Name $appname
        } until ($tempprocess)

        Write-Host "Success! App installed." -ForegroundColor Green
    }
    catch {
        Write-Host "Install Failed: $_" -ForegroundColor Red
        return
    }

    # Attempt to launch app
    try {
        Start-Process "$appname.exe" -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Failed to launch app." -ForegroundColor Red
    }

    Write-Host "Waiting for app to close..."

    # Wait for process to end
    do {
        Start-Sleep -Seconds 1
        $tempprocess = Get-Process -ErrorAction SilentlyContinue -Name $appname
    } until (-not $tempprocess)

    # Uninstall silently
    try {
        winget uninstall --id $id --silent 2>&1 | Out-Null
        Write-Host "Successfully uninstalled:" -ForegroundColor Green -nonewline;
        Write-Host "$appname $version" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Failed uninstalling." -ForegroundColor Red
    }
}

function wingettempinstall {
    param (
        [bool] $debug = $false,
        [string] $usersearch
    )

    $esc = [char]27
    $yellow = "$esc[38;2;255;255;180m"

    # Search for app using winget
    $searchOutput = winget search --source winget --name $usersearch 2>$null
    if (-not $searchOutput) {
        Write-Host ""
        Write-Host "App not found or winget error." -ForegroundColor Red
        return
    }

    # Skip header lines
    $appLines = $searchOutput | Select-Object -Skip 2

    $appParsed = $null
    foreach ($line in $appLines) {
        if ($line -match '^(.{1,25})\s+([^\s]{1,40})\s+([\d\.]+)$') {
            $appParsed = @{
                Name = $matches[1].Trim()
                Id = $matches[2].Trim()
                Version = $matches[3].Trim()
            }
            break
        }
    }

    if (-not $appParsed) {
        Write-Host "Could not parse search results." -ForegroundColor Red
        return
    }

    $appname = $appParsed.Name
    $id = $appParsed.Id
    $version = $appParsed.Version


    Write-host " "
    Write-Host "Success! App found" -ForegroundColor Green
    Write-Host "ID:" -nonewline;
    Write-Host " $id" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Confirm temp installation: " -nonewline;
    Write-Host "$appname" -ForegroundColor Cyan -nonewline;
    Write-Host " Version:" -nonewline 
    Write-Host " $version" -ForegroundColor Cyan -nonewline
    Write-Host " [y/n]"

    $installconfirm = Read-Host -Prompt ":"
    Write-Host ""

    if ($installconfirm -eq 'y') {
        if ($debug -eq $true) {
            $logfile = "$env:TEMP\wingettempmodule_debug_log.txt"
            winget install --id $id --accept-package-agreements --accept-source-agreements --verbose-logs | Tee-Object -FilePath $logfile
            Start-Process $logfile
            Start-Process $appname
            installscriptsecondpart -id $id -appname $appname -version $version -yellow $yellow
        }
        else {
            installscriptsecondpart -id $id -appname $appname -version $version -yellow $yellow
        }
    }
    else {
        Write-Host "Cancelled." -ForegroundColor Red
    }
}

# Export the user-facing function only
Export-ModuleMember -Function wingettempinstall
