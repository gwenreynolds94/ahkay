#Requires AutoHotkey v2.0+
;
#Include gdijk.ahk
;
class gdeye extends Gui {
    static opts_layered := "-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs"
        ,  font_name := "Arial"
        ,  font_options := "x10p y10p w80p Centre cffffffff r4"
        ,  WM_LBUTTONDOWN := ObjBindMethod(gdeye, "__WM_LBUTTONDOWN__")
    x := 0, y := 0, w := 0, h := 0, gfx := 0, hbm := 0, hdc := 0, obm := 0, is_init := false
  , display_text := "", font_options := "x10p w80p Centre cffffffff r4"
    __New(x, y, w, h, _display_text:="") {
        super.__New(gdeye.opts_layered,,this)
        this.x := x, this.y := y, this.w := w, this.h := h
        this.display_text := _display_text
        display_len := StrLen(this.display_text)
        if display_len = 1
            this.font_options .= " s50 y20p"
        else if display_len <= 3
            this.font_options .= " s30 y30p"
        else this.font_options .= " s16 y40p"
        this.Show("NA")
        this.__Gdip_Init__()
        this.__FillRound__()
        this.__UpdateLayeredWindow__()
        this.__Gdip_Dispose__()
    }
    __FillRound__(*) {
        Gdip_SetSmoothingMode(this.gfx, 4)
        pbr := Gdip_BrushCreateSolid(0x77000000)
        Gdip_FillRoundedRectangle(this.gfx, pbr, 0, 0, this.w, this.h, 10)
        Gdip_DeleteBrush(pbr)
        Gdip_FontFamilyCreate(gdeye.font_name)
        Gdip_TextToGraphics(this.gfx, this.display_text, this.font_options, gdeye.font_name, this.w, this.h)
    }
    __UpdateLayeredWindow__(*) {
        UpdateLayeredWindow(this.Hwnd, this.hdc, this.x, this.y, this.w, this.h)
    }
    __Gdip_Init__(*) {
        if this.is_init
            return
        this.hbm := CreateDIBSection(this.w, this.h)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.gfx := Gdip_GraphicsFromHDC(this.hdc)
        this.is_init := true
    }
    __Gdip_Dispose__(*) {
        if !this.is_init
            return
        SelectObject(this.hdc, this.obm)
        DeleteObject(this.hbm)
        DeleteDC(this.hdc)
        Gdip_DeleteGraphics(this.gfx)
        this.is_init := false
    }
    static __WM_LBUTTONDOWN__(wParam, lParam, msg, hwnd, *) {
        PostMessage 0xA1, 2
    }
    static __New(*) {
        OnMessage 0x201, gdeye.WM_LBUTTONDOWN
    }
}
;
gda := gdeye(50, 50, 100, 100, "A")
gdb := gdeye(150, 150, 100, 100, "Bas")
gdc := gdeye(250, 50, 100, 100, "Casdasd")

F4::ExitApp