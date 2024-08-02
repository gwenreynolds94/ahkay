#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include Trans.ahk
#Include Wink.ahk
;
Persistent()
;
__ON_STARTUP__ := true
__STARTUP_FILE__ := A_AppData "\Microsoft\Windows\Start Menu\Programs\Startup\ahkay.ahk.lnk"
__STARTUP_ENABLED__ := FIleExist(__STARTUP_FILE__)
if __ON_STARTUP__ and not __STARTUP_ENABLED__
    FileCreateShortcut(A_LineFile, __STARTUP_FILE__)
else if not __ON_STARTUP__ and __STARTUP_ENABLED__
    FileDelete(__STARTUP_FILE__)
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

Wink("+#0","#0","000")
Wink("+#9","#9","999")
Wink("+#8","#8","888")
Wink("+#7","#7","777")
Wink("+#6","#6","666")
Wink("+#5","#5","555")
Wink("+#4","#4","444")
Wink("+#3","#3","333")
Wink("+#2","#2","222")
Wink("+#1","#1","111")


;
/**
WindowToggles := {
    floorp: TogWin("ahk_exe floorp.exe"),
    hh: TogWin("ahk_exe hh.exe"),
    code: TogWin("ahk_exe Code.exe"),
}
WindowToggles.floorp.Hotkey := "+#f"
WindowToggles.hh.Hotkey := "+#a"
WindowToggles.code.Hotkey := "+#c"
*/
;
