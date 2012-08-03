/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/
class vec2 {
  num x;
  num y;
  /// Constructs a new [vec2]. Follows GLSL constructor syntax so many combinations are possible
  vec2([Dynamic x_, Dynamic y_]) {
    x = y = 0.0;
    if (x_ is vec2) {
      xy = x_.xy;
      return;
    }
    if (x_ is num && y_ is num) {
      x = x_;
      y = y_;
      return;
    }
    if (x_ is num) {
      x = y = x_;
      return;
    }
  }
  /// Constructs a new [vec2] filled with 0.
  vec2.zero() {
    x = 0.0;
    y = 0.0;
  }
  /// Constructs a new [vec2] that is a copy of [other].
  vec2.copy(vec2 other) {
    x = other.x;
    y = other.y;
  }
  /// Constructs a new [vec2] that is initialized with passed in values.
  vec2.raw(num x_, num y_) {
    x = x_;
    y = y_;
  }
  /// Constructs a new [vec2] that is initialized with values from [array] starting at [offset].
  vec2.array(Float32List array, [int offset=0]) {
    int i = offset;
    x = array[i];
    i++;
    y = array[i];
    i++;
  }
  /// Returns a printable string
  String toString() => '$x,$y';
  /// Returns a new vec2 from -this
  vec2 operator negate() => new vec2(-x, -y);
  /// Returns a new vec2 from this - [other]
  vec2 operator-(vec2 other) => new vec2(x - other.x, y - other.y);
  /// Returns a new vec2 from this + [other]
  vec2 operator+(vec2 other) => new vec2(x + other.x, y + other.y);
  /// Returns a new vec2 divided by [other]
  vec2 operator/(Dynamic other) {
    if (other is num) {
      return new vec2(x / other, y / other);
    }
    if (other is vec2) {
      return new vec2(x / other.x, y / other.y);
    }
  }
  /// Returns a new vec2 scaled by [other]
  vec2 operator*(Dynamic other) {
    if (other is num) {
      return new vec2(x * other, y * other);
    }
    if (other is vec2) {
      return new vec2(x * other.x, y * other.y);
    }
  }
  /// Returns a component from vec2. This is indexed as an array with [i]
  num operator[](int i) {
    assert(i >= 0 && i < 2);
    switch (i) {
      case 0: return x;
      case 1: return y;
    };
    return 0.0;
  }
  /// Assigns a component in vec2 the value in [v]. This is indexed as an array with [i]
  void operator[]=(int i, num v) {
    assert(i >= 0 && i < 2);
    switch (i) {
      case 0: x = v; break;
      case 1: y = v; break;
    };
  }
  /// Returns length of this
  num get length() {
    num sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    return Math.sqrt(sum);
  }
  /// Returns squared length of this
  num get length2() {
    num sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    return sum;
  }
  /// Normalizes this
  void normalize() {
    num l = length;
    if (l == 0.0) {
      return;
    }
    x /= l;
    y /= l;
  }
  /// Returns the dot product of [this] and [other]
  num dot(vec2 other) {
    num sum = 0.0;
    sum += (x * other.x);
    sum += (y * other.y);
    return sum;
  }
  /// Returns the relative error between [this] and [correct]
  num relativeError(vec2 correct) {
    num this_norm = length;
    num correct_norm = correct.length;
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns the absolute error between [this] and [correct]
  num absoluteError(vec2 correct) {
    num this_norm = length;
    num correct_norm = correct.length;
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  set xy(vec2 arg) {
    x = arg.x;
    y = arg.y;
  }
  set yx(vec2 arg) {
    y = arg.x;
    x = arg.y;
  }
  set r(num arg) => x = arg;
  set g(num arg) => y = arg;
  set s(num arg) => x = arg;
  set t(num arg) => y = arg;
  set rg(vec2 arg) {
    r = arg.r;
    g = arg.g;
  }
  set gr(vec2 arg) {
    g = arg.r;
    r = arg.g;
  }
  set st(vec2 arg) {
    s = arg.s;
    t = arg.t;
  }
  set ts(vec2 arg) {
    t = arg.s;
    s = arg.t;
  }
  vec2 get xx() => new vec2(x, x);
  vec2 get xy() => new vec2(x, y);
  vec2 get yx() => new vec2(y, x);
  vec2 get yy() => new vec2(y, y);
  vec3 get xxx() => new vec3(x, x, x);
  vec3 get xxy() => new vec3(x, x, y);
  vec3 get xyx() => new vec3(x, y, x);
  vec3 get xyy() => new vec3(x, y, y);
  vec3 get yxx() => new vec3(y, x, x);
  vec3 get yxy() => new vec3(y, x, y);
  vec3 get yyx() => new vec3(y, y, x);
  vec3 get yyy() => new vec3(y, y, y);
  vec4 get xxxx() => new vec4(x, x, x, x);
  vec4 get xxxy() => new vec4(x, x, x, y);
  vec4 get xxyx() => new vec4(x, x, y, x);
  vec4 get xxyy() => new vec4(x, x, y, y);
  vec4 get xyxx() => new vec4(x, y, x, x);
  vec4 get xyxy() => new vec4(x, y, x, y);
  vec4 get xyyx() => new vec4(x, y, y, x);
  vec4 get xyyy() => new vec4(x, y, y, y);
  vec4 get yxxx() => new vec4(y, x, x, x);
  vec4 get yxxy() => new vec4(y, x, x, y);
  vec4 get yxyx() => new vec4(y, x, y, x);
  vec4 get yxyy() => new vec4(y, x, y, y);
  vec4 get yyxx() => new vec4(y, y, x, x);
  vec4 get yyxy() => new vec4(y, y, x, y);
  vec4 get yyyx() => new vec4(y, y, y, x);
  vec4 get yyyy() => new vec4(y, y, y, y);
  num get r() => x;
  num get g() => y;
  num get s() => x;
  num get t() => y;
  vec2 get rr() => new vec2(r, r);
  vec2 get rg() => new vec2(r, g);
  vec2 get gr() => new vec2(g, r);
  vec2 get gg() => new vec2(g, g);
  vec3 get rrr() => new vec3(r, r, r);
  vec3 get rrg() => new vec3(r, r, g);
  vec3 get rgr() => new vec3(r, g, r);
  vec3 get rgg() => new vec3(r, g, g);
  vec3 get grr() => new vec3(g, r, r);
  vec3 get grg() => new vec3(g, r, g);
  vec3 get ggr() => new vec3(g, g, r);
  vec3 get ggg() => new vec3(g, g, g);
  vec4 get rrrr() => new vec4(r, r, r, r);
  vec4 get rrrg() => new vec4(r, r, r, g);
  vec4 get rrgr() => new vec4(r, r, g, r);
  vec4 get rrgg() => new vec4(r, r, g, g);
  vec4 get rgrr() => new vec4(r, g, r, r);
  vec4 get rgrg() => new vec4(r, g, r, g);
  vec4 get rggr() => new vec4(r, g, g, r);
  vec4 get rggg() => new vec4(r, g, g, g);
  vec4 get grrr() => new vec4(g, r, r, r);
  vec4 get grrg() => new vec4(g, r, r, g);
  vec4 get grgr() => new vec4(g, r, g, r);
  vec4 get grgg() => new vec4(g, r, g, g);
  vec4 get ggrr() => new vec4(g, g, r, r);
  vec4 get ggrg() => new vec4(g, g, r, g);
  vec4 get gggr() => new vec4(g, g, g, r);
  vec4 get gggg() => new vec4(g, g, g, g);
  vec2 get ss() => new vec2(s, s);
  vec2 get st() => new vec2(s, t);
  vec2 get ts() => new vec2(t, s);
  vec2 get tt() => new vec2(t, t);
  vec3 get sss() => new vec3(s, s, s);
  vec3 get sst() => new vec3(s, s, t);
  vec3 get sts() => new vec3(s, t, s);
  vec3 get stt() => new vec3(s, t, t);
  vec3 get tss() => new vec3(t, s, s);
  vec3 get tst() => new vec3(t, s, t);
  vec3 get tts() => new vec3(t, t, s);
  vec3 get ttt() => new vec3(t, t, t);
  vec4 get ssss() => new vec4(s, s, s, s);
  vec4 get ssst() => new vec4(s, s, s, t);
  vec4 get ssts() => new vec4(s, s, t, s);
  vec4 get sstt() => new vec4(s, s, t, t);
  vec4 get stss() => new vec4(s, t, s, s);
  vec4 get stst() => new vec4(s, t, s, t);
  vec4 get stts() => new vec4(s, t, t, s);
  vec4 get sttt() => new vec4(s, t, t, t);
  vec4 get tsss() => new vec4(t, s, s, s);
  vec4 get tsst() => new vec4(t, s, s, t);
  vec4 get tsts() => new vec4(t, s, t, s);
  vec4 get tstt() => new vec4(t, s, t, t);
  vec4 get ttss() => new vec4(t, t, s, s);
  vec4 get ttst() => new vec4(t, t, s, t);
  vec4 get ttts() => new vec4(t, t, t, s);
  vec4 get tttt() => new vec4(t, t, t, t);
  vec2 selfAdd(vec2 arg) {
    x = x + arg.x;
    y = y + arg.y;
    return this;
  }
  vec2 selfSub(vec2 arg) {
    x = x - arg.x;
    y = y - arg.y;
    return this;
  }
  vec2 selfMul(vec2 arg) {
    x = x * arg.x;
    y = y * arg.y;
    return this;
  }
  vec2 selfDiv(vec2 arg) {
    x = x / arg.x;
    y = y / arg.y;
    return this;
  }
  vec2 selfScale(num arg) {
    x = x * arg;
    y = y * arg;
    return this;
  }
  vec2 selfNegate() {
    x = -x;
    y = -y;
    return this;
  }
  vec2 copy() {
    vec2 c = new vec2.copy(this);
    return c;
  }
  void copyIntoVector(vec2 arg) {
    arg.x = x;
    arg.y = y;
  }
  void copyFromVector(vec2 arg) {
    x = arg.x;
    y = arg.y;
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(Float32List array, [int offset=0]) {
    int i = offset;
    array[i] = x;
    i++;
    array[i] = y;
    i++;
  }
  /// Returns a copy of [this] as a [Float32List].
  Float32List copyAsArray() {
    Float32List array = new Float32List(2);
    int i = 0;
    array[i] = x;
    i++;
    array[i] = y;
    i++;
    return array;
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(Float32List array, [int offset=0]) {
    int i = offset;
    x = array[i];
    i++;
    y = array[i];
    i++;
  }
}
