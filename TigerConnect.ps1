$downloadUrl = "https://github.com/tigerconnect/desktop-app/releases/latest/download/TigerConnect-Setup.exe"  # Replace with the actual download link
$downloadPath = "C:\Temp"  # Adjust the download folder path as desired

# Ensure the folder exists, create it if necessary
if (!(Test-Path -Path $downloadPath)) {
    New-Item -ItemType Directory -Path $downloadPath | Out-Null
    Write-Host "Created folder: $downloadPath"
}

# Use Invoke-WebRequest to download the file silently
$localFilePath = Join-Path -Path $downloadPath -ChildPath ($downloadUrl.Split("/")[-1])
Invoke-WebRequest -Uri $downloadUrl -OutFile $localFilePath -UseBasicParsing

# Check for download success (optional)
if (Test-Path $localFilePath) {
    Write-Host "Download successful!"
} else {
    Write-Error "Download failed!"
}

#Run the .exe and install the program
Start-Process -FilePath $localFilePath -ArgumentList "/S" -Wait -NoNewWindow

# After install
Write-Host "Checking for TigerConnect.exe ..."

$PossiblePaths = @(
    "$env:LOCALAPPDATA\Programs\TigerConnect\TigerConnect.exe",
    "${env:ProgramFiles}\TigerConnect\TigerConnect.exe",
    "${env:ProgramFiles(x86)}\TigerConnect\TigerConnect.exe"
)

$Installed = $false

foreach ($path in $PossiblePaths) {
    if (Test-Path $path) {
        $Installed = $true
        Write-Host "TigerConnnect loaded"
        break
    }
}

if ($Installed) {
    Write-Host "Installed successfully"
} else {
    Write-Error "Installation failed! TigerConnect.exe not found in expected paths."
}
