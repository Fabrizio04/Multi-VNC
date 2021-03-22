Dim Arg, var
Set Arg = WScript.Arguments
var = Arg(0)
strUser = CreateObject("WScript.Network").UserName


Set oWS = WScript.CreateObject("WScript.Shell") 
sLinkFile = "C:\Users\" &strUser& "\Desktop\" & var & ".lnk" 
Set oLink = oWS.CreateShortcut(sLinkFile) 
oLink.TargetPath = "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" 
oLink.Arguments = "/config ""%userprofile%\Documents\UltraVNC\" & var & ".vnc""" 
oLink.Save
