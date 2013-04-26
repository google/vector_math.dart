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

/// 4D column vector.
class vec4 {
  final Float32List _storage = new Float32List(4);
  Float32List get storage => _storage;

  /// Constructs a new vector with the specified values.
  vec4(double x_, double y_, double z_, double w_) {
    setValues(x_, y_, z_, w_);
  }

  /// Initialized with values from [array] starting at [offset].
  vec4.array(List<double> array, [int offset=0]) {
    int i = offset;
    _storage[0] = array[i+0];
    _storage[1] = array[i+1];
    _storage[2] = array[i+2];
    _storage[3] = array[i+3];
  }

  //// Zero vector.
  vec4.zero();

  /// Copy of [other].
  vec4.copy(vec4 other) {
    setFrom(other);
  }

  /// Set the values of the vector.
  vec4 setValues(double x_, double y_, double z_, double w_) {
    _storage[3] = w_;
    _storage[2] = z_;
    _storage[1] = y_;
    _storage[0] = x_;
    return this;
  }

  /// Zero the vector.
  vec4 setZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
    return this;
  }

  /// Set the values by copying them from [other].
  vec4 setFrom(vec4 other) {
    _storage[3] = other._storage[3];
    _storage[2] = other._storage[2];
    _storage[1] = other._storage[1];
    _storage[0] = other._storage[0];
    return this;
  }

  /// Splat [arg] into all lanes of the vector.
  vec4 splat(double arg) {
    _storage[3] = arg;
    _storage[2] = arg;
    _storage[1] = arg;
    _storage[0] = arg;
    return this;
  }

  /// Returns a printable string
  String toString() => '${_storage[0]},${_storage[1]},'
                       '${_storage[2]},${_storage[3]}';

  /// Negate.
  vec4 operator-() => new vec4(-_storage[0], -_storage[1], -_storage[2],
                               -_storage[3]);

  /// Subtract two vectors.
  vec4 operator-(vec4 other) => new vec4(_storage[0] - other._storage[0],
                                         _storage[1] - other._storage[1],
                                         _storage[2] - other._storage[2],
                                         _storage[3] - other._storage[3]);

  /// Add two vectors.
  vec4 operator+(vec4 other) => new vec4(_storage[0] + other._storage[0],
                                         _storage[1] + other._storage[1],
                                         _storage[2] + other._storage[2],
                                         _storage[3] + other._storage[3]);

  /// Scale.
  vec4 operator/(double scale) {
    var o = 1.0 / scale;
    return new vec4(_storage[0] * o, _storage[1] * o, _storage[2] * o,
                    _storage[3] * o);
  }

  /// Scale.
  vec4 operator*(double scale) {
    var o = scale;
    return new vec4(_storage[0] * o, _storage[1] * o, _storage[2] * o,
                    _storage[3] * o);
  }

  double operator[](int i) => _storage[i];

  void operator[]=(int i, double v) { _storage[i] = v; }

  /// Length.
  double get length {
    double sum;
    sum = (_storage[0] * _storage[0]);
    sum += (_storage[1] * _storage[1]);
    sum += (_storage[2] * _storage[2]);
    sum += (_storage[3] * _storage[3]);
    return Math.sqrt(sum);
  }

  /// Length squared.
  double get length2 {
    double sum;
    sum = (_storage[0] * _storage[0]);
    sum += (_storage[1] * _storage[1]);
    sum += (_storage[2] * _storage[2]);
    sum += (_storage[3] * _storage[3]);
    return sum;
  }

  /// Normalizes [this].
  vec4 normalize() {
    double l = length;
    // TODO(johnmccutchan): Use an epsilon.
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    _storage[2] *= l;
    _storage[3] *= l;
    return this;
  }

  /// Normalizes [this]. Returns length of vector before normalization.
  double normalizeLength() {
    double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    _storage[2] *= l;
    _storage[3] *= l;
    return l;
  }

  /// Normalizes copy of [this].
  vec4 normalized() {
    return new vec4.copy(this).normalize();
  }

  /// Normalize vector into [out].
  vec4 normalizeInto(vec4 out) {
    out.setFrom(this);
    return out.normalize();
  }

  /// Inner product.
  double dot(vec4 other) {
    double sum;
    sum = _storage[0] * other._storage[0];
    sum += _storage[1] * other._storage[1];
    sum += _storage[2] * other._storage[2];
    sum += _storage[3] * other._storage[3];
    return sum;
  }

  /// Relative error between [this] and [correct]
  double relativeError(vec4 correct) {
    double correct_norm = correct.length;
    double diff_norm = (this - correct).length;
    return diff_norm/correct_norm;
  }

  /// Absolute error between [this] and [correct]
  double absoluteError(vec4 correct) {
    return (this - correct).length;
  }

  /// True if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || _storage[0].isInfinite;
    is_infinite = is_infinite || _storage[1].isInfinite;
    is_infinite = is_infinite || _storage[2].isInfinite;
    is_infinite = is_infinite || _storage[3].isInfinite;
    return is_infinite;
  }

  /// True if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || _storage[0].isNaN;
    is_nan = is_nan || _storage[1].isNaN;
    is_nan = is_nan || _storage[2].isNaN;
    is_nan = is_nan || _storage[3].isNaN;
    return is_nan;
  }

  vec4 add(vec4 arg) {
    _storage[0] = _storage[0] + arg._storage[0];
    _storage[1] = _storage[1] + arg._storage[1];
    _storage[2] = _storage[2] + arg._storage[2];
    _storage[3] = _storage[3] + arg._storage[3];
    return this;
  }

  vec4 sub(vec4 arg) {
    _storage[0] = _storage[0] - arg._storage[0];
    _storage[1] = _storage[1] - arg._storage[1];
    _storage[2] = _storage[2] - arg._storage[2];
    _storage[3] = _storage[3] - arg._storage[3];
    return this;
  }

  vec4 multiply(vec4 arg) {
    _storage[0] = _storage[0] * arg._storage[0];
    _storage[1] = _storage[1] * arg._storage[1];
    _storage[2] = _storage[2] * arg._storage[2];
    _storage[3] = _storage[3] * arg._storage[3];
    return this;
  }

  vec4 div(vec4 arg) {
    _storage[0] = _storage[0] / arg._storage[0];
    _storage[1] = _storage[1] / arg._storage[1];
    _storage[2] = _storage[2] / arg._storage[2];
    _storage[3] = _storage[3] / arg._storage[3];
    return this;
  }

  vec4 scale(double arg) {
    _storage[0] = _storage[0] * arg;
    _storage[1] = _storage[1] * arg;
    _storage[2] = _storage[2] * arg;
    _storage[3] = _storage[3] * arg;
    return this;
  }

  vec4 scaled(double arg) {
    return clone().scale(arg);
  }

  vec4 negate() {
    _storage[0] = -_storage[0];
    _storage[1] = -_storage[1];
    _storage[2] = -_storage[2];
    _storage[3] = -_storage[3];
    return this;
  }

  vec4 absolute() {
    _storage[3] = _storage[3].abs();
    _storage[2] = _storage[2].abs();
    _storage[1] = _storage[1].abs();
    _storage[0] = _storage[0].abs();
    return this;
  }

  vec4 clone() {
    return new vec4.copy(this);
  }

  vec4 copyInto(vec4 arg) {
    arg._storage[0] = _storage[0];
    arg._storage[1] = _storage[1];
    arg._storage[2] = _storage[2];
    arg._storage[3] = _storage[3];
    return arg;
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset=0]) {
    array[offset+0] = _storage[0];
    array[offset+1] = _storage[1];
    array[offset+2] = _storage[2];
    array[offset+3] = _storage[3];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset=0]) {
    _storage[0] = array[offset+0];
    _storage[1] = array[offset+1];
    _storage[2] = array[offset+2];
    _storage[3] = array[offset+3];
  }

  set xy(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set xz(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set xw(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set yx(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set yz(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set yw(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set zx(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set zy(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set zw(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set wx(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set wy(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set wz(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set xyz(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set xyw(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set xzy(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set xzw(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set xwy(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set xwz(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set yxz(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set yxw(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set yzx(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set yzw(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set ywx(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set ywz(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set zxy(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set zxw(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set zyx(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set zyw(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set zwx(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set zwy(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set wxy(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set wxz(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set wyx(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set wyz(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set wzx(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set wzy(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set xyzw(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set xywz(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set xzyw(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set xzwy(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set xwyz(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set xwzy(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set yxzw(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set yxwz(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set yzxw(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set yzwx(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set ywxz(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set ywzx(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set zxyw(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set zxwy(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set zyxw(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set zywx(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set zwxy(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set zwyx(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set wxyz(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set wxzy(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set wyxz(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set wyzx(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set wzxy(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set wzyx(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set r(double arg) => _storage[0] = arg;
  set g(double arg) => _storage[1] = arg;
  set b(double arg) => _storage[2] = arg;
  set a(double arg) => _storage[3] = arg;
  set s(double arg) => _storage[0] = arg;
  set t(double arg) => _storage[1] = arg;
  set p(double arg) => _storage[2] = arg;
  set q(double arg) => _storage[3] = arg;
  set x(double arg) => _storage[0] = arg;
  set y(double arg) => _storage[1] = arg;
  set z(double arg) => _storage[2] = arg;
  set w(double arg) => _storage[3] = arg;
  set rg(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set rb(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set ra(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set gr(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set gb(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set ga(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set br(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set bg(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set ba(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set ar(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set ag(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set ab(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set rgb(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set rga(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set rbg(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set rba(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set rag(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set rab(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set grb(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set gra(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set gbr(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set gba(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set gar(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set gab(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set brg(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set bra(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set bgr(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set bga(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set bar(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set bag(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set arg(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set arb(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set agr(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set agb(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set abr(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set abg(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set rgba(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set rgab(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set rbga(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set rbag(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set ragb(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set rabg(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set grba(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set grab(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set gbra(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set gbar(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set garb(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set gabr(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set brga(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set brag(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set bgra(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set bgar(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set barg(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set bagr(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set argb(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set arbg(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set agrb(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set agbr(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set abrg(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set abgr(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set st(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set sp(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set sq(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set ts(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set tp(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set tq(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set ps(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set pt(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set pq(vec2 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
  }
  set qs(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set qt(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set qp(vec2 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
  }
  set stp(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set stq(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set spt(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set spq(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set sqt(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set sqp(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set tsp(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set tsq(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set tps(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set tpq(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set tqs(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set tqp(vec3 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set pst(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set psq(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set pts(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set ptq(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
  }
  set pqs(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set pqt(vec3 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set qst(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set qsp(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set qts(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set qtp(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
  }
  set qps(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
  }
  set qpt(vec3 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
  }
  set stpq(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set stqp(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set sptq(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set spqt(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set sqtp(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set sqpt(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set tspq(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set tsqp(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set tpsq(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set tpqs(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set tqsp(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set tqps(vec4 arg) {
    _storage[1] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set pstq(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set psqt(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set ptsq(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[3] = arg._storage[3];
  }
  set ptqs(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set pqst(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set pqts(vec4 arg) {
    _storage[2] = arg._storage[0];
    _storage[3] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set qstp(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set qspt(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[0] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set qtsp(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[2] = arg._storage[3];
  }
  set qtps(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  set qpst(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[0] = arg._storage[2];
    _storage[1] = arg._storage[3];
  }
  set qpts(vec4 arg) {
    _storage[3] = arg._storage[0];
    _storage[2] = arg._storage[1];
    _storage[1] = arg._storage[2];
    _storage[0] = arg._storage[3];
  }
  vec2 get xx => new vec2(_storage[0], _storage[0]);
  vec2 get xy => new vec2(_storage[0], _storage[1]);
  vec2 get xz => new vec2(_storage[0], _storage[2]);
  vec2 get xw => new vec2(_storage[0], _storage[3]);
  vec2 get yx => new vec2(_storage[1], _storage[0]);
  vec2 get yy => new vec2(_storage[1], _storage[1]);
  vec2 get yz => new vec2(_storage[1], _storage[2]);
  vec2 get yw => new vec2(_storage[1], _storage[3]);
  vec2 get zx => new vec2(_storage[2], _storage[0]);
  vec2 get zy => new vec2(_storage[2], _storage[1]);
  vec2 get zz => new vec2(_storage[2], _storage[2]);
  vec2 get zw => new vec2(_storage[2], _storage[3]);
  vec2 get wx => new vec2(_storage[3], _storage[0]);
  vec2 get wy => new vec2(_storage[3], _storage[1]);
  vec2 get wz => new vec2(_storage[3], _storage[2]);
  vec2 get ww => new vec2(_storage[3], _storage[3]);
  vec3 get xxx => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get xxy => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get xxz => new vec3(_storage[0], _storage[0], _storage[2]);
  vec3 get xxw => new vec3(_storage[0], _storage[0], _storage[3]);
  vec3 get xyx => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get xyy => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get xyz => new vec3(_storage[0], _storage[1], _storage[2]);
  vec3 get xyw => new vec3(_storage[0], _storage[1], _storage[3]);
  vec3 get xzx => new vec3(_storage[0], _storage[2], _storage[0]);
  vec3 get xzy => new vec3(_storage[0], _storage[2], _storage[1]);
  vec3 get xzz => new vec3(_storage[0], _storage[2], _storage[2]);
  vec3 get xzw => new vec3(_storage[0], _storage[2], _storage[3]);
  vec3 get xwx => new vec3(_storage[0], _storage[3], _storage[0]);
  vec3 get xwy => new vec3(_storage[0], _storage[3], _storage[1]);
  vec3 get xwz => new vec3(_storage[0], _storage[3], _storage[2]);
  vec3 get xww => new vec3(_storage[0], _storage[3], _storage[3]);
  vec3 get yxx => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get yxy => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get yxz => new vec3(_storage[1], _storage[0], _storage[2]);
  vec3 get yxw => new vec3(_storage[1], _storage[0], _storage[3]);
  vec3 get yyx => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get yyy => new vec3(_storage[1], _storage[1], _storage[1]);
  vec3 get yyz => new vec3(_storage[1], _storage[1], _storage[2]);
  vec3 get yyw => new vec3(_storage[1], _storage[1], _storage[3]);
  vec3 get yzx => new vec3(_storage[1], _storage[2], _storage[0]);
  vec3 get yzy => new vec3(_storage[1], _storage[2], _storage[1]);
  vec3 get yzz => new vec3(_storage[1], _storage[2], _storage[2]);
  vec3 get yzw => new vec3(_storage[1], _storage[2], _storage[3]);
  vec3 get ywx => new vec3(_storage[1], _storage[3], _storage[0]);
  vec3 get ywy => new vec3(_storage[1], _storage[3], _storage[1]);
  vec3 get ywz => new vec3(_storage[1], _storage[3], _storage[2]);
  vec3 get yww => new vec3(_storage[1], _storage[3], _storage[3]);
  vec3 get zxx => new vec3(_storage[2], _storage[0], _storage[0]);
  vec3 get zxy => new vec3(_storage[2], _storage[0], _storage[1]);
  vec3 get zxz => new vec3(_storage[2], _storage[0], _storage[2]);
  vec3 get zxw => new vec3(_storage[2], _storage[0], _storage[3]);
  vec3 get zyx => new vec3(_storage[2], _storage[1], _storage[0]);
  vec3 get zyy => new vec3(_storage[2], _storage[1], _storage[1]);
  vec3 get zyz => new vec3(_storage[2], _storage[1], _storage[2]);
  vec3 get zyw => new vec3(_storage[2], _storage[1], _storage[3]);
  vec3 get zzx => new vec3(_storage[2], _storage[2], _storage[0]);
  vec3 get zzy => new vec3(_storage[2], _storage[2], _storage[1]);
  vec3 get zzz => new vec3(_storage[2], _storage[2], _storage[2]);
  vec3 get zzw => new vec3(_storage[2], _storage[2], _storage[3]);
  vec3 get zwx => new vec3(_storage[2], _storage[3], _storage[0]);
  vec3 get zwy => new vec3(_storage[2], _storage[3], _storage[1]);
  vec3 get zwz => new vec3(_storage[2], _storage[3], _storage[2]);
  vec3 get zww => new vec3(_storage[2], _storage[3], _storage[3]);
  vec3 get wxx => new vec3(_storage[3], _storage[0], _storage[0]);
  vec3 get wxy => new vec3(_storage[3], _storage[0], _storage[1]);
  vec3 get wxz => new vec3(_storage[3], _storage[0], _storage[2]);
  vec3 get wxw => new vec3(_storage[3], _storage[0], _storage[3]);
  vec3 get wyx => new vec3(_storage[3], _storage[1], _storage[0]);
  vec3 get wyy => new vec3(_storage[3], _storage[1], _storage[1]);
  vec3 get wyz => new vec3(_storage[3], _storage[1], _storage[2]);
  vec3 get wyw => new vec3(_storage[3], _storage[1], _storage[3]);
  vec3 get wzx => new vec3(_storage[3], _storage[2], _storage[0]);
  vec3 get wzy => new vec3(_storage[3], _storage[2], _storage[1]);
  vec3 get wzz => new vec3(_storage[3], _storage[2], _storage[2]);
  vec3 get wzw => new vec3(_storage[3], _storage[2], _storage[3]);
  vec3 get wwx => new vec3(_storage[3], _storage[3], _storage[0]);
  vec3 get wwy => new vec3(_storage[3], _storage[3], _storage[1]);
  vec3 get wwz => new vec3(_storage[3], _storage[3], _storage[2]);
  vec3 get www => new vec3(_storage[3], _storage[3], _storage[3]);
  vec4 get xxxx => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get xxxy => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get xxxz => new vec4(_storage[0], _storage[0], _storage[0], _storage[2]);
  vec4 get xxxw => new vec4(_storage[0], _storage[0], _storage[0], _storage[3]);
  vec4 get xxyx => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get xxyy => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get xxyz => new vec4(_storage[0], _storage[0], _storage[1], _storage[2]);
  vec4 get xxyw => new vec4(_storage[0], _storage[0], _storage[1], _storage[3]);
  vec4 get xxzx => new vec4(_storage[0], _storage[0], _storage[2], _storage[0]);
  vec4 get xxzy => new vec4(_storage[0], _storage[0], _storage[2], _storage[1]);
  vec4 get xxzz => new vec4(_storage[0], _storage[0], _storage[2], _storage[2]);
  vec4 get xxzw => new vec4(_storage[0], _storage[0], _storage[2], _storage[3]);
  vec4 get xxwx => new vec4(_storage[0], _storage[0], _storage[3], _storage[0]);
  vec4 get xxwy => new vec4(_storage[0], _storage[0], _storage[3], _storage[1]);
  vec4 get xxwz => new vec4(_storage[0], _storage[0], _storage[3], _storage[2]);
  vec4 get xxww => new vec4(_storage[0], _storage[0], _storage[3], _storage[3]);
  vec4 get xyxx => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get xyxy => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get xyxz => new vec4(_storage[0], _storage[1], _storage[0], _storage[2]);
  vec4 get xyxw => new vec4(_storage[0], _storage[1], _storage[0], _storage[3]);
  vec4 get xyyx => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get xyyy => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get xyyz => new vec4(_storage[0], _storage[1], _storage[1], _storage[2]);
  vec4 get xyyw => new vec4(_storage[0], _storage[1], _storage[1], _storage[3]);
  vec4 get xyzx => new vec4(_storage[0], _storage[1], _storage[2], _storage[0]);
  vec4 get xyzy => new vec4(_storage[0], _storage[1], _storage[2], _storage[1]);
  vec4 get xyzz => new vec4(_storage[0], _storage[1], _storage[2], _storage[2]);
  vec4 get xyzw => new vec4(_storage[0], _storage[1], _storage[2], _storage[3]);
  vec4 get xywx => new vec4(_storage[0], _storage[1], _storage[3], _storage[0]);
  vec4 get xywy => new vec4(_storage[0], _storage[1], _storage[3], _storage[1]);
  vec4 get xywz => new vec4(_storage[0], _storage[1], _storage[3], _storage[2]);
  vec4 get xyww => new vec4(_storage[0], _storage[1], _storage[3], _storage[3]);
  vec4 get xzxx => new vec4(_storage[0], _storage[2], _storage[0], _storage[0]);
  vec4 get xzxy => new vec4(_storage[0], _storage[2], _storage[0], _storage[1]);
  vec4 get xzxz => new vec4(_storage[0], _storage[2], _storage[0], _storage[2]);
  vec4 get xzxw => new vec4(_storage[0], _storage[2], _storage[0], _storage[3]);
  vec4 get xzyx => new vec4(_storage[0], _storage[2], _storage[1], _storage[0]);
  vec4 get xzyy => new vec4(_storage[0], _storage[2], _storage[1], _storage[1]);
  vec4 get xzyz => new vec4(_storage[0], _storage[2], _storage[1], _storage[2]);
  vec4 get xzyw => new vec4(_storage[0], _storage[2], _storage[1], _storage[3]);
  vec4 get xzzx => new vec4(_storage[0], _storage[2], _storage[2], _storage[0]);
  vec4 get xzzy => new vec4(_storage[0], _storage[2], _storage[2], _storage[1]);
  vec4 get xzzz => new vec4(_storage[0], _storage[2], _storage[2], _storage[2]);
  vec4 get xzzw => new vec4(_storage[0], _storage[2], _storage[2], _storage[3]);
  vec4 get xzwx => new vec4(_storage[0], _storage[2], _storage[3], _storage[0]);
  vec4 get xzwy => new vec4(_storage[0], _storage[2], _storage[3], _storage[1]);
  vec4 get xzwz => new vec4(_storage[0], _storage[2], _storage[3], _storage[2]);
  vec4 get xzww => new vec4(_storage[0], _storage[2], _storage[3], _storage[3]);
  vec4 get xwxx => new vec4(_storage[0], _storage[3], _storage[0], _storage[0]);
  vec4 get xwxy => new vec4(_storage[0], _storage[3], _storage[0], _storage[1]);
  vec4 get xwxz => new vec4(_storage[0], _storage[3], _storage[0], _storage[2]);
  vec4 get xwxw => new vec4(_storage[0], _storage[3], _storage[0], _storage[3]);
  vec4 get xwyx => new vec4(_storage[0], _storage[3], _storage[1], _storage[0]);
  vec4 get xwyy => new vec4(_storage[0], _storage[3], _storage[1], _storage[1]);
  vec4 get xwyz => new vec4(_storage[0], _storage[3], _storage[1], _storage[2]);
  vec4 get xwyw => new vec4(_storage[0], _storage[3], _storage[1], _storage[3]);
  vec4 get xwzx => new vec4(_storage[0], _storage[3], _storage[2], _storage[0]);
  vec4 get xwzy => new vec4(_storage[0], _storage[3], _storage[2], _storage[1]);
  vec4 get xwzz => new vec4(_storage[0], _storage[3], _storage[2], _storage[2]);
  vec4 get xwzw => new vec4(_storage[0], _storage[3], _storage[2], _storage[3]);
  vec4 get xwwx => new vec4(_storage[0], _storage[3], _storage[3], _storage[0]);
  vec4 get xwwy => new vec4(_storage[0], _storage[3], _storage[3], _storage[1]);
  vec4 get xwwz => new vec4(_storage[0], _storage[3], _storage[3], _storage[2]);
  vec4 get xwww => new vec4(_storage[0], _storage[3], _storage[3], _storage[3]);
  vec4 get yxxx => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get yxxy => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get yxxz => new vec4(_storage[1], _storage[0], _storage[0], _storage[2]);
  vec4 get yxxw => new vec4(_storage[1], _storage[0], _storage[0], _storage[3]);
  vec4 get yxyx => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get yxyy => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get yxyz => new vec4(_storage[1], _storage[0], _storage[1], _storage[2]);
  vec4 get yxyw => new vec4(_storage[1], _storage[0], _storage[1], _storage[3]);
  vec4 get yxzx => new vec4(_storage[1], _storage[0], _storage[2], _storage[0]);
  vec4 get yxzy => new vec4(_storage[1], _storage[0], _storage[2], _storage[1]);
  vec4 get yxzz => new vec4(_storage[1], _storage[0], _storage[2], _storage[2]);
  vec4 get yxzw => new vec4(_storage[1], _storage[0], _storage[2], _storage[3]);
  vec4 get yxwx => new vec4(_storage[1], _storage[0], _storage[3], _storage[0]);
  vec4 get yxwy => new vec4(_storage[1], _storage[0], _storage[3], _storage[1]);
  vec4 get yxwz => new vec4(_storage[1], _storage[0], _storage[3], _storage[2]);
  vec4 get yxww => new vec4(_storage[1], _storage[0], _storage[3], _storage[3]);
  vec4 get yyxx => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get yyxy => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get yyxz => new vec4(_storage[1], _storage[1], _storage[0], _storage[2]);
  vec4 get yyxw => new vec4(_storage[1], _storage[1], _storage[0], _storage[3]);
  vec4 get yyyx => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get yyyy => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  vec4 get yyyz => new vec4(_storage[1], _storage[1], _storage[1], _storage[2]);
  vec4 get yyyw => new vec4(_storage[1], _storage[1], _storage[1], _storage[3]);
  vec4 get yyzx => new vec4(_storage[1], _storage[1], _storage[2], _storage[0]);
  vec4 get yyzy => new vec4(_storage[1], _storage[1], _storage[2], _storage[1]);
  vec4 get yyzz => new vec4(_storage[1], _storage[1], _storage[2], _storage[2]);
  vec4 get yyzw => new vec4(_storage[1], _storage[1], _storage[2], _storage[3]);
  vec4 get yywx => new vec4(_storage[1], _storage[1], _storage[3], _storage[0]);
  vec4 get yywy => new vec4(_storage[1], _storage[1], _storage[3], _storage[1]);
  vec4 get yywz => new vec4(_storage[1], _storage[1], _storage[3], _storage[2]);
  vec4 get yyww => new vec4(_storage[1], _storage[1], _storage[3], _storage[3]);
  vec4 get yzxx => new vec4(_storage[1], _storage[2], _storage[0], _storage[0]);
  vec4 get yzxy => new vec4(_storage[1], _storage[2], _storage[0], _storage[1]);
  vec4 get yzxz => new vec4(_storage[1], _storage[2], _storage[0], _storage[2]);
  vec4 get yzxw => new vec4(_storage[1], _storage[2], _storage[0], _storage[3]);
  vec4 get yzyx => new vec4(_storage[1], _storage[2], _storage[1], _storage[0]);
  vec4 get yzyy => new vec4(_storage[1], _storage[2], _storage[1], _storage[1]);
  vec4 get yzyz => new vec4(_storage[1], _storage[2], _storage[1], _storage[2]);
  vec4 get yzyw => new vec4(_storage[1], _storage[2], _storage[1], _storage[3]);
  vec4 get yzzx => new vec4(_storage[1], _storage[2], _storage[2], _storage[0]);
  vec4 get yzzy => new vec4(_storage[1], _storage[2], _storage[2], _storage[1]);
  vec4 get yzzz => new vec4(_storage[1], _storage[2], _storage[2], _storage[2]);
  vec4 get yzzw => new vec4(_storage[1], _storage[2], _storage[2], _storage[3]);
  vec4 get yzwx => new vec4(_storage[1], _storage[2], _storage[3], _storage[0]);
  vec4 get yzwy => new vec4(_storage[1], _storage[2], _storage[3], _storage[1]);
  vec4 get yzwz => new vec4(_storage[1], _storage[2], _storage[3], _storage[2]);
  vec4 get yzww => new vec4(_storage[1], _storage[2], _storage[3], _storage[3]);
  vec4 get ywxx => new vec4(_storage[1], _storage[3], _storage[0], _storage[0]);
  vec4 get ywxy => new vec4(_storage[1], _storage[3], _storage[0], _storage[1]);
  vec4 get ywxz => new vec4(_storage[1], _storage[3], _storage[0], _storage[2]);
  vec4 get ywxw => new vec4(_storage[1], _storage[3], _storage[0], _storage[3]);
  vec4 get ywyx => new vec4(_storage[1], _storage[3], _storage[1], _storage[0]);
  vec4 get ywyy => new vec4(_storage[1], _storage[3], _storage[1], _storage[1]);
  vec4 get ywyz => new vec4(_storage[1], _storage[3], _storage[1], _storage[2]);
  vec4 get ywyw => new vec4(_storage[1], _storage[3], _storage[1], _storage[3]);
  vec4 get ywzx => new vec4(_storage[1], _storage[3], _storage[2], _storage[0]);
  vec4 get ywzy => new vec4(_storage[1], _storage[3], _storage[2], _storage[1]);
  vec4 get ywzz => new vec4(_storage[1], _storage[3], _storage[2], _storage[2]);
  vec4 get ywzw => new vec4(_storage[1], _storage[3], _storage[2], _storage[3]);
  vec4 get ywwx => new vec4(_storage[1], _storage[3], _storage[3], _storage[0]);
  vec4 get ywwy => new vec4(_storage[1], _storage[3], _storage[3], _storage[1]);
  vec4 get ywwz => new vec4(_storage[1], _storage[3], _storage[3], _storage[2]);
  vec4 get ywww => new vec4(_storage[1], _storage[3], _storage[3], _storage[3]);
  vec4 get zxxx => new vec4(_storage[2], _storage[0], _storage[0], _storage[0]);
  vec4 get zxxy => new vec4(_storage[2], _storage[0], _storage[0], _storage[1]);
  vec4 get zxxz => new vec4(_storage[2], _storage[0], _storage[0], _storage[2]);
  vec4 get zxxw => new vec4(_storage[2], _storage[0], _storage[0], _storage[3]);
  vec4 get zxyx => new vec4(_storage[2], _storage[0], _storage[1], _storage[0]);
  vec4 get zxyy => new vec4(_storage[2], _storage[0], _storage[1], _storage[1]);
  vec4 get zxyz => new vec4(_storage[2], _storage[0], _storage[1], _storage[2]);
  vec4 get zxyw => new vec4(_storage[2], _storage[0], _storage[1], _storage[3]);
  vec4 get zxzx => new vec4(_storage[2], _storage[0], _storage[2], _storage[0]);
  vec4 get zxzy => new vec4(_storage[2], _storage[0], _storage[2], _storage[1]);
  vec4 get zxzz => new vec4(_storage[2], _storage[0], _storage[2], _storage[2]);
  vec4 get zxzw => new vec4(_storage[2], _storage[0], _storage[2], _storage[3]);
  vec4 get zxwx => new vec4(_storage[2], _storage[0], _storage[3], _storage[0]);
  vec4 get zxwy => new vec4(_storage[2], _storage[0], _storage[3], _storage[1]);
  vec4 get zxwz => new vec4(_storage[2], _storage[0], _storage[3], _storage[2]);
  vec4 get zxww => new vec4(_storage[2], _storage[0], _storage[3], _storage[3]);
  vec4 get zyxx => new vec4(_storage[2], _storage[1], _storage[0], _storage[0]);
  vec4 get zyxy => new vec4(_storage[2], _storage[1], _storage[0], _storage[1]);
  vec4 get zyxz => new vec4(_storage[2], _storage[1], _storage[0], _storage[2]);
  vec4 get zyxw => new vec4(_storage[2], _storage[1], _storage[0], _storage[3]);
  vec4 get zyyx => new vec4(_storage[2], _storage[1], _storage[1], _storage[0]);
  vec4 get zyyy => new vec4(_storage[2], _storage[1], _storage[1], _storage[1]);
  vec4 get zyyz => new vec4(_storage[2], _storage[1], _storage[1], _storage[2]);
  vec4 get zyyw => new vec4(_storage[2], _storage[1], _storage[1], _storage[3]);
  vec4 get zyzx => new vec4(_storage[2], _storage[1], _storage[2], _storage[0]);
  vec4 get zyzy => new vec4(_storage[2], _storage[1], _storage[2], _storage[1]);
  vec4 get zyzz => new vec4(_storage[2], _storage[1], _storage[2], _storage[2]);
  vec4 get zyzw => new vec4(_storage[2], _storage[1], _storage[2], _storage[3]);
  vec4 get zywx => new vec4(_storage[2], _storage[1], _storage[3], _storage[0]);
  vec4 get zywy => new vec4(_storage[2], _storage[1], _storage[3], _storage[1]);
  vec4 get zywz => new vec4(_storage[2], _storage[1], _storage[3], _storage[2]);
  vec4 get zyww => new vec4(_storage[2], _storage[1], _storage[3], _storage[3]);
  vec4 get zzxx => new vec4(_storage[2], _storage[2], _storage[0], _storage[0]);
  vec4 get zzxy => new vec4(_storage[2], _storage[2], _storage[0], _storage[1]);
  vec4 get zzxz => new vec4(_storage[2], _storage[2], _storage[0], _storage[2]);
  vec4 get zzxw => new vec4(_storage[2], _storage[2], _storage[0], _storage[3]);
  vec4 get zzyx => new vec4(_storage[2], _storage[2], _storage[1], _storage[0]);
  vec4 get zzyy => new vec4(_storage[2], _storage[2], _storage[1], _storage[1]);
  vec4 get zzyz => new vec4(_storage[2], _storage[2], _storage[1], _storage[2]);
  vec4 get zzyw => new vec4(_storage[2], _storage[2], _storage[1], _storage[3]);
  vec4 get zzzx => new vec4(_storage[2], _storage[2], _storage[2], _storage[0]);
  vec4 get zzzy => new vec4(_storage[2], _storage[2], _storage[2], _storage[1]);
  vec4 get zzzz => new vec4(_storage[2], _storage[2], _storage[2], _storage[2]);
  vec4 get zzzw => new vec4(_storage[2], _storage[2], _storage[2], _storage[3]);
  vec4 get zzwx => new vec4(_storage[2], _storage[2], _storage[3], _storage[0]);
  vec4 get zzwy => new vec4(_storage[2], _storage[2], _storage[3], _storage[1]);
  vec4 get zzwz => new vec4(_storage[2], _storage[2], _storage[3], _storage[2]);
  vec4 get zzww => new vec4(_storage[2], _storage[2], _storage[3], _storage[3]);
  vec4 get zwxx => new vec4(_storage[2], _storage[3], _storage[0], _storage[0]);
  vec4 get zwxy => new vec4(_storage[2], _storage[3], _storage[0], _storage[1]);
  vec4 get zwxz => new vec4(_storage[2], _storage[3], _storage[0], _storage[2]);
  vec4 get zwxw => new vec4(_storage[2], _storage[3], _storage[0], _storage[3]);
  vec4 get zwyx => new vec4(_storage[2], _storage[3], _storage[1], _storage[0]);
  vec4 get zwyy => new vec4(_storage[2], _storage[3], _storage[1], _storage[1]);
  vec4 get zwyz => new vec4(_storage[2], _storage[3], _storage[1], _storage[2]);
  vec4 get zwyw => new vec4(_storage[2], _storage[3], _storage[1], _storage[3]);
  vec4 get zwzx => new vec4(_storage[2], _storage[3], _storage[2], _storage[0]);
  vec4 get zwzy => new vec4(_storage[2], _storage[3], _storage[2], _storage[1]);
  vec4 get zwzz => new vec4(_storage[2], _storage[3], _storage[2], _storage[2]);
  vec4 get zwzw => new vec4(_storage[2], _storage[3], _storage[2], _storage[3]);
  vec4 get zwwx => new vec4(_storage[2], _storage[3], _storage[3], _storage[0]);
  vec4 get zwwy => new vec4(_storage[2], _storage[3], _storage[3], _storage[1]);
  vec4 get zwwz => new vec4(_storage[2], _storage[3], _storage[3], _storage[2]);
  vec4 get zwww => new vec4(_storage[2], _storage[3], _storage[3], _storage[3]);
  vec4 get wxxx => new vec4(_storage[3], _storage[0], _storage[0], _storage[0]);
  vec4 get wxxy => new vec4(_storage[3], _storage[0], _storage[0], _storage[1]);
  vec4 get wxxz => new vec4(_storage[3], _storage[0], _storage[0], _storage[2]);
  vec4 get wxxw => new vec4(_storage[3], _storage[0], _storage[0], _storage[3]);
  vec4 get wxyx => new vec4(_storage[3], _storage[0], _storage[1], _storage[0]);
  vec4 get wxyy => new vec4(_storage[3], _storage[0], _storage[1], _storage[1]);
  vec4 get wxyz => new vec4(_storage[3], _storage[0], _storage[1], _storage[2]);
  vec4 get wxyw => new vec4(_storage[3], _storage[0], _storage[1], _storage[3]);
  vec4 get wxzx => new vec4(_storage[3], _storage[0], _storage[2], _storage[0]);
  vec4 get wxzy => new vec4(_storage[3], _storage[0], _storage[2], _storage[1]);
  vec4 get wxzz => new vec4(_storage[3], _storage[0], _storage[2], _storage[2]);
  vec4 get wxzw => new vec4(_storage[3], _storage[0], _storage[2], _storage[3]);
  vec4 get wxwx => new vec4(_storage[3], _storage[0], _storage[3], _storage[0]);
  vec4 get wxwy => new vec4(_storage[3], _storage[0], _storage[3], _storage[1]);
  vec4 get wxwz => new vec4(_storage[3], _storage[0], _storage[3], _storage[2]);
  vec4 get wxww => new vec4(_storage[3], _storage[0], _storage[3], _storage[3]);
  vec4 get wyxx => new vec4(_storage[3], _storage[1], _storage[0], _storage[0]);
  vec4 get wyxy => new vec4(_storage[3], _storage[1], _storage[0], _storage[1]);
  vec4 get wyxz => new vec4(_storage[3], _storage[1], _storage[0], _storage[2]);
  vec4 get wyxw => new vec4(_storage[3], _storage[1], _storage[0], _storage[3]);
  vec4 get wyyx => new vec4(_storage[3], _storage[1], _storage[1], _storage[0]);
  vec4 get wyyy => new vec4(_storage[3], _storage[1], _storage[1], _storage[1]);
  vec4 get wyyz => new vec4(_storage[3], _storage[1], _storage[1], _storage[2]);
  vec4 get wyyw => new vec4(_storage[3], _storage[1], _storage[1], _storage[3]);
  vec4 get wyzx => new vec4(_storage[3], _storage[1], _storage[2], _storage[0]);
  vec4 get wyzy => new vec4(_storage[3], _storage[1], _storage[2], _storage[1]);
  vec4 get wyzz => new vec4(_storage[3], _storage[1], _storage[2], _storage[2]);
  vec4 get wyzw => new vec4(_storage[3], _storage[1], _storage[2], _storage[3]);
  vec4 get wywx => new vec4(_storage[3], _storage[1], _storage[3], _storage[0]);
  vec4 get wywy => new vec4(_storage[3], _storage[1], _storage[3], _storage[1]);
  vec4 get wywz => new vec4(_storage[3], _storage[1], _storage[3], _storage[2]);
  vec4 get wyww => new vec4(_storage[3], _storage[1], _storage[3], _storage[3]);
  vec4 get wzxx => new vec4(_storage[3], _storage[2], _storage[0], _storage[0]);
  vec4 get wzxy => new vec4(_storage[3], _storage[2], _storage[0], _storage[1]);
  vec4 get wzxz => new vec4(_storage[3], _storage[2], _storage[0], _storage[2]);
  vec4 get wzxw => new vec4(_storage[3], _storage[2], _storage[0], _storage[3]);
  vec4 get wzyx => new vec4(_storage[3], _storage[2], _storage[1], _storage[0]);
  vec4 get wzyy => new vec4(_storage[3], _storage[2], _storage[1], _storage[1]);
  vec4 get wzyz => new vec4(_storage[3], _storage[2], _storage[1], _storage[2]);
  vec4 get wzyw => new vec4(_storage[3], _storage[2], _storage[1], _storage[3]);
  vec4 get wzzx => new vec4(_storage[3], _storage[2], _storage[2], _storage[0]);
  vec4 get wzzy => new vec4(_storage[3], _storage[2], _storage[2], _storage[1]);
  vec4 get wzzz => new vec4(_storage[3], _storage[2], _storage[2], _storage[2]);
  vec4 get wzzw => new vec4(_storage[3], _storage[2], _storage[2], _storage[3]);
  vec4 get wzwx => new vec4(_storage[3], _storage[2], _storage[3], _storage[0]);
  vec4 get wzwy => new vec4(_storage[3], _storage[2], _storage[3], _storage[1]);
  vec4 get wzwz => new vec4(_storage[3], _storage[2], _storage[3], _storage[2]);
  vec4 get wzww => new vec4(_storage[3], _storage[2], _storage[3], _storage[3]);
  vec4 get wwxx => new vec4(_storage[3], _storage[3], _storage[0], _storage[0]);
  vec4 get wwxy => new vec4(_storage[3], _storage[3], _storage[0], _storage[1]);
  vec4 get wwxz => new vec4(_storage[3], _storage[3], _storage[0], _storage[2]);
  vec4 get wwxw => new vec4(_storage[3], _storage[3], _storage[0], _storage[3]);
  vec4 get wwyx => new vec4(_storage[3], _storage[3], _storage[1], _storage[0]);
  vec4 get wwyy => new vec4(_storage[3], _storage[3], _storage[1], _storage[1]);
  vec4 get wwyz => new vec4(_storage[3], _storage[3], _storage[1], _storage[2]);
  vec4 get wwyw => new vec4(_storage[3], _storage[3], _storage[1], _storage[3]);
  vec4 get wwzx => new vec4(_storage[3], _storage[3], _storage[2], _storage[0]);
  vec4 get wwzy => new vec4(_storage[3], _storage[3], _storage[2], _storage[1]);
  vec4 get wwzz => new vec4(_storage[3], _storage[3], _storage[2], _storage[2]);
  vec4 get wwzw => new vec4(_storage[3], _storage[3], _storage[2], _storage[3]);
  vec4 get wwwx => new vec4(_storage[3], _storage[3], _storage[3], _storage[0]);
  vec4 get wwwy => new vec4(_storage[3], _storage[3], _storage[3], _storage[1]);
  vec4 get wwwz => new vec4(_storage[3], _storage[3], _storage[3], _storage[2]);
  vec4 get wwww => new vec4(_storage[3], _storage[3], _storage[3], _storage[3]);
  double get r => _storage[0];
  double get g => _storage[1];
  double get b => _storage[2];
  double get a => _storage[3];
  double get s => _storage[0];
  double get t => _storage[1];
  double get p => _storage[2];
  double get q => _storage[3];
  double get x => _storage[0];
  double get y => _storage[1];
  double get z => _storage[2];
  double get w => _storage[3];
  vec2 get rr => new vec2(_storage[0], _storage[0]);
  vec2 get rg => new vec2(_storage[0], _storage[1]);
  vec2 get rb => new vec2(_storage[0], _storage[2]);
  vec2 get ra => new vec2(_storage[0], _storage[3]);
  vec2 get gr => new vec2(_storage[1], _storage[0]);
  vec2 get gg => new vec2(_storage[1], _storage[1]);
  vec2 get gb => new vec2(_storage[1], _storage[2]);
  vec2 get ga => new vec2(_storage[1], _storage[3]);
  vec2 get br => new vec2(_storage[2], _storage[0]);
  vec2 get bg => new vec2(_storage[2], _storage[1]);
  vec2 get bb => new vec2(_storage[2], _storage[2]);
  vec2 get ba => new vec2(_storage[2], _storage[3]);
  vec2 get ar => new vec2(_storage[3], _storage[0]);
  vec2 get ag => new vec2(_storage[3], _storage[1]);
  vec2 get ab => new vec2(_storage[3], _storage[2]);
  vec2 get aa => new vec2(_storage[3], _storage[3]);
  vec3 get rrr => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get rrg => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get rrb => new vec3(_storage[0], _storage[0], _storage[2]);
  vec3 get rra => new vec3(_storage[0], _storage[0], _storage[3]);
  vec3 get rgr => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get rgg => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get rgb => new vec3(_storage[0], _storage[1], _storage[2]);
  vec3 get rga => new vec3(_storage[0], _storage[1], _storage[3]);
  vec3 get rbr => new vec3(_storage[0], _storage[2], _storage[0]);
  vec3 get rbg => new vec3(_storage[0], _storage[2], _storage[1]);
  vec3 get rbb => new vec3(_storage[0], _storage[2], _storage[2]);
  vec3 get rba => new vec3(_storage[0], _storage[2], _storage[3]);
  vec3 get rar => new vec3(_storage[0], _storage[3], _storage[0]);
  vec3 get rag => new vec3(_storage[0], _storage[3], _storage[1]);
  vec3 get rab => new vec3(_storage[0], _storage[3], _storage[2]);
  vec3 get raa => new vec3(_storage[0], _storage[3], _storage[3]);
  vec3 get grr => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get grg => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get grb => new vec3(_storage[1], _storage[0], _storage[2]);
  vec3 get gra => new vec3(_storage[1], _storage[0], _storage[3]);
  vec3 get ggr => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get ggg => new vec3(_storage[1], _storage[1], _storage[1]);
  vec3 get ggb => new vec3(_storage[1], _storage[1], _storage[2]);
  vec3 get gga => new vec3(_storage[1], _storage[1], _storage[3]);
  vec3 get gbr => new vec3(_storage[1], _storage[2], _storage[0]);
  vec3 get gbg => new vec3(_storage[1], _storage[2], _storage[1]);
  vec3 get gbb => new vec3(_storage[1], _storage[2], _storage[2]);
  vec3 get gba => new vec3(_storage[1], _storage[2], _storage[3]);
  vec3 get gar => new vec3(_storage[1], _storage[3], _storage[0]);
  vec3 get gag => new vec3(_storage[1], _storage[3], _storage[1]);
  vec3 get gab => new vec3(_storage[1], _storage[3], _storage[2]);
  vec3 get gaa => new vec3(_storage[1], _storage[3], _storage[3]);
  vec3 get brr => new vec3(_storage[2], _storage[0], _storage[0]);
  vec3 get brg => new vec3(_storage[2], _storage[0], _storage[1]);
  vec3 get brb => new vec3(_storage[2], _storage[0], _storage[2]);
  vec3 get bra => new vec3(_storage[2], _storage[0], _storage[3]);
  vec3 get bgr => new vec3(_storage[2], _storage[1], _storage[0]);
  vec3 get bgg => new vec3(_storage[2], _storage[1], _storage[1]);
  vec3 get bgb => new vec3(_storage[2], _storage[1], _storage[2]);
  vec3 get bga => new vec3(_storage[2], _storage[1], _storage[3]);
  vec3 get bbr => new vec3(_storage[2], _storage[2], _storage[0]);
  vec3 get bbg => new vec3(_storage[2], _storage[2], _storage[1]);
  vec3 get bbb => new vec3(_storage[2], _storage[2], _storage[2]);
  vec3 get bba => new vec3(_storage[2], _storage[2], _storage[3]);
  vec3 get bar => new vec3(_storage[2], _storage[3], _storage[0]);
  vec3 get bag => new vec3(_storage[2], _storage[3], _storage[1]);
  vec3 get bab => new vec3(_storage[2], _storage[3], _storage[2]);
  vec3 get baa => new vec3(_storage[2], _storage[3], _storage[3]);
  vec3 get arr => new vec3(_storage[3], _storage[0], _storage[0]);
  vec3 get arg => new vec3(_storage[3], _storage[0], _storage[1]);
  vec3 get arb => new vec3(_storage[3], _storage[0], _storage[2]);
  vec3 get ara => new vec3(_storage[3], _storage[0], _storage[3]);
  vec3 get agr => new vec3(_storage[3], _storage[1], _storage[0]);
  vec3 get agg => new vec3(_storage[3], _storage[1], _storage[1]);
  vec3 get agb => new vec3(_storage[3], _storage[1], _storage[2]);
  vec3 get aga => new vec3(_storage[3], _storage[1], _storage[3]);
  vec3 get abr => new vec3(_storage[3], _storage[2], _storage[0]);
  vec3 get abg => new vec3(_storage[3], _storage[2], _storage[1]);
  vec3 get abb => new vec3(_storage[3], _storage[2], _storage[2]);
  vec3 get aba => new vec3(_storage[3], _storage[2], _storage[3]);
  vec3 get aar => new vec3(_storage[3], _storage[3], _storage[0]);
  vec3 get aag => new vec3(_storage[3], _storage[3], _storage[1]);
  vec3 get aab => new vec3(_storage[3], _storage[3], _storage[2]);
  vec3 get aaa => new vec3(_storage[3], _storage[3], _storage[3]);
  vec4 get rrrr => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get rrrg => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get rrrb => new vec4(_storage[0], _storage[0], _storage[0], _storage[2]);
  vec4 get rrra => new vec4(_storage[0], _storage[0], _storage[0], _storage[3]);
  vec4 get rrgr => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get rrgg => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get rrgb => new vec4(_storage[0], _storage[0], _storage[1], _storage[2]);
  vec4 get rrga => new vec4(_storage[0], _storage[0], _storage[1], _storage[3]);
  vec4 get rrbr => new vec4(_storage[0], _storage[0], _storage[2], _storage[0]);
  vec4 get rrbg => new vec4(_storage[0], _storage[0], _storage[2], _storage[1]);
  vec4 get rrbb => new vec4(_storage[0], _storage[0], _storage[2], _storage[2]);
  vec4 get rrba => new vec4(_storage[0], _storage[0], _storage[2], _storage[3]);
  vec4 get rrar => new vec4(_storage[0], _storage[0], _storage[3], _storage[0]);
  vec4 get rrag => new vec4(_storage[0], _storage[0], _storage[3], _storage[1]);
  vec4 get rrab => new vec4(_storage[0], _storage[0], _storage[3], _storage[2]);
  vec4 get rraa => new vec4(_storage[0], _storage[0], _storage[3], _storage[3]);
  vec4 get rgrr => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get rgrg => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get rgrb => new vec4(_storage[0], _storage[1], _storage[0], _storage[2]);
  vec4 get rgra => new vec4(_storage[0], _storage[1], _storage[0], _storage[3]);
  vec4 get rggr => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get rggg => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get rggb => new vec4(_storage[0], _storage[1], _storage[1], _storage[2]);
  vec4 get rgga => new vec4(_storage[0], _storage[1], _storage[1], _storage[3]);
  vec4 get rgbr => new vec4(_storage[0], _storage[1], _storage[2], _storage[0]);
  vec4 get rgbg => new vec4(_storage[0], _storage[1], _storage[2], _storage[1]);
  vec4 get rgbb => new vec4(_storage[0], _storage[1], _storage[2], _storage[2]);
  vec4 get rgba => new vec4(_storage[0], _storage[1], _storage[2], _storage[3]);
  vec4 get rgar => new vec4(_storage[0], _storage[1], _storage[3], _storage[0]);
  vec4 get rgag => new vec4(_storage[0], _storage[1], _storage[3], _storage[1]);
  vec4 get rgab => new vec4(_storage[0], _storage[1], _storage[3], _storage[2]);
  vec4 get rgaa => new vec4(_storage[0], _storage[1], _storage[3], _storage[3]);
  vec4 get rbrr => new vec4(_storage[0], _storage[2], _storage[0], _storage[0]);
  vec4 get rbrg => new vec4(_storage[0], _storage[2], _storage[0], _storage[1]);
  vec4 get rbrb => new vec4(_storage[0], _storage[2], _storage[0], _storage[2]);
  vec4 get rbra => new vec4(_storage[0], _storage[2], _storage[0], _storage[3]);
  vec4 get rbgr => new vec4(_storage[0], _storage[2], _storage[1], _storage[0]);
  vec4 get rbgg => new vec4(_storage[0], _storage[2], _storage[1], _storage[1]);
  vec4 get rbgb => new vec4(_storage[0], _storage[2], _storage[1], _storage[2]);
  vec4 get rbga => new vec4(_storage[0], _storage[2], _storage[1], _storage[3]);
  vec4 get rbbr => new vec4(_storage[0], _storage[2], _storage[2], _storage[0]);
  vec4 get rbbg => new vec4(_storage[0], _storage[2], _storage[2], _storage[1]);
  vec4 get rbbb => new vec4(_storage[0], _storage[2], _storage[2], _storage[2]);
  vec4 get rbba => new vec4(_storage[0], _storage[2], _storage[2], _storage[3]);
  vec4 get rbar => new vec4(_storage[0], _storage[2], _storage[3], _storage[0]);
  vec4 get rbag => new vec4(_storage[0], _storage[2], _storage[3], _storage[1]);
  vec4 get rbab => new vec4(_storage[0], _storage[2], _storage[3], _storage[2]);
  vec4 get rbaa => new vec4(_storage[0], _storage[2], _storage[3], _storage[3]);
  vec4 get rarr => new vec4(_storage[0], _storage[3], _storage[0], _storage[0]);
  vec4 get rarg => new vec4(_storage[0], _storage[3], _storage[0], _storage[1]);
  vec4 get rarb => new vec4(_storage[0], _storage[3], _storage[0], _storage[2]);
  vec4 get rara => new vec4(_storage[0], _storage[3], _storage[0], _storage[3]);
  vec4 get ragr => new vec4(_storage[0], _storage[3], _storage[1], _storage[0]);
  vec4 get ragg => new vec4(_storage[0], _storage[3], _storage[1], _storage[1]);
  vec4 get ragb => new vec4(_storage[0], _storage[3], _storage[1], _storage[2]);
  vec4 get raga => new vec4(_storage[0], _storage[3], _storage[1], _storage[3]);
  vec4 get rabr => new vec4(_storage[0], _storage[3], _storage[2], _storage[0]);
  vec4 get rabg => new vec4(_storage[0], _storage[3], _storage[2], _storage[1]);
  vec4 get rabb => new vec4(_storage[0], _storage[3], _storage[2], _storage[2]);
  vec4 get raba => new vec4(_storage[0], _storage[3], _storage[2], _storage[3]);
  vec4 get raar => new vec4(_storage[0], _storage[3], _storage[3], _storage[0]);
  vec4 get raag => new vec4(_storage[0], _storage[3], _storage[3], _storage[1]);
  vec4 get raab => new vec4(_storage[0], _storage[3], _storage[3], _storage[2]);
  vec4 get raaa => new vec4(_storage[0], _storage[3], _storage[3], _storage[3]);
  vec4 get grrr => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get grrg => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get grrb => new vec4(_storage[1], _storage[0], _storage[0], _storage[2]);
  vec4 get grra => new vec4(_storage[1], _storage[0], _storage[0], _storage[3]);
  vec4 get grgr => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get grgg => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get grgb => new vec4(_storage[1], _storage[0], _storage[1], _storage[2]);
  vec4 get grga => new vec4(_storage[1], _storage[0], _storage[1], _storage[3]);
  vec4 get grbr => new vec4(_storage[1], _storage[0], _storage[2], _storage[0]);
  vec4 get grbg => new vec4(_storage[1], _storage[0], _storage[2], _storage[1]);
  vec4 get grbb => new vec4(_storage[1], _storage[0], _storage[2], _storage[2]);
  vec4 get grba => new vec4(_storage[1], _storage[0], _storage[2], _storage[3]);
  vec4 get grar => new vec4(_storage[1], _storage[0], _storage[3], _storage[0]);
  vec4 get grag => new vec4(_storage[1], _storage[0], _storage[3], _storage[1]);
  vec4 get grab => new vec4(_storage[1], _storage[0], _storage[3], _storage[2]);
  vec4 get graa => new vec4(_storage[1], _storage[0], _storage[3], _storage[3]);
  vec4 get ggrr => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get ggrg => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get ggrb => new vec4(_storage[1], _storage[1], _storage[0], _storage[2]);
  vec4 get ggra => new vec4(_storage[1], _storage[1], _storage[0], _storage[3]);
  vec4 get gggr => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get gggg => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  vec4 get gggb => new vec4(_storage[1], _storage[1], _storage[1], _storage[2]);
  vec4 get ggga => new vec4(_storage[1], _storage[1], _storage[1], _storage[3]);
  vec4 get ggbr => new vec4(_storage[1], _storage[1], _storage[2], _storage[0]);
  vec4 get ggbg => new vec4(_storage[1], _storage[1], _storage[2], _storage[1]);
  vec4 get ggbb => new vec4(_storage[1], _storage[1], _storage[2], _storage[2]);
  vec4 get ggba => new vec4(_storage[1], _storage[1], _storage[2], _storage[3]);
  vec4 get ggar => new vec4(_storage[1], _storage[1], _storage[3], _storage[0]);
  vec4 get ggag => new vec4(_storage[1], _storage[1], _storage[3], _storage[1]);
  vec4 get ggab => new vec4(_storage[1], _storage[1], _storage[3], _storage[2]);
  vec4 get ggaa => new vec4(_storage[1], _storage[1], _storage[3], _storage[3]);
  vec4 get gbrr => new vec4(_storage[1], _storage[2], _storage[0], _storage[0]);
  vec4 get gbrg => new vec4(_storage[1], _storage[2], _storage[0], _storage[1]);
  vec4 get gbrb => new vec4(_storage[1], _storage[2], _storage[0], _storage[2]);
  vec4 get gbra => new vec4(_storage[1], _storage[2], _storage[0], _storage[3]);
  vec4 get gbgr => new vec4(_storage[1], _storage[2], _storage[1], _storage[0]);
  vec4 get gbgg => new vec4(_storage[1], _storage[2], _storage[1], _storage[1]);
  vec4 get gbgb => new vec4(_storage[1], _storage[2], _storage[1], _storage[2]);
  vec4 get gbga => new vec4(_storage[1], _storage[2], _storage[1], _storage[3]);
  vec4 get gbbr => new vec4(_storage[1], _storage[2], _storage[2], _storage[0]);
  vec4 get gbbg => new vec4(_storage[1], _storage[2], _storage[2], _storage[1]);
  vec4 get gbbb => new vec4(_storage[1], _storage[2], _storage[2], _storage[2]);
  vec4 get gbba => new vec4(_storage[1], _storage[2], _storage[2], _storage[3]);
  vec4 get gbar => new vec4(_storage[1], _storage[2], _storage[3], _storage[0]);
  vec4 get gbag => new vec4(_storage[1], _storage[2], _storage[3], _storage[1]);
  vec4 get gbab => new vec4(_storage[1], _storage[2], _storage[3], _storage[2]);
  vec4 get gbaa => new vec4(_storage[1], _storage[2], _storage[3], _storage[3]);
  vec4 get garr => new vec4(_storage[1], _storage[3], _storage[0], _storage[0]);
  vec4 get garg => new vec4(_storage[1], _storage[3], _storage[0], _storage[1]);
  vec4 get garb => new vec4(_storage[1], _storage[3], _storage[0], _storage[2]);
  vec4 get gara => new vec4(_storage[1], _storage[3], _storage[0], _storage[3]);
  vec4 get gagr => new vec4(_storage[1], _storage[3], _storage[1], _storage[0]);
  vec4 get gagg => new vec4(_storage[1], _storage[3], _storage[1], _storage[1]);
  vec4 get gagb => new vec4(_storage[1], _storage[3], _storage[1], _storage[2]);
  vec4 get gaga => new vec4(_storage[1], _storage[3], _storage[1], _storage[3]);
  vec4 get gabr => new vec4(_storage[1], _storage[3], _storage[2], _storage[0]);
  vec4 get gabg => new vec4(_storage[1], _storage[3], _storage[2], _storage[1]);
  vec4 get gabb => new vec4(_storage[1], _storage[3], _storage[2], _storage[2]);
  vec4 get gaba => new vec4(_storage[1], _storage[3], _storage[2], _storage[3]);
  vec4 get gaar => new vec4(_storage[1], _storage[3], _storage[3], _storage[0]);
  vec4 get gaag => new vec4(_storage[1], _storage[3], _storage[3], _storage[1]);
  vec4 get gaab => new vec4(_storage[1], _storage[3], _storage[3], _storage[2]);
  vec4 get gaaa => new vec4(_storage[1], _storage[3], _storage[3], _storage[3]);
  vec4 get brrr => new vec4(_storage[2], _storage[0], _storage[0], _storage[0]);
  vec4 get brrg => new vec4(_storage[2], _storage[0], _storage[0], _storage[1]);
  vec4 get brrb => new vec4(_storage[2], _storage[0], _storage[0], _storage[2]);
  vec4 get brra => new vec4(_storage[2], _storage[0], _storage[0], _storage[3]);
  vec4 get brgr => new vec4(_storage[2], _storage[0], _storage[1], _storage[0]);
  vec4 get brgg => new vec4(_storage[2], _storage[0], _storage[1], _storage[1]);
  vec4 get brgb => new vec4(_storage[2], _storage[0], _storage[1], _storage[2]);
  vec4 get brga => new vec4(_storage[2], _storage[0], _storage[1], _storage[3]);
  vec4 get brbr => new vec4(_storage[2], _storage[0], _storage[2], _storage[0]);
  vec4 get brbg => new vec4(_storage[2], _storage[0], _storage[2], _storage[1]);
  vec4 get brbb => new vec4(_storage[2], _storage[0], _storage[2], _storage[2]);
  vec4 get brba => new vec4(_storage[2], _storage[0], _storage[2], _storage[3]);
  vec4 get brar => new vec4(_storage[2], _storage[0], _storage[3], _storage[0]);
  vec4 get brag => new vec4(_storage[2], _storage[0], _storage[3], _storage[1]);
  vec4 get brab => new vec4(_storage[2], _storage[0], _storage[3], _storage[2]);
  vec4 get braa => new vec4(_storage[2], _storage[0], _storage[3], _storage[3]);
  vec4 get bgrr => new vec4(_storage[2], _storage[1], _storage[0], _storage[0]);
  vec4 get bgrg => new vec4(_storage[2], _storage[1], _storage[0], _storage[1]);
  vec4 get bgrb => new vec4(_storage[2], _storage[1], _storage[0], _storage[2]);
  vec4 get bgra => new vec4(_storage[2], _storage[1], _storage[0], _storage[3]);
  vec4 get bggr => new vec4(_storage[2], _storage[1], _storage[1], _storage[0]);
  vec4 get bggg => new vec4(_storage[2], _storage[1], _storage[1], _storage[1]);
  vec4 get bggb => new vec4(_storage[2], _storage[1], _storage[1], _storage[2]);
  vec4 get bgga => new vec4(_storage[2], _storage[1], _storage[1], _storage[3]);
  vec4 get bgbr => new vec4(_storage[2], _storage[1], _storage[2], _storage[0]);
  vec4 get bgbg => new vec4(_storage[2], _storage[1], _storage[2], _storage[1]);
  vec4 get bgbb => new vec4(_storage[2], _storage[1], _storage[2], _storage[2]);
  vec4 get bgba => new vec4(_storage[2], _storage[1], _storage[2], _storage[3]);
  vec4 get bgar => new vec4(_storage[2], _storage[1], _storage[3], _storage[0]);
  vec4 get bgag => new vec4(_storage[2], _storage[1], _storage[3], _storage[1]);
  vec4 get bgab => new vec4(_storage[2], _storage[1], _storage[3], _storage[2]);
  vec4 get bgaa => new vec4(_storage[2], _storage[1], _storage[3], _storage[3]);
  vec4 get bbrr => new vec4(_storage[2], _storage[2], _storage[0], _storage[0]);
  vec4 get bbrg => new vec4(_storage[2], _storage[2], _storage[0], _storage[1]);
  vec4 get bbrb => new vec4(_storage[2], _storage[2], _storage[0], _storage[2]);
  vec4 get bbra => new vec4(_storage[2], _storage[2], _storage[0], _storage[3]);
  vec4 get bbgr => new vec4(_storage[2], _storage[2], _storage[1], _storage[0]);
  vec4 get bbgg => new vec4(_storage[2], _storage[2], _storage[1], _storage[1]);
  vec4 get bbgb => new vec4(_storage[2], _storage[2], _storage[1], _storage[2]);
  vec4 get bbga => new vec4(_storage[2], _storage[2], _storage[1], _storage[3]);
  vec4 get bbbr => new vec4(_storage[2], _storage[2], _storage[2], _storage[0]);
  vec4 get bbbg => new vec4(_storage[2], _storage[2], _storage[2], _storage[1]);
  vec4 get bbbb => new vec4(_storage[2], _storage[2], _storage[2], _storage[2]);
  vec4 get bbba => new vec4(_storage[2], _storage[2], _storage[2], _storage[3]);
  vec4 get bbar => new vec4(_storage[2], _storage[2], _storage[3], _storage[0]);
  vec4 get bbag => new vec4(_storage[2], _storage[2], _storage[3], _storage[1]);
  vec4 get bbab => new vec4(_storage[2], _storage[2], _storage[3], _storage[2]);
  vec4 get bbaa => new vec4(_storage[2], _storage[2], _storage[3], _storage[3]);
  vec4 get barr => new vec4(_storage[2], _storage[3], _storage[0], _storage[0]);
  vec4 get barg => new vec4(_storage[2], _storage[3], _storage[0], _storage[1]);
  vec4 get barb => new vec4(_storage[2], _storage[3], _storage[0], _storage[2]);
  vec4 get bara => new vec4(_storage[2], _storage[3], _storage[0], _storage[3]);
  vec4 get bagr => new vec4(_storage[2], _storage[3], _storage[1], _storage[0]);
  vec4 get bagg => new vec4(_storage[2], _storage[3], _storage[1], _storage[1]);
  vec4 get bagb => new vec4(_storage[2], _storage[3], _storage[1], _storage[2]);
  vec4 get baga => new vec4(_storage[2], _storage[3], _storage[1], _storage[3]);
  vec4 get babr => new vec4(_storage[2], _storage[3], _storage[2], _storage[0]);
  vec4 get babg => new vec4(_storage[2], _storage[3], _storage[2], _storage[1]);
  vec4 get babb => new vec4(_storage[2], _storage[3], _storage[2], _storage[2]);
  vec4 get baba => new vec4(_storage[2], _storage[3], _storage[2], _storage[3]);
  vec4 get baar => new vec4(_storage[2], _storage[3], _storage[3], _storage[0]);
  vec4 get baag => new vec4(_storage[2], _storage[3], _storage[3], _storage[1]);
  vec4 get baab => new vec4(_storage[2], _storage[3], _storage[3], _storage[2]);
  vec4 get baaa => new vec4(_storage[2], _storage[3], _storage[3], _storage[3]);
  vec4 get arrr => new vec4(_storage[3], _storage[0], _storage[0], _storage[0]);
  vec4 get arrg => new vec4(_storage[3], _storage[0], _storage[0], _storage[1]);
  vec4 get arrb => new vec4(_storage[3], _storage[0], _storage[0], _storage[2]);
  vec4 get arra => new vec4(_storage[3], _storage[0], _storage[0], _storage[3]);
  vec4 get argr => new vec4(_storage[3], _storage[0], _storage[1], _storage[0]);
  vec4 get argg => new vec4(_storage[3], _storage[0], _storage[1], _storage[1]);
  vec4 get argb => new vec4(_storage[3], _storage[0], _storage[1], _storage[2]);
  vec4 get arga => new vec4(_storage[3], _storage[0], _storage[1], _storage[3]);
  vec4 get arbr => new vec4(_storage[3], _storage[0], _storage[2], _storage[0]);
  vec4 get arbg => new vec4(_storage[3], _storage[0], _storage[2], _storage[1]);
  vec4 get arbb => new vec4(_storage[3], _storage[0], _storage[2], _storage[2]);
  vec4 get arba => new vec4(_storage[3], _storage[0], _storage[2], _storage[3]);
  vec4 get arar => new vec4(_storage[3], _storage[0], _storage[3], _storage[0]);
  vec4 get arag => new vec4(_storage[3], _storage[0], _storage[3], _storage[1]);
  vec4 get arab => new vec4(_storage[3], _storage[0], _storage[3], _storage[2]);
  vec4 get araa => new vec4(_storage[3], _storage[0], _storage[3], _storage[3]);
  vec4 get agrr => new vec4(_storage[3], _storage[1], _storage[0], _storage[0]);
  vec4 get agrg => new vec4(_storage[3], _storage[1], _storage[0], _storage[1]);
  vec4 get agrb => new vec4(_storage[3], _storage[1], _storage[0], _storage[2]);
  vec4 get agra => new vec4(_storage[3], _storage[1], _storage[0], _storage[3]);
  vec4 get aggr => new vec4(_storage[3], _storage[1], _storage[1], _storage[0]);
  vec4 get aggg => new vec4(_storage[3], _storage[1], _storage[1], _storage[1]);
  vec4 get aggb => new vec4(_storage[3], _storage[1], _storage[1], _storage[2]);
  vec4 get agga => new vec4(_storage[3], _storage[1], _storage[1], _storage[3]);
  vec4 get agbr => new vec4(_storage[3], _storage[1], _storage[2], _storage[0]);
  vec4 get agbg => new vec4(_storage[3], _storage[1], _storage[2], _storage[1]);
  vec4 get agbb => new vec4(_storage[3], _storage[1], _storage[2], _storage[2]);
  vec4 get agba => new vec4(_storage[3], _storage[1], _storage[2], _storage[3]);
  vec4 get agar => new vec4(_storage[3], _storage[1], _storage[3], _storage[0]);
  vec4 get agag => new vec4(_storage[3], _storage[1], _storage[3], _storage[1]);
  vec4 get agab => new vec4(_storage[3], _storage[1], _storage[3], _storage[2]);
  vec4 get agaa => new vec4(_storage[3], _storage[1], _storage[3], _storage[3]);
  vec4 get abrr => new vec4(_storage[3], _storage[2], _storage[0], _storage[0]);
  vec4 get abrg => new vec4(_storage[3], _storage[2], _storage[0], _storage[1]);
  vec4 get abrb => new vec4(_storage[3], _storage[2], _storage[0], _storage[2]);
  vec4 get abra => new vec4(_storage[3], _storage[2], _storage[0], _storage[3]);
  vec4 get abgr => new vec4(_storage[3], _storage[2], _storage[1], _storage[0]);
  vec4 get abgg => new vec4(_storage[3], _storage[2], _storage[1], _storage[1]);
  vec4 get abgb => new vec4(_storage[3], _storage[2], _storage[1], _storage[2]);
  vec4 get abga => new vec4(_storage[3], _storage[2], _storage[1], _storage[3]);
  vec4 get abbr => new vec4(_storage[3], _storage[2], _storage[2], _storage[0]);
  vec4 get abbg => new vec4(_storage[3], _storage[2], _storage[2], _storage[1]);
  vec4 get abbb => new vec4(_storage[3], _storage[2], _storage[2], _storage[2]);
  vec4 get abba => new vec4(_storage[3], _storage[2], _storage[2], _storage[3]);
  vec4 get abar => new vec4(_storage[3], _storage[2], _storage[3], _storage[0]);
  vec4 get abag => new vec4(_storage[3], _storage[2], _storage[3], _storage[1]);
  vec4 get abab => new vec4(_storage[3], _storage[2], _storage[3], _storage[2]);
  vec4 get abaa => new vec4(_storage[3], _storage[2], _storage[3], _storage[3]);
  vec4 get aarr => new vec4(_storage[3], _storage[3], _storage[0], _storage[0]);
  vec4 get aarg => new vec4(_storage[3], _storage[3], _storage[0], _storage[1]);
  vec4 get aarb => new vec4(_storage[3], _storage[3], _storage[0], _storage[2]);
  vec4 get aara => new vec4(_storage[3], _storage[3], _storage[0], _storage[3]);
  vec4 get aagr => new vec4(_storage[3], _storage[3], _storage[1], _storage[0]);
  vec4 get aagg => new vec4(_storage[3], _storage[3], _storage[1], _storage[1]);
  vec4 get aagb => new vec4(_storage[3], _storage[3], _storage[1], _storage[2]);
  vec4 get aaga => new vec4(_storage[3], _storage[3], _storage[1], _storage[3]);
  vec4 get aabr => new vec4(_storage[3], _storage[3], _storage[2], _storage[0]);
  vec4 get aabg => new vec4(_storage[3], _storage[3], _storage[2], _storage[1]);
  vec4 get aabb => new vec4(_storage[3], _storage[3], _storage[2], _storage[2]);
  vec4 get aaba => new vec4(_storage[3], _storage[3], _storage[2], _storage[3]);
  vec4 get aaar => new vec4(_storage[3], _storage[3], _storage[3], _storage[0]);
  vec4 get aaag => new vec4(_storage[3], _storage[3], _storage[3], _storage[1]);
  vec4 get aaab => new vec4(_storage[3], _storage[3], _storage[3], _storage[2]);
  vec4 get aaaa => new vec4(_storage[3], _storage[3], _storage[3], _storage[3]);
  vec2 get ss => new vec2(_storage[0], _storage[0]);
  vec2 get st => new vec2(_storage[0], _storage[1]);
  vec2 get sp => new vec2(_storage[0], _storage[2]);
  vec2 get sq => new vec2(_storage[0], _storage[3]);
  vec2 get ts => new vec2(_storage[1], _storage[0]);
  vec2 get tt => new vec2(_storage[1], _storage[1]);
  vec2 get tp => new vec2(_storage[1], _storage[2]);
  vec2 get tq => new vec2(_storage[1], _storage[3]);
  vec2 get ps => new vec2(_storage[2], _storage[0]);
  vec2 get pt => new vec2(_storage[2], _storage[1]);
  vec2 get pp => new vec2(_storage[2], _storage[2]);
  vec2 get pq => new vec2(_storage[2], _storage[3]);
  vec2 get qs => new vec2(_storage[3], _storage[0]);
  vec2 get qt => new vec2(_storage[3], _storage[1]);
  vec2 get qp => new vec2(_storage[3], _storage[2]);
  vec2 get qq => new vec2(_storage[3], _storage[3]);
  vec3 get sss => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get sst => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get ssp => new vec3(_storage[0], _storage[0], _storage[2]);
  vec3 get ssq => new vec3(_storage[0], _storage[0], _storage[3]);
  vec3 get sts => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get stt => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get stp => new vec3(_storage[0], _storage[1], _storage[2]);
  vec3 get stq => new vec3(_storage[0], _storage[1], _storage[3]);
  vec3 get sps => new vec3(_storage[0], _storage[2], _storage[0]);
  vec3 get spt => new vec3(_storage[0], _storage[2], _storage[1]);
  vec3 get spp => new vec3(_storage[0], _storage[2], _storage[2]);
  vec3 get spq => new vec3(_storage[0], _storage[2], _storage[3]);
  vec3 get sqs => new vec3(_storage[0], _storage[3], _storage[0]);
  vec3 get sqt => new vec3(_storage[0], _storage[3], _storage[1]);
  vec3 get sqp => new vec3(_storage[0], _storage[3], _storage[2]);
  vec3 get sqq => new vec3(_storage[0], _storage[3], _storage[3]);
  vec3 get tss => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get tst => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get tsp => new vec3(_storage[1], _storage[0], _storage[2]);
  vec3 get tsq => new vec3(_storage[1], _storage[0], _storage[3]);
  vec3 get tts => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get ttt => new vec3(_storage[1], _storage[1], _storage[1]);
  vec3 get ttp => new vec3(_storage[1], _storage[1], _storage[2]);
  vec3 get ttq => new vec3(_storage[1], _storage[1], _storage[3]);
  vec3 get tps => new vec3(_storage[1], _storage[2], _storage[0]);
  vec3 get tpt => new vec3(_storage[1], _storage[2], _storage[1]);
  vec3 get tpp => new vec3(_storage[1], _storage[2], _storage[2]);
  vec3 get tpq => new vec3(_storage[1], _storage[2], _storage[3]);
  vec3 get tqs => new vec3(_storage[1], _storage[3], _storage[0]);
  vec3 get tqt => new vec3(_storage[1], _storage[3], _storage[1]);
  vec3 get tqp => new vec3(_storage[1], _storage[3], _storage[2]);
  vec3 get tqq => new vec3(_storage[1], _storage[3], _storage[3]);
  vec3 get pss => new vec3(_storage[2], _storage[0], _storage[0]);
  vec3 get pst => new vec3(_storage[2], _storage[0], _storage[1]);
  vec3 get psp => new vec3(_storage[2], _storage[0], _storage[2]);
  vec3 get psq => new vec3(_storage[2], _storage[0], _storage[3]);
  vec3 get pts => new vec3(_storage[2], _storage[1], _storage[0]);
  vec3 get ptt => new vec3(_storage[2], _storage[1], _storage[1]);
  vec3 get ptp => new vec3(_storage[2], _storage[1], _storage[2]);
  vec3 get ptq => new vec3(_storage[2], _storage[1], _storage[3]);
  vec3 get pps => new vec3(_storage[2], _storage[2], _storage[0]);
  vec3 get ppt => new vec3(_storage[2], _storage[2], _storage[1]);
  vec3 get ppp => new vec3(_storage[2], _storage[2], _storage[2]);
  vec3 get ppq => new vec3(_storage[2], _storage[2], _storage[3]);
  vec3 get pqs => new vec3(_storage[2], _storage[3], _storage[0]);
  vec3 get pqt => new vec3(_storage[2], _storage[3], _storage[1]);
  vec3 get pqp => new vec3(_storage[2], _storage[3], _storage[2]);
  vec3 get pqq => new vec3(_storage[2], _storage[3], _storage[3]);
  vec3 get qss => new vec3(_storage[3], _storage[0], _storage[0]);
  vec3 get qst => new vec3(_storage[3], _storage[0], _storage[1]);
  vec3 get qsp => new vec3(_storage[3], _storage[0], _storage[2]);
  vec3 get qsq => new vec3(_storage[3], _storage[0], _storage[3]);
  vec3 get qts => new vec3(_storage[3], _storage[1], _storage[0]);
  vec3 get qtt => new vec3(_storage[3], _storage[1], _storage[1]);
  vec3 get qtp => new vec3(_storage[3], _storage[1], _storage[2]);
  vec3 get qtq => new vec3(_storage[3], _storage[1], _storage[3]);
  vec3 get qps => new vec3(_storage[3], _storage[2], _storage[0]);
  vec3 get qpt => new vec3(_storage[3], _storage[2], _storage[1]);
  vec3 get qpp => new vec3(_storage[3], _storage[2], _storage[2]);
  vec3 get qpq => new vec3(_storage[3], _storage[2], _storage[3]);
  vec3 get qqs => new vec3(_storage[3], _storage[3], _storage[0]);
  vec3 get qqt => new vec3(_storage[3], _storage[3], _storage[1]);
  vec3 get qqp => new vec3(_storage[3], _storage[3], _storage[2]);
  vec3 get qqq => new vec3(_storage[3], _storage[3], _storage[3]);
  vec4 get ssss => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get ssst => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get sssp => new vec4(_storage[0], _storage[0], _storage[0], _storage[2]);
  vec4 get sssq => new vec4(_storage[0], _storage[0], _storage[0], _storage[3]);
  vec4 get ssts => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get sstt => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get sstp => new vec4(_storage[0], _storage[0], _storage[1], _storage[2]);
  vec4 get sstq => new vec4(_storage[0], _storage[0], _storage[1], _storage[3]);
  vec4 get ssps => new vec4(_storage[0], _storage[0], _storage[2], _storage[0]);
  vec4 get sspt => new vec4(_storage[0], _storage[0], _storage[2], _storage[1]);
  vec4 get sspp => new vec4(_storage[0], _storage[0], _storage[2], _storage[2]);
  vec4 get sspq => new vec4(_storage[0], _storage[0], _storage[2], _storage[3]);
  vec4 get ssqs => new vec4(_storage[0], _storage[0], _storage[3], _storage[0]);
  vec4 get ssqt => new vec4(_storage[0], _storage[0], _storage[3], _storage[1]);
  vec4 get ssqp => new vec4(_storage[0], _storage[0], _storage[3], _storage[2]);
  vec4 get ssqq => new vec4(_storage[0], _storage[0], _storage[3], _storage[3]);
  vec4 get stss => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get stst => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get stsp => new vec4(_storage[0], _storage[1], _storage[0], _storage[2]);
  vec4 get stsq => new vec4(_storage[0], _storage[1], _storage[0], _storage[3]);
  vec4 get stts => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get sttt => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get sttp => new vec4(_storage[0], _storage[1], _storage[1], _storage[2]);
  vec4 get sttq => new vec4(_storage[0], _storage[1], _storage[1], _storage[3]);
  vec4 get stps => new vec4(_storage[0], _storage[1], _storage[2], _storage[0]);
  vec4 get stpt => new vec4(_storage[0], _storage[1], _storage[2], _storage[1]);
  vec4 get stpp => new vec4(_storage[0], _storage[1], _storage[2], _storage[2]);
  vec4 get stpq => new vec4(_storage[0], _storage[1], _storage[2], _storage[3]);
  vec4 get stqs => new vec4(_storage[0], _storage[1], _storage[3], _storage[0]);
  vec4 get stqt => new vec4(_storage[0], _storage[1], _storage[3], _storage[1]);
  vec4 get stqp => new vec4(_storage[0], _storage[1], _storage[3], _storage[2]);
  vec4 get stqq => new vec4(_storage[0], _storage[1], _storage[3], _storage[3]);
  vec4 get spss => new vec4(_storage[0], _storage[2], _storage[0], _storage[0]);
  vec4 get spst => new vec4(_storage[0], _storage[2], _storage[0], _storage[1]);
  vec4 get spsp => new vec4(_storage[0], _storage[2], _storage[0], _storage[2]);
  vec4 get spsq => new vec4(_storage[0], _storage[2], _storage[0], _storage[3]);
  vec4 get spts => new vec4(_storage[0], _storage[2], _storage[1], _storage[0]);
  vec4 get sptt => new vec4(_storage[0], _storage[2], _storage[1], _storage[1]);
  vec4 get sptp => new vec4(_storage[0], _storage[2], _storage[1], _storage[2]);
  vec4 get sptq => new vec4(_storage[0], _storage[2], _storage[1], _storage[3]);
  vec4 get spps => new vec4(_storage[0], _storage[2], _storage[2], _storage[0]);
  vec4 get sppt => new vec4(_storage[0], _storage[2], _storage[2], _storage[1]);
  vec4 get sppp => new vec4(_storage[0], _storage[2], _storage[2], _storage[2]);
  vec4 get sppq => new vec4(_storage[0], _storage[2], _storage[2], _storage[3]);
  vec4 get spqs => new vec4(_storage[0], _storage[2], _storage[3], _storage[0]);
  vec4 get spqt => new vec4(_storage[0], _storage[2], _storage[3], _storage[1]);
  vec4 get spqp => new vec4(_storage[0], _storage[2], _storage[3], _storage[2]);
  vec4 get spqq => new vec4(_storage[0], _storage[2], _storage[3], _storage[3]);
  vec4 get sqss => new vec4(_storage[0], _storage[3], _storage[0], _storage[0]);
  vec4 get sqst => new vec4(_storage[0], _storage[3], _storage[0], _storage[1]);
  vec4 get sqsp => new vec4(_storage[0], _storage[3], _storage[0], _storage[2]);
  vec4 get sqsq => new vec4(_storage[0], _storage[3], _storage[0], _storage[3]);
  vec4 get sqts => new vec4(_storage[0], _storage[3], _storage[1], _storage[0]);
  vec4 get sqtt => new vec4(_storage[0], _storage[3], _storage[1], _storage[1]);
  vec4 get sqtp => new vec4(_storage[0], _storage[3], _storage[1], _storage[2]);
  vec4 get sqtq => new vec4(_storage[0], _storage[3], _storage[1], _storage[3]);
  vec4 get sqps => new vec4(_storage[0], _storage[3], _storage[2], _storage[0]);
  vec4 get sqpt => new vec4(_storage[0], _storage[3], _storage[2], _storage[1]);
  vec4 get sqpp => new vec4(_storage[0], _storage[3], _storage[2], _storage[2]);
  vec4 get sqpq => new vec4(_storage[0], _storage[3], _storage[2], _storage[3]);
  vec4 get sqqs => new vec4(_storage[0], _storage[3], _storage[3], _storage[0]);
  vec4 get sqqt => new vec4(_storage[0], _storage[3], _storage[3], _storage[1]);
  vec4 get sqqp => new vec4(_storage[0], _storage[3], _storage[3], _storage[2]);
  vec4 get sqqq => new vec4(_storage[0], _storage[3], _storage[3], _storage[3]);
  vec4 get tsss => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get tsst => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get tssp => new vec4(_storage[1], _storage[0], _storage[0], _storage[2]);
  vec4 get tssq => new vec4(_storage[1], _storage[0], _storage[0], _storage[3]);
  vec4 get tsts => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get tstt => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get tstp => new vec4(_storage[1], _storage[0], _storage[1], _storage[2]);
  vec4 get tstq => new vec4(_storage[1], _storage[0], _storage[1], _storage[3]);
  vec4 get tsps => new vec4(_storage[1], _storage[0], _storage[2], _storage[0]);
  vec4 get tspt => new vec4(_storage[1], _storage[0], _storage[2], _storage[1]);
  vec4 get tspp => new vec4(_storage[1], _storage[0], _storage[2], _storage[2]);
  vec4 get tspq => new vec4(_storage[1], _storage[0], _storage[2], _storage[3]);
  vec4 get tsqs => new vec4(_storage[1], _storage[0], _storage[3], _storage[0]);
  vec4 get tsqt => new vec4(_storage[1], _storage[0], _storage[3], _storage[1]);
  vec4 get tsqp => new vec4(_storage[1], _storage[0], _storage[3], _storage[2]);
  vec4 get tsqq => new vec4(_storage[1], _storage[0], _storage[3], _storage[3]);
  vec4 get ttss => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get ttst => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get ttsp => new vec4(_storage[1], _storage[1], _storage[0], _storage[2]);
  vec4 get ttsq => new vec4(_storage[1], _storage[1], _storage[0], _storage[3]);
  vec4 get ttts => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get tttt => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  vec4 get tttp => new vec4(_storage[1], _storage[1], _storage[1], _storage[2]);
  vec4 get tttq => new vec4(_storage[1], _storage[1], _storage[1], _storage[3]);
  vec4 get ttps => new vec4(_storage[1], _storage[1], _storage[2], _storage[0]);
  vec4 get ttpt => new vec4(_storage[1], _storage[1], _storage[2], _storage[1]);
  vec4 get ttpp => new vec4(_storage[1], _storage[1], _storage[2], _storage[2]);
  vec4 get ttpq => new vec4(_storage[1], _storage[1], _storage[2], _storage[3]);
  vec4 get ttqs => new vec4(_storage[1], _storage[1], _storage[3], _storage[0]);
  vec4 get ttqt => new vec4(_storage[1], _storage[1], _storage[3], _storage[1]);
  vec4 get ttqp => new vec4(_storage[1], _storage[1], _storage[3], _storage[2]);
  vec4 get ttqq => new vec4(_storage[1], _storage[1], _storage[3], _storage[3]);
  vec4 get tpss => new vec4(_storage[1], _storage[2], _storage[0], _storage[0]);
  vec4 get tpst => new vec4(_storage[1], _storage[2], _storage[0], _storage[1]);
  vec4 get tpsp => new vec4(_storage[1], _storage[2], _storage[0], _storage[2]);
  vec4 get tpsq => new vec4(_storage[1], _storage[2], _storage[0], _storage[3]);
  vec4 get tpts => new vec4(_storage[1], _storage[2], _storage[1], _storage[0]);
  vec4 get tptt => new vec4(_storage[1], _storage[2], _storage[1], _storage[1]);
  vec4 get tptp => new vec4(_storage[1], _storage[2], _storage[1], _storage[2]);
  vec4 get tptq => new vec4(_storage[1], _storage[2], _storage[1], _storage[3]);
  vec4 get tpps => new vec4(_storage[1], _storage[2], _storage[2], _storage[0]);
  vec4 get tppt => new vec4(_storage[1], _storage[2], _storage[2], _storage[1]);
  vec4 get tppp => new vec4(_storage[1], _storage[2], _storage[2], _storage[2]);
  vec4 get tppq => new vec4(_storage[1], _storage[2], _storage[2], _storage[3]);
  vec4 get tpqs => new vec4(_storage[1], _storage[2], _storage[3], _storage[0]);
  vec4 get tpqt => new vec4(_storage[1], _storage[2], _storage[3], _storage[1]);
  vec4 get tpqp => new vec4(_storage[1], _storage[2], _storage[3], _storage[2]);
  vec4 get tpqq => new vec4(_storage[1], _storage[2], _storage[3], _storage[3]);
  vec4 get tqss => new vec4(_storage[1], _storage[3], _storage[0], _storage[0]);
  vec4 get tqst => new vec4(_storage[1], _storage[3], _storage[0], _storage[1]);
  vec4 get tqsp => new vec4(_storage[1], _storage[3], _storage[0], _storage[2]);
  vec4 get tqsq => new vec4(_storage[1], _storage[3], _storage[0], _storage[3]);
  vec4 get tqts => new vec4(_storage[1], _storage[3], _storage[1], _storage[0]);
  vec4 get tqtt => new vec4(_storage[1], _storage[3], _storage[1], _storage[1]);
  vec4 get tqtp => new vec4(_storage[1], _storage[3], _storage[1], _storage[2]);
  vec4 get tqtq => new vec4(_storage[1], _storage[3], _storage[1], _storage[3]);
  vec4 get tqps => new vec4(_storage[1], _storage[3], _storage[2], _storage[0]);
  vec4 get tqpt => new vec4(_storage[1], _storage[3], _storage[2], _storage[1]);
  vec4 get tqpp => new vec4(_storage[1], _storage[3], _storage[2], _storage[2]);
  vec4 get tqpq => new vec4(_storage[1], _storage[3], _storage[2], _storage[3]);
  vec4 get tqqs => new vec4(_storage[1], _storage[3], _storage[3], _storage[0]);
  vec4 get tqqt => new vec4(_storage[1], _storage[3], _storage[3], _storage[1]);
  vec4 get tqqp => new vec4(_storage[1], _storage[3], _storage[3], _storage[2]);
  vec4 get tqqq => new vec4(_storage[1], _storage[3], _storage[3], _storage[3]);
  vec4 get psss => new vec4(_storage[2], _storage[0], _storage[0], _storage[0]);
  vec4 get psst => new vec4(_storage[2], _storage[0], _storage[0], _storage[1]);
  vec4 get pssp => new vec4(_storage[2], _storage[0], _storage[0], _storage[2]);
  vec4 get pssq => new vec4(_storage[2], _storage[0], _storage[0], _storage[3]);
  vec4 get psts => new vec4(_storage[2], _storage[0], _storage[1], _storage[0]);
  vec4 get pstt => new vec4(_storage[2], _storage[0], _storage[1], _storage[1]);
  vec4 get pstp => new vec4(_storage[2], _storage[0], _storage[1], _storage[2]);
  vec4 get pstq => new vec4(_storage[2], _storage[0], _storage[1], _storage[3]);
  vec4 get psps => new vec4(_storage[2], _storage[0], _storage[2], _storage[0]);
  vec4 get pspt => new vec4(_storage[2], _storage[0], _storage[2], _storage[1]);
  vec4 get pspp => new vec4(_storage[2], _storage[0], _storage[2], _storage[2]);
  vec4 get pspq => new vec4(_storage[2], _storage[0], _storage[2], _storage[3]);
  vec4 get psqs => new vec4(_storage[2], _storage[0], _storage[3], _storage[0]);
  vec4 get psqt => new vec4(_storage[2], _storage[0], _storage[3], _storage[1]);
  vec4 get psqp => new vec4(_storage[2], _storage[0], _storage[3], _storage[2]);
  vec4 get psqq => new vec4(_storage[2], _storage[0], _storage[3], _storage[3]);
  vec4 get ptss => new vec4(_storage[2], _storage[1], _storage[0], _storage[0]);
  vec4 get ptst => new vec4(_storage[2], _storage[1], _storage[0], _storage[1]);
  vec4 get ptsp => new vec4(_storage[2], _storage[1], _storage[0], _storage[2]);
  vec4 get ptsq => new vec4(_storage[2], _storage[1], _storage[0], _storage[3]);
  vec4 get ptts => new vec4(_storage[2], _storage[1], _storage[1], _storage[0]);
  vec4 get pttt => new vec4(_storage[2], _storage[1], _storage[1], _storage[1]);
  vec4 get pttp => new vec4(_storage[2], _storage[1], _storage[1], _storage[2]);
  vec4 get pttq => new vec4(_storage[2], _storage[1], _storage[1], _storage[3]);
  vec4 get ptps => new vec4(_storage[2], _storage[1], _storage[2], _storage[0]);
  vec4 get ptpt => new vec4(_storage[2], _storage[1], _storage[2], _storage[1]);
  vec4 get ptpp => new vec4(_storage[2], _storage[1], _storage[2], _storage[2]);
  vec4 get ptpq => new vec4(_storage[2], _storage[1], _storage[2], _storage[3]);
  vec4 get ptqs => new vec4(_storage[2], _storage[1], _storage[3], _storage[0]);
  vec4 get ptqt => new vec4(_storage[2], _storage[1], _storage[3], _storage[1]);
  vec4 get ptqp => new vec4(_storage[2], _storage[1], _storage[3], _storage[2]);
  vec4 get ptqq => new vec4(_storage[2], _storage[1], _storage[3], _storage[3]);
  vec4 get ppss => new vec4(_storage[2], _storage[2], _storage[0], _storage[0]);
  vec4 get ppst => new vec4(_storage[2], _storage[2], _storage[0], _storage[1]);
  vec4 get ppsp => new vec4(_storage[2], _storage[2], _storage[0], _storage[2]);
  vec4 get ppsq => new vec4(_storage[2], _storage[2], _storage[0], _storage[3]);
  vec4 get ppts => new vec4(_storage[2], _storage[2], _storage[1], _storage[0]);
  vec4 get pptt => new vec4(_storage[2], _storage[2], _storage[1], _storage[1]);
  vec4 get pptp => new vec4(_storage[2], _storage[2], _storage[1], _storage[2]);
  vec4 get pptq => new vec4(_storage[2], _storage[2], _storage[1], _storage[3]);
  vec4 get ppps => new vec4(_storage[2], _storage[2], _storage[2], _storage[0]);
  vec4 get pppt => new vec4(_storage[2], _storage[2], _storage[2], _storage[1]);
  vec4 get pppp => new vec4(_storage[2], _storage[2], _storage[2], _storage[2]);
  vec4 get pppq => new vec4(_storage[2], _storage[2], _storage[2], _storage[3]);
  vec4 get ppqs => new vec4(_storage[2], _storage[2], _storage[3], _storage[0]);
  vec4 get ppqt => new vec4(_storage[2], _storage[2], _storage[3], _storage[1]);
  vec4 get ppqp => new vec4(_storage[2], _storage[2], _storage[3], _storage[2]);
  vec4 get ppqq => new vec4(_storage[2], _storage[2], _storage[3], _storage[3]);
  vec4 get pqss => new vec4(_storage[2], _storage[3], _storage[0], _storage[0]);
  vec4 get pqst => new vec4(_storage[2], _storage[3], _storage[0], _storage[1]);
  vec4 get pqsp => new vec4(_storage[2], _storage[3], _storage[0], _storage[2]);
  vec4 get pqsq => new vec4(_storage[2], _storage[3], _storage[0], _storage[3]);
  vec4 get pqts => new vec4(_storage[2], _storage[3], _storage[1], _storage[0]);
  vec4 get pqtt => new vec4(_storage[2], _storage[3], _storage[1], _storage[1]);
  vec4 get pqtp => new vec4(_storage[2], _storage[3], _storage[1], _storage[2]);
  vec4 get pqtq => new vec4(_storage[2], _storage[3], _storage[1], _storage[3]);
  vec4 get pqps => new vec4(_storage[2], _storage[3], _storage[2], _storage[0]);
  vec4 get pqpt => new vec4(_storage[2], _storage[3], _storage[2], _storage[1]);
  vec4 get pqpp => new vec4(_storage[2], _storage[3], _storage[2], _storage[2]);
  vec4 get pqpq => new vec4(_storage[2], _storage[3], _storage[2], _storage[3]);
  vec4 get pqqs => new vec4(_storage[2], _storage[3], _storage[3], _storage[0]);
  vec4 get pqqt => new vec4(_storage[2], _storage[3], _storage[3], _storage[1]);
  vec4 get pqqp => new vec4(_storage[2], _storage[3], _storage[3], _storage[2]);
  vec4 get pqqq => new vec4(_storage[2], _storage[3], _storage[3], _storage[3]);
  vec4 get qsss => new vec4(_storage[3], _storage[0], _storage[0], _storage[0]);
  vec4 get qsst => new vec4(_storage[3], _storage[0], _storage[0], _storage[1]);
  vec4 get qssp => new vec4(_storage[3], _storage[0], _storage[0], _storage[2]);
  vec4 get qssq => new vec4(_storage[3], _storage[0], _storage[0], _storage[3]);
  vec4 get qsts => new vec4(_storage[3], _storage[0], _storage[1], _storage[0]);
  vec4 get qstt => new vec4(_storage[3], _storage[0], _storage[1], _storage[1]);
  vec4 get qstp => new vec4(_storage[3], _storage[0], _storage[1], _storage[2]);
  vec4 get qstq => new vec4(_storage[3], _storage[0], _storage[1], _storage[3]);
  vec4 get qsps => new vec4(_storage[3], _storage[0], _storage[2], _storage[0]);
  vec4 get qspt => new vec4(_storage[3], _storage[0], _storage[2], _storage[1]);
  vec4 get qspp => new vec4(_storage[3], _storage[0], _storage[2], _storage[2]);
  vec4 get qspq => new vec4(_storage[3], _storage[0], _storage[2], _storage[3]);
  vec4 get qsqs => new vec4(_storage[3], _storage[0], _storage[3], _storage[0]);
  vec4 get qsqt => new vec4(_storage[3], _storage[0], _storage[3], _storage[1]);
  vec4 get qsqp => new vec4(_storage[3], _storage[0], _storage[3], _storage[2]);
  vec4 get qsqq => new vec4(_storage[3], _storage[0], _storage[3], _storage[3]);
  vec4 get qtss => new vec4(_storage[3], _storage[1], _storage[0], _storage[0]);
  vec4 get qtst => new vec4(_storage[3], _storage[1], _storage[0], _storage[1]);
  vec4 get qtsp => new vec4(_storage[3], _storage[1], _storage[0], _storage[2]);
  vec4 get qtsq => new vec4(_storage[3], _storage[1], _storage[0], _storage[3]);
  vec4 get qtts => new vec4(_storage[3], _storage[1], _storage[1], _storage[0]);
  vec4 get qttt => new vec4(_storage[3], _storage[1], _storage[1], _storage[1]);
  vec4 get qttp => new vec4(_storage[3], _storage[1], _storage[1], _storage[2]);
  vec4 get qttq => new vec4(_storage[3], _storage[1], _storage[1], _storage[3]);
  vec4 get qtps => new vec4(_storage[3], _storage[1], _storage[2], _storage[0]);
  vec4 get qtpt => new vec4(_storage[3], _storage[1], _storage[2], _storage[1]);
  vec4 get qtpp => new vec4(_storage[3], _storage[1], _storage[2], _storage[2]);
  vec4 get qtpq => new vec4(_storage[3], _storage[1], _storage[2], _storage[3]);
  vec4 get qtqs => new vec4(_storage[3], _storage[1], _storage[3], _storage[0]);
  vec4 get qtqt => new vec4(_storage[3], _storage[1], _storage[3], _storage[1]);
  vec4 get qtqp => new vec4(_storage[3], _storage[1], _storage[3], _storage[2]);
  vec4 get qtqq => new vec4(_storage[3], _storage[1], _storage[3], _storage[3]);
  vec4 get qpss => new vec4(_storage[3], _storage[2], _storage[0], _storage[0]);
  vec4 get qpst => new vec4(_storage[3], _storage[2], _storage[0], _storage[1]);
  vec4 get qpsp => new vec4(_storage[3], _storage[2], _storage[0], _storage[2]);
  vec4 get qpsq => new vec4(_storage[3], _storage[2], _storage[0], _storage[3]);
  vec4 get qpts => new vec4(_storage[3], _storage[2], _storage[1], _storage[0]);
  vec4 get qptt => new vec4(_storage[3], _storage[2], _storage[1], _storage[1]);
  vec4 get qptp => new vec4(_storage[3], _storage[2], _storage[1], _storage[2]);
  vec4 get qptq => new vec4(_storage[3], _storage[2], _storage[1], _storage[3]);
  vec4 get qpps => new vec4(_storage[3], _storage[2], _storage[2], _storage[0]);
  vec4 get qppt => new vec4(_storage[3], _storage[2], _storage[2], _storage[1]);
  vec4 get qppp => new vec4(_storage[3], _storage[2], _storage[2], _storage[2]);
  vec4 get qppq => new vec4(_storage[3], _storage[2], _storage[2], _storage[3]);
  vec4 get qpqs => new vec4(_storage[3], _storage[2], _storage[3], _storage[0]);
  vec4 get qpqt => new vec4(_storage[3], _storage[2], _storage[3], _storage[1]);
  vec4 get qpqp => new vec4(_storage[3], _storage[2], _storage[3], _storage[2]);
  vec4 get qpqq => new vec4(_storage[3], _storage[2], _storage[3], _storage[3]);
  vec4 get qqss => new vec4(_storage[3], _storage[3], _storage[0], _storage[0]);
  vec4 get qqst => new vec4(_storage[3], _storage[3], _storage[0], _storage[1]);
  vec4 get qqsp => new vec4(_storage[3], _storage[3], _storage[0], _storage[2]);
  vec4 get qqsq => new vec4(_storage[3], _storage[3], _storage[0], _storage[3]);
  vec4 get qqts => new vec4(_storage[3], _storage[3], _storage[1], _storage[0]);
  vec4 get qqtt => new vec4(_storage[3], _storage[3], _storage[1], _storage[1]);
  vec4 get qqtp => new vec4(_storage[3], _storage[3], _storage[1], _storage[2]);
  vec4 get qqtq => new vec4(_storage[3], _storage[3], _storage[1], _storage[3]);
  vec4 get qqps => new vec4(_storage[3], _storage[3], _storage[2], _storage[0]);
  vec4 get qqpt => new vec4(_storage[3], _storage[3], _storage[2], _storage[1]);
  vec4 get qqpp => new vec4(_storage[3], _storage[3], _storage[2], _storage[2]);
  vec4 get qqpq => new vec4(_storage[3], _storage[3], _storage[2], _storage[3]);
  vec4 get qqqs => new vec4(_storage[3], _storage[3], _storage[3], _storage[0]);
  vec4 get qqqt => new vec4(_storage[3], _storage[3], _storage[3], _storage[1]);
  vec4 get qqqp => new vec4(_storage[3], _storage[3], _storage[3], _storage[2]);
  vec4 get qqqq => new vec4(_storage[3], _storage[3], _storage[3], _storage[3]);
}
