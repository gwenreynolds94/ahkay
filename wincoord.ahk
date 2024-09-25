#Requires AutoHotkey v2.0+
#Warn All, OutputDebug
#SingleInstance Force
;
#Include tip.ahk
;
class wincoord {
    static sizingbeginkey := "#RButton"
        ,  sizingendkey := "*RButton Up"
        ,  movingbeginkey := "#LButton"
        ,  movingendkey := "*LButton Up"
        ,  mouseIsSizing := false
        ,  mouseIsMoving := false
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
        ,  StartMouseSizing := ObjBindMethod(this, "__StartMouseSizing")
        ,  EndMouseSizing := ObjBindMethod(this, "__EndMouseSizing")
        ,  IsMouseSizing := ObjBindMethod(this, "__IsMouseSizing")
        ,  StartMouseMoving := ObjBindMethod(this, "__StartMouseMoving")
        ,  EndMouseMoving := ObjBindMethod(this, "__EndMouseMoving")
        ,  IsMouseMoving := ObjBindMethod(this, "__IsMouseMoving")
    static __IsMouseSizing(*)=>this.mouseIsSizing
    static __StartMouseSizing(*) {
        CoordMode("Mouse", "Screen")
        MouseGetPos(&_mxstart, &_mystart, &_mwin)
        WinGetPos(,,&_winw, &_winh, _mwin)
        this.mouseIsSizing := true
        MouseSizingLoop(*) {
            static mxrecent := _mxstart
                ,  myrecent := _mystart
            CoordMode("Mouse", "Screen")
            SetWinDelay -1
            MouseGetPos(&_mxcurrent, &_mycurrent)
            if (_mxcurrent != mxrecent) or (_mycurrent != myrecent) {
                neww := _winw + (_mxcurrent - _mxstart)
                newh := _winh + (_mycurrent - _mystart)
                neww := (neww < 200) ? 200 : neww
                newh := (newh < 200) ? 200 : newh
                WinMove(,,neww,newh,_mwin)
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
        Hotkey this.sizingendkey, this.EnableMouseSizing, "Off"
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
        WinGetPos(&_winx, &_winy,,, _mwin)
        this.mouseIsMoving := true
        MouseMovingLoop(*) {
            static mxrecent := _mxstart
                ,  myrecent := _mystart
            CoordMode("Mouse", "Screen")
            SetWinDelay -1
            MouseGetPos(&_mxcurrent, &_mycurrent)
            if (_mxcurrent != mxrecent) or (_mycurrent != myrecent) {
                newx := _winx + (_mxcurrent - _mxstart)
                newy := _winy + (_mycurrent - _mystart)
                WinMove(newx,newy,,,_mwin)
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
    static SetWindowPos(_hwnd, _after_hwnd?, _x?, _y?, _cx?, _cy?, _uflags?) {

    }
}
;
