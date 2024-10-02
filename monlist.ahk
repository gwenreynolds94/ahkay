#Requires AutoHotkey v2.0+

#Include dbgo.ahk

class monlist {
    class mon {
        l := 0,  t := 0,  r := 0,  b := 0
     , wl := 0, wt := 0, wr := 0, wb := 0
        __New(_monitor_id?) {
            MonitorGet(_monitor_id?, &l, &t, &r, &b)
            MonitorGetWorkArea(_monitor_id?, &wl, &wt, &wr, &wb)
            this.l := l, this.t := t, this.r := r, this.b := b
            this.wl := wl, this.wt := wt, this.wr := wr, this.wb := wb
        }
    }
    static __Enum(_varcount:=1) {
        moncount := MonitorGetCount()
        index := 0
        _Enum_(&var, *) {
            var := monlist.mon(index)
            return ++index <= moncount
        }
        return _Enum_
    }
    static __Item[_monitor_id] => monlist.mon(_monitor_id)
}
