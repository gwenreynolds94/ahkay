#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include trans.ahk
#Include wink.ahk
#Include taskbar.ahk
#Include tip.ahk
;
Persistent()
;
__ON_STARTUP__ := true
__STARTUP_FILE__ := A_AppData "\Microsoft\Windows\Start Menu\Programs\Startup\ahkay.ahk.lnk"
__STARTUP_ENABLED__ := FIleExist(__STARTUP_FILE__)
if __ON_STARTUP__ and not __STARTUP_ENABLED__
    FileCreateShortcut(A_LineFile, __STARTUP_FILE__)
else if not __ON_STARTUP__ and __STARTUP_ENABLED__
    FileDelete(__STARTUP_FILE__)
;
tip "AHKayyyyy............."

;
Hotkey "#F5", (*) => Reload()
Hotkey "+#a", (*) => Run("C:\Program Files\AutoHotkey\v2\AutoHotkey.chm")
Hotkey "+#w", (*) => (Run("C:\Users\" A_UserName "\proggers\SysInternals\Debugviewpp.exe"), WinWait("ahk_exe Debugviewpp.exe"), WinActivate())

wink("000", "#0", "+#0")
wink("999", "#9", "+#9")
wink("888", "#8", "+#8")
wink("777", "#7", "+#7")
wink("666", "#6", "+#6")
wink("555", "#5", "+#5")
wink("444", "#4", "+#4")
wink("333", "#3", "+#3")
wink("222", "#2", "+#2")
wink("111", "#1", "+#1")


global HOTIF_AC := (*)=>WinActive("ahk_exe armoredcore6.exe")

sc029 & 1::trans.PrevStep
sc029 & 2::trans.NextStep
sc029 & F1::taskbar.autohide.Toggle
sc029::sc029

OnX1DownUp(*) {
    static last_tick := 0
         , thresh := 200
         , duration := 30
    if SubStr(A_ThisHotkey, -1) = "1"
        last_tick := A_TickCount
    else if ((A_TickCount - last_tick) < thresh)
        Send("{Tab Down}"), SetTimer((*)=>Send("{Tab Up}"), duration)
}
OnX2DownUp(*) {
    static last_tick := 0
         , thresh := 200
         , duration := 30
    if SubStr(A_ThisHotkey, -1) = "2"
        last_tick := A_TickCount
    else if ((A_TickCount - last_tick) < thresh)
        Send("{Tab Down}"), SetTimer((*)=>Send("{Tab Up}"), duration)
}
class KeyHandler {
    is_down := false
      , key := ""
      , hotif := false
      , input_level := 0
      , last_up_tick := 0
      , last_down_tick := 0
      , _enabled := false
      , PostPress       := []
      , PostRelease     := []
      , PostPressOnce   := []
      , PostReleaseOnce := []
      , Toggle    := ObjBindMethod(this, "__Toggle")
      , Enable    := ObjBindMethod(this, "__Enable")
      , Disable   := ObjBindMethod(this, "__Disable")
      , OnPress   := ObjBindMethod(this, "__OnPress")
      , OnRelease := ObjBindMethod(this, "__OnRelease")
    __New(_key, _hotif?, _input_level:=1) {
        this.key := _key
        this.hotif := _hotif ?? false
        this.input_level := _input_level
    }
    __Enable(*) {
        if this._enabled
            return
        if not this.hotif
            return (Hotkey(this.key, this.OnPress, "I" this.input_level), Hotkey(this.key " Up", this.OnRelease, "I" this.input_level))
        HotIf this.hotif
        Hotkey this.key, this.OnPress, "On I" this.input_level
        Hotkey this.key " Up", this.OnRelease, "On I" this.input_level
        HotIf
        this._enabled := true
    }
    __Disable(*) {
        if !this._enabled
            return
        if not this.hotif
            return (Hotkey(this.key, this.OnPress, "Off"), Hotkey(this.key " Up", this.OnRelease, "Off"))
        HotIf this.hotif
        Hotkey this.key, this.OnPress, "Off"
        Hotkey this.key " Up", this.OnRelease, "Off"
        HotIf
        this._enabled := false
    }
    __Toggle(*) {
        if !this._enabled
            return this.__Enable()
        this.__Disable()
    }
    __OnPress(*) {
        this.last_down_tick := A_TickCount, this.is_down := true
        loop this.PostPressOnce.Length
            (this.PostPressOnce.Pop())(this)
        for _func in this.PostPress
            _func(this)
        
    }
    __OnRelease(*) {
        this.last_up_tick := A_TickCount, this.is_down := false
        loop this.PostReleaseOnce.Length
            (this.PostReleaseOnce.Pop())(this)
        for _func in this.PostRelease
            _func(this)
    }
}
global X2H := KeyHandler("*~XButton2", HOTIF_AC)
X2H.PostRelease.Push((_x2h,*)=>(
    (_x2h.last_up_tick - _x2h.last_down_tick) < 150 and (
        Send("{f Down}"), SetTimer((*)=>Send("{f Up}"), -30)
    ))
)
#HotIf X2H._enabled and !X2H.is_down and WinActive("ahk_exe armoredcore6.exe")
*LButton::3
*RButton::4
#HotIf X2H._enabled and X2H.is_down
*LButton::1
*RButton::2
#HotIf

global X1H := KeyHandler("*~XButton1", HOTIF_AC)
X1H.PostRelease.Push((_x1h,*)=>(
    (_x1h.last_up_tick - _x1h.last_down_tick) < 200 and (
        Send("{LCtrl Down}"), SetTimer((*)=>Send("{LCtrl Up}"), -30)
    ))
)
#HotIf 
; #Hotif (X2H.is_down and X1H.is_down)
; *$w::Send("{LAlt Down}{w Down}")
; *$w Up::Send("{w Up}{LAlt Up}")
; *$a::Send("{LAlt Down}{a Down}")
; *$a Up::Send("{a Up}{LAlt Up}")
; *$s::Send("{LAlt Down}{s Down}")
; *$s Up::Send("{s Up}{LAlt Up}")
; *$d::Send("{LAlt Down}{d Down}")
; *$d Up::Send("{d Up}{LAlt Up}")
; #HotIf 
/**
global aKH := KeyHandler("*~a", HOTIF_AC, 0)
global dKH := KeyHandler("*~d", HOTIF_AC, 0)
aKH.PostRelease.Push((_akh,*)=>(
    (_akh.last_up_tick - _akh.last_down_tick) < 150 and (
        Send("{XButton1 Down}")
        , SetTimer((*)=>(Send("{a Down}")
            , SetTimer((*)=>(Send("{a Up}")
                , SetTimer((*)=>Send("{XButton1 Up}"), -30)), -30)), -30)
    ))
)
dKH.PostRelease.Push((_dkh,*)=>(
    (_dkh.last_up_tick - _dkh.last_down_tick) < 150 and (
        Send("{XButton1 Down}")
      , SetTimer((*)=>(Send("{d Down}")
          , SetTimer((*)=>(Send("{d Up}")
              , SetTimer((*)=>Send("{XButton1 Up}"), -30)), -30)), -30)
    ))
)
*/

; #HotIf WinActive("ahk_exe armoredcore6.exe")
; F1::!F1
; F2::!F3
; F3::!F2
; #HotIf



/**
class ACQuickPress {
    alt_fire_threshold := 0
      , alt_fire_duration := 0
      , last_keydown := 0
      , key := ""
      , alt_key := ""
      , enabled := false
      , __OnKeyDown__ := ObjBindMethod(this, "OnKeyDown")
      , __OnKeyUp__ := ObjBindMethod(this, "OnKeyUp")
    __New(_key, _alt_key, _alt_fire_threshold:=150, _alt_fire_duration:=50) {
        this.key := _key
        this.alt_key := _alt_key
        this.alt_fire_threshold := _alt_fire_threshold
        this.alt_fire_duration := _alt_fire_duration
    }
    Enable(*) {
        if this.enabled
            return
        HotIf HOTIF_AC
        Hotkey "*~" this.key, this.__OnKeyDown__, "On"
        Hotkey "*~" this.key " Up", this.__OnKeyUp__, "On"
        HotIf
        this.enabled := true
    }
    Disable(*) {
        if !this.enabled
            return
        HotIf HOTIF_AC
        Hotkey "*~" this.key, this.__OnKeyDown__, "Off"
        Hotkey "*~" this.key " Up", this.__OnKeyUp__, "Off"
        HotIf
        this.enabled := false
    }
    Toggle(*) {
        if this.enabled
            return this.Disable()
        this.Enable()
    }
    OnKeyDown(*) {
        this.last_keydown := A_TickCount
    }
    OnKeyUp(*) {
        if (A_TickCount - this.last_keydown) < this.alt_fire_threshold
            Send("{" this.alt_key " Down}"), SetTimer((*)=>Send("{" this.alt_key " Up}"), this.alt_fire_duration)
    }
}

ACQuickPress("XButton1", "Tab", 400).Enable()
ACQuickPress("XButton2", "r", 125).Enable()
*/



;
/**
WindowToggles := {
    floorp: TogWin("ahk_exe floorp.exe"),
    hh: TogWin("ahk_exe hh.exe"),
    code: TogWin("ahk_exe Code.exe"),
}
WindowToggles.floorp.Hotkey := "+#f"
WindowToggles.hh.Hotkey := "+#a"
WindowToggles.code.Hotkey := "+#c"
*/
;
