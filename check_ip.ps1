# Load settings
$config = Get-Content -Path "settings.ini" | ConvertFrom-StringData
$rootPath = $config["Paths.rootPath"]
$blockedIpsFile = Join-Path -Path $rootPath -ChildPath $config["Paths.blockedIpsFile"]
$queueFile = Join-Path -Path $rootPath -ChildPath $config["Paths.queueFile"]
$hoursToCheck = [int]$config["Settings.hoursToCheck"]

$blockedIps = Get-Content -Path $blockedIpsFile | ForEach-Object {
    $fields = $_ -split ","
    [PSCustomObject]@{
        IP        = $fields[0]
        Timestamp = [datetime]::ParseExact($fields[1], "yyyy-MM-dd HH:mm:ss", $null)
    }
}

$currentTime = Get-Date

foreach ($ip in $blockedIps) {
    $timeBlocked = $currentTime - $ip.Timestamp
    if ($timeBlocked.TotalHours -ge $hoursToCheck) {
        $entry = "$($ip.IP),remove,$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        Add-Content -Path $queueFile -Value $entry
        Write-Output "Queued for removal: $entry"
    }
}