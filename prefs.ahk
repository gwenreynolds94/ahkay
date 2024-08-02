#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
;
#Include dbgo.ahk
;
class prefs extends Map {
    static save_dir := A_AppData "\ahkay"
         , all := Map()
    __New(_name) {
        super.__path__ := prefs.save_dir "\" _name ".ini"
        if not DirExist(prefs.save_dir)
            DirCreate(prefs.save_dir)
        if not FileExist(this.__path__)
            IniWrite(A_YYYY "." A_MM "." A_DD "." A_Hour ":" A_Min ":" A_Sec
                , this.__path__
                , "prefs"
                , "created")
        this.__LoadFile()
        prefs.all[_name] := this
    }
    __LoadFile(*) {
        loop parse IniRead(this.__path__, "prefs"), "`n", "`r" {
            RegExMatch(A_LoopField, "(?<keytext>[^=]+)=(?<valtext>.+)", &reinfo)
            this[reinfo.keytext, false] := reinfo.valtext
        }
    }
    __UpdateFile(*) {
        for _key, _value in this
            this[_key] := _value
    }
    SetDefaults(_prefs_map) {
        for _key, _value in _prefs_map
            if this[_key] == "NUL"
                this[_key] := _value
    }
    __Item[_name, _sync_file := true] {
        get => _sync_file ? (super[_name] := IniRead(this.__path__, "prefs", _name, "NUL")) : super[_name]
        set => _sync_file ? IniWrite((super[_name] := Value), this.__path__, "prefs", _name) : (super[_name] := Value)
    }
    __Set(_name, _params, _value) {
        if _name = "__path__"
            super.%_name% := _value
        this[_name, _params*] := _value
    }
    __Get(_name, _params) {
        if _name = "__path__"
            return super.%_name%
        return this[_name, _params*]
    }
}
;
if A_ScriptFullPath == A_LineFile {
    t1 := prefs("test.ass")
    t1.SetDefaults(Map(
        "ass", "butt",
        "butt", "ass",
        "assbutt", "buttass"
    ))
    msgbox t1.ass "`n" t1.butt[false] "`n" t1["assbutt"]
    t1.ass := "ass"
    t1["butt"] := "butt"
    t1.assbutt := t1.ass t1.butt
    msgbox t1.ass "`n" t1.butt[true] "`n" t1["assbutt"]
}