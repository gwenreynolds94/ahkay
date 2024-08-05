#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
class taskbar {
    class autohide {
        static RegPath := 
            [ "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3", "Settings" ]
          , Toggle := ObjBindMethod(this, "__Toggle")
        static Enabled {
            get => (Integer(SubStr(RegRead(this.RegPath*), 17, 2)) = 3)
            set => (bin_text:=RegRead(this.RegPath*), msgbox(SubStr(bin_text, 1, 16) (Value = false ? "02" : "03") SubStr(bin_text, 19) "`n" bin_text))
        }
        static Enable(*) {
            static bin_text
            bin_text := RegRead(this.RegPath*)
            if (SubStr(bin_text, 17, 2) == "03")
                return
            RegWrite(SubStr(bin_text, 1, 16) "03" SubStr(bin_text, 19), "REG_BINARY", this.RegPath*)
            this.UpdateExplorer()
        }
        static Disable(*) {
            static bin_text
            bin_text := RegRead(this.RegPath*)
            if (SubStr(bin_text, 17, 2) == "02")
                return
            RegWrite(SubStr(bin_text, 1, 16) "02" SubStr(bin_text, 19), "REG_BINARY", this.RegPath*)
            this.UpdateExplorer()
        }
        static __Toggle(*) {
            static bin_text
            bin_text := RegRead(this.RegPath*), 
            RegWrite(SubStr(bin_text, 1, 16) (SubStr(bin_text, 17, 2) = "03" ? "02" : "03") SubStr(bin_text, 19)
                    , "REG_BINARY"
                    , this.RegPath* )
            this.UpdateExplorer()
        }
        static UpdateExplorer(*) {
            static prev_win 
            prev_win := WinExist("A")
            ProcessClose("explorer.exe")
            Sleep 666
            WinActivate(prev_win)
        }
    }
}
;
if A_ScriptFullPath == A_LineFile {
    taskbar.autohide.Toggle()
}
;