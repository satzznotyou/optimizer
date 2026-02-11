Write-Host ""
Write-Host "ALL IN OPTIMIZER PRO LOADER"
Write-Host "Downloading latest version..."
Write-Host ""

$scriptUrl = "https://raw.githubusercontent.com/satzznotyou/optimizer/blob/main/Optimizer.ps1"

try {
    $script = Invoke-RestMethod $scriptUrl
    if ([string]::IsNullOrWhiteSpace($script)) {
        Write-Host "Download failed or file empty."
        pause
        exit
    }
    Invoke-Expression $script
}
catch {
    Write-Host "Failed to download script."
    pause
}
