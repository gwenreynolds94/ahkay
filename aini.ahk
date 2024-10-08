#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include fs.ahk
;
class aini extends Map {
    /** @prop {fs.path} fpath */
    fpath := {}
    sections := []
    __New(_fpath) {
        this.fpath := fs.path(_fpath)
        fs.ValidateFile(this.fpath)
        this.UpdateSections()
    }
    UpdateSections(_default_sections*) {
        current_sections := []
        Loop read this.fpath.str
            if A_LoopReadLine ~= "^\[\S+\]$"
                current_sections.Push RegExReplace(A_LoopReadLine, "\]|\[")
        for section in current_sections
            if not this.Has(section)
                this[section] := aini.section(this.fpath, section)
        for section in _default_sections
            if not this.Has(section)
                this[section] := aini.section(this.fpath, section)
    }
    class section {
        __New(_fpath, _section) {
            this.fpath := _fpath
            this.section := _section
        }
        __Item[_key] {
            Get => IniRead(this.fpath.str, this.section, _key, 'unset')
            Set => IniWrite(Value, this.fpath.str, this.section, _key)
        }
        UpdateDefaults(_default_map) {
            for _def_key, _def_val in _default_map
                if this[_def_key] = 'unset'
                    this[_def_key] := _def_val
        }
    }
}