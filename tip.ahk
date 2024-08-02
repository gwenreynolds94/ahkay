#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
class tip {
    static HideTooltip := (*)=>ToolTip()
    static Call(_msg, _timeout:=2000) =>
        Tooltip(_msg) and SetTimer(Tip.HideTooltip, Abs(_timeout) * -1)
}
;