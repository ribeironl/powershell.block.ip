# Load settings
$config = Get-Content -Path "settings.ini" | ConvertFrom-StringData
$rootPath = $config["Paths.rootPath"]
$queueFile = Join-Path -Path $rootPath -ChildPath $config["Paths.queueFile"]
$denyListFile = Join-Path -Path $rootPath -ChildPath $config["Paths.denyListFile"]
$externalDenyListFile = Join-Path -Path $rootPath -ChildPath $config["Paths.externalDenyListFile"]
$blockedIpsFile = Join-Path -Path $rootPath -ChildPath $config["Paths.blockedIpsFile"]

if (-Not (Test-Path -Path $queueFile)) {
    Write-Output "Queue file not found."
    exit
}

$queueEntries = Get-Content -Path $queueFile

# Clear the queue file after reading its content
Clear-Content -Path $queueFile

foreach ($entry in $queueEntries) {
    $fields = $entry -split ","
    $ip = $fields[0]
    $action = $fields[1]

    if ($action -eq "add") {
        Add-Content -Path $denyListFile -Value $ip
        Add-Content -Path $externalDenyListFile -Value $ip
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $blockedIpsFile -Value "$ip,$timestamp"
        Write-Output "Added IP to deny list and external deny list: $ip"
    } elseif ($action -eq "remove") {
        $denyList = Get-Content -Path $denyListFile
        $updatedDenyList = $denyList | Where-Object { $_ -ne $ip }
        Set-Content -Path $denyListFile -Value $updatedDenyList

        $externalDenyList = Get-Content -Path $externalDenyListFile
        $updatedExternalDenyList = $externalDenyList | Where-Object { $_ -ne $ip }
        Set-Content -Path $externalDenyListFile -Value $updatedExternalDenyList

        $blockedIps = Get-Content -Path $blockedIpsFile
        $updatedBlockedIps = $blockedIps | Where-Object { $_ -notmatch "^$ip," }
        Set-Content -Path $blockedIpsFile -Value $updatedBlockedIps

        Write-Output "Removed IP from deny list and external deny list: $ip"
    }
}