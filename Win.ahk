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
            this.Class := WinGetClass(this.HWND)
                , this.PID := WinGetPID(this.HWND)
        Win[this.HWND] := this
    }
    Transparency => WinGetTransparent(this) or 255
    /**
     * @returns {Win}
     */
    static __Item[_wintitle] {
        Get => (wHWND := WinExist(_wintitle)) ? (this.Info.Has(wHWND) ? this.Info.Get(wHWND) : Win(wHWND)) : {}
        Set => this.Info[WinExist(_wintitle)] := Value
    }
}
Win("A")
OutputDebug("trans:" Win["A"].Transparency ":")
