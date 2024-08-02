#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include tip.ahk
;
class Wink {
    static lastid := 0
    _SetHWND_ := ObjBindMethod(this, "SetHWND")
    , _Switch_ := ObjBindMethod(this, "Switch")
    , _enabled_ := false
    , HWND := 0x0
    , name := ""
    , exe := ""
    , _set_hwnd_key_ := ""
    , _switch_key_ := ""
    , id := 0
    __New(_set_hwnd_key?, _switch_key?, _name?) {
        this.id := Wink.lastid++
        this.name := _name ?? this.id
        if IsSet(_set_hwnd_key)
            this.SetHWNDKey := _set_hwnd_key
        if IsSet(_switch_key)
            this.SwitchKey := _switch_key
    }
    SetHWNDKey {
        get => this._set_hwnd_key_
        set {
            if !!this._set_hwnd_key_
                Hotkey this._set_hwnd_key_, "Off"
            this._set_hwnd_key_ := Value
            Hotkey this._set_hwnd_key_, this._SetHWND_
        }
    }
    SwitchKey {
        get => this._switch_key_
        set {
            if !!this._switch_key_
                Hotkey this._switch_key_, "Off"
            this._switch_key_ := Value
            Hotkey this._switch_key_, this._Switch_
        }
    }
    SetHWND(*) => ((this.HWND := WinExist("A")) and this.exe := WinGetProcessName()) and Tip(this.name ":" this.exe ":SetHWND")
    Active => WinActive(this.HWND)
    Show(*) => (WinExist(this.HWND) and (WinActivate(this.HWND), true) or Tip(this.name ":" this.exe ":Show:WinNotFound"))
    Hide(*) => WinMinimize(this.HWND)
    Switch(*) => this.Active and (this.Hide(), true) or this.Show()
}
;