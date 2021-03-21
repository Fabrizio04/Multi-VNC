Dim Arg, var
Set Arg = WScript.Arguments
var = Arg(0)
testo=ChrW(232)
If var = "VNC" Then
x=MsgBox("VNC Server non "&testo&" stato trovato sul pc remoto",48,"Avviso")

ElseIF var = "viewer" Then

y=MsgBox("Ultra VNC Viewer non "&testo&" stato trovato sul questo pc",48,"Avviso")

ElseIF var = "java" Then

z=MsgBox("Java non "&testo&" stato trovato sul questo pc",48,"Avviso")

ElseIF var = "install" Then

result = MsgBox ("Installare Ultra VNC Viewer?", vbYesNo + vbQuestion, "Installazione VNC")

Select Case result
Case vbYes
	Set WshShell = CreateObject("WScript.Shell") 
	WshShell.Run chr(34) & ".\cmd\install_vnc_viewer.bat" & Chr(34), 0
	WScript.Sleep 4000
	Set WshShell = Nothing
Case vbNo
    'exit
End Select

End IF