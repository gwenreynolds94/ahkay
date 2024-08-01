#Requires AutoHotkey v2.0+
#SingleInstance Force
#Warn All, OutputDebug

class Tablet {
    class Gui extends Gui {
        static inst := Tablet.Gui()
        __New() {
            super.__New()
            this.MarginX := 10
            this.MarginY := 10
            loop 8 {
                this.AddPicture("w24 h24 x10 " ((A_Index = 1) ? "" : "y+10"), "C:\Users\jonat\Pictures\icons\8596868.ico")
                this.AddButton("w48 h24 x+10 yp", "F" (12 + A_Index))
                this.AddEdit("w128 h24 x+10 yp")
            }
            this.AddButton("w64 h24 x12 y+10", "Apply")
            this.AddButton("w64 h24 x+12 yp", "OK")
            this.AddButton("w64 h24 x+12 yp", "Cancel")
            this.Show()
        }
    }
}
F4:: ExitApp
