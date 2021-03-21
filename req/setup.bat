@echo off
cls
where java >nul 2>nul
if %errorlevel%==1 (
ECHO Installazione di Java . . .
"%~dp0\jre-8u281-windows-i586.exe" /s
timeout /t 2
)

if not exist "C:\Program Files\dotnet\dotnet.exe" (
ECHO.
ECHO Installazione di Microsoft .NET 5 Runtime . . .
"%~dp0\windowsdesktop-runtime-5.0.4-win-x86.exe" /s
timeout /t 2
)

if not exist "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" (
ECHO.
ECHO Installazione di Ultra VNC Viewer . . .
"%~dp0\..\cmd\install_vnc_viewer.bat"
)