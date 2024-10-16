#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include tip.ahk
;
class wincoord {
    static sizingbeginkey := "#RButton"
        ,  movingbeginkey := "#LButton"
        ,  mouseIsSizing := false
        ,  mouseIsMoving := false
        ,  movingendkey := "*LButton Up"
        ,  sizingendkey := "*RButton Up"
        ,  curwin := 0
        ,  StartMouseSizing := ObjBindMethod(this, "__StartMouseSizing")
        ,  StartMouseMoving := ObjBindMethod(this, "__StartMouseMoving")
        ,  EndMouseSizing := ObjBindMethod(this, "__EndMouseSizing")
        ,  EndMouseMoving := ObjBindMethod(this, "__EndMouseMoving")
        ,  IsMouseSizing := ObjBindMethod(this, "__IsMouseSizing")
        ,  IsMouseMoving := ObjBindMethod(this, "__IsMouseMoving")
        /** @prop {Object} SWP Constants for use by SetWindowPos */
        ,  SWP := { NOSIZE          : 0x0001
                  , NOMOVE          : 0x0002
                  , NOZORDER        : 0x0004
                  , NOREDRAW        : 0x0008
                  , NOACTIVATE      : 0x0010
                  , FRAMECHANGED    : 0x0020
                  , SHOWWINDOW      : 0x0040
                  , HIDEWINDOW      : 0x0080
                  , NOCOPYBITS      : 0x0100
                  , NOOWNERZORDER   : 0x0200
                  , NOSENDCHANGING  : 0x0400
                  , HWND_BOTTOM     : 1
                  , HWND_TOP        : 0
                  , HWND_TOPMOST    : -1
                  , HWND_NOTTOPMOST : -2 }
    static __IsMouseSizing(*)=>this.mouseIsSizing
    static __StartMouseSizing(*) {
        CoordMode("Mouse", "Screen")
        MouseGetPos(&_mxstart, &_mystart, &_mwin)
        this.curwin := _mwin
        SendMessage(0x1666, true,,, _mwin)
        wrect := wincoord.GetWindowRect(_mwin)
        this.mouseIsSizing := true
        MouseSizingLoop(*) {
            static mxrecent := _mxstart
                ,  myrecent := _mystart
            CoordMode("Mouse", "Screen")
            SetWinDelay -1
            MouseGetPos(&_mxcurrent, &_mycurrent)
            if (_mxcurrent != mxrecent) or (_mycurrent != myrecent) {
                neww := wrect.w + (_mxcurrent - _mxstart)
                newh := wrect.h + (_mycurrent - _mystart)
                neww := (neww < 200) ? 200 : neww
                newh := (newh < 200) ? 200 : newh
                wincoord.SetWindowPos(_mwin,,,,neww,newh)
            }
            mxrecent := _mxcurrent
            myrecent := _mycurrent
            if !this.mouseIsSizing
                SetTimer(,0)
        }
        SetTimer(MouseSizingLoop, 1)
        Hotkey this.sizingendkey, this.EndMouseSizing, "On"
    }
    static __EndMouseSizing(*) {
        Hotkey this.sizingendkey, this.EndMouseSizing, "Off"
        DetectHiddenWindows true
        SendMessage(0x1666,,,,this.curwin)
        this.mouseIsSizing := false
    }
    static EnableMouseSizing(_beginkey?, _endkey?, *) {
        this.sizingbeginkey := _beginkey ?? this.sizingbeginkey
        this.sizingendkey := _endkey ?? this.sizingendkey
        Hotkey this.sizingbeginkey, this.StartMouseSizing, "On"
    }
    static __IsMouseMoving(*)=>this.mouseIsMoving
    static __StartMouseMoving(*) {
        CoordMode("Mouse", "Screen")
        MouseGetPos(&_mxstart, &_mystart, &_mwin)
        wrect := wincoord.GetWindowRect(_mwin)
        this.mouseIsMoving := true
        MouseMovingLoop(*) {
            static mxrecent := _mxstart
                ,  myrecent := _mystart
            CoordMode("Mouse", "Screen")
            SetWinDelay -1
            MouseGetPos(&_mxcurrent, &_mycurrent)
            if (_mxcurrent != mxrecent) or (_mycurrent != myrecent) {
                newx := wrect.x + (_mxcurrent - _mxstart)
                newy := wrect.y + (_mycurrent - _mystart)
                wincoord.SetWindowPos(_mwin,,newx,newy)
            }
            mxrecent := _mxcurrent
            myrecent := _mycurrent
            if !this.mouseIsMoving
                SetTimer(,0)
        }
        SetTimer(MouseMovingLoop, 1)
        Hotkey this.movingendkey, this.EndMouseMoving, "On"
    }
    static __EndMouseMoving(*) {
        Hotkey this.movingendkey, this.EndMouseMoving, "Off"
        this.mouseIsMoving := false
    }
    static EnableMouseMoving(_beginkey?, _endkey?, *) {
        this.movingbeginkey := _beginkey ?? this.movingbeginkey
        this.movingendkey := _endkey ?? this.movingendkey
        Hotkey this.movingbeginkey, this.StartMouseMoving, "On"
    }
    static SetWindowPos(_hwnd, _after_hwnd:=false, _x?, _y?, _cx?, _cy?, _uflags?) {
        if IsSet(_uflags) {
            uflags := _uflags
        } else {
            uflags := wincoord.SWP.NOZORDER
            if not IsSet(_x) and not IsSet(_y)
                uflags |= wincoord.SWP.NOMOVE
            if not IsSet(_cx) and not IsSet(_cy)
                uflags |= wincoord.SWP.NOSIZE
        }
        DllCall "SetWindowPos", "Ptr", _hwnd
                              , "Int", _after_hwnd
                              , "Int", _x ?? 0, "Int", _y ?? 0
                              , "Int", _cx ?? 0, "Int", _cy ?? 0
                              , "UInt", uflags
    }
    static GetWindowRect(_hwnd) {
        wRECT := Buffer(16)
        DllCall "GetWindowRect", "Ptr", _hwnd, "Ptr", wRECT
        return {
            x: _x:=NumGet(wRECT, 0, "Int")
          , y: _y:=NumGet(wRECT, 4, "Int")
          , cx: _cx:=NumGet(wRECT, 8, "Int")
          , cy: _cy:=NumGet(wRECT, 12, "Int")
          , w: _cx-_x
          , h: _cy-_y
        }
    }
}
;
