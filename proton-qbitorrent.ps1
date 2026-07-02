# Function to display native Windows Notifications
Function Show-Notification {
    param (
        [string]$Title,
        [string]$Message
    )
    Add-Type -AssemblyName System.Windows.Forms
    $notify = New-Object System.Windows.Forms.NotifyIcon
    $notify.Icon = [System.Drawing.SystemIcons]::Information
    $notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $notify.BalloonTipTitle = $Title
    $notify.BalloonTipText = $Message
    $notify.Visible = $true
    $notify.ShowBalloonTip(5000)
    Start-Sleep -Seconds 5
    $notify.Dispose()
}

# Infinite loop to monitor for qBittorrent
while ($true) {
    # Check if qBittorrent is running
    $qb = Get-Process -Name "qbittorrent" -ErrorAction SilentlyContinue
    
    if ($qb) {
        # Give qBittorrent a few seconds to fully initialize its WebUI
        Start-Sleep -Seconds 5 

        # 1. Grab the port from Proton VPN logs
        $vpnPort = Select-String -Path "C:\Program Files\Proton\VPN\v*\ServiceData\Logs\service-logs.txt" -Pattern "Port pair \d+->(\d+)" | Select-Object -Last 1 | ForEach-Object { $_.Matches.Groups[1].Value }

        # 2. Send the port to qBittorrent
        if ($vpnPort) {    
            $webUiUrl = "http://localhost:8080/api/v2/app/setPreferences"
            $payload = @{ json = "{ `"listen_port`": $vpnPort }" }
            
            try {
                Invoke-RestMethod -Uri $webUiUrl -Method Post -Body $payload
                Show-Notification -Title "qBittorrent Port Updated" -Message "Successfully bound to Proton VPN port $vpnPort."
            } catch {
                Show-Notification -Title "qBittorrent Update Failed" -Message "Could not update. Is WebUI bypass enabled?"
            }
        } else {
            Show-Notification -Title "Proton VPN Error" -Message "Could not find a forwarded port in Proton VPN logs."
        }

        # IMPORTANT: Wait until qBittorrent closes before looping again. 
        # This prevents the script from spamming the WebUI API.
        $qb.WaitForExit()
    }

    # If qBittorrent isn't running, wait 5 seconds and check again.
    # (This uses practically zero CPU resources).
    Start-Sleep -Seconds 5
}