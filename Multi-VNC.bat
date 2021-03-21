@echo off
color A0

:menu
title Multi-VNC by Fabrizio Amorelli
cls
ECHO  __  __         _  _    _       __      __ _   _   _____ 
ECHO ^|  \/  ^|       ^| ^|^| ^|  (_)      \ \    / /^| \ ^| ^| / ____^|
ECHO ^| \  / ^| _   _ ^| ^|^| ^|_  _  ______\ \  / / ^|  \^| ^|^| ^|     
ECHO ^| ^|\/^| ^|^| ^| ^| ^|^| ^|^| __^|^| ^|^|______^|\ \/ /  ^| . ` ^|^| ^|     
ECHO ^| ^|  ^| ^|^| ^|_^| ^|^| ^|^| ^|_ ^| ^|         \  /   ^| ^|\  ^|^| ^|____ 
ECHO ^|_^|  ^|_^| \__,_^|^|_^| \__^|^|_^|          \/    ^|_^| \_^| \_____^|
ECHO.

ECHO  1 - Lancia installazione remota VNC Server
ECHO  2 - Applica configurazione remota
ECHO  3 - Imposta password VNC Server
ECHO  4 - Imposta porta VNC Server
if exist "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" (
ECHO  5 - Lancia Ultra VNC Viewer
) else (
ECHO  5 - Installa Ultra VNC Viewer
)
ECHO  6 - Nuovo collegamento VNC Viewer (Desktop)
ECHO  7 - Nuovo collegamento VNC Viewer (Preferiti)
ECHO  8 - Visualizza cartella Preferiti
ECHO  9 - Connessione Ultra VNC Server (Preferiti)
ECHO 10 - Nuova connessione VNC Server (Java)

ECHO.
set /p menu= Digita il numero [1-10]: || set menu=NothingChosen

if '%menu%'=='NothingChosen' goto menu

if '%menu%'=='1' goto installserver
if '%menu%'=='2' goto installconfig
if '%menu%'=='3' goto setvncpassword
if '%menu%'=='4' goto setvncport
if '%menu%'=='5' goto launchvnc
if '%menu%'=='6' goto vncdesktop
if '%menu%'=='7' goto vncdocuments
if '%menu%'=='8' goto openvncpreferr
if '%menu%'=='9' goto startvncpreferr
if '%menu%'=='10' goto startvncjava
if '%menu%'=='about' goto about

if '%menu%'=='exit' exit

goto menu

:installserver
cd "%~dp0"
:host
cls
set /p host= Hostname - Indirizzo IP: || set host=NothingChosen
if '%host%'=='menu' goto menu
if '%host%'=='NothingChosen' goto host

:username
cls
ECHO Hostname - Indirizzo IP: %host%
set /p username= Nome utente [DOMINIO\USERNAME]: || set username=NothingChosen
if '%username%'=='menu' goto menu
if '%username%'=='NothingChosen' goto username

:password
cls
ECHO Hostname - Indirizzo IP: %host%
ECHO Nome utente [DOMINIO\USERNAME]: %username%
set /p password= Password: || set password=NothingChosen
if '%password%'=='menu' goto menu
if '%password%'=='NothingChosen' goto password

:netuse
cls
ECHO Hostname - Indirizzo IP: %host%
ECHO Nome utente [DOMINIO\USERNAME]: %username%
ECHO Password: ********
ECHO.
ECHO Connessione a %host%
net use Z: \\%host%\c$ %password% /user:%username%
if not exist Z: (
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu
) else (
:copia
rem cls
ECHO Creo la cartella vncinstall
mkdir Z:\vncinstall
ECHO Copio il file d^'installazione
copy /y "%~dp0\vnc\UltraVNC_1_3_2_X64_Setup.exe" Z:\vncinstall>nul
ECHO Copio il file di configurazione
copy /y "%~dp0\inf\ultravnc_server.inf" Z:\vncinstall>nul
ECHO Copio il launcher
copy /y "%~dp0\cmd\launcher.bat" Z:\vncinstall>nul
ECHO Copio il service start
copy /y "%~dp0\cmd\start_uvnc_service.bat" Z:\vncinstall>nul
ECHO Copio il service stop
copy /y "%~dp0\cmd\stop_uvnc_service.bat" Z:\vncinstall>nul

:installVNC
rem cls
ECHO.
ECHO Installo VNC . . .
PsExec64.exe -nobanner \\%host% "C:\vncinstall\launcher.bat">nul

:configVNC
ECHO.
ECHO Arresto VNC . . .
PsExec64.exe -nobanner \\%host% "C:\vncinstall\stop_uvnc_service.bat">nul
ECHO.
ECHO Copio il file di configurazione
copy /y "%~dp0\inf\ultravnc.ini" "Z:\Program Files\uvnc bvba\UltraVNC">nul
ECHO.
timeout /t 2 >nul
ECHO Avvio VNC . . .
PsExec64.exe -nobanner \\%host% "C:\vncinstall\start_uvnc_service.bat">nul

:delete
rem cls
ECHO.
ECHO Rimuovo i file
echo S|rmdir /S Z:\vncinstall>nul
ECHO Disconnessione da %host%
net use Z: /delete

ECHO Operazione completata
ECHO Connetti all^'host %host% sulla porta configurata
ECHO.
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu
)

:installconfig
cd "%~dp0"
:host2
cls
set /p host= Hostname - Indirizzo IP: || set host=NothingChosen
if '%host%'=='menu' goto menu
if '%host%'=='NothingChosen' goto host2

:username2
cls
ECHO Hostname - Indirizzo IP: %host%
set /p username= Nome utente [DOMINIO\USERNAME]: || set username=NothingChosen
if '%username%'=='menu' goto menu
if '%username%'=='NothingChosen' goto username2

:password2
cls
ECHO Hostname - Indirizzo IP: %host%
ECHO Nome utente [DOMINIO\USERNAME]: %username%
set /p password= Password: || set password=NothingChosen
if '%password%'=='menu' goto menu
if '%password%'=='NothingChosen' goto password2

:netuse2
cls
ECHO Hostname - Indirizzo IP: %host%
ECHO Nome utente [DOMINIO\USERNAME]: %username%
ECHO Password: ********
ECHO.
ECHO Connessione a %host%
net use Z: \\%host%\c$ %password% /user:%username%
if not exist Z: (
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu
) else (
if not exist "Z:\Program Files\uvnc bvba\UltraVNC\ultravnc.ini" (
ECHO Disconnessione da %host%
net use Z: /delete
"%~dp0\vbs\messaggio.vbs" VNC
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu
) else (
:copia2
rem cls
ECHO Creo la cartella vncinstall
mkdir Z:\vncinstall
ECHO Copio il service start
copy /y "%~dp0\cmd\start_uvnc_service.bat" Z:\vncinstall>nul
ECHO Copio il service stop
copy /y "%~dp0\cmd\stop_uvnc_service.bat" Z:\vncinstall>nul

:configVNC2
ECHO.
ECHO Arresto VNC . . .
PsExec64.exe -nobanner \\%host% "C:\vncinstall\stop_uvnc_service.bat">nul
ECHO.
ECHO Copio il file di configurazione
copy /y "%~dp0\inf\ultravnc.ini" "Z:\Program Files\uvnc bvba\UltraVNC">nul
ECHO.
timeout /t 2 >nul
ECHO Avvio VNC . . .
PsExec64.exe -nobanner \\%host% "C:\vncinstall\start_uvnc_service.bat">nul

ECHO.
ECHO Rimuovo i file
echo S|rmdir /S Z:\vncinstall>nul
ECHO Disconnessione da %host%
net use Z: /delete
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu
)
)

:setvncpassword
cls
cd "%~dp0"
"%~dp0\bin\vncsettings.exe" encrypt
ECHO.
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu

:setvncport
cls
cd "%~dp0"
"%~dp0\bin\vncsettings.exe" port
ECHO.
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu

:launchvnc
if exist "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" (
start "" "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe"
goto menu
) else (
cd "%~dp0"
"%~dp0\vbs\messaggio.vbs" install
rem timeout /t 3
goto menu
)

:vncdesktop
cls
if exist "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" (
if not exist "%userprofile%\Documents\UltraVNC" mkdir "%userprofile%\Documents\UltraVNC"
cd "%~dp0"
"%~dp0\bin\vncsettings.exe" vncdesktop
ECHO.
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu
) else (
"%~dp0\vbs\messaggio.vbs" viewer
goto menu
)

:vncdocuments
cls
if exist "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" (
if not exist "%userprofile%\Documents\UltraVNC" mkdir "%userprofile%\Documents\UltraVNC"
cd "%~dp0"
"%~dp0\bin\vncsettings.exe" vncdocuments
ECHO.
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu
) else (
"%~dp0\vbs\messaggio.vbs" viewer
goto menu
)

:openvncpreferr
cls
if exist "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" (
if not exist "%userprofile%\Documents\UltraVNC" mkdir "%userprofile%\Documents\UltraVNC"
start "" "%userprofile%\Documents\UltraVNC"
) else (
"%~dp0\vbs\messaggio.vbs" viewer
)
goto menu

:startvncpreferr
cls

if not exist "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" (
"%~dp0\vbs\messaggio.vbs" viewer
goto menu
)

set /p prefvnc= Inserisci l^'indirizzo ip: || set prefvnc=NothingChosen
if '%prefvnc%'=='menu' goto menu

if exist "%userprofile%\Documents\UltraVNC\%prefvnc%.vnc" (
start "" "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" /config "%userprofile%\Documents\UltraVNC\%prefvnc%.vnc"
)

goto startvncpreferr

:startvncjava
cls
where java >nul 2>nul
if %errorlevel%==1 (
"%~dp0\vbs\messaggio.vbs" java
goto menu
)

:hostjava
cls
set /p ip= Hostname - Indirizzo IP: || set ip=NothingChosen
if '%ip%'=='menu' goto menu
if '%ip%'=='NothingChosen' goto hostjava

:porta
cls
ECHO Hostname - Indirizzo IP: %ip%
set /p porta= Porta: || set porta=NothingChosen
if '%porta%'=='menu' goto menu
if '%porta%'=='NothingChosen' goto porta

:passwordjava
cls
ECHO Hostname - Indirizzo IP: %ip%
ECHO Porta: %porta%
set /p passwordjava= Password: || set passwordjava=NothingChosen
if '%passwordjava%'=='menu' goto menu
if '%passwordjava%'=='NothingChosen' goto passwordjava
cls
ECHO Hostname - Indirizzo IP: %ip%
ECHO Porta: %porta%
ECHO Password: ********
ECHO.
java -jar "%~dp0\vnc\VncViewer.jar" PORT %porta% HOST %ip% PASSWORD %passwordjava%
ECHO.
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu

:about
cls
ECHO Multi-VNC
ECHO.
ECHO Versione: 1.0
ECHO Anno: 2021
ECHO Released By: Fabrizio Amorelli
ECHO https://github.com/Fabrizio04/Multi-VNC
ECHO.
ECHO Premere un tasto per tornare al menu' . . .
pause>nul
goto menu