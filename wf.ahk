#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force

class WF {
    class Melee {
        OnDown(*)=>Send("{w Down}{XButton1 Down}")
        OnUp(*)=>Send("{w Up}{XButton1 Up}")
    }
}

F13::Send("{w Down}{XButton1 Down}")
F13 Up::Send("{XButton1 Up}{w Up} bb f" )