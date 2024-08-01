#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include Trans.ahk
;
Persistent()
;
Tooltip "AHKayyyyy............."
SetTimer((*) => Tooltip(), -2000)
;
Hotkey "#F5", (*) => Reload()
Hotkey "+#a", (*) => Run("C:\Program Files\AutoHotkey\v2\AutoHotkey.chm")
Hotkey "+#w", (*) => (Run("C:\Users\" A_UserName "\proggers\SysInternals\Debugviewpp.exe"), WinWait("ahk_exe Debugviewpp.exe"), WinActivate())
    Hotkey "sc029 & 1", (*) => Trans.PrevStep()
Hotkey "sc029 & 2", (*) => Trans.NextStep()
sc029::sc029
;
