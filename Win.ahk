#Requires AutoHotkey v2.0
#Warn All, OutputDebug
;
class Win {
    static Info := Map()
    HWND := 0x0
        , Class := ""
        , PID := 0x0
    __New(_wintitle) {
        this.HWND := WinExist(_wintitle)
        if (this.HWND)
            this.Class := WinGetClass()
                , this.PID := WinGetPID()
                , this.Transparency := WinGetTransparent()
        Win[this.HWND] := this
    }
    static __Item[_wintitle] {
        Get => this.Info[WinExist(_wintitle)]
        Set => this.Info[WinExist(_wintitle)] := Value
    }
}
Win("A")
OutputDebug(":{tk!}:" Win["ahk_exe WindowsTerminal.exe"].Transparency)
