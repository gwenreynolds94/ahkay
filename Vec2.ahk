#Requires AutoHotkey v2.0+
;
class Vec2 {
    x := 0, y := 0
    __New(_x?, _y?) {
        this.x := _x ?? 0
        this.y := _y ?? 0
    }
    Mul1(_value, _new := false) {
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
    Mul(_p0, _p1?, _new:=false) {
        if IsNumber(_p0) {
            if IsSet(_p1)
                return this.Mul2(_p0, _p1, _new)
            else return this.Mul1(_p0, _new)
        } else return this.MulV(_p0, _new)
    }
    Add1(_value, _new := false) {
        if _new
            return Vec2(this.x + _value, this.y + _value)
        this.x += _value
        this.y += _value
        return this
    }
    Add2(_x, _y, _new := false) {
        if _new
            return Vec2(this.x + _x, this.y + _y)
        this.x += _x
        this.y += _y
        return this
    }
    AddV(_vec2, _new := false) {
        if _new
            return Vec2(this.x + _vec2.x, this.y + _vec2.y)
        this.x += _vec2.x
        this.y += _vec2.y
        return this
    }
    Add(_p0, _p1?, _new:=false) {
        if IsNumber(_p0) {
            if IsSet(_p1)
                return this.Add2(_p0, _p1, _new)
            else return this.Add1(_p0, _new)
        } else return this.AddV(_p0, _new)
    }
    Sub1(_value, _new := false) {
        if _new
            return Vec2(this.x - _value, this.y - _value)
        this.x -= _value
        this.y -= _value
        return this
    }
    Sub2(_x, _y, _new := false) {
        if _new
            return Vec2(this.x - _x, this.y - _y)
        this.x -= _x
        this.y -= _y
        return this
    }
    SubV(_vec2, _new := false) {
        if _new
            return Vec2(this.x - _vec2.x, this.y - _vec2.y)
        this.x -= _vec2.x
        this.y -= _vec2.y
        return this
    }
    Sub(_p0, _p1?, _new:=false) {
        if IsNumber(_p0) {
            if IsSet(_p1)
                return this.Sub2(_p0, _p1, _new)
            else return this.Sub1(_p0, _new)
        } else return this.SubV(_p0, _new)
    }
    Div1(_value, _new := false) {
        if _new
            return Vec2(this.x / _value, this.y / _value)
        this.x /= _value
        this.y /= _value
        return this
    }
    Div2(_x, _y, _new := false) {
        if _new
            return Vec2(this.x / _x, this.y / _y)
        this.x /= _x
        this.y /= _y
        return this
    }
    DivV(_vec2, _new := false) {
        if _new
            return Vec2(this.x / _vec2.x, this.y / _vec2.y)
        this.x /= _vec2.x
        this.y /= _vec2.y
        return this
    }
    Div(_p0, _p1?, _new:=false) {
        if IsNumber(_p0) {
            if IsSet(_p1)
                return this.Div2(_p0, _p1, _new)
            else return this.Div1(_p0, _new)
        } else return this.DivV(_p0, _new)
    }
}
;
