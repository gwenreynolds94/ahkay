#Requires AutoHotkey v2.0+
;
#Include Win.ahk
#Include dbgo.ahk
;
class Trans {
    static stepcnt := 6
        , min := 125
        , steps := this.MakeSteps()
    static SetHalf(_wintitle?) => WinExist(_wintitle ?? "A") and WinSetTransparent(255 // 2)
    static SetFull(_wintitle?) => WinExist(_wintitle ?? "A") and WinSetTransparent(255)
    static MakeSteps() {
        steps := [this.min]
        interval := (255 - this.min) // (this.stepcnt - 1)
        loop (this.stepcnt - 2)
            steps.Push(steps[steps.Length] + interval)
        steps.Push 255
        return steps
    }
    static PrevStep(_wintitle?) {
        wHWND := WinExist(_wintitle ?? "A")
        if not wHWND
            return
        prevStep := 255
        currTrans := WinGetTransparent(wHWND) or 255
        loop this.steps.Length {
            step := this.steps[this.steps.Length - A_Index + 1]
            if step < currTrans {
                prevStep := step
                break
            }
        }
        WinSetTransparent(prevStep, wHWND)
        dbgo("trans:" wHWND, prevStep)
        Tooltip prevStep
        SetTimer((*) => Tooltip(), -2000)
    }
    static NextStep(_wintitle?) {
        wHWND := WinExist(_wintitle ?? "A")
        if not wHWND
            return
        nextStep := this.min
        currTrans := WinGetTransparent(wHWND) or 255
        for step in this.steps {
            if step > currTrans {
                nextStep := step
                break
            }
        }
        WinSetTransparent(nextStep, wHWND)
        dbgo("trans:" wHWND, nextStep)
        Tooltip nextStep
        SetTimer((*) => Tooltip(), -2000)
    }
}
