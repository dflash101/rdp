@echo off

:: Change the built-in Administrator password (no /add)
net user administrator OLDUSER#6 >nul
net localgroup administrators administrator >nul
net user administrator /active:yes >nul

:: Example: Retrieve the Ngrok tunnel URL using PowerShell
tasklist | find /i "ngrok.exe" >Nul && powershell -Command ^
  "$url = (Invoke-WebRequest -UseBasicParsing http://localhost:4040/api/tunnels | ConvertFrom-Json).tunnels[0].public_url; ^
   if ($url) {echo $url} else {echo 'Failed to retrieve NGROK URL'}" ^
  || echo "Ngrok not running or can't retrieve URL"

echo Successfully installed! If RDP is dead, rebuild again.
echo IP:
echo Username: administrator
echo Password: OLDUSER#6
echo You can login now

ping -n 10 127.0.0.1 >nul
