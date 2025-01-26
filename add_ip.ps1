param (
    [string]$ip,
    [string]$action
)

# Load settings
$config = Get-Content -Path "settings.ini" | ConvertFrom-StringData
$rootPath = $config["Paths.rootPath"]
$queueFile = Join-Path -Path $rootPath -ChildPath $config["Paths.queueFile"]

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$entry = "$ip,$action,$timestamp"
Add-Content -Path $queueFile -Value $entry
Write-Output "Added entry: $entry"