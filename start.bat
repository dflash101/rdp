@echo off

:: Remove the Epic Games Launcher shortcut (optional cleanup)
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1

:: Set server comment
net config server /srvcomment:"Windows Server 2019 By administrator " > out.txt 2>&1

:: Adjust Explorer auto-tray registry setting
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1

:: Run wallpaper script on startup (if it exists at D:\a\wallpaper.bat)
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat

:: Instead of creating a new user named "administrator", set the built-in Administrator's password
net user administrator OLDUSER#6 >nul

:: Ensure Administrator is in the local administrators group (often redundant, but harmless)
net localgroup administrators administrator >nul

:: Make sure Administrator account is active
net user administrator /active:yes >nul

:: Remove "installer" account if it exists
net user installer /delete

:: Enable disk performance counters
diskperf -Y >nul

:: Enable and start the Audio service
sc config Audiosrv start= auto >nul
sc start audiosrv >nul

:: Grant Administrator full access to Temp and Installer folders
ICACLS C:\Windows\Temp /grant administrator :F >nul
ICACLS C:\Windows\installer /grant administrator :F >nul

echo Successfully installed! If RDP is dead, rebuild again.
echo IP:

:: Check if ngrok is running, then retrieve the public URL via the local API and jq
tasklist | find /i "ngrok.exe" >Nul && ^
    curl -s http://localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || ^
    echo "Failed to retreive NGROK authtoken - check again your authtoken"

echo Username: administrator
echo Password: OLDUSER#6
echo You can login now

:: Wait 10 seconds before exiting
ping -n 10 127.0.0.1 >nul
