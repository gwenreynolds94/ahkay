#Requires AutoHotkey v2.0+
class Trans {
    static SetHalf(_wintitle?) => WinExist(_wintitle ?? "A") and WinSetTransparent(255 // 2)
    static SetFull(_wintitle?) => WinExist(_wintitle ?? "A") and WinSetTransparent(255)
}
