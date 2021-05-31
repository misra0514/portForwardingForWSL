@ECHO OFF
:: MADE BY MISRA0514
:: MORE INFORMATION PLZ VIEW https://github.com/misra0514/portForwardingForWSL/

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

SET LXDISTRO=Ubuntu & SET WSL2PORT=8080 & SET HOSTPORT=8001
NETSH INTERFACE PORTPROXY RESET & NETSH AdvFirewall Firewall delete rule name="%LXDISTRO% Port Forward" > NUL
WSL -d %LXDISTRO% -- ip addr show eth0 ^| grep -oP '(?^<=inet\s)\d+(\.\d+){3}' > IP.TMP
SET /p IP=<IP.TMP
NETSH INTERFACE PORTPROXY ADD v4tov4 listenport=%HOSTPORT% listenaddress=0.0.0.0 connectport=%WSL2PORT% connectaddress=%IP% 
NETSH AdvFirewall Firewall add rule name="%LXDISTRO% Port Forward" dir=in action=allow protocol=TCP localport=%HOSTPORT% > NUL
ECHO WSL2 Virtual Machine %IP%:%WSL2PORT%now accepting traffic on %COMPUTERNAME%:%HOSTPORT%

ECHO config success!
pause