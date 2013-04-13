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

/// 2D vector.
class vec2 {
  final Float32List _storage = new Float32List(2);
  Float32List get storage => _storage;

  /// Vector.
  vec2(double x_, double y_) {
    makeRaw(x_, y_);
  }

  /// Components of [this] are set to the passed in values.
  vec2 makeRaw(double x_, double y_) {
    _storage[0] = x_;
    _storage[1] = y_;
    return this;
  }

  /// Zero vector.
  vec2.zero();

  /// Modify [this] to be the zero vector.
  vec2 makeZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
    return this;
  }

  /// Copy of [other].
  vec2.copy(vec2 other) {
    makeCopy(other);
  }

  /// Modify [this] by copying the values in [other].
  vec2 makeCopy(vec2 other) {
    _storage[1] = other._storage[1];
    _storage[0] = other._storage[0];
    return this;
  }

  /// Initialized with values from [array] starting at [offset].
  vec2.array(List<num> array, [int offset=0]) {
    int i = offset;
    _storage[1] = array[i+1];
    _storage[0] = array[i+0];
  }

  /// Splats a scalar into all lanes of the vector.
  vec2 splat(double arg) {
    _storage[0] = arg;
    _storage[1] = arg;
    return this;
  }

  /// Returns a printable string
  String toString() => '[${_storage[0]},${_storage[1]}]';

  /// Negate.
  vec2 operator-() => new vec2(-_storage[0], -_storage[1]);

  /// Subtract two vectors.
  vec2 operator-(vec2 other) => new vec2(_storage[0] - other._storage[0],
                                         _storage[1] - other._storage[1]);

  /// Add two vectors.
  vec2 operator+(vec2 other) => new vec2(_storage[0] + other._storage[0],
                                         _storage[1] + other._storage[1]);

  /// Returns a copy with each entry divided by [scale].
  vec2 operator/(double scale) {
    var o = 1.0 / scale;
    return new vec2(_storage[0] * o, _storage[1] * o);
  }

  /// Returns a copy with each entry multiplied by [scale].
  vec2 operator*(double scale) {
    var o = scale;
    return new vec2(_storage[0] * o, _storage[1] * o);
  }

  /// Returns an entry from [this].
  double operator[](int i) => _storage[i];

  /// Assigns an entry in [this].
  void operator[]=(int i, double v) { _storage[i] = v; }

  /// Length.
  double get length {
    double sum = 0.0;
    sum += (_storage[0] * _storage[0]);
    sum += (_storage[1] * _storage[1]);
    return Math.sqrt(sum);
  }

  /// Squared length.
  double get length2 {
    double sum = 0.0;
    sum += (_storage[0] * _storage[0]);
    sum += (_storage[1] * _storage[1]);
    return sum;
  }

  /// Normalize [this]. Returns [this].
  vec2 normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    return this;
  }

  /// Normalize [this]. Returns [length].
  double normalizeLength() {
    double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    return l;
  }

  /// Normalizes [this] returns new vector or optional [out]
  vec2 normalized([vec2 out = null]) {
    if (out == null) {
      out = new vec2(_storage[0], _storage[1]);
    }
    double l = out.length;
    if (l == 0.0) {
      return out;
    }
    l = 1.0 / l;
    out._storage[0] *= l;
    out._storage[1] *= l;
    return out;
  }

  /// Returns the dot product of [this] and [other].
  double dot(vec2 other) {
    double sum = 0.0;
    sum += _storage[0] * other._storage[0];
    sum += _storage[1] * other._storage[1];
    return sum;
  }

  /// Returns the cross product of [this] and [other].
  double cross(vec2 other) {
    return _storage[0] * other._storage[1] - _storage[1] * other._storage[0];
  }

  /// Returns the relative error between [this] and [correct]
  double relativeError(vec2 correct) {
    double correct_norm = correct.length;
    double diff_norm = (this - correct).length;
    return diff_norm/correct_norm;
  }

  /// Returns the absolute error between [this] and [correct]
  double absoluteError(vec2 correct) {
    return (this - correct).length;
  }

  /// Returns true if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || _storage[0].isInfinite;
    is_infinite = is_infinite || _storage[1].isInfinite;
    return is_infinite;
  }

  /// Returns true if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || _storage[0].isNaN;
    is_nan = is_nan || _storage[1].isNaN;
    return is_nan;
  }

  /// Add [arg] to [this].
  vec2 add(vec2 arg) {
    _storage[0] = _storage[0] + arg._storage[0];
    _storage[1] = _storage[1] + arg._storage[1];
    return this;
  }

  /// Subtract [arg] from [this].
  vec2 sub(vec2 arg) {
    _storage[0] = _storage[0] - arg._storage[0];
    _storage[1] = _storage[1] - arg._storage[1];
    return this;
  }

  /// Multiply entries in [this] with entries in [arg].
  vec2 multiply(vec2 arg) {
    _storage[0] = _storage[0] * arg._storage[0];
    _storage[1] = _storage[1] * arg._storage[1];
    return this;
  }

  /// Divide entries in [this] with entries in [arg].
  vec2 div(vec2 arg) {
    _storage[0] = _storage[0] / arg._storage[0];
    _storage[1] = _storage[1] / arg._storage[1];
    return this;
  }

  vec2 scale(double arg) {
    _storage[0] = _storage[0] * arg;
    _storage[1] = _storage[1] * arg;
    return this;
  }

  vec2 scaled(num arg) {
    return clone().scale(arg);
  }

  vec2 negate() {
    _storage[1] = -_storage[1];
    _storage[0] = -_storage[0];
    return this;
  }

  vec2 absolute() {
    _storage[1] = -_storage[1].abs();
    _storage[0] = -_storage[0].abs();
    return this;
  }

  vec2 clone() {
    return new vec2.copy(this);
  }

  vec2 copyInto(vec2 arg) {
    arg._storage[0] = _storage[0];
    arg._storage[1] = _storage[1];
    return arg;
  }

  vec2 copyFrom(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    return this;
  }

  vec2 setComponents(double x_, double y_) {
    _storage[0] = x_;
    _storage[1] = y_;
    return this;
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset=0]) {
    int i = offset;
    array[i+0] = _storage[0];
    array[i+1] = _storage[1];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset=0]) {
    int i = offset;
    _storage[0] = array[i+0];
    i++;
    _storage[1] = array[i+1];
    i++;
  }

  set xy(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set yx(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set r(double arg) => _storage[0] = arg;
  set g(double arg) => _storage[1] = arg;
  set s(double arg) => _storage[0] = arg;
  set t(double arg) => _storage[1] = arg;
  set x(double arg) => _storage[0] = arg;
  set y(double arg) => _storage[1] = arg;
  set rg(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set gr(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  set st(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
  }
  set ts(vec2 arg) {
    _storage[1] = arg._storage[0];
    _storage[0] = arg._storage[1];
  }
  vec2 get xx => new vec2(_storage[0], _storage[0]);
  vec2 get xy => new vec2(_storage[0], _storage[1]);
  vec2 get yx => new vec2(_storage[1], _storage[0]);
  vec2 get yy => new vec2(_storage[1], _storage[1]);
  vec3 get xxx => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get xxy => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get xyx => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get xyy => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get yxx => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get yxy => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get yyx => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get yyy => new vec3(_storage[1], _storage[1], _storage[1]);
  vec4 get xxxx => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get xxxy => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get xxyx => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get xxyy => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get xyxx => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get xyxy => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get xyyx => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get xyyy => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get yxxx => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get yxxy => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get yxyx => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get yxyy => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get yyxx => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get yyxy => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get yyyx => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get yyyy => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  double get r => _storage[0];
  double get g => _storage[1];
  double get s => _storage[0];
  double get t => _storage[1];
  double get x => _storage[0];
  double get y => _storage[1];
  vec2 get rr => new vec2(_storage[0], _storage[0]);
  vec2 get rg => new vec2(_storage[0], _storage[1]);
  vec2 get gr => new vec2(_storage[1], _storage[0]);
  vec2 get gg => new vec2(_storage[1], _storage[1]);
  vec3 get rrr => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get rrg => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get rgr => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get rgg => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get grr => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get grg => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get ggr => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get ggg => new vec3(_storage[1], _storage[1], _storage[1]);
  vec4 get rrrr => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get rrrg => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get rrgr => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get rrgg => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get rgrr => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get rgrg => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get rggr => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get rggg => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get grrr => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get grrg => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get grgr => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get grgg => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get ggrr => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get ggrg => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get gggr => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get gggg => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
  vec2 get ss => new vec2(_storage[0], _storage[0]);
  vec2 get st => new vec2(_storage[0], _storage[1]);
  vec2 get ts => new vec2(_storage[1], _storage[0]);
  vec2 get tt => new vec2(_storage[1], _storage[1]);
  vec3 get sss => new vec3(_storage[0], _storage[0], _storage[0]);
  vec3 get sst => new vec3(_storage[0], _storage[0], _storage[1]);
  vec3 get sts => new vec3(_storage[0], _storage[1], _storage[0]);
  vec3 get stt => new vec3(_storage[0], _storage[1], _storage[1]);
  vec3 get tss => new vec3(_storage[1], _storage[0], _storage[0]);
  vec3 get tst => new vec3(_storage[1], _storage[0], _storage[1]);
  vec3 get tts => new vec3(_storage[1], _storage[1], _storage[0]);
  vec3 get ttt => new vec3(_storage[1], _storage[1], _storage[1]);
  vec4 get ssss => new vec4(_storage[0], _storage[0], _storage[0], _storage[0]);
  vec4 get ssst => new vec4(_storage[0], _storage[0], _storage[0], _storage[1]);
  vec4 get ssts => new vec4(_storage[0], _storage[0], _storage[1], _storage[0]);
  vec4 get sstt => new vec4(_storage[0], _storage[0], _storage[1], _storage[1]);
  vec4 get stss => new vec4(_storage[0], _storage[1], _storage[0], _storage[0]);
  vec4 get stst => new vec4(_storage[0], _storage[1], _storage[0], _storage[1]);
  vec4 get stts => new vec4(_storage[0], _storage[1], _storage[1], _storage[0]);
  vec4 get sttt => new vec4(_storage[0], _storage[1], _storage[1], _storage[1]);
  vec4 get tsss => new vec4(_storage[1], _storage[0], _storage[0], _storage[0]);
  vec4 get tsst => new vec4(_storage[1], _storage[0], _storage[0], _storage[1]);
  vec4 get tsts => new vec4(_storage[1], _storage[0], _storage[1], _storage[0]);
  vec4 get tstt => new vec4(_storage[1], _storage[0], _storage[1], _storage[1]);
  vec4 get ttss => new vec4(_storage[1], _storage[1], _storage[0], _storage[0]);
  vec4 get ttst => new vec4(_storage[1], _storage[1], _storage[0], _storage[1]);
  vec4 get ttts => new vec4(_storage[1], _storage[1], _storage[1], _storage[0]);
  vec4 get tttt => new vec4(_storage[1], _storage[1], _storage[1], _storage[1]);
}
