#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include dbgo.ahk

SoundWheelCheckMouse(*) {
    MouseGetPos ,, &_winhwnd, &_ctrlclass
    _winclass := _winhwnd ? WinGetClass(_winhwnd) : false
    if _winclass = "Shell_TrayWnd" and _ctrlclass = "ToolbarWindow323"
        return true
    return false
}
SoundWheelSetVolume(_amount, *) {
    SoundSetVolume(_amount)
    Tooltip Integer(SoundGetVolume())
    SetTimer (*)=>Tooltip(), -1000
}

A_MaxHotkeysPerInterval := 2000

HotIf SoundWheelCheckMouse
Hotkey "WheelUp", (*)=>SoundWheelSetVolume('+2')
Hotkey "WheelDown", (*)=>SoundWheelSetVolume('-2')
HotIf