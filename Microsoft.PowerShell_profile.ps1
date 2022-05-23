Import-Module PSReadLine

$proxy = 'http://127.0.0.1:7890'

function update {
    scoop.ps1 update *
    Write-Host ----------------------------- -ForegroundColor yellow
    rustup.exe update
    Write-Host ----------------------------- -ForegroundColor yellow
    flutter.bat upgrade
    Write-Host ----------------------------- -ForegroundColor yellow
    Update-Module -Force
}

function status {
    Write-Host 当前环境变量：`nHTTP_PROXY = $ENV:HTTP_PROXY
    Write-Host HTTPS_PROXY = $ENV:HTTPS_PROXY
}

function proxy {
    param(
        [ValidateSet('1', '0')]
        $choice
    )
    switch ($choice) {
        0 { 
            if (Test-Path ENV:HTTP_PROXY) {
                Remove-Item ENV:HTTP_PROXY
            }
            if (Test-Path ENV:HTTPS_PROXY) {
                Remove-Item ENV:HTTPS_PROXY
            }
        }
        1 {
            $ENV:HTTP_PROXY = $proxy 
            $ENV:HTTPS_PROXY = $proxy
        }
    }
    status
}

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -ShowToolTips

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Invoke-Expression (&starship init powershell)
