#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
;
#Include dbgo.ahk
;
class prefs extends Map {
    static save_dir := A_AppData "\ahkay"
         , all := Map()
    __New(_name, _section, _default_prefs_map?) {
        super.__path__ := prefs.save_dir "\" _name ".ini"
        super.__name__ := _name
        super.__section__ := _section
        if not DirExist(prefs.save_dir)
            DirCreate(prefs.save_dir)
        if not FileExist(this.__path__)
            IniWrite(A_YYYY "." A_MM "." A_DD "." A_Hour ":" A_Min ":" A_Sec
                , this.__path__
                , "info"
                , "created")
        this.__LoadFile()
        prefs.all[_name "." _section] := this
        if IsSet(_default_prefs_map)
            this.SetDefaults(_default_prefs_map)
    }
    __LoadFile(*) {
        static has_section := false
        if !has_section {
            loop parse IniRead(this.__path__), "`n", "`r"
                if A_LoopField = this.__section__
                    has_section := true
            if !has_section
                FileAppend "`n[" this.__section__ "]`n", this.__path__
        }
        loop parse IniRead(this.__path__, this.__section__), "`n", "`r" {
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
        get => _sync_file ? (super[_name] := IniRead(this.__path__, this.__section__, _name, "NUL")) : super[_name]
        set => _sync_file ? IniWrite((super[_name] := Value), this.__path__, this.__section__, _name) : (super[_name] := Value)
    }
    __Set(_name, _params, _value) {
        if (SubStr(_name,1, 2) SubStr(_name, -2)) = "____"
            super.%_name% := _value
        this[_name, _params*] := _value
    }
    __Get(_name, _params) {
        if (SubStr(_name,1, 2) SubStr(_name, -2)) = "____"
            return super.%_name%
        return this[_name, _params*]
    }
}
;
if A_ScriptFullPath == A_LineFile {
    t1 := prefs("test", "ass", Map(
        "ass", "butt",
        "butt", "ass",
        "assbutt", "buttass"
    ))
    msgbox t1.ass "`n" t1.butt[false] "`n" t1["assbutt"]
    t1.ass := "ass"
    t1["butt"] := "butt"
    t1.assbutt := t1.ass t1.butt
    msgbox t1.ass "`n" t1.butt[true] "`n" t1["assbutt"]
    t2 := prefs("test", "butt", Map(
        "ass", "butt",
        "butt", "ass",
        "assbutt", "buttass"
    ))
    msgbox t2.ass "`n" t2.butt[false] "`n" t2["assbutt"]
    t2.ass := "ass"
    t2["butt"] := "butt"
    t2.assbutt := t2.ass t2.butt
    msgbox t2.ass "`n" t2.butt[true] "`n" t2["assbutt"]
}