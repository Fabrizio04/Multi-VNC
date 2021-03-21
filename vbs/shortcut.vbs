Dim Arg, var
Set Arg = WScript.Arguments
var = Arg(0)
Set oWS = WScript.CreateObject("WScript.Shell") 
sLinkFile = "C:\Users\Fabrizio\Desktop\" & var & ".lnk" 
Set oLink = oWS.CreateShortcut(sLinkFile) 
oLink.TargetPath = "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" 
oLink.Arguments = "/config ""%userprofile%\Documents\UltraVNC\" & var & ".vnc""" 
oLink.Save 
