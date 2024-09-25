#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include trans.ahk
#Include wink.ahk
#Include taskbar.ahk
#Include tip.ahk
#Include hotpath.ahk
#Include wincoord.ahk
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

cpath := hotpath("CapsLock", 1000)
cpath["r", "r"] := (*)=>Reload()
cpath["w", "a"] := (*)=>Run("C:\Program Files\AutoHotkey\v2\AutoHotkey.chm")
cpath["w", "d"] := (*)=>(
    Run("C:\Users\" A_UserName "\proggers\SysInternals\Debugviewpp.exe")
  , WinWait("ahk_exe Debugviewpp.exe")
  , WinActivate()
)
cpath.Enable()

wink("000", "+#0", "#0")
wink("999", "+#9", "#9")
wink("888", "+#8", "#8")
wink("777", "+#7", "#7")
wink("666", "+#6", "#6")
wink("555", "+#5", "#5")
wink("444", "+#4", "#4")
wink("333", "+#3", "#3")
wink("222", "+#2", "#2")
wink("111", "+#1", "#1")

sc029 & 1::trans.PrevStep
sc029 & 2::trans.NextStep
sc029 & F1::taskbar.autohide.Toggle
sc029::sc029

wincoord.EnableMouseSizing()
wincoord.EnableMouseMoving()

#HotIf WinActive("ahk_exe Code.exe")
XButton1 & RButton::^c
XButton2 & LButton::^v
XButton2 & RButton::^x
XButton1::XButton1
XButton2::XButton2
#HotIf

/**
class KeyHandler {
    is_down := false
      , key := ""
      , hotif := false
      , input_level := 0
      , last_up_tick := 0
      , last_down_tick := 0
      , prev_up_tick := 0
      , prev_down_tick := 0
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
        this.prev_down_tick := this.last_down_tick
        this.last_down_tick := A_TickCount, this.is_down := true
        loop this.PostPressOnce.Length
            (this.PostPressOnce.Pop())(this)
        for _func in this.PostPress
            _func(this)
    }
    __OnRelease(*) {
        this.prev_up_tick := this.last_up_tick
        this.last_up_tick := A_TickCount, this.is_down := false
        loop this.PostReleaseOnce.Length
            (this.PostReleaseOnce.Pop())(this)
        for _func in this.PostRelease
            _func(this)
    }
}
*/

/**
global HOTIF_AC := (*)=>WinActive("ahk_exe armoredcore6.exe")
#HotIf HOTIF_AC()
XButton1::Send("{LButton Down}{RButton Down}")
XButton1 Up::Send("{RButton Up}{LButton Up}")
XButton2::Send("{1 Down}{2 Down}")
XButton2 Up::Send("{2 Up}{1 Up}")

global X1H := KeyHandler("*~XButton1", HOTIF_AC)
X1H.Enable()
global X2H := KeyHandler("*~XButton2", HOTIF_AC)
X2H.Enable()
X1H.PostRelease.Push((_x1h,*)=>(
    (_x1h.last_up_tick - _x1h.last_down_tick) < 200 and (
        Send("{LShift Down}"), SetTimer((*)=>Send("{LShift Up}"), -30)
    ))
)
X2H.PostRelease.Push((_x2h,*)=>(
    (_x2h.last_up_tick - _x2h.last_down_tick) < 200 and (
        Send("{LCtrl Down}"), SetTimer((*)=>Send("{LCtrl Up}"), -30)
    )
))
*/
; 
; class ACMouse {
;     static X1 := ACMouse.Btn("*~XButton1")
;          , X2 := ACMouse.Btn("*~XButton2")
;          , LB := ACMouse.Btn("*~LButton")
;          , RB := ACMouse.Btn("*~RButton")
;          , tap_threshold := 200
;          , GameInputs := {
;             LArm: { down: (*)=>Send("{1 Down}")      , up: (*)=>Send("{1 Up}")      }
;           , RArm: { down: (*)=>Send("{2 Down}")      , up: (*)=>Send("{2 Up}")      }
;           , LBak: { down: (*)=>Send("{3 Down}")      , up: (*)=>Send("{3 Up}")      }
;           , RBak: { down: (*)=>Send("{4 Down}")      , up: (*)=>Send("{4 Up}")      }
;           , TrgA: { down: (*)=>Send("{q Down}")      , up: (*)=>Send("{q Up}")      }
;           , NBst: { down: (*)=>Send("{t Down}")      , up: (*)=>Send("{t Up}")      }
;           , ABst: { down: (*)=>Send("{Tab Down}")    , up: (*)=>Send("{Tab Up}")    }
;           , SCtl: { down: (*)=>Send("{LCtrl Down}")  , up: (*)=>Send("{LCtrl Up}")  }
;           , QBst: { down: (*)=>Send("{LShift Down}") , up: (*)=>Send("{LShift Up}") }
;          }
;          , Macros := {
;             LArm: (_this,_period:=(-30),*)=>(this.GameInputs.LArm.down(),SetTimer(this.GameInputs.LArm.up,_period),true)
;           , RArm: (_this,_period:=(-30),*)=>(this.GameInputs.RArm.down(),SetTimer(this.GameInputs.RArm.up,_period),true)
;           , LBak: (_this,_period:=(-30),*)=>(this.GameInputs.LBak.down(),SetTimer(this.GameInputs.LBak.up,_period),true)
;           , RBak: (_this,_period:=(-30),*)=>(this.GameInputs.RBak.down(),SetTimer(this.GameInputs.RBak.up,_period),true)
;           , TrgA: (_this,_period:=(-30),*)=>(this.GameInputs.TrgA.down(),SetTimer(this.GameInputs.TrgA.up,_period),true)
;           , ABst: (_this,_period:=(-30),*)=>(this.GameInputs.ABst.down(),SetTimer(this.GameInputs.ABst.up,_period),true)
;           , NBst: (_this,_period:=(-30),*)=>(this.GameInputs.NBst.down(),SetTimer(this.GameInputs.NBst.up,_period),true)
;           , SCtl: (_this,_period:=(-30),*)=>(this.GameInputs.SCtl.down(),SetTimer(this.GameInputs.SCtl.up,_period),true)
;           , QBst: (_this,_period:=(-30),*)=>(this.GameInputs.QBst.down(),SetTimer(this.GameInputs.QBst.up,_period),true)
;          }
;          , CoreExpansion := (*)=>(this.Macros.ABst(-120),SetTimer(ObjBindMethod(this.Macros.SCtl,"Call",(-40)),(-40)),true)
;     static __New() {
;         this.LB.on_press_actions.always.Push (*)=>(
;             _btn:=(!this.X2.pressed and "LArm" or "LBak")
;           , (this.GameInputs.%_btn%.down(), this.LB.on_release_actions.once.Push(this.GameInputs.%_btn%.up))
;         )
;         this.RB.on_press_actions.always.Push (*)=>(
;             _btn:=(!this.X2.pressed and "RArm" or "RBak")
;           , (this.GameInputs.%_btn%.down(), this.RB.on_release_actions.once.Push(this.GameInputs.%_btn%.up))
;         )
;         this.X1.on_press_actions.always.Push (*)=>(
;             this.GameInputs.NBst.down()
;         )
;         this.X1.on_release_actions.always.Push (*)=>(
;             this.GameInputs.NBst.up()
;           , ((this.X1.recent_release - this.X1.recent_press) < this.tap_threshold) and this.Macros.QBst(-40)
;         )
;         this.X2.on_press_actions.always.Push (*)=>(
;             this.LB.pressed and (this.GameInputs.LBak.down(),this.LB.on_release_actions.once.Push(this.GameInputs.LBak.up),true)
;           , this.RB.pressed and (this.GameInputs.RBak.down(),this.RB.on_release_actions.once.Push(this.GameInputs.RBak.up),true)
;         )
;         this.X2.on_release_actions.always.Push (*)=>(
;             ((this.X2.recent_release - this.X2.previous_press) < this.tap_threshold*1.5) and this.CoreExpansion() or
;             ((this.X2.recent_release - this.X2.recent_press) < this.tap_threshold) and this.Macros.ABst(-40)
;         )
;         this.X1.Enable
;         this.X2.Enable
;         this.LB.Enable
;         this.RB.Enable
;     }
;     class Btn {
;         key := ""
;       , pressed := false
;       , _enabled := false
;       , input_level := 0
;       , recent_press := 0
;       , recent_release := 0
;       , previous_press := 0
;       , previous_release := 0
;       , on_press_actions := { once: [], always: [] }
;       , on_release_actions := { once: [], always: [] }
;       , Enable := ObjBindMethod(this, "__Hotkey", true)
;       , Disable := ObjBindMethod(this, "__Hotkey", false)
;       , OnRelease := ObjBindMethod(this, "__OnRelease")
;       , OnPress := ObjBindMethod(this, "__OnPress")
;       , HotIf := ObjBindMethod(this, "__HotIf")
;       , and_hotifs := []
;       , or_hotifs := []
;       , AndHotIf := ObjBindMethod(this.and_hotifs, "Push")
;       , OrHotIf := ObjBindMethod(this.or_hotifs, "Push")
;       __HotIf(*)=>WinActive("ahk_exe armoredcore6.exe")
;       /*
;         __HotIf(*) {
;             ands := this._enabled
;             ors := !this.or_hotifs.Length
;             for _hotif in this.and_hotifs
;                 if !_hotif(this)
;                     ands := false
;             for _hotif in this.or_hotifs
;                 if _hotif(this)
;                     ors := true
;             return ands and ors
;         }
;         */
;         __OnPress(*) {
;             this.previous_press := this.recent_press
;             this.recent_press := A_TickCount, this.pressed := true
;             loop this.on_press_actions.once.Length
;                 (this.on_press_actions.once.Pop())(this)
;             for _func in this.on_press_actions.always
;                 _func(this)
;         }
;         __OnRelease(*) {
;             this.previous_release := this.recent_release
;             this.recent_release := A_TickCount, this.pressed := false
;             loop this.on_release_actions.once.Length
;                 (this.on_release_actions.once.Pop())(this)
;             for _func in this.on_release_actions.always
;                 _func(this)
;         }
;         __New(_key, _input_level:=0) {
;             this.key := _key
;             this.input_level := _input_level
;         }
;         __Hotkey(_enabled:=true, *) {
;             if !this._enabled and (this._enabled:=_enabled) {
;                 HotIf this.HotIf
;                 Hotkey this.key, this.OnPress, "On I" this.input_level
;                 Hotkey this.key " Up", this.OnRelease, "On I" this.input_level
;                 HotIf
;             } else if this._enabled and !(this._enabled:=_enabled) {
;                 HotIf this.HotIf
;                 Hotkey this.key, this.OnPress, "Off"
;                 Hotkey this.key " Up", this.OnRelease, "Off"
;                 HotIf
;             }
;         }
;     }
; }
; 

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
