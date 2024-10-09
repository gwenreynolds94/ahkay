#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
class hotpath {
    class key extends Map {
        /** @prop {Integer} _enabled */
        _enabled := false
        /** @prop {String} keyname the key passed to the Hotkey function */
        keyname := ""
        /** @prop {Func|Integer} hotif optional custom hotif func object */
        hotif := false
        /** @prop {Array<Func>} actions func objects to run upon hotkey trigger */
        actions := []
        /** @prop {Integer} oneshot whether to disable self after actions */
        oneshot := false
        /** @prop {Integer} timeout amount of ticks to wait before auto-disabling */
        timeout := 0
        /** @prop {Map} disable_on_trigger keys to disable after actions */
        disable_on_trigger := Map()
        IsHot := ObjBindMethod(this, "__IsHot__")
        RunActions := ObjBindMethod(this, "__RunActions__")
        BndDisable := ObjBindMethod(this, "Disable")
        /**
         * 
         * @param {String} _keyname the key passed to Hotkey function
         * @param {Integer} [_oneshot=false] whether to disable after triggering actions
         * @param {Integer} [_timeout] amount of ticks to wait before disabling automatically
         * @param {Func} [_hotif] an optional custom hotif func object
         * @param {Array<Func>} [_actions] func object actions to run upon hotkey trigger
         */
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
            for _prevkeyname, _prevkey in this.disable_on_trigger
                _prevkey.Disable()
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
    /** @prop {hotpath.key} firstkey the leader key */
    firstkey := {}
    /** @prop {Integer} keytimeout default timeout of subsequently added keys */
    keytimeout := 0
    /** @prop {Integer} _enabled */
    _enabled := false
    __New(_firstkeyname, _keytimeout:=1250, *) {
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
                for _keyname, _keyvalue in recentfound
                    if _keyname != _key and not recentfound[_key].disable_on_trigger.Has(_keyname)
                        recentfound[_key].disable_on_trigger[_keyname] := _keyvalue
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