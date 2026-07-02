# Qbittorrent-ProtonVPN

A background-startup script to set your qbittorrent listening port to the port forwarded by ProtonVPN.

## Prerequisites
1. ProtonVPN with port-forwarding enabled and being able to connect to port-forward servers.
2. qbitorrent with webUI and auth bypass for localhost enabled.

## How to Install

1. Download the [script](https://raw.githubusercontent.com/KonstantinosPetrakis/qbittorrent-protonvpn/refs/heads/main/proton-qbitorrent.ps1) from this repository.
2. Store it some location of your liking, e.g `C:\Users\%USERPROFILE%\Documents`
3. Press `Win+R` and type `shell:startup` and hit `Enter`.
4. Right-click inside the folder, select New > Shortcut.
5. In the location box, paste the following line (make sure to update the path to where you actually saved the script): `powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\%USERPROFILE%\Documents\proton-qbitorrent.ps1"`
6. Name the shortcut something like "qB Port Monitor" and finish.

## How to use
1. Open ProtonVPN and connect to some server that supports port forwading.
2. Open qbittorrent.
3. After some seconds after openining qbitorrent, a notification will appear updating you that the new port has been set.
