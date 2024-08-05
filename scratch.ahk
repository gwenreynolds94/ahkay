#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#Include dbgo.ahk

dbgo SubStr(RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3", "Settings"), 8*2 + 1, 2)
