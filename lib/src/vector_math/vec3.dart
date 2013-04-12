/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

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

part of vector_math;

/// 3D vector.
class vec3 {
  final _storage = new Float32List(3);

  /// Constructs a new [vec3] initialized with passed in values.
  vec3(double x_, double y_, double z_) {
    makeRaw(x_, y_, z_);
  }

  /// Components of [this] are set to the passed in values.
  vec3 makeRaw(double x_, double y_, double z_) {
    _storage[0] = x_;
    _storage[1] = y_;
    _storage[2] = z_;
    return this;
  }
  //// Constructs a new [vec3] zero vector.
  vec3.zero() {
    makeZero();
  }

  /// Make [this] the zero vector.
  vec3 makeZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    return this;
  }

  /// Constructs a copy of [other].
  vec3.copy(vec3 other) {
    makeCopy(other);
  }

  /// Make [this] a copy of [other] [other].
  vec3 makeCopy(vec3 other) {
    _storage[0] = other._storage[0];
    _storage[1] = other._storage[1];
    _storage[2] = other._storage[2];
    return this;
  }

  /// Constructs a new [vec3] that is initialized with values from [array] starting at [offset].
  vec3.array(List<num> array, [int offset=0]) {
    int i = offset;
    _storage[0] = array[i+0];
    _storage[1] = array[i+1];
    _storage[2] = array[i+2];
  }

  /// Splats a scalar into all lanes of the vector.
  vec3 splat(double arg) {
    _storage[2] = arg;
    _storage[1] = arg;
    _storage[0] = arg;
    return this;
  }

  /// Returns a printable string
  String toString() => '[${_storage[0]},${_storage[1]},${_storage[2]}]';
  /// Returns a new vec3 from -this
  vec3 operator-() => new vec3(- _storage[0], - _storage[1], - _storage[2]);
  /// Returns a new vec3 from this - [other]
  vec3 operator-(vec3 other) => new vec3(_storage[0] - other._storage[0], _storage[1] - other._storage[1], _storage[2] - other._storage[2]);
  /// Returns a new vec3 from this + [other]
  vec3 operator+(vec3 other) => new vec3(_storage[0] + other._storage[0], _storage[1] + other._storage[1], _storage[2] + other._storage[2]);
  /// Returns a new vec3 divided by [other]
  vec3 operator/(double scale) {
    var o = 1.0 / scale;
    return new vec3(_storage[0] * o, _storage[1] * o, _storage[2] * o);
  }
  /// Returns a new vec3 scaled by [other]
  vec3 operator*(double scale) {
    var o = scale;
    return new vec3(_storage[0] * o, _storage[1] * o, _storage[2] * o);
  }
  /// Returns a component from vec3. This is indexed as an array with [i]
  double operator[](int i) => _storage[i];
  /// Assigns a component in vec3 the value in [v]. This is indexed as an array with [i]
  void operator[]=(int i, double v) { _storage[i] = v; }
  /// Returns length of this
  double get length {
    double sum = 0.0;
    sum += (_storage[0] * _storage[0]);
    sum += (_storage[1] * _storage[1]);
    sum += (_storage[2] * _storage[2]);
    return Math.sqrt(sum);
  }
  /// Returns squared length of this
  double get length2 {
    double sum = 0.0;
    sum += (_storage[0] * _storage[0]);
    sum += (_storage[1] * _storage[1]);
    sum += (_storage[2] * _storage[2]);
    return sum;
  }
  /// Normalizes [this]. Returns [this].
  vec3 normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    _storage[2] *= l;
    return this;
  }
  /// Normalizes [this]. Returns length.
  double normalizeLength() {
    double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    _storage[2] *= l;
    return l;
  }
  /// Normalizes [this] returns new vector or optional [out]
  vec3 normalized([vec3 out = null]) {
    if (out == null) {
      out = new vec3(_storage[0], _storage[1], _storage[2]);
    }
    double l = out.length;
    if (l == 0.0) {
      return out;
    }
    l = 1.0 / l;
    out._storage[0] *= l;
    out._storage[1] *= l;
    out._storage[2] *= l;
    return out;
  }
  /// Returns the dot product of [this] and [other]
  double dot(vec3 other) {
    double sum = 0.0;
    sum += _storage[0] * other._storage[0];
    sum += _storage[1] * other._storage[1];
    sum += _storage[2] * other._storage[2];
    return sum;
  }
  /// Returns the cross product of [this] and [other], optionally pass in output storage [out]
  vec3 cross(vec3 other, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.zero();
    }
    out._storage[0] = _storage[1] * other._storage[2] - _storage[2] * other._storage[1];
    out._storage[1] = _storage[2] * other._storage[0] - _storage[0] * other._storage[2];
    out._storage[2] = _storage[0] * other._storage[1] - _storage[1] * other._storage[0];
    return out;
  }
  /// Returns the relative error between [this] and [correct]
  double relativeError(vec3 correct) {
    double correct_norm = correct.length;
    double diff_norm = (this - correct).length;
    return diff_norm/correct_norm;
  }
  /// Returns the absolute error between [this] and [correct]
  double absoluteError(vec3 correct) {
    return (this - correct).length;
  }

  /// Returns true if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || _storage[0].isInfinite;
    is_infinite = is_infinite || _storage[1].isInfinite;
    is_infinite = is_infinite || _storage[2].isInfinite;
    return is_infinite;
  }
  /// Returns true if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || _storage[0].isNaN;
    is_nan = is_nan || _storage[1].isNaN;
    is_nan = is_nan || _storage[2].isNaN;
    return is_nan;
  }
  vec3 add(vec3 arg) {
    _storage[0] = _storage[0] + arg._storage[0];
    _storage[1] = _storage[1] + arg._storage[1];
    _storage[2] = _storage[2] + arg._storage[2];
    return this;
  }
  vec3 sub(vec3 arg) {
    _storage[0] = _storage[0] - arg._storage[0];
    _storage[1] = _storage[1] - arg._storage[1];
    _storage[2] = _storage[2] - arg._storage[2];
    return this;
  }
  vec3 multiply(vec3 arg) {
    _storage[0] = _storage[0] * arg._storage[0];
    _storage[1] = _storage[1] * arg._storage[1];
    _storage[2] = _storage[2] * arg._storage[2];
    return this;
  }
  vec3 div(vec3 arg) {
    _storage[0] = _storage[0] / arg._storage[0];
    _storage[1] = _storage[1] / arg._storage[1];
    _storage[2] = _storage[2] / arg._storage[2];
    return this;
  }
  vec3 scale(double arg) {
    _storage[2] = _storage[2] * arg;
    _storage[1] = _storage[1] * arg;
    _storage[0] = _storage[0] * arg;
    return this;
  }
  vec3 scaled(num arg) {
    return clone().scale(arg);
  }
  vec3 negate() {
    _storage[2] = -_storage[2];
    _storage[1] = -_storage[1];
    _storage[0] = -_storage[0];
    return this;
  }
  vec3 absolute() {
    _storage[0] = -_storage[0].abs();
    _storage[1] = -_storage[1].abs();
    _storage[2] = -_storage[2].abs();
    return this;
  }

  vec3 clone() {
    return new vec3.copy(this);
  }
  vec3 copyInto(vec3 arg) {
    arg._storage[0] = _storage[0];
    arg._storage[1] = _storage[1];
    arg._storage[2] = _storage[2];
    return arg;
  }
  vec3 copyFrom(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    return this;
  }
  vec3 setComponents(double x_, double y_, double z_) {
    _storage[0] = x_;
    _storage[1] = y_;
    _storage[2] = z_;
    return this;
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset=0]) {
    int i = offset;
    array[i+0] = _storage[0];
    array[i+1] = _storage[1];
    array[i+2] = _storage[2];
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<num> array, [int offset=0]) {
    int i = offset;
    _storage[0] = array[i+0];
    i++;
    _storage[1] = array[i+1];
    i++;
    _storage[2] = array[i+2];
    i++;
  }
  set xy(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set xz(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set yx(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set yz(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set zx(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set zy(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set xyz(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set xzy(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set yxz(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set yzx(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set zxy(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set zyx(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set r(double arg) => _storage[0] = arg;
  set g(double arg) => _storage[1] = arg;
  set b(double arg) => _storage[2] = arg;
  set s(double arg) => _storage[0] = arg;
  set t(double arg) => _storage[1] = arg;
  set p(double arg) => _storage[2] = arg;
  set x(double arg) => _storage[0] = arg;
  set y(double arg) => _storage[1] = arg;
  set z(double arg) => _storage[2] = arg;
  set rg(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set rb(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set gr(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set gb(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set br(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set bg(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set rgb(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set rbg(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set grb(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set gbr(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set brg(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set bgr(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set st(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set sp(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set ts(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set tp(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set ps(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set pt(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set stp(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set spt(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set tsp(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set tps(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set pst(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set pts(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  vec2 get xx => new vec2(_storage[0], _storage[0]);
  vec2 get xy => new vec2(_storage[0], _storage[1]);
  vec2 get xz => new vec2(_storage[0], _storage[2]);
  vec2 get yx => new vec2(_storage[1], _storage[0]);
  vec2 get yy => new vec2(_storage[1], _storage[1]);
  vec2 get yz => new vec2(_storage[1], _storage[2]);
  vec2 get zx => new vec2(_storage[2], _storage[0]);
  vec2 get zy => new vec2(_storage[2], _storage[1]);
  vec2 get zz => new vec2(_storage[2], _storage[2]);
  vec3 get xxx => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get xxy => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get xxz => new vec3(_storage[0], _storage[0], _storage[2]);
  vec3 get xyx => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get xyy => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get xyz => new vec3(_storage[0], _storage[1], _storage[2]);
  vec3 get xzx => new vec3(_storage[0], _storage[2], _storage[0]);
  vec3 get xzy => new vec3(_storage[0], _storage[2], _storage[1]);
  vec3 get xzz => new vec3(_storage[0], _storage[2], _storage[2]);
  vec3 get yxx => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get yxy => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get yxz => new vec3(_storage[1], _storage[0], _storage[2]);
  vec3 get yyx => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get yyy => new vec3(_storage[1], _storage[1], _storage[1]);
  vec3 get yyz => new vec3(_storage[1], _storage[1], _storage[2]);
  vec3 get yzx => new vec3(_storage[1], _storage[2], _storage[0]);
  vec3 get yzy => new vec3(_storage[1], _storage[2], _storage[1]);
  vec3 get yzz => new vec3(_storage[1], _storage[2], _storage[2]);
  vec3 get zxx => new vec3(_storage[2], _storage[0], _storage[0]);
  vec3 get zxy => new vec3(_storage[2], _storage[0], _storage[1]);
  vec3 get zxz => new vec3(_storage[2], _storage[0], _storage[2]);
  vec3 get zyx => new vec3(_storage[2], _storage[1], _storage[0]);
  vec3 get zyy => new vec3(_storage[2], _storage[1], _storage[1]);
  vec3 get zyz => new vec3(_storage[2], _storage[1], _storage[2]);
  vec3 get zzx => new vec3(_storage[2], _storage[2], _storage[0]);
  vec3 get zzy => new vec3(_storage[2], _storage[2], _storage[1]);
  vec3 get zzz => new vec3(_storage[2], _storage[2], _storage[2]);
  vec4 get xxxx => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get xxxy => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get xxxz => new vec4(_storage[0], _storage[0], _storage[0], _storage[2]);
  vec4 get xxyx => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get xxyy => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get xxyz => new vec4(_storage[0], _storage[0], _storage[1], _storage[2]);
  vec4 get xxzx => new vec4(_storage[0], _storage[0], _storage[2], _storage[0]);
  vec4 get xxzy => new vec4(_storage[0], _storage[0], _storage[2], _storage[1]);
  vec4 get xxzz => new vec4(_storage[0], _storage[0], _storage[2], _storage[2]);
  vec4 get xyxx => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get xyxy => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get xyxz => new vec4(_storage[0], _storage[1], _storage[0], _storage[2]);
  vec4 get xyyx => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get xyyy => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get xyyz => new vec4(_storage[0], _storage[1], _storage[1], _storage[2]);
  vec4 get xyzx => new vec4(_storage[0], _storage[1], _storage[2], _storage[0]);
  vec4 get xyzy => new vec4(_storage[0], _storage[1], _storage[2], _storage[1]);
  vec4 get xyzz => new vec4(_storage[0], _storage[1], _storage[2], _storage[2]);
  vec4 get xzxx => new vec4(_storage[0], _storage[2], _storage[0], _storage[0]);
  vec4 get xzxy => new vec4(_storage[0], _storage[2], _storage[0], _storage[1]);
  vec4 get xzxz => new vec4(_storage[0], _storage[2], _storage[0], _storage[2]);
  vec4 get xzyx => new vec4(_storage[0], _storage[2], _storage[1], _storage[0]);
  vec4 get xzyy => new vec4(_storage[0], _storage[2], _storage[1], _storage[1]);
  vec4 get xzyz => new vec4(_storage[0], _storage[2], _storage[1], _storage[2]);
  vec4 get xzzx => new vec4(_storage[0], _storage[2], _storage[2], _storage[0]);
  vec4 get xzzy => new vec4(_storage[0], _storage[2], _storage[2], _storage[1]);
  vec4 get xzzz => new vec4(_storage[0], _storage[2], _storage[2], _storage[2]);
  vec4 get yxxx => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get yxxy => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get yxxz => new vec4(_storage[1], _storage[0], _storage[0], _storage[2]);
  vec4 get yxyx => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get yxyy => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get yxyz => new vec4(_storage[1], _storage[0], _storage[1], _storage[2]);
  vec4 get yxzx => new vec4(_storage[1], _storage[0], _storage[2], _storage[0]);
  vec4 get yxzy => new vec4(_storage[1], _storage[0], _storage[2], _storage[1]);
  vec4 get yxzz => new vec4(_storage[1], _storage[0], _storage[2], _storage[2]);
  vec4 get yyxx => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get yyxy => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get yyxz => new vec4(_storage[1], _storage[1], _storage[0], _storage[2]);
  vec4 get yyyx => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get yyyy => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  vec4 get yyyz => new vec4(_storage[1], _storage[1], _storage[1], _storage[2]);
  vec4 get yyzx => new vec4(_storage[1], _storage[1], _storage[2], _storage[0]);
  vec4 get yyzy => new vec4(_storage[1], _storage[1], _storage[2], _storage[1]);
  vec4 get yyzz => new vec4(_storage[1], _storage[1], _storage[2], _storage[2]);
  vec4 get yzxx => new vec4(_storage[1], _storage[2], _storage[0], _storage[0]);
  vec4 get yzxy => new vec4(_storage[1], _storage[2], _storage[0], _storage[1]);
  vec4 get yzxz => new vec4(_storage[1], _storage[2], _storage[0], _storage[2]);
  vec4 get yzyx => new vec4(_storage[1], _storage[2], _storage[1], _storage[0]);
  vec4 get yzyy => new vec4(_storage[1], _storage[2], _storage[1], _storage[1]);
  vec4 get yzyz => new vec4(_storage[1], _storage[2], _storage[1], _storage[2]);
  vec4 get yzzx => new vec4(_storage[1], _storage[2], _storage[2], _storage[0]);
  vec4 get yzzy => new vec4(_storage[1], _storage[2], _storage[2], _storage[1]);
  vec4 get yzzz => new vec4(_storage[1], _storage[2], _storage[2], _storage[2]);
  vec4 get zxxx => new vec4(_storage[2], _storage[0], _storage[0], _storage[0]);
  vec4 get zxxy => new vec4(_storage[2], _storage[0], _storage[0], _storage[1]);
  vec4 get zxxz => new vec4(_storage[2], _storage[0], _storage[0], _storage[2]);
  vec4 get zxyx => new vec4(_storage[2], _storage[0], _storage[1], _storage[0]);
  vec4 get zxyy => new vec4(_storage[2], _storage[0], _storage[1], _storage[1]);
  vec4 get zxyz => new vec4(_storage[2], _storage[0], _storage[1], _storage[2]);
  vec4 get zxzx => new vec4(_storage[2], _storage[0], _storage[2], _storage[0]);
  vec4 get zxzy => new vec4(_storage[2], _storage[0], _storage[2], _storage[1]);
  vec4 get zxzz => new vec4(_storage[2], _storage[0], _storage[2], _storage[2]);
  vec4 get zyxx => new vec4(_storage[2], _storage[1], _storage[0], _storage[0]);
  vec4 get zyxy => new vec4(_storage[2], _storage[1], _storage[0], _storage[1]);
  vec4 get zyxz => new vec4(_storage[2], _storage[1], _storage[0], _storage[2]);
  vec4 get zyyx => new vec4(_storage[2], _storage[1], _storage[1], _storage[0]);
  vec4 get zyyy => new vec4(_storage[2], _storage[1], _storage[1], _storage[1]);
  vec4 get zyyz => new vec4(_storage[2], _storage[1], _storage[1], _storage[2]);
  vec4 get zyzx => new vec4(_storage[2], _storage[1], _storage[2], _storage[0]);
  vec4 get zyzy => new vec4(_storage[2], _storage[1], _storage[2], _storage[1]);
  vec4 get zyzz => new vec4(_storage[2], _storage[1], _storage[2], _storage[2]);
  vec4 get zzxx => new vec4(_storage[2], _storage[2], _storage[0], _storage[0]);
  vec4 get zzxy => new vec4(_storage[2], _storage[2], _storage[0], _storage[1]);
  vec4 get zzxz => new vec4(_storage[2], _storage[2], _storage[0], _storage[2]);
  vec4 get zzyx => new vec4(_storage[2], _storage[2], _storage[1], _storage[0]);
  vec4 get zzyy => new vec4(_storage[2], _storage[2], _storage[1], _storage[1]);
  vec4 get zzyz => new vec4(_storage[2], _storage[2], _storage[1], _storage[2]);
  vec4 get zzzx => new vec4(_storage[2], _storage[2], _storage[2], _storage[0]);
  vec4 get zzzy => new vec4(_storage[2], _storage[2], _storage[2], _storage[1]);
  vec4 get zzzz => new vec4(_storage[2], _storage[2], _storage[2], _storage[2]);
  double get r => _storage[0];
  double get g => _storage[1];
  double get b => _storage[2];
  double get s => _storage[0];
  double get t => _storage[1];
  double get p => _storage[2];
  double get x => _storage[0];
  double get y => _storage[1];
  double get z => _storage[2];
  vec2 get rr => new vec2(_storage[0], _storage[0]);
  vec2 get rg => new vec2(_storage[0], _storage[1]);
  vec2 get rb => new vec2(_storage[0], _storage[2]);
  vec2 get gr => new vec2(_storage[1], _storage[0]);
  vec2 get gg => new vec2(_storage[1], _storage[1]);
  vec2 get gb => new vec2(_storage[1], _storage[2]);
  vec2 get br => new vec2(_storage[2], _storage[0]);
  vec2 get bg => new vec2(_storage[2], _storage[1]);
  vec2 get bb => new vec2(_storage[2], _storage[2]);
  vec3 get rrr => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get rrg => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get rrb => new vec3(_storage[0], _storage[0], _storage[2]);
  vec3 get rgr => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get rgg => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get rgb => new vec3(_storage[0], _storage[1], _storage[2]);
  vec3 get rbr => new vec3(_storage[0], _storage[2], _storage[0]);
  vec3 get rbg => new vec3(_storage[0], _storage[2], _storage[1]);
  vec3 get rbb => new vec3(_storage[0], _storage[2], _storage[2]);
  vec3 get grr => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get grg => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get grb => new vec3(_storage[1], _storage[0], _storage[2]);
  vec3 get ggr => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get ggg => new vec3(_storage[1], _storage[1], _storage[1]);
  vec3 get ggb => new vec3(_storage[1], _storage[1], _storage[2]);
  vec3 get gbr => new vec3(_storage[1], _storage[2], _storage[0]);
  vec3 get gbg => new vec3(_storage[1], _storage[2], _storage[1]);
  vec3 get gbb => new vec3(_storage[1], _storage[2], _storage[2]);
  vec3 get brr => new vec3(_storage[2], _storage[0], _storage[0]);
  vec3 get brg => new vec3(_storage[2], _storage[0], _storage[1]);
  vec3 get brb => new vec3(_storage[2], _storage[0], _storage[2]);
  vec3 get bgr => new vec3(_storage[2], _storage[1], _storage[0]);
  vec3 get bgg => new vec3(_storage[2], _storage[1], _storage[1]);
  vec3 get bgb => new vec3(_storage[2], _storage[1], _storage[2]);
  vec3 get bbr => new vec3(_storage[2], _storage[2], _storage[0]);
  vec3 get bbg => new vec3(_storage[2], _storage[2], _storage[1]);
  vec3 get bbb => new vec3(_storage[2], _storage[2], _storage[2]);
  vec4 get rrrr => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get rrrg => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get rrrb => new vec4(_storage[0], _storage[0], _storage[0], _storage[2]);
  vec4 get rrgr => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get rrgg => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get rrgb => new vec4(_storage[0], _storage[0], _storage[1], _storage[2]);
  vec4 get rrbr => new vec4(_storage[0], _storage[0], _storage[2], _storage[0]);
  vec4 get rrbg => new vec4(_storage[0], _storage[0], _storage[2], _storage[1]);
  vec4 get rrbb => new vec4(_storage[0], _storage[0], _storage[2], _storage[2]);
  vec4 get rgrr => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get rgrg => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get rgrb => new vec4(_storage[0], _storage[1], _storage[0], _storage[2]);
  vec4 get rggr => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get rggg => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get rggb => new vec4(_storage[0], _storage[1], _storage[1], _storage[2]);
  vec4 get rgbr => new vec4(_storage[0], _storage[1], _storage[2], _storage[0]);
  vec4 get rgbg => new vec4(_storage[0], _storage[1], _storage[2], _storage[1]);
  vec4 get rgbb => new vec4(_storage[0], _storage[1], _storage[2], _storage[2]);
  vec4 get rbrr => new vec4(_storage[0], _storage[2], _storage[0], _storage[0]);
  vec4 get rbrg => new vec4(_storage[0], _storage[2], _storage[0], _storage[1]);
  vec4 get rbrb => new vec4(_storage[0], _storage[2], _storage[0], _storage[2]);
  vec4 get rbgr => new vec4(_storage[0], _storage[2], _storage[1], _storage[0]);
  vec4 get rbgg => new vec4(_storage[0], _storage[2], _storage[1], _storage[1]);
  vec4 get rbgb => new vec4(_storage[0], _storage[2], _storage[1], _storage[2]);
  vec4 get rbbr => new vec4(_storage[0], _storage[2], _storage[2], _storage[0]);
  vec4 get rbbg => new vec4(_storage[0], _storage[2], _storage[2], _storage[1]);
  vec4 get rbbb => new vec4(_storage[0], _storage[2], _storage[2], _storage[2]);
  vec4 get grrr => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get grrg => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get grrb => new vec4(_storage[1], _storage[0], _storage[0], _storage[2]);
  vec4 get grgr => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get grgg => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get grgb => new vec4(_storage[1], _storage[0], _storage[1], _storage[2]);
  vec4 get grbr => new vec4(_storage[1], _storage[0], _storage[2], _storage[0]);
  vec4 get grbg => new vec4(_storage[1], _storage[0], _storage[2], _storage[1]);
  vec4 get grbb => new vec4(_storage[1], _storage[0], _storage[2], _storage[2]);
  vec4 get ggrr => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get ggrg => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get ggrb => new vec4(_storage[1], _storage[1], _storage[0], _storage[2]);
  vec4 get gggr => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get gggg => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  vec4 get gggb => new vec4(_storage[1], _storage[1], _storage[1], _storage[2]);
  vec4 get ggbr => new vec4(_storage[1], _storage[1], _storage[2], _storage[0]);
  vec4 get ggbg => new vec4(_storage[1], _storage[1], _storage[2], _storage[1]);
  vec4 get ggbb => new vec4(_storage[1], _storage[1], _storage[2], _storage[2]);
  vec4 get gbrr => new vec4(_storage[1], _storage[2], _storage[0], _storage[0]);
  vec4 get gbrg => new vec4(_storage[1], _storage[2], _storage[0], _storage[1]);
  vec4 get gbrb => new vec4(_storage[1], _storage[2], _storage[0], _storage[2]);
  vec4 get gbgr => new vec4(_storage[1], _storage[2], _storage[1], _storage[0]);
  vec4 get gbgg => new vec4(_storage[1], _storage[2], _storage[1], _storage[1]);
  vec4 get gbgb => new vec4(_storage[1], _storage[2], _storage[1], _storage[2]);
  vec4 get gbbr => new vec4(_storage[1], _storage[2], _storage[2], _storage[0]);
  vec4 get gbbg => new vec4(_storage[1], _storage[2], _storage[2], _storage[1]);
  vec4 get gbbb => new vec4(_storage[1], _storage[2], _storage[2], _storage[2]);
  vec4 get brrr => new vec4(_storage[2], _storage[0], _storage[0], _storage[0]);
  vec4 get brrg => new vec4(_storage[2], _storage[0], _storage[0], _storage[1]);
  vec4 get brrb => new vec4(_storage[2], _storage[0], _storage[0], _storage[2]);
  vec4 get brgr => new vec4(_storage[2], _storage[0], _storage[1], _storage[0]);
  vec4 get brgg => new vec4(_storage[2], _storage[0], _storage[1], _storage[1]);
  vec4 get brgb => new vec4(_storage[2], _storage[0], _storage[1], _storage[2]);
  vec4 get brbr => new vec4(_storage[2], _storage[0], _storage[2], _storage[0]);
  vec4 get brbg => new vec4(_storage[2], _storage[0], _storage[2], _storage[1]);
  vec4 get brbb => new vec4(_storage[2], _storage[0], _storage[2], _storage[2]);
  vec4 get bgrr => new vec4(_storage[2], _storage[1], _storage[0], _storage[0]);
  vec4 get bgrg => new vec4(_storage[2], _storage[1], _storage[0], _storage[1]);
  vec4 get bgrb => new vec4(_storage[2], _storage[1], _storage[0], _storage[2]);
  vec4 get bggr => new vec4(_storage[2], _storage[1], _storage[1], _storage[0]);
  vec4 get bggg => new vec4(_storage[2], _storage[1], _storage[1], _storage[1]);
  vec4 get bggb => new vec4(_storage[2], _storage[1], _storage[1], _storage[2]);
  vec4 get bgbr => new vec4(_storage[2], _storage[1], _storage[2], _storage[0]);
  vec4 get bgbg => new vec4(_storage[2], _storage[1], _storage[2], _storage[1]);
  vec4 get bgbb => new vec4(_storage[2], _storage[1], _storage[2], _storage[2]);
  vec4 get bbrr => new vec4(_storage[2], _storage[2], _storage[0], _storage[0]);
  vec4 get bbrg => new vec4(_storage[2], _storage[2], _storage[0], _storage[1]);
  vec4 get bbrb => new vec4(_storage[2], _storage[2], _storage[0], _storage[2]);
  vec4 get bbgr => new vec4(_storage[2], _storage[2], _storage[1], _storage[0]);
  vec4 get bbgg => new vec4(_storage[2], _storage[2], _storage[1], _storage[1]);
  vec4 get bbgb => new vec4(_storage[2], _storage[2], _storage[1], _storage[2]);
  vec4 get bbbr => new vec4(_storage[2], _storage[2], _storage[2], _storage[0]);
  vec4 get bbbg => new vec4(_storage[2], _storage[2], _storage[2], _storage[1]);
  vec4 get bbbb => new vec4(_storage[2], _storage[2], _storage[2], _storage[2]);
  vec2 get ss => new vec2(_storage[0], _storage[0]);
  vec2 get st => new vec2(_storage[0], _storage[1]);
  vec2 get sp => new vec2(_storage[0], _storage[2]);
  vec2 get ts => new vec2(_storage[1], _storage[0]);
  vec2 get tt => new vec2(_storage[1], _storage[1]);
  vec2 get tp => new vec2(_storage[1], _storage[2]);
  vec2 get ps => new vec2(_storage[2], _storage[0]);
  vec2 get pt => new vec2(_storage[2], _storage[1]);
  vec2 get pp => new vec2(_storage[2], _storage[2]);
  vec3 get sss => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get sst => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get ssp => new vec3(_storage[0], _storage[0], _storage[2]);
  vec3 get sts => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get stt => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get stp => new vec3(_storage[0], _storage[1], _storage[2]);
  vec3 get sps => new vec3(_storage[0], _storage[2], _storage[0]);
  vec3 get spt => new vec3(_storage[0], _storage[2], _storage[1]);
  vec3 get spp => new vec3(_storage[0], _storage[2], _storage[2]);
  vec3 get tss => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get tst => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get tsp => new vec3(_storage[1], _storage[0], _storage[2]);
  vec3 get tts => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get ttt => new vec3(_storage[1], _storage[1], _storage[1]);
  vec3 get ttp => new vec3(_storage[1], _storage[1], _storage[2]);
  vec3 get tps => new vec3(_storage[1], _storage[2], _storage[0]);
  vec3 get tpt => new vec3(_storage[1], _storage[2], _storage[1]);
  vec3 get tpp => new vec3(_storage[1], _storage[2], _storage[2]);
  vec3 get pss => new vec3(_storage[2], _storage[0], _storage[0]);
  vec3 get pst => new vec3(_storage[2], _storage[0], _storage[1]);
  vec3 get psp => new vec3(_storage[2], _storage[0], _storage[2]);
  vec3 get pts => new vec3(_storage[2], _storage[1], _storage[0]);
  vec3 get ptt => new vec3(_storage[2], _storage[1], _storage[1]);
  vec3 get ptp => new vec3(_storage[2], _storage[1], _storage[2]);
  vec3 get pps => new vec3(_storage[2], _storage[2], _storage[0]);
  vec3 get ppt => new vec3(_storage[2], _storage[2], _storage[1]);
  vec3 get ppp => new vec3(_storage[2], _storage[2], _storage[2]);
  vec4 get ssss => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get ssst => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get sssp => new vec4(_storage[0], _storage[0], _storage[0], _storage[2]);
  vec4 get ssts => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get sstt => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get sstp => new vec4(_storage[0], _storage[0], _storage[1], _storage[2]);
  vec4 get ssps => new vec4(_storage[0], _storage[0], _storage[2], _storage[0]);
  vec4 get sspt => new vec4(_storage[0], _storage[0], _storage[2], _storage[1]);
  vec4 get sspp => new vec4(_storage[0], _storage[0], _storage[2], _storage[2]);
  vec4 get stss => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get stst => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get stsp => new vec4(_storage[0], _storage[1], _storage[0], _storage[2]);
  vec4 get stts => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get sttt => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get sttp => new vec4(_storage[0], _storage[1], _storage[1], _storage[2]);
  vec4 get stps => new vec4(_storage[0], _storage[1], _storage[2], _storage[0]);
  vec4 get stpt => new vec4(_storage[0], _storage[1], _storage[2], _storage[1]);
  vec4 get stpp => new vec4(_storage[0], _storage[1], _storage[2], _storage[2]);
  vec4 get spss => new vec4(_storage[0], _storage[2], _storage[0], _storage[0]);
  vec4 get spst => new vec4(_storage[0], _storage[2], _storage[0], _storage[1]);
  vec4 get spsp => new vec4(_storage[0], _storage[2], _storage[0], _storage[2]);
  vec4 get spts => new vec4(_storage[0], _storage[2], _storage[1], _storage[0]);
  vec4 get sptt => new vec4(_storage[0], _storage[2], _storage[1], _storage[1]);
  vec4 get sptp => new vec4(_storage[0], _storage[2], _storage[1], _storage[2]);
  vec4 get spps => new vec4(_storage[0], _storage[2], _storage[2], _storage[0]);
  vec4 get sppt => new vec4(_storage[0], _storage[2], _storage[2], _storage[1]);
  vec4 get sppp => new vec4(_storage[0], _storage[2], _storage[2], _storage[2]);
  vec4 get tsss => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get tsst => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get tssp => new vec4(_storage[1], _storage[0], _storage[0], _storage[2]);
  vec4 get tsts => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get tstt => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get tstp => new vec4(_storage[1], _storage[0], _storage[1], _storage[2]);
  vec4 get tsps => new vec4(_storage[1], _storage[0], _storage[2], _storage[0]);
  vec4 get tspt => new vec4(_storage[1], _storage[0], _storage[2], _storage[1]);
  vec4 get tspp => new vec4(_storage[1], _storage[0], _storage[2], _storage[2]);
  vec4 get ttss => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get ttst => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get ttsp => new vec4(_storage[1], _storage[1], _storage[0], _storage[2]);
  vec4 get ttts => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get tttt => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  vec4 get tttp => new vec4(_storage[1], _storage[1], _storage[1], _storage[2]);
  vec4 get ttps => new vec4(_storage[1], _storage[1], _storage[2], _storage[0]);
  vec4 get ttpt => new vec4(_storage[1], _storage[1], _storage[2], _storage[1]);
  vec4 get ttpp => new vec4(_storage[1], _storage[1], _storage[2], _storage[2]);
  vec4 get tpss => new vec4(_storage[1], _storage[2], _storage[0], _storage[0]);
  vec4 get tpst => new vec4(_storage[1], _storage[2], _storage[0], _storage[1]);
  vec4 get tpsp => new vec4(_storage[1], _storage[2], _storage[0], _storage[2]);
  vec4 get tpts => new vec4(_storage[1], _storage[2], _storage[1], _storage[0]);
  vec4 get tptt => new vec4(_storage[1], _storage[2], _storage[1], _storage[1]);
  vec4 get tptp => new vec4(_storage[1], _storage[2], _storage[1], _storage[2]);
  vec4 get tpps => new vec4(_storage[1], _storage[2], _storage[2], _storage[0]);
  vec4 get tppt => new vec4(_storage[1], _storage[2], _storage[2], _storage[1]);
  vec4 get tppp => new vec4(_storage[1], _storage[2], _storage[2], _storage[2]);
  vec4 get psss => new vec4(_storage[2], _storage[0], _storage[0], _storage[0]);
  vec4 get psst => new vec4(_storage[2], _storage[0], _storage[0], _storage[1]);
  vec4 get pssp => new vec4(_storage[2], _storage[0], _storage[0], _storage[2]);
  vec4 get psts => new vec4(_storage[2], _storage[0], _storage[1], _storage[0]);
  vec4 get pstt => new vec4(_storage[2], _storage[0], _storage[1], _storage[1]);
  vec4 get pstp => new vec4(_storage[2], _storage[0], _storage[1], _storage[2]);
  vec4 get psps => new vec4(_storage[2], _storage[0], _storage[2], _storage[0]);
  vec4 get pspt => new vec4(_storage[2], _storage[0], _storage[2], _storage[1]);
  vec4 get pspp => new vec4(_storage[2], _storage[0], _storage[2], _storage[2]);
  vec4 get ptss => new vec4(_storage[2], _storage[1], _storage[0], _storage[0]);
  vec4 get ptst => new vec4(_storage[2], _storage[1], _storage[0], _storage[1]);
  vec4 get ptsp => new vec4(_storage[2], _storage[1], _storage[0], _storage[2]);
  vec4 get ptts => new vec4(_storage[2], _storage[1], _storage[1], _storage[0]);
  vec4 get pttt => new vec4(_storage[2], _storage[1], _storage[1], _storage[1]);
  vec4 get pttp => new vec4(_storage[2], _storage[1], _storage[1], _storage[2]);
  vec4 get ptps => new vec4(_storage[2], _storage[1], _storage[2], _storage[0]);
  vec4 get ptpt => new vec4(_storage[2], _storage[1], _storage[2], _storage[1]);
  vec4 get ptpp => new vec4(_storage[2], _storage[1], _storage[2], _storage[2]);
  vec4 get ppss => new vec4(_storage[2], _storage[2], _storage[0], _storage[0]);
  vec4 get ppst => new vec4(_storage[2], _storage[2], _storage[0], _storage[1]);
  vec4 get ppsp => new vec4(_storage[2], _storage[2], _storage[0], _storage[2]);
  vec4 get ppts => new vec4(_storage[2], _storage[2], _storage[1], _storage[0]);
  vec4 get pptt => new vec4(_storage[2], _storage[2], _storage[1], _storage[1]);
  vec4 get pptp => new vec4(_storage[2], _storage[2], _storage[1], _storage[2]);
  vec4 get ppps => new vec4(_storage[2], _storage[2], _storage[2], _storage[0]);
  vec4 get pppt => new vec4(_storage[2], _storage[2], _storage[2], _storage[1]);
  vec4 get pppp => new vec4(_storage[2], _storage[2], _storage[2], _storage[2]);
}
