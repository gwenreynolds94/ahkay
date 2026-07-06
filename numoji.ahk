#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force

;
#include jsongo.ahk
#include peep.ahk
joyjson := FileRead("numotes.json")
joyobj := jsongo.Parse(joyjson)

Class Numote {
    cat := ""
    secs := []
    len := 1
    __New(cat:="", secs:=[], *) {
        this.cat := cat
        this.secs := secs
        this.len := secs.Length
    }
}



numotes := Map()
for numote_name, numote_contents in joyobj {
    numotes.Set(numote_name, Numote(numote_name, numote_contents))
}
joymote := numotes["sympathy"]
joysec := joymote.secs[1]

F12::{
    SetKeyDelay(100,50)
    Send "{LButton 3}"
    Send "^c"
    WinActivate("ahk_exe Code.exe")
    Send "{Enter}"
    SendEvent '"^v",'
    WinActivate("ahk_exe vivaldi.exe")
}

F11::{
    Peep WinGetProcessName(WinExist("A"))
}

Peep numotes["magic"].secs