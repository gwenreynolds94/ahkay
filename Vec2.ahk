#Requires AutoHotkey v2.0+
;
class Vec2 {
    x := 0, y := 0
    __New(_x?, _y?) {
        this.x := _x ?? 0
        this.y := _y ?? 0
    }
    Mul(_value, _new := false) {
        if _new
            return Vec2(this.x * _value, this.y * _value)
        this.x *= _value
        this.y *= _value
        return this
    }
    Mul2(_x, _y, _new := false) {
        if _new
            return Vec2(this.x * _x, this.y * _y)
        this.x *= _x
        this.y *= _y
        return this
    }
    MulV(_vec2, _new := false) {
        if _new
            return Vec2(this.x * _vec2.x, this.y * _vec2.y)
        this.x *= _vec2.x
        this.y *= _vec2.y
        return this
    }
}
;
