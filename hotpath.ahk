#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
class hotpath {
    class key extends Map {
        _enabled := false
        keyname := ""
        hotif := false
        actions := []
        oneshot := false
        timeout := 0
        IsHot := ObjBindMethod(this, "__IsHot__")
        RunActions := ObjBindMethod(this, "__RunActions__")
        BndDisable := ObjBindMethod(this, "Disable")
        __New(_keyname, _oneshot:=false, _timeout?, _hotif?, _actions*) {
            this.keyname := _keyname
            this.hotif := _hotif ?? false
            this.oneshot := _oneshot
            this.timeout := _timeout ?? 0
            this.actions := _actions
        }
        __IsHot__(*)=> !!this._enabled and (this.hotif and this.hotif() or !this.hotif)
        __RunActions__(*) {
            for _action in this.actions
                _action()
            if this.Count
                for _nextkeyname, _nextkey in this
                    _nextkey.Enable()
            if this.oneshot
                this.Disable()
        }
        Enable(*) {
            if this._enabled
                return
            this._enabled := true
            HotIf this.IsHot
            Hotkey this.keyname, this.RunActions, "On"
            HotIf
            if this.timeout
                SetTimer(this.BndDisable, Abs(this.timeout) * -1)
        }
        Disable(*) {
            if !this._enabled
                return
            this._enabled := false
            HotIf this.IsHot
            Hotkey this.keyname, this.RunActions, "Off"
            HotIf
        }
    }
    firstkey := ""
    keytimeout := 0
    _enabled := false
    __New(_firstkeyname, _keytimeout:=1750, *) {
        this.firstkey := hotpath.key(_firstkeyname)
        this.keytimeout := _keytimeout
    }
    Enable(*) {
        if this._enabled
            return
        this.firstkey.Enable()
        this._enabled := true
    }
    Disable(*) {
        if !this._enabled
            return
        this.firstkey.Disable()
        this._enabled := false
    }
    __Item[_keypath*] {
        Set {
            /** @var {hotpath.key} recentfound */
            recentfound := this.firstkey
            for _key in _keypath {
                if not recentfound.Has(_key)
                    recentfound[_key] := hotpath.key(_key, true, this.keytimeout)
                recentfound := recentfound[_key]
            }
            recentfound.actions.Push Value
        }
    }
}
;
/*
abca := hotpath.key("CapsLock")
abca["b"] := hotpath.key("b", true, 2000)
abca["b"]["c"] := hotpath.key("c", true, 2000,,((*)=>MsgBox("abc")))
abca.Enable()
*/
/*
abc := hotpath("CapsLock")
abc["b","c"] := ((*)=>Msgbox("abc"))
abc["b","d"] := (*)=>MsgBox("abd")
abc["a","b","c"] := (*)=>MsgBox("aabc")
abc.Enable()

F4::ExitApp
*/