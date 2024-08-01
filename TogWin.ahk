#Requires AutoHotkey v2.0
#Warn All, OutputDebug
#SingleInstance Force
;
class TogWin {
    wTitle := ""
    _Hotkey := ""
    _Toggle_ := ObjBindMethod(this, "Toggle")
    __New(_wTitle:="A") {
        this.wTitle := _wTitle
    }
    HWND => WinExist(this.wTitle)
    Active => WinActive(this)
    Show(*) => this.HWND and WinShow(this)
    Hide(*) => WinHide(this)
    Toggle(*) => this.Active and this.Hide() or this.Show()
    Hotkey {
        Get => this._Hotkey
        Set {
            if this._Hotkey
                Hotkey this._Hotkey, "Off"
            this._Hotkey := Value
            Hotkey this._Hotkey, this._Toggle_, "On"
        }
    }
}
;