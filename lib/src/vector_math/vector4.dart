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
class Vector4 {
  final Float32List storage = new Float32List(4);

  /// Set the values of [result] to the minimum of [a] and [b] for each line.
  static void min(Vector4 a, Vector4 b, Vector4 result) {
    result.x = Math.min(a.x, b.x);
    result.y = Math.min(a.y, b.y);
    result.z = Math.min(a.z, b.z);
    result.w = Math.min(a.w, b.w);
  }

  /// Set the values of [result] to the maximum of [a] and [b] for each line.
  static void max(Vector4 a, Vector4 b, Vector4 result) {
    result.x = Math.max(a.x, b.x);
    result.y = Math.max(a.y, b.y);
    result.z = Math.max(a.z, b.z);
    result.w = Math.max(a.w, b.w);
  }

  /// Constructs a new vector with the specified values.
  Vector4(double x_, double y_, double z_, double w_) {
    setValues(x_, y_, z_, w_);
  }

  /// Initialized with values from [array] starting at [offset].
  Vector4.array(List<double> array, [int offset=0]) {
    int i = offset;
    storage[0] = array[i+0];
    storage[1] = array[i+1];
    storage[2] = array[i+2];
    storage[3] = array[i+3];
  }

  //// Zero vector.
  Vector4.zero();

  /// Constructs the identity vector.
  Vector4.identity() {
    storage[3] = 1.0;
  }

  /// Copy of [other].
  Vector4.copy(Vector4 other) {
    setFrom(other);
  }


  /// Set the values of the vector.
  Vector4 setValues(double x_, double y_, double z_, double w_) {
    storage[3] = w_;
    storage[2] = z_;
    storage[1] = y_;
    storage[0] = x_;
    return this;
  }

  /// Zero the vector.
  Vector4 setZero() {
    storage[0] = 0.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    return this;
  }

  /// Set the values by copying them from [other].
  Vector4 setFrom(Vector4 other) {
    storage[3] = other.storage[3];
    storage[2] = other.storage[2];
    storage[1] = other.storage[1];
    storage[0] = other.storage[0];
    return this;
  }

  /// Splat [arg] into all lanes of the vector.
  Vector4 splat(double arg) {
    storage[3] = arg;
    storage[2] = arg;
    storage[1] = arg;
    storage[0] = arg;
    return this;
  }

  /// Returns a printable string
  String toString() => '${storage[0]},${storage[1]},'
                       '${storage[2]},${storage[3]}';

  /// Negate.
  Vector4 operator-() => new Vector4(-storage[0], -storage[1], -storage[2],
                               -storage[3]);

  /// Subtract two vectors.
  Vector4 operator-(Vector4 other) => new Vector4(storage[0] - other.storage[0],
                                         storage[1] - other.storage[1],
                                         storage[2] - other.storage[2],
                                         storage[3] - other.storage[3]);

  /// Add two vectors.
  Vector4 operator+(Vector4 other) => new Vector4(storage[0] + other.storage[0],
                                         storage[1] + other.storage[1],
                                         storage[2] + other.storage[2],
                                         storage[3] + other.storage[3]);

  /// Scale.
  Vector4 operator/(double scale) {
    var o = 1.0 / scale;
    return new Vector4(storage[0] * o, storage[1] * o, storage[2] * o,
                    storage[3] * o);
  }

  /// Scale.
  Vector4 operator*(double scale) {
    var o = scale;
    return new Vector4(storage[0] * o, storage[1] * o, storage[2] * o,
                    storage[3] * o);
  }

  double operator[](int i) => storage[i];

  void operator[]=(int i, double v) { storage[i] = v; }

  /// Length.
  double get length {
    double sum;
    sum = (storage[0] * storage[0]);
    sum += (storage[1] * storage[1]);
    sum += (storage[2] * storage[2]);
    sum += (storage[3] * storage[3]);
    return Math.sqrt(sum);
  }

  /// Length squared.
  double get length2 {
    double sum;
    sum = (storage[0] * storage[0]);
    sum += (storage[1] * storage[1]);
    sum += (storage[2] * storage[2]);
    sum += (storage[3] * storage[3]);
    return sum;
  }

  /// Normalizes [this].
  Vector4 normalize() {
    double l = length;
    // TODO(johnmccutchan): Use an epsilon.
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    storage[0] *= l;
    storage[1] *= l;
    storage[2] *= l;
    storage[3] *= l;
    return this;
  }

  /// Normalizes [this]. Returns length of vector before normalization.
  double normalizeLength() {
    double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    l = 1.0 / l;
    storage[0] *= l;
    storage[1] *= l;
    storage[2] *= l;
    storage[3] *= l;
    return l;
  }

  /// Normalizes copy of [this].
  Vector4 normalized() {
    return new Vector4.copy(this).normalize();
  }

  /// Normalize vector into [out].
  Vector4 normalizeInto(Vector4 out) {
    out.setFrom(this);
    return out.normalize();
  }

  /// Distance from [this] to [arg]
  double distanceTo(Vector4 arg) {
    return this.clone().sub(arg).length;
  }

  /// Squared distance from [this] to [arg]
  double distanceToSquared(Vector4 arg) {
    return this.clone().sub(arg).length2;
  }

  /// Inner product.
  double dot(Vector4 other) {
    double sum;
    sum = storage[0] * other.storage[0];
    sum += storage[1] * other.storage[1];
    sum += storage[2] * other.storage[2];
    sum += storage[3] * other.storage[3];
    return sum;
  }

  /// Relative error between [this] and [correct]
  double relativeError(Vector4 correct) {
    double correct_norm = correct.length;
    double diff_norm = (this - correct).length;
    return diff_norm/correct_norm;
  }

  /// Absolute error between [this] and [correct]
  double absoluteError(Vector4 correct) {
    return (this - correct).length;
  }

  /// True if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || storage[0].isInfinite;
    is_infinite = is_infinite || storage[1].isInfinite;
    is_infinite = is_infinite || storage[2].isInfinite;
    is_infinite = is_infinite || storage[3].isInfinite;
    return is_infinite;
  }

  /// True if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || storage[0].isNaN;
    is_nan = is_nan || storage[1].isNaN;
    is_nan = is_nan || storage[2].isNaN;
    is_nan = is_nan || storage[3].isNaN;
    return is_nan;
  }

  Vector4 add(Vector4 arg) {
    storage[0] = storage[0] + arg.storage[0];
    storage[1] = storage[1] + arg.storage[1];
    storage[2] = storage[2] + arg.storage[2];
    storage[3] = storage[3] + arg.storage[3];
    return this;
  }

  Vector4 sub(Vector4 arg) {
    storage[0] = storage[0] - arg.storage[0];
    storage[1] = storage[1] - arg.storage[1];
    storage[2] = storage[2] - arg.storage[2];
    storage[3] = storage[3] - arg.storage[3];
    return this;
  }

  Vector4 multiply(Vector4 arg) {
    storage[0] = storage[0] * arg.storage[0];
    storage[1] = storage[1] * arg.storage[1];
    storage[2] = storage[2] * arg.storage[2];
    storage[3] = storage[3] * arg.storage[3];
    return this;
  }

  Vector4 div(Vector4 arg) {
    storage[0] = storage[0] / arg.storage[0];
    storage[1] = storage[1] / arg.storage[1];
    storage[2] = storage[2] / arg.storage[2];
    storage[3] = storage[3] / arg.storage[3];
    return this;
  }

  Vector4 scale(double arg) {
    storage[0] = storage[0] * arg;
    storage[1] = storage[1] * arg;
    storage[2] = storage[2] * arg;
    storage[3] = storage[3] * arg;
    return this;
  }

  Vector4 scaled(double arg) {
    return clone().scale(arg);
  }

  Vector4 negate() {
    storage[0] = -storage[0];
    storage[1] = -storage[1];
    storage[2] = -storage[2];
    storage[3] = -storage[3];
    return this;
  }

  Vector4 absolute() {
    storage[3] = storage[3].abs();
    storage[2] = storage[2].abs();
    storage[1] = storage[1].abs();
    storage[0] = storage[0].abs();
    return this;
  }

  Vector4 clone() {
    return new Vector4.copy(this);
  }

  Vector4 copyInto(Vector4 arg) {
    arg.storage[0] = storage[0];
    arg.storage[1] = storage[1];
    arg.storage[2] = storage[2];
    arg.storage[3] = storage[3];
    return arg;
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset=0]) {
    array[offset+0] = storage[0];
    array[offset+1] = storage[1];
    array[offset+2] = storage[2];
    array[offset+3] = storage[3];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset=0]) {
    storage[0] = array[offset+0];
    storage[1] = array[offset+1];
    storage[2] = array[offset+2];
    storage[3] = array[offset+3];
  }

  set xy(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set xz(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set xw(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set yx(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set yz(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set yw(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set zx(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set zy(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set zw(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set wx(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set wy(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set wz(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set xyz(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set xyw(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set xzy(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set xzw(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set xwy(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set xwz(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set yxz(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set yxw(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set yzx(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set yzw(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set ywx(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set ywz(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set zxy(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set zxw(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set zyx(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set zyw(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set zwx(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set zwy(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set wxy(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set wxz(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set wyx(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set wyz(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set wzx(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set wzy(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set xyzw(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set xywz(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set xzyw(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set xzwy(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set xwyz(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set xwzy(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set yxzw(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set yxwz(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set yzxw(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set yzwx(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set ywxz(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set ywzx(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set zxyw(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set zxwy(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set zyxw(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set zywx(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set zwxy(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set zwyx(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set wxyz(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set wxzy(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set wyxz(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set wyzx(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set wzxy(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set wzyx(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set r(double arg) => storage[0] = arg;
  set g(double arg) => storage[1] = arg;
  set b(double arg) => storage[2] = arg;
  set a(double arg) => storage[3] = arg;
  set s(double arg) => storage[0] = arg;
  set t(double arg) => storage[1] = arg;
  set p(double arg) => storage[2] = arg;
  set q(double arg) => storage[3] = arg;
  set x(double arg) => storage[0] = arg;
  set y(double arg) => storage[1] = arg;
  set z(double arg) => storage[2] = arg;
  set w(double arg) => storage[3] = arg;
  set rg(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set rb(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set ra(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set gr(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set gb(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set ga(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set br(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set bg(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set ba(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set ar(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set ag(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set ab(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set rgb(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set rga(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set rbg(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set rba(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set rag(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set rab(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set grb(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set gra(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set gbr(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set gba(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set gar(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set gab(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set brg(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set bra(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set bgr(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set bga(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set bar(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set bag(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set arg(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set arb(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set agr(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set agb(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set abr(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set abg(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set rgba(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set rgab(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set rbga(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set rbag(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set ragb(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set rabg(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set grba(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set grab(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set gbra(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set gbar(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set garb(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set gabr(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set brga(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set brag(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set bgra(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set bgar(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set barg(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set bagr(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set argb(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set arbg(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set agrb(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set agbr(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set abrg(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set abgr(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set st(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set sp(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set sq(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set ts(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set tp(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set tq(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set ps(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set pt(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set pq(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
  }
  set qs(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set qt(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set qp(Vector2 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set stp(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set stq(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set spt(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set spq(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set sqt(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set sqp(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set tsp(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set tsq(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set tps(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set tpq(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set tqs(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set tqp(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set pst(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set psq(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set pts(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set ptq(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
  }
  set pqs(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set pqt(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set qst(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set qsp(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set qts(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set qtp(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set qps(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set qpt(Vector3 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set stpq(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set stqp(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set sptq(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set spqt(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set sqtp(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set sqpt(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set tspq(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set tsqp(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set tpsq(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set tpqs(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set tqsp(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set tqps(Vector4 arg) {
    storage[1] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set pstq(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set psqt(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set ptsq(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[3] = arg.storage[3];
  }
  set ptqs(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[3] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set pqst(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set pqts(Vector4 arg) {
    storage[2] = arg.storage[0];
    storage[3] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set qstp(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set qspt(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set qtsp(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[2] = arg.storage[3];
  }
  set qtps(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  set qpst(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
    storage[1] = arg.storage[3];
  }
  set qpts(Vector4 arg) {
    storage[3] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
    storage[0] = arg.storage[3];
  }
  Vector2 get xx => new Vector2(storage[0], storage[0]);
  Vector2 get xy => new Vector2(storage[0], storage[1]);
  Vector2 get xz => new Vector2(storage[0], storage[2]);
  Vector2 get xw => new Vector2(storage[0], storage[3]);
  Vector2 get yx => new Vector2(storage[1], storage[0]);
  Vector2 get yy => new Vector2(storage[1], storage[1]);
  Vector2 get yz => new Vector2(storage[1], storage[2]);
  Vector2 get yw => new Vector2(storage[1], storage[3]);
  Vector2 get zx => new Vector2(storage[2], storage[0]);
  Vector2 get zy => new Vector2(storage[2], storage[1]);
  Vector2 get zz => new Vector2(storage[2], storage[2]);
  Vector2 get zw => new Vector2(storage[2], storage[3]);
  Vector2 get wx => new Vector2(storage[3], storage[0]);
  Vector2 get wy => new Vector2(storage[3], storage[1]);
  Vector2 get wz => new Vector2(storage[3], storage[2]);
  Vector2 get ww => new Vector2(storage[3], storage[3]);
  Vector3 get xxx => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get xxy => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get xxz => new Vector3(storage[0], storage[0], storage[2]);
  Vector3 get xxw => new Vector3(storage[0], storage[0], storage[3]);
  Vector3 get xyx => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get xyy => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get xyz => new Vector3(storage[0], storage[1], storage[2]);
  Vector3 get xyw => new Vector3(storage[0], storage[1], storage[3]);
  Vector3 get xzx => new Vector3(storage[0], storage[2], storage[0]);
  Vector3 get xzy => new Vector3(storage[0], storage[2], storage[1]);
  Vector3 get xzz => new Vector3(storage[0], storage[2], storage[2]);
  Vector3 get xzw => new Vector3(storage[0], storage[2], storage[3]);
  Vector3 get xwx => new Vector3(storage[0], storage[3], storage[0]);
  Vector3 get xwy => new Vector3(storage[0], storage[3], storage[1]);
  Vector3 get xwz => new Vector3(storage[0], storage[3], storage[2]);
  Vector3 get xww => new Vector3(storage[0], storage[3], storage[3]);
  Vector3 get yxx => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get yxy => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get yxz => new Vector3(storage[1], storage[0], storage[2]);
  Vector3 get yxw => new Vector3(storage[1], storage[0], storage[3]);
  Vector3 get yyx => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get yyy => new Vector3(storage[1], storage[1], storage[1]);
  Vector3 get yyz => new Vector3(storage[1], storage[1], storage[2]);
  Vector3 get yyw => new Vector3(storage[1], storage[1], storage[3]);
  Vector3 get yzx => new Vector3(storage[1], storage[2], storage[0]);
  Vector3 get yzy => new Vector3(storage[1], storage[2], storage[1]);
  Vector3 get yzz => new Vector3(storage[1], storage[2], storage[2]);
  Vector3 get yzw => new Vector3(storage[1], storage[2], storage[3]);
  Vector3 get ywx => new Vector3(storage[1], storage[3], storage[0]);
  Vector3 get ywy => new Vector3(storage[1], storage[3], storage[1]);
  Vector3 get ywz => new Vector3(storage[1], storage[3], storage[2]);
  Vector3 get yww => new Vector3(storage[1], storage[3], storage[3]);
  Vector3 get zxx => new Vector3(storage[2], storage[0], storage[0]);
  Vector3 get zxy => new Vector3(storage[2], storage[0], storage[1]);
  Vector3 get zxz => new Vector3(storage[2], storage[0], storage[2]);
  Vector3 get zxw => new Vector3(storage[2], storage[0], storage[3]);
  Vector3 get zyx => new Vector3(storage[2], storage[1], storage[0]);
  Vector3 get zyy => new Vector3(storage[2], storage[1], storage[1]);
  Vector3 get zyz => new Vector3(storage[2], storage[1], storage[2]);
  Vector3 get zyw => new Vector3(storage[2], storage[1], storage[3]);
  Vector3 get zzx => new Vector3(storage[2], storage[2], storage[0]);
  Vector3 get zzy => new Vector3(storage[2], storage[2], storage[1]);
  Vector3 get zzz => new Vector3(storage[2], storage[2], storage[2]);
  Vector3 get zzw => new Vector3(storage[2], storage[2], storage[3]);
  Vector3 get zwx => new Vector3(storage[2], storage[3], storage[0]);
  Vector3 get zwy => new Vector3(storage[2], storage[3], storage[1]);
  Vector3 get zwz => new Vector3(storage[2], storage[3], storage[2]);
  Vector3 get zww => new Vector3(storage[2], storage[3], storage[3]);
  Vector3 get wxx => new Vector3(storage[3], storage[0], storage[0]);
  Vector3 get wxy => new Vector3(storage[3], storage[0], storage[1]);
  Vector3 get wxz => new Vector3(storage[3], storage[0], storage[2]);
  Vector3 get wxw => new Vector3(storage[3], storage[0], storage[3]);
  Vector3 get wyx => new Vector3(storage[3], storage[1], storage[0]);
  Vector3 get wyy => new Vector3(storage[3], storage[1], storage[1]);
  Vector3 get wyz => new Vector3(storage[3], storage[1], storage[2]);
  Vector3 get wyw => new Vector3(storage[3], storage[1], storage[3]);
  Vector3 get wzx => new Vector3(storage[3], storage[2], storage[0]);
  Vector3 get wzy => new Vector3(storage[3], storage[2], storage[1]);
  Vector3 get wzz => new Vector3(storage[3], storage[2], storage[2]);
  Vector3 get wzw => new Vector3(storage[3], storage[2], storage[3]);
  Vector3 get wwx => new Vector3(storage[3], storage[3], storage[0]);
  Vector3 get wwy => new Vector3(storage[3], storage[3], storage[1]);
  Vector3 get wwz => new Vector3(storage[3], storage[3], storage[2]);
  Vector3 get www => new Vector3(storage[3], storage[3], storage[3]);
  Vector4 get xxxx => new Vector4(storage[0], storage[0], storage[0], storage[0]);
  Vector4 get xxxy => new Vector4(storage[0], storage[0], storage[0], storage[1]);
  Vector4 get xxxz => new Vector4(storage[0], storage[0], storage[0], storage[2]);
  Vector4 get xxxw => new Vector4(storage[0], storage[0], storage[0], storage[3]);
  Vector4 get xxyx => new Vector4(storage[0], storage[0], storage[1], storage[0]);
  Vector4 get xxyy => new Vector4(storage[0], storage[0], storage[1], storage[1]);
  Vector4 get xxyz => new Vector4(storage[0], storage[0], storage[1], storage[2]);
  Vector4 get xxyw => new Vector4(storage[0], storage[0], storage[1], storage[3]);
  Vector4 get xxzx => new Vector4(storage[0], storage[0], storage[2], storage[0]);
  Vector4 get xxzy => new Vector4(storage[0], storage[0], storage[2], storage[1]);
  Vector4 get xxzz => new Vector4(storage[0], storage[0], storage[2], storage[2]);
  Vector4 get xxzw => new Vector4(storage[0], storage[0], storage[2], storage[3]);
  Vector4 get xxwx => new Vector4(storage[0], storage[0], storage[3], storage[0]);
  Vector4 get xxwy => new Vector4(storage[0], storage[0], storage[3], storage[1]);
  Vector4 get xxwz => new Vector4(storage[0], storage[0], storage[3], storage[2]);
  Vector4 get xxww => new Vector4(storage[0], storage[0], storage[3], storage[3]);
  Vector4 get xyxx => new Vector4(storage[0], storage[1], storage[0], storage[0]);
  Vector4 get xyxy => new Vector4(storage[0], storage[1], storage[0], storage[1]);
  Vector4 get xyxz => new Vector4(storage[0], storage[1], storage[0], storage[2]);
  Vector4 get xyxw => new Vector4(storage[0], storage[1], storage[0], storage[3]);
  Vector4 get xyyx => new Vector4(storage[0], storage[1], storage[1], storage[0]);
  Vector4 get xyyy => new Vector4(storage[0], storage[1], storage[1], storage[1]);
  Vector4 get xyyz => new Vector4(storage[0], storage[1], storage[1], storage[2]);
  Vector4 get xyyw => new Vector4(storage[0], storage[1], storage[1], storage[3]);
  Vector4 get xyzx => new Vector4(storage[0], storage[1], storage[2], storage[0]);
  Vector4 get xyzy => new Vector4(storage[0], storage[1], storage[2], storage[1]);
  Vector4 get xyzz => new Vector4(storage[0], storage[1], storage[2], storage[2]);
  Vector4 get xyzw => new Vector4(storage[0], storage[1], storage[2], storage[3]);
  Vector4 get xywx => new Vector4(storage[0], storage[1], storage[3], storage[0]);
  Vector4 get xywy => new Vector4(storage[0], storage[1], storage[3], storage[1]);
  Vector4 get xywz => new Vector4(storage[0], storage[1], storage[3], storage[2]);
  Vector4 get xyww => new Vector4(storage[0], storage[1], storage[3], storage[3]);
  Vector4 get xzxx => new Vector4(storage[0], storage[2], storage[0], storage[0]);
  Vector4 get xzxy => new Vector4(storage[0], storage[2], storage[0], storage[1]);
  Vector4 get xzxz => new Vector4(storage[0], storage[2], storage[0], storage[2]);
  Vector4 get xzxw => new Vector4(storage[0], storage[2], storage[0], storage[3]);
  Vector4 get xzyx => new Vector4(storage[0], storage[2], storage[1], storage[0]);
  Vector4 get xzyy => new Vector4(storage[0], storage[2], storage[1], storage[1]);
  Vector4 get xzyz => new Vector4(storage[0], storage[2], storage[1], storage[2]);
  Vector4 get xzyw => new Vector4(storage[0], storage[2], storage[1], storage[3]);
  Vector4 get xzzx => new Vector4(storage[0], storage[2], storage[2], storage[0]);
  Vector4 get xzzy => new Vector4(storage[0], storage[2], storage[2], storage[1]);
  Vector4 get xzzz => new Vector4(storage[0], storage[2], storage[2], storage[2]);
  Vector4 get xzzw => new Vector4(storage[0], storage[2], storage[2], storage[3]);
  Vector4 get xzwx => new Vector4(storage[0], storage[2], storage[3], storage[0]);
  Vector4 get xzwy => new Vector4(storage[0], storage[2], storage[3], storage[1]);
  Vector4 get xzwz => new Vector4(storage[0], storage[2], storage[3], storage[2]);
  Vector4 get xzww => new Vector4(storage[0], storage[2], storage[3], storage[3]);
  Vector4 get xwxx => new Vector4(storage[0], storage[3], storage[0], storage[0]);
  Vector4 get xwxy => new Vector4(storage[0], storage[3], storage[0], storage[1]);
  Vector4 get xwxz => new Vector4(storage[0], storage[3], storage[0], storage[2]);
  Vector4 get xwxw => new Vector4(storage[0], storage[3], storage[0], storage[3]);
  Vector4 get xwyx => new Vector4(storage[0], storage[3], storage[1], storage[0]);
  Vector4 get xwyy => new Vector4(storage[0], storage[3], storage[1], storage[1]);
  Vector4 get xwyz => new Vector4(storage[0], storage[3], storage[1], storage[2]);
  Vector4 get xwyw => new Vector4(storage[0], storage[3], storage[1], storage[3]);
  Vector4 get xwzx => new Vector4(storage[0], storage[3], storage[2], storage[0]);
  Vector4 get xwzy => new Vector4(storage[0], storage[3], storage[2], storage[1]);
  Vector4 get xwzz => new Vector4(storage[0], storage[3], storage[2], storage[2]);
  Vector4 get xwzw => new Vector4(storage[0], storage[3], storage[2], storage[3]);
  Vector4 get xwwx => new Vector4(storage[0], storage[3], storage[3], storage[0]);
  Vector4 get xwwy => new Vector4(storage[0], storage[3], storage[3], storage[1]);
  Vector4 get xwwz => new Vector4(storage[0], storage[3], storage[3], storage[2]);
  Vector4 get xwww => new Vector4(storage[0], storage[3], storage[3], storage[3]);
  Vector4 get yxxx => new Vector4(storage[1], storage[0], storage[0], storage[0]);
  Vector4 get yxxy => new Vector4(storage[1], storage[0], storage[0], storage[1]);
  Vector4 get yxxz => new Vector4(storage[1], storage[0], storage[0], storage[2]);
  Vector4 get yxxw => new Vector4(storage[1], storage[0], storage[0], storage[3]);
  Vector4 get yxyx => new Vector4(storage[1], storage[0], storage[1], storage[0]);
  Vector4 get yxyy => new Vector4(storage[1], storage[0], storage[1], storage[1]);
  Vector4 get yxyz => new Vector4(storage[1], storage[0], storage[1], storage[2]);
  Vector4 get yxyw => new Vector4(storage[1], storage[0], storage[1], storage[3]);
  Vector4 get yxzx => new Vector4(storage[1], storage[0], storage[2], storage[0]);
  Vector4 get yxzy => new Vector4(storage[1], storage[0], storage[2], storage[1]);
  Vector4 get yxzz => new Vector4(storage[1], storage[0], storage[2], storage[2]);
  Vector4 get yxzw => new Vector4(storage[1], storage[0], storage[2], storage[3]);
  Vector4 get yxwx => new Vector4(storage[1], storage[0], storage[3], storage[0]);
  Vector4 get yxwy => new Vector4(storage[1], storage[0], storage[3], storage[1]);
  Vector4 get yxwz => new Vector4(storage[1], storage[0], storage[3], storage[2]);
  Vector4 get yxww => new Vector4(storage[1], storage[0], storage[3], storage[3]);
  Vector4 get yyxx => new Vector4(storage[1], storage[1], storage[0], storage[0]);
  Vector4 get yyxy => new Vector4(storage[1], storage[1], storage[0], storage[1]);
  Vector4 get yyxz => new Vector4(storage[1], storage[1], storage[0], storage[2]);
  Vector4 get yyxw => new Vector4(storage[1], storage[1], storage[0], storage[3]);
  Vector4 get yyyx => new Vector4(storage[1], storage[1], storage[1], storage[0]);
  Vector4 get yyyy => new Vector4(storage[1], storage[1], storage[1], storage[1]);
  Vector4 get yyyz => new Vector4(storage[1], storage[1], storage[1], storage[2]);
  Vector4 get yyyw => new Vector4(storage[1], storage[1], storage[1], storage[3]);
  Vector4 get yyzx => new Vector4(storage[1], storage[1], storage[2], storage[0]);
  Vector4 get yyzy => new Vector4(storage[1], storage[1], storage[2], storage[1]);
  Vector4 get yyzz => new Vector4(storage[1], storage[1], storage[2], storage[2]);
  Vector4 get yyzw => new Vector4(storage[1], storage[1], storage[2], storage[3]);
  Vector4 get yywx => new Vector4(storage[1], storage[1], storage[3], storage[0]);
  Vector4 get yywy => new Vector4(storage[1], storage[1], storage[3], storage[1]);
  Vector4 get yywz => new Vector4(storage[1], storage[1], storage[3], storage[2]);
  Vector4 get yyww => new Vector4(storage[1], storage[1], storage[3], storage[3]);
  Vector4 get yzxx => new Vector4(storage[1], storage[2], storage[0], storage[0]);
  Vector4 get yzxy => new Vector4(storage[1], storage[2], storage[0], storage[1]);
  Vector4 get yzxz => new Vector4(storage[1], storage[2], storage[0], storage[2]);
  Vector4 get yzxw => new Vector4(storage[1], storage[2], storage[0], storage[3]);
  Vector4 get yzyx => new Vector4(storage[1], storage[2], storage[1], storage[0]);
  Vector4 get yzyy => new Vector4(storage[1], storage[2], storage[1], storage[1]);
  Vector4 get yzyz => new Vector4(storage[1], storage[2], storage[1], storage[2]);
  Vector4 get yzyw => new Vector4(storage[1], storage[2], storage[1], storage[3]);
  Vector4 get yzzx => new Vector4(storage[1], storage[2], storage[2], storage[0]);
  Vector4 get yzzy => new Vector4(storage[1], storage[2], storage[2], storage[1]);
  Vector4 get yzzz => new Vector4(storage[1], storage[2], storage[2], storage[2]);
  Vector4 get yzzw => new Vector4(storage[1], storage[2], storage[2], storage[3]);
  Vector4 get yzwx => new Vector4(storage[1], storage[2], storage[3], storage[0]);
  Vector4 get yzwy => new Vector4(storage[1], storage[2], storage[3], storage[1]);
  Vector4 get yzwz => new Vector4(storage[1], storage[2], storage[3], storage[2]);
  Vector4 get yzww => new Vector4(storage[1], storage[2], storage[3], storage[3]);
  Vector4 get ywxx => new Vector4(storage[1], storage[3], storage[0], storage[0]);
  Vector4 get ywxy => new Vector4(storage[1], storage[3], storage[0], storage[1]);
  Vector4 get ywxz => new Vector4(storage[1], storage[3], storage[0], storage[2]);
  Vector4 get ywxw => new Vector4(storage[1], storage[3], storage[0], storage[3]);
  Vector4 get ywyx => new Vector4(storage[1], storage[3], storage[1], storage[0]);
  Vector4 get ywyy => new Vector4(storage[1], storage[3], storage[1], storage[1]);
  Vector4 get ywyz => new Vector4(storage[1], storage[3], storage[1], storage[2]);
  Vector4 get ywyw => new Vector4(storage[1], storage[3], storage[1], storage[3]);
  Vector4 get ywzx => new Vector4(storage[1], storage[3], storage[2], storage[0]);
  Vector4 get ywzy => new Vector4(storage[1], storage[3], storage[2], storage[1]);
  Vector4 get ywzz => new Vector4(storage[1], storage[3], storage[2], storage[2]);
  Vector4 get ywzw => new Vector4(storage[1], storage[3], storage[2], storage[3]);
  Vector4 get ywwx => new Vector4(storage[1], storage[3], storage[3], storage[0]);
  Vector4 get ywwy => new Vector4(storage[1], storage[3], storage[3], storage[1]);
  Vector4 get ywwz => new Vector4(storage[1], storage[3], storage[3], storage[2]);
  Vector4 get ywww => new Vector4(storage[1], storage[3], storage[3], storage[3]);
  Vector4 get zxxx => new Vector4(storage[2], storage[0], storage[0], storage[0]);
  Vector4 get zxxy => new Vector4(storage[2], storage[0], storage[0], storage[1]);
  Vector4 get zxxz => new Vector4(storage[2], storage[0], storage[0], storage[2]);
  Vector4 get zxxw => new Vector4(storage[2], storage[0], storage[0], storage[3]);
  Vector4 get zxyx => new Vector4(storage[2], storage[0], storage[1], storage[0]);
  Vector4 get zxyy => new Vector4(storage[2], storage[0], storage[1], storage[1]);
  Vector4 get zxyz => new Vector4(storage[2], storage[0], storage[1], storage[2]);
  Vector4 get zxyw => new Vector4(storage[2], storage[0], storage[1], storage[3]);
  Vector4 get zxzx => new Vector4(storage[2], storage[0], storage[2], storage[0]);
  Vector4 get zxzy => new Vector4(storage[2], storage[0], storage[2], storage[1]);
  Vector4 get zxzz => new Vector4(storage[2], storage[0], storage[2], storage[2]);
  Vector4 get zxzw => new Vector4(storage[2], storage[0], storage[2], storage[3]);
  Vector4 get zxwx => new Vector4(storage[2], storage[0], storage[3], storage[0]);
  Vector4 get zxwy => new Vector4(storage[2], storage[0], storage[3], storage[1]);
  Vector4 get zxwz => new Vector4(storage[2], storage[0], storage[3], storage[2]);
  Vector4 get zxww => new Vector4(storage[2], storage[0], storage[3], storage[3]);
  Vector4 get zyxx => new Vector4(storage[2], storage[1], storage[0], storage[0]);
  Vector4 get zyxy => new Vector4(storage[2], storage[1], storage[0], storage[1]);
  Vector4 get zyxz => new Vector4(storage[2], storage[1], storage[0], storage[2]);
  Vector4 get zyxw => new Vector4(storage[2], storage[1], storage[0], storage[3]);
  Vector4 get zyyx => new Vector4(storage[2], storage[1], storage[1], storage[0]);
  Vector4 get zyyy => new Vector4(storage[2], storage[1], storage[1], storage[1]);
  Vector4 get zyyz => new Vector4(storage[2], storage[1], storage[1], storage[2]);
  Vector4 get zyyw => new Vector4(storage[2], storage[1], storage[1], storage[3]);
  Vector4 get zyzx => new Vector4(storage[2], storage[1], storage[2], storage[0]);
  Vector4 get zyzy => new Vector4(storage[2], storage[1], storage[2], storage[1]);
  Vector4 get zyzz => new Vector4(storage[2], storage[1], storage[2], storage[2]);
  Vector4 get zyzw => new Vector4(storage[2], storage[1], storage[2], storage[3]);
  Vector4 get zywx => new Vector4(storage[2], storage[1], storage[3], storage[0]);
  Vector4 get zywy => new Vector4(storage[2], storage[1], storage[3], storage[1]);
  Vector4 get zywz => new Vector4(storage[2], storage[1], storage[3], storage[2]);
  Vector4 get zyww => new Vector4(storage[2], storage[1], storage[3], storage[3]);
  Vector4 get zzxx => new Vector4(storage[2], storage[2], storage[0], storage[0]);
  Vector4 get zzxy => new Vector4(storage[2], storage[2], storage[0], storage[1]);
  Vector4 get zzxz => new Vector4(storage[2], storage[2], storage[0], storage[2]);
  Vector4 get zzxw => new Vector4(storage[2], storage[2], storage[0], storage[3]);
  Vector4 get zzyx => new Vector4(storage[2], storage[2], storage[1], storage[0]);
  Vector4 get zzyy => new Vector4(storage[2], storage[2], storage[1], storage[1]);
  Vector4 get zzyz => new Vector4(storage[2], storage[2], storage[1], storage[2]);
  Vector4 get zzyw => new Vector4(storage[2], storage[2], storage[1], storage[3]);
  Vector4 get zzzx => new Vector4(storage[2], storage[2], storage[2], storage[0]);
  Vector4 get zzzy => new Vector4(storage[2], storage[2], storage[2], storage[1]);
  Vector4 get zzzz => new Vector4(storage[2], storage[2], storage[2], storage[2]);
  Vector4 get zzzw => new Vector4(storage[2], storage[2], storage[2], storage[3]);
  Vector4 get zzwx => new Vector4(storage[2], storage[2], storage[3], storage[0]);
  Vector4 get zzwy => new Vector4(storage[2], storage[2], storage[3], storage[1]);
  Vector4 get zzwz => new Vector4(storage[2], storage[2], storage[3], storage[2]);
  Vector4 get zzww => new Vector4(storage[2], storage[2], storage[3], storage[3]);
  Vector4 get zwxx => new Vector4(storage[2], storage[3], storage[0], storage[0]);
  Vector4 get zwxy => new Vector4(storage[2], storage[3], storage[0], storage[1]);
  Vector4 get zwxz => new Vector4(storage[2], storage[3], storage[0], storage[2]);
  Vector4 get zwxw => new Vector4(storage[2], storage[3], storage[0], storage[3]);
  Vector4 get zwyx => new Vector4(storage[2], storage[3], storage[1], storage[0]);
  Vector4 get zwyy => new Vector4(storage[2], storage[3], storage[1], storage[1]);
  Vector4 get zwyz => new Vector4(storage[2], storage[3], storage[1], storage[2]);
  Vector4 get zwyw => new Vector4(storage[2], storage[3], storage[1], storage[3]);
  Vector4 get zwzx => new Vector4(storage[2], storage[3], storage[2], storage[0]);
  Vector4 get zwzy => new Vector4(storage[2], storage[3], storage[2], storage[1]);
  Vector4 get zwzz => new Vector4(storage[2], storage[3], storage[2], storage[2]);
  Vector4 get zwzw => new Vector4(storage[2], storage[3], storage[2], storage[3]);
  Vector4 get zwwx => new Vector4(storage[2], storage[3], storage[3], storage[0]);
  Vector4 get zwwy => new Vector4(storage[2], storage[3], storage[3], storage[1]);
  Vector4 get zwwz => new Vector4(storage[2], storage[3], storage[3], storage[2]);
  Vector4 get zwww => new Vector4(storage[2], storage[3], storage[3], storage[3]);
  Vector4 get wxxx => new Vector4(storage[3], storage[0], storage[0], storage[0]);
  Vector4 get wxxy => new Vector4(storage[3], storage[0], storage[0], storage[1]);
  Vector4 get wxxz => new Vector4(storage[3], storage[0], storage[0], storage[2]);
  Vector4 get wxxw => new Vector4(storage[3], storage[0], storage[0], storage[3]);
  Vector4 get wxyx => new Vector4(storage[3], storage[0], storage[1], storage[0]);
  Vector4 get wxyy => new Vector4(storage[3], storage[0], storage[1], storage[1]);
  Vector4 get wxyz => new Vector4(storage[3], storage[0], storage[1], storage[2]);
  Vector4 get wxyw => new Vector4(storage[3], storage[0], storage[1], storage[3]);
  Vector4 get wxzx => new Vector4(storage[3], storage[0], storage[2], storage[0]);
  Vector4 get wxzy => new Vector4(storage[3], storage[0], storage[2], storage[1]);
  Vector4 get wxzz => new Vector4(storage[3], storage[0], storage[2], storage[2]);
  Vector4 get wxzw => new Vector4(storage[3], storage[0], storage[2], storage[3]);
  Vector4 get wxwx => new Vector4(storage[3], storage[0], storage[3], storage[0]);
  Vector4 get wxwy => new Vector4(storage[3], storage[0], storage[3], storage[1]);
  Vector4 get wxwz => new Vector4(storage[3], storage[0], storage[3], storage[2]);
  Vector4 get wxww => new Vector4(storage[3], storage[0], storage[3], storage[3]);
  Vector4 get wyxx => new Vector4(storage[3], storage[1], storage[0], storage[0]);
  Vector4 get wyxy => new Vector4(storage[3], storage[1], storage[0], storage[1]);
  Vector4 get wyxz => new Vector4(storage[3], storage[1], storage[0], storage[2]);
  Vector4 get wyxw => new Vector4(storage[3], storage[1], storage[0], storage[3]);
  Vector4 get wyyx => new Vector4(storage[3], storage[1], storage[1], storage[0]);
  Vector4 get wyyy => new Vector4(storage[3], storage[1], storage[1], storage[1]);
  Vector4 get wyyz => new Vector4(storage[3], storage[1], storage[1], storage[2]);
  Vector4 get wyyw => new Vector4(storage[3], storage[1], storage[1], storage[3]);
  Vector4 get wyzx => new Vector4(storage[3], storage[1], storage[2], storage[0]);
  Vector4 get wyzy => new Vector4(storage[3], storage[1], storage[2], storage[1]);
  Vector4 get wyzz => new Vector4(storage[3], storage[1], storage[2], storage[2]);
  Vector4 get wyzw => new Vector4(storage[3], storage[1], storage[2], storage[3]);
  Vector4 get wywx => new Vector4(storage[3], storage[1], storage[3], storage[0]);
  Vector4 get wywy => new Vector4(storage[3], storage[1], storage[3], storage[1]);
  Vector4 get wywz => new Vector4(storage[3], storage[1], storage[3], storage[2]);
  Vector4 get wyww => new Vector4(storage[3], storage[1], storage[3], storage[3]);
  Vector4 get wzxx => new Vector4(storage[3], storage[2], storage[0], storage[0]);
  Vector4 get wzxy => new Vector4(storage[3], storage[2], storage[0], storage[1]);
  Vector4 get wzxz => new Vector4(storage[3], storage[2], storage[0], storage[2]);
  Vector4 get wzxw => new Vector4(storage[3], storage[2], storage[0], storage[3]);
  Vector4 get wzyx => new Vector4(storage[3], storage[2], storage[1], storage[0]);
  Vector4 get wzyy => new Vector4(storage[3], storage[2], storage[1], storage[1]);
  Vector4 get wzyz => new Vector4(storage[3], storage[2], storage[1], storage[2]);
  Vector4 get wzyw => new Vector4(storage[3], storage[2], storage[1], storage[3]);
  Vector4 get wzzx => new Vector4(storage[3], storage[2], storage[2], storage[0]);
  Vector4 get wzzy => new Vector4(storage[3], storage[2], storage[2], storage[1]);
  Vector4 get wzzz => new Vector4(storage[3], storage[2], storage[2], storage[2]);
  Vector4 get wzzw => new Vector4(storage[3], storage[2], storage[2], storage[3]);
  Vector4 get wzwx => new Vector4(storage[3], storage[2], storage[3], storage[0]);
  Vector4 get wzwy => new Vector4(storage[3], storage[2], storage[3], storage[1]);
  Vector4 get wzwz => new Vector4(storage[3], storage[2], storage[3], storage[2]);
  Vector4 get wzww => new Vector4(storage[3], storage[2], storage[3], storage[3]);
  Vector4 get wwxx => new Vector4(storage[3], storage[3], storage[0], storage[0]);
  Vector4 get wwxy => new Vector4(storage[3], storage[3], storage[0], storage[1]);
  Vector4 get wwxz => new Vector4(storage[3], storage[3], storage[0], storage[2]);
  Vector4 get wwxw => new Vector4(storage[3], storage[3], storage[0], storage[3]);
  Vector4 get wwyx => new Vector4(storage[3], storage[3], storage[1], storage[0]);
  Vector4 get wwyy => new Vector4(storage[3], storage[3], storage[1], storage[1]);
  Vector4 get wwyz => new Vector4(storage[3], storage[3], storage[1], storage[2]);
  Vector4 get wwyw => new Vector4(storage[3], storage[3], storage[1], storage[3]);
  Vector4 get wwzx => new Vector4(storage[3], storage[3], storage[2], storage[0]);
  Vector4 get wwzy => new Vector4(storage[3], storage[3], storage[2], storage[1]);
  Vector4 get wwzz => new Vector4(storage[3], storage[3], storage[2], storage[2]);
  Vector4 get wwzw => new Vector4(storage[3], storage[3], storage[2], storage[3]);
  Vector4 get wwwx => new Vector4(storage[3], storage[3], storage[3], storage[0]);
  Vector4 get wwwy => new Vector4(storage[3], storage[3], storage[3], storage[1]);
  Vector4 get wwwz => new Vector4(storage[3], storage[3], storage[3], storage[2]);
  Vector4 get wwww => new Vector4(storage[3], storage[3], storage[3], storage[3]);
  double get r => storage[0];
  double get g => storage[1];
  double get b => storage[2];
  double get a => storage[3];
  double get s => storage[0];
  double get t => storage[1];
  double get p => storage[2];
  double get q => storage[3];
  double get x => storage[0];
  double get y => storage[1];
  double get z => storage[2];
  double get w => storage[3];
  Vector2 get rr => new Vector2(storage[0], storage[0]);
  Vector2 get rg => new Vector2(storage[0], storage[1]);
  Vector2 get rb => new Vector2(storage[0], storage[2]);
  Vector2 get ra => new Vector2(storage[0], storage[3]);
  Vector2 get gr => new Vector2(storage[1], storage[0]);
  Vector2 get gg => new Vector2(storage[1], storage[1]);
  Vector2 get gb => new Vector2(storage[1], storage[2]);
  Vector2 get ga => new Vector2(storage[1], storage[3]);
  Vector2 get br => new Vector2(storage[2], storage[0]);
  Vector2 get bg => new Vector2(storage[2], storage[1]);
  Vector2 get bb => new Vector2(storage[2], storage[2]);
  Vector2 get ba => new Vector2(storage[2], storage[3]);
  Vector2 get ar => new Vector2(storage[3], storage[0]);
  Vector2 get ag => new Vector2(storage[3], storage[1]);
  Vector2 get ab => new Vector2(storage[3], storage[2]);
  Vector2 get aa => new Vector2(storage[3], storage[3]);
  Vector3 get rrr => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get rrg => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get rrb => new Vector3(storage[0], storage[0], storage[2]);
  Vector3 get rra => new Vector3(storage[0], storage[0], storage[3]);
  Vector3 get rgr => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get rgg => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get rgb => new Vector3(storage[0], storage[1], storage[2]);
  Vector3 get rga => new Vector3(storage[0], storage[1], storage[3]);
  Vector3 get rbr => new Vector3(storage[0], storage[2], storage[0]);
  Vector3 get rbg => new Vector3(storage[0], storage[2], storage[1]);
  Vector3 get rbb => new Vector3(storage[0], storage[2], storage[2]);
  Vector3 get rba => new Vector3(storage[0], storage[2], storage[3]);
  Vector3 get rar => new Vector3(storage[0], storage[3], storage[0]);
  Vector3 get rag => new Vector3(storage[0], storage[3], storage[1]);
  Vector3 get rab => new Vector3(storage[0], storage[3], storage[2]);
  Vector3 get raa => new Vector3(storage[0], storage[3], storage[3]);
  Vector3 get grr => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get grg => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get grb => new Vector3(storage[1], storage[0], storage[2]);
  Vector3 get gra => new Vector3(storage[1], storage[0], storage[3]);
  Vector3 get ggr => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get ggg => new Vector3(storage[1], storage[1], storage[1]);
  Vector3 get ggb => new Vector3(storage[1], storage[1], storage[2]);
  Vector3 get gga => new Vector3(storage[1], storage[1], storage[3]);
  Vector3 get gbr => new Vector3(storage[1], storage[2], storage[0]);
  Vector3 get gbg => new Vector3(storage[1], storage[2], storage[1]);
  Vector3 get gbb => new Vector3(storage[1], storage[2], storage[2]);
  Vector3 get gba => new Vector3(storage[1], storage[2], storage[3]);
  Vector3 get gar => new Vector3(storage[1], storage[3], storage[0]);
  Vector3 get gag => new Vector3(storage[1], storage[3], storage[1]);
  Vector3 get gab => new Vector3(storage[1], storage[3], storage[2]);
  Vector3 get gaa => new Vector3(storage[1], storage[3], storage[3]);
  Vector3 get brr => new Vector3(storage[2], storage[0], storage[0]);
  Vector3 get brg => new Vector3(storage[2], storage[0], storage[1]);
  Vector3 get brb => new Vector3(storage[2], storage[0], storage[2]);
  Vector3 get bra => new Vector3(storage[2], storage[0], storage[3]);
  Vector3 get bgr => new Vector3(storage[2], storage[1], storage[0]);
  Vector3 get bgg => new Vector3(storage[2], storage[1], storage[1]);
  Vector3 get bgb => new Vector3(storage[2], storage[1], storage[2]);
  Vector3 get bga => new Vector3(storage[2], storage[1], storage[3]);
  Vector3 get bbr => new Vector3(storage[2], storage[2], storage[0]);
  Vector3 get bbg => new Vector3(storage[2], storage[2], storage[1]);
  Vector3 get bbb => new Vector3(storage[2], storage[2], storage[2]);
  Vector3 get bba => new Vector3(storage[2], storage[2], storage[3]);
  Vector3 get bar => new Vector3(storage[2], storage[3], storage[0]);
  Vector3 get bag => new Vector3(storage[2], storage[3], storage[1]);
  Vector3 get bab => new Vector3(storage[2], storage[3], storage[2]);
  Vector3 get baa => new Vector3(storage[2], storage[3], storage[3]);
  Vector3 get arr => new Vector3(storage[3], storage[0], storage[0]);
  Vector3 get arg => new Vector3(storage[3], storage[0], storage[1]);
  Vector3 get arb => new Vector3(storage[3], storage[0], storage[2]);
  Vector3 get ara => new Vector3(storage[3], storage[0], storage[3]);
  Vector3 get agr => new Vector3(storage[3], storage[1], storage[0]);
  Vector3 get agg => new Vector3(storage[3], storage[1], storage[1]);
  Vector3 get agb => new Vector3(storage[3], storage[1], storage[2]);
  Vector3 get aga => new Vector3(storage[3], storage[1], storage[3]);
  Vector3 get abr => new Vector3(storage[3], storage[2], storage[0]);
  Vector3 get abg => new Vector3(storage[3], storage[2], storage[1]);
  Vector3 get abb => new Vector3(storage[3], storage[2], storage[2]);
  Vector3 get aba => new Vector3(storage[3], storage[2], storage[3]);
  Vector3 get aar => new Vector3(storage[3], storage[3], storage[0]);
  Vector3 get aag => new Vector3(storage[3], storage[3], storage[1]);
  Vector3 get aab => new Vector3(storage[3], storage[3], storage[2]);
  Vector3 get aaa => new Vector3(storage[3], storage[3], storage[3]);
  Vector4 get rrrr => new Vector4(storage[0], storage[0], storage[0], storage[0]);
  Vector4 get rrrg => new Vector4(storage[0], storage[0], storage[0], storage[1]);
  Vector4 get rrrb => new Vector4(storage[0], storage[0], storage[0], storage[2]);
  Vector4 get rrra => new Vector4(storage[0], storage[0], storage[0], storage[3]);
  Vector4 get rrgr => new Vector4(storage[0], storage[0], storage[1], storage[0]);
  Vector4 get rrgg => new Vector4(storage[0], storage[0], storage[1], storage[1]);
  Vector4 get rrgb => new Vector4(storage[0], storage[0], storage[1], storage[2]);
  Vector4 get rrga => new Vector4(storage[0], storage[0], storage[1], storage[3]);
  Vector4 get rrbr => new Vector4(storage[0], storage[0], storage[2], storage[0]);
  Vector4 get rrbg => new Vector4(storage[0], storage[0], storage[2], storage[1]);
  Vector4 get rrbb => new Vector4(storage[0], storage[0], storage[2], storage[2]);
  Vector4 get rrba => new Vector4(storage[0], storage[0], storage[2], storage[3]);
  Vector4 get rrar => new Vector4(storage[0], storage[0], storage[3], storage[0]);
  Vector4 get rrag => new Vector4(storage[0], storage[0], storage[3], storage[1]);
  Vector4 get rrab => new Vector4(storage[0], storage[0], storage[3], storage[2]);
  Vector4 get rraa => new Vector4(storage[0], storage[0], storage[3], storage[3]);
  Vector4 get rgrr => new Vector4(storage[0], storage[1], storage[0], storage[0]);
  Vector4 get rgrg => new Vector4(storage[0], storage[1], storage[0], storage[1]);
  Vector4 get rgrb => new Vector4(storage[0], storage[1], storage[0], storage[2]);
  Vector4 get rgra => new Vector4(storage[0], storage[1], storage[0], storage[3]);
  Vector4 get rggr => new Vector4(storage[0], storage[1], storage[1], storage[0]);
  Vector4 get rggg => new Vector4(storage[0], storage[1], storage[1], storage[1]);
  Vector4 get rggb => new Vector4(storage[0], storage[1], storage[1], storage[2]);
  Vector4 get rgga => new Vector4(storage[0], storage[1], storage[1], storage[3]);
  Vector4 get rgbr => new Vector4(storage[0], storage[1], storage[2], storage[0]);
  Vector4 get rgbg => new Vector4(storage[0], storage[1], storage[2], storage[1]);
  Vector4 get rgbb => new Vector4(storage[0], storage[1], storage[2], storage[2]);
  Vector4 get rgba => new Vector4(storage[0], storage[1], storage[2], storage[3]);
  Vector4 get rgar => new Vector4(storage[0], storage[1], storage[3], storage[0]);
  Vector4 get rgag => new Vector4(storage[0], storage[1], storage[3], storage[1]);
  Vector4 get rgab => new Vector4(storage[0], storage[1], storage[3], storage[2]);
  Vector4 get rgaa => new Vector4(storage[0], storage[1], storage[3], storage[3]);
  Vector4 get rbrr => new Vector4(storage[0], storage[2], storage[0], storage[0]);
  Vector4 get rbrg => new Vector4(storage[0], storage[2], storage[0], storage[1]);
  Vector4 get rbrb => new Vector4(storage[0], storage[2], storage[0], storage[2]);
  Vector4 get rbra => new Vector4(storage[0], storage[2], storage[0], storage[3]);
  Vector4 get rbgr => new Vector4(storage[0], storage[2], storage[1], storage[0]);
  Vector4 get rbgg => new Vector4(storage[0], storage[2], storage[1], storage[1]);
  Vector4 get rbgb => new Vector4(storage[0], storage[2], storage[1], storage[2]);
  Vector4 get rbga => new Vector4(storage[0], storage[2], storage[1], storage[3]);
  Vector4 get rbbr => new Vector4(storage[0], storage[2], storage[2], storage[0]);
  Vector4 get rbbg => new Vector4(storage[0], storage[2], storage[2], storage[1]);
  Vector4 get rbbb => new Vector4(storage[0], storage[2], storage[2], storage[2]);
  Vector4 get rbba => new Vector4(storage[0], storage[2], storage[2], storage[3]);
  Vector4 get rbar => new Vector4(storage[0], storage[2], storage[3], storage[0]);
  Vector4 get rbag => new Vector4(storage[0], storage[2], storage[3], storage[1]);
  Vector4 get rbab => new Vector4(storage[0], storage[2], storage[3], storage[2]);
  Vector4 get rbaa => new Vector4(storage[0], storage[2], storage[3], storage[3]);
  Vector4 get rarr => new Vector4(storage[0], storage[3], storage[0], storage[0]);
  Vector4 get rarg => new Vector4(storage[0], storage[3], storage[0], storage[1]);
  Vector4 get rarb => new Vector4(storage[0], storage[3], storage[0], storage[2]);
  Vector4 get rara => new Vector4(storage[0], storage[3], storage[0], storage[3]);
  Vector4 get ragr => new Vector4(storage[0], storage[3], storage[1], storage[0]);
  Vector4 get ragg => new Vector4(storage[0], storage[3], storage[1], storage[1]);
  Vector4 get ragb => new Vector4(storage[0], storage[3], storage[1], storage[2]);
  Vector4 get raga => new Vector4(storage[0], storage[3], storage[1], storage[3]);
  Vector4 get rabr => new Vector4(storage[0], storage[3], storage[2], storage[0]);
  Vector4 get rabg => new Vector4(storage[0], storage[3], storage[2], storage[1]);
  Vector4 get rabb => new Vector4(storage[0], storage[3], storage[2], storage[2]);
  Vector4 get raba => new Vector4(storage[0], storage[3], storage[2], storage[3]);
  Vector4 get raar => new Vector4(storage[0], storage[3], storage[3], storage[0]);
  Vector4 get raag => new Vector4(storage[0], storage[3], storage[3], storage[1]);
  Vector4 get raab => new Vector4(storage[0], storage[3], storage[3], storage[2]);
  Vector4 get raaa => new Vector4(storage[0], storage[3], storage[3], storage[3]);
  Vector4 get grrr => new Vector4(storage[1], storage[0], storage[0], storage[0]);
  Vector4 get grrg => new Vector4(storage[1], storage[0], storage[0], storage[1]);
  Vector4 get grrb => new Vector4(storage[1], storage[0], storage[0], storage[2]);
  Vector4 get grra => new Vector4(storage[1], storage[0], storage[0], storage[3]);
  Vector4 get grgr => new Vector4(storage[1], storage[0], storage[1], storage[0]);
  Vector4 get grgg => new Vector4(storage[1], storage[0], storage[1], storage[1]);
  Vector4 get grgb => new Vector4(storage[1], storage[0], storage[1], storage[2]);
  Vector4 get grga => new Vector4(storage[1], storage[0], storage[1], storage[3]);
  Vector4 get grbr => new Vector4(storage[1], storage[0], storage[2], storage[0]);
  Vector4 get grbg => new Vector4(storage[1], storage[0], storage[2], storage[1]);
  Vector4 get grbb => new Vector4(storage[1], storage[0], storage[2], storage[2]);
  Vector4 get grba => new Vector4(storage[1], storage[0], storage[2], storage[3]);
  Vector4 get grar => new Vector4(storage[1], storage[0], storage[3], storage[0]);
  Vector4 get grag => new Vector4(storage[1], storage[0], storage[3], storage[1]);
  Vector4 get grab => new Vector4(storage[1], storage[0], storage[3], storage[2]);
  Vector4 get graa => new Vector4(storage[1], storage[0], storage[3], storage[3]);
  Vector4 get ggrr => new Vector4(storage[1], storage[1], storage[0], storage[0]);
  Vector4 get ggrg => new Vector4(storage[1], storage[1], storage[0], storage[1]);
  Vector4 get ggrb => new Vector4(storage[1], storage[1], storage[0], storage[2]);
  Vector4 get ggra => new Vector4(storage[1], storage[1], storage[0], storage[3]);
  Vector4 get gggr => new Vector4(storage[1], storage[1], storage[1], storage[0]);
  Vector4 get gggg => new Vector4(storage[1], storage[1], storage[1], storage[1]);
  Vector4 get gggb => new Vector4(storage[1], storage[1], storage[1], storage[2]);
  Vector4 get ggga => new Vector4(storage[1], storage[1], storage[1], storage[3]);
  Vector4 get ggbr => new Vector4(storage[1], storage[1], storage[2], storage[0]);
  Vector4 get ggbg => new Vector4(storage[1], storage[1], storage[2], storage[1]);
  Vector4 get ggbb => new Vector4(storage[1], storage[1], storage[2], storage[2]);
  Vector4 get ggba => new Vector4(storage[1], storage[1], storage[2], storage[3]);
  Vector4 get ggar => new Vector4(storage[1], storage[1], storage[3], storage[0]);
  Vector4 get ggag => new Vector4(storage[1], storage[1], storage[3], storage[1]);
  Vector4 get ggab => new Vector4(storage[1], storage[1], storage[3], storage[2]);
  Vector4 get ggaa => new Vector4(storage[1], storage[1], storage[3], storage[3]);
  Vector4 get gbrr => new Vector4(storage[1], storage[2], storage[0], storage[0]);
  Vector4 get gbrg => new Vector4(storage[1], storage[2], storage[0], storage[1]);
  Vector4 get gbrb => new Vector4(storage[1], storage[2], storage[0], storage[2]);
  Vector4 get gbra => new Vector4(storage[1], storage[2], storage[0], storage[3]);
  Vector4 get gbgr => new Vector4(storage[1], storage[2], storage[1], storage[0]);
  Vector4 get gbgg => new Vector4(storage[1], storage[2], storage[1], storage[1]);
  Vector4 get gbgb => new Vector4(storage[1], storage[2], storage[1], storage[2]);
  Vector4 get gbga => new Vector4(storage[1], storage[2], storage[1], storage[3]);
  Vector4 get gbbr => new Vector4(storage[1], storage[2], storage[2], storage[0]);
  Vector4 get gbbg => new Vector4(storage[1], storage[2], storage[2], storage[1]);
  Vector4 get gbbb => new Vector4(storage[1], storage[2], storage[2], storage[2]);
  Vector4 get gbba => new Vector4(storage[1], storage[2], storage[2], storage[3]);
  Vector4 get gbar => new Vector4(storage[1], storage[2], storage[3], storage[0]);
  Vector4 get gbag => new Vector4(storage[1], storage[2], storage[3], storage[1]);
  Vector4 get gbab => new Vector4(storage[1], storage[2], storage[3], storage[2]);
  Vector4 get gbaa => new Vector4(storage[1], storage[2], storage[3], storage[3]);
  Vector4 get garr => new Vector4(storage[1], storage[3], storage[0], storage[0]);
  Vector4 get garg => new Vector4(storage[1], storage[3], storage[0], storage[1]);
  Vector4 get garb => new Vector4(storage[1], storage[3], storage[0], storage[2]);
  Vector4 get gara => new Vector4(storage[1], storage[3], storage[0], storage[3]);
  Vector4 get gagr => new Vector4(storage[1], storage[3], storage[1], storage[0]);
  Vector4 get gagg => new Vector4(storage[1], storage[3], storage[1], storage[1]);
  Vector4 get gagb => new Vector4(storage[1], storage[3], storage[1], storage[2]);
  Vector4 get gaga => new Vector4(storage[1], storage[3], storage[1], storage[3]);
  Vector4 get gabr => new Vector4(storage[1], storage[3], storage[2], storage[0]);
  Vector4 get gabg => new Vector4(storage[1], storage[3], storage[2], storage[1]);
  Vector4 get gabb => new Vector4(storage[1], storage[3], storage[2], storage[2]);
  Vector4 get gaba => new Vector4(storage[1], storage[3], storage[2], storage[3]);
  Vector4 get gaar => new Vector4(storage[1], storage[3], storage[3], storage[0]);
  Vector4 get gaag => new Vector4(storage[1], storage[3], storage[3], storage[1]);
  Vector4 get gaab => new Vector4(storage[1], storage[3], storage[3], storage[2]);
  Vector4 get gaaa => new Vector4(storage[1], storage[3], storage[3], storage[3]);
  Vector4 get brrr => new Vector4(storage[2], storage[0], storage[0], storage[0]);
  Vector4 get brrg => new Vector4(storage[2], storage[0], storage[0], storage[1]);
  Vector4 get brrb => new Vector4(storage[2], storage[0], storage[0], storage[2]);
  Vector4 get brra => new Vector4(storage[2], storage[0], storage[0], storage[3]);
  Vector4 get brgr => new Vector4(storage[2], storage[0], storage[1], storage[0]);
  Vector4 get brgg => new Vector4(storage[2], storage[0], storage[1], storage[1]);
  Vector4 get brgb => new Vector4(storage[2], storage[0], storage[1], storage[2]);
  Vector4 get brga => new Vector4(storage[2], storage[0], storage[1], storage[3]);
  Vector4 get brbr => new Vector4(storage[2], storage[0], storage[2], storage[0]);
  Vector4 get brbg => new Vector4(storage[2], storage[0], storage[2], storage[1]);
  Vector4 get brbb => new Vector4(storage[2], storage[0], storage[2], storage[2]);
  Vector4 get brba => new Vector4(storage[2], storage[0], storage[2], storage[3]);
  Vector4 get brar => new Vector4(storage[2], storage[0], storage[3], storage[0]);
  Vector4 get brag => new Vector4(storage[2], storage[0], storage[3], storage[1]);
  Vector4 get brab => new Vector4(storage[2], storage[0], storage[3], storage[2]);
  Vector4 get braa => new Vector4(storage[2], storage[0], storage[3], storage[3]);
  Vector4 get bgrr => new Vector4(storage[2], storage[1], storage[0], storage[0]);
  Vector4 get bgrg => new Vector4(storage[2], storage[1], storage[0], storage[1]);
  Vector4 get bgrb => new Vector4(storage[2], storage[1], storage[0], storage[2]);
  Vector4 get bgra => new Vector4(storage[2], storage[1], storage[0], storage[3]);
  Vector4 get bggr => new Vector4(storage[2], storage[1], storage[1], storage[0]);
  Vector4 get bggg => new Vector4(storage[2], storage[1], storage[1], storage[1]);
  Vector4 get bggb => new Vector4(storage[2], storage[1], storage[1], storage[2]);
  Vector4 get bgga => new Vector4(storage[2], storage[1], storage[1], storage[3]);
  Vector4 get bgbr => new Vector4(storage[2], storage[1], storage[2], storage[0]);
  Vector4 get bgbg => new Vector4(storage[2], storage[1], storage[2], storage[1]);
  Vector4 get bgbb => new Vector4(storage[2], storage[1], storage[2], storage[2]);
  Vector4 get bgba => new Vector4(storage[2], storage[1], storage[2], storage[3]);
  Vector4 get bgar => new Vector4(storage[2], storage[1], storage[3], storage[0]);
  Vector4 get bgag => new Vector4(storage[2], storage[1], storage[3], storage[1]);
  Vector4 get bgab => new Vector4(storage[2], storage[1], storage[3], storage[2]);
  Vector4 get bgaa => new Vector4(storage[2], storage[1], storage[3], storage[3]);
  Vector4 get bbrr => new Vector4(storage[2], storage[2], storage[0], storage[0]);
  Vector4 get bbrg => new Vector4(storage[2], storage[2], storage[0], storage[1]);
  Vector4 get bbrb => new Vector4(storage[2], storage[2], storage[0], storage[2]);
  Vector4 get bbra => new Vector4(storage[2], storage[2], storage[0], storage[3]);
  Vector4 get bbgr => new Vector4(storage[2], storage[2], storage[1], storage[0]);
  Vector4 get bbgg => new Vector4(storage[2], storage[2], storage[1], storage[1]);
  Vector4 get bbgb => new Vector4(storage[2], storage[2], storage[1], storage[2]);
  Vector4 get bbga => new Vector4(storage[2], storage[2], storage[1], storage[3]);
  Vector4 get bbbr => new Vector4(storage[2], storage[2], storage[2], storage[0]);
  Vector4 get bbbg => new Vector4(storage[2], storage[2], storage[2], storage[1]);
  Vector4 get bbbb => new Vector4(storage[2], storage[2], storage[2], storage[2]);
  Vector4 get bbba => new Vector4(storage[2], storage[2], storage[2], storage[3]);
  Vector4 get bbar => new Vector4(storage[2], storage[2], storage[3], storage[0]);
  Vector4 get bbag => new Vector4(storage[2], storage[2], storage[3], storage[1]);
  Vector4 get bbab => new Vector4(storage[2], storage[2], storage[3], storage[2]);
  Vector4 get bbaa => new Vector4(storage[2], storage[2], storage[3], storage[3]);
  Vector4 get barr => new Vector4(storage[2], storage[3], storage[0], storage[0]);
  Vector4 get barg => new Vector4(storage[2], storage[3], storage[0], storage[1]);
  Vector4 get barb => new Vector4(storage[2], storage[3], storage[0], storage[2]);
  Vector4 get bara => new Vector4(storage[2], storage[3], storage[0], storage[3]);
  Vector4 get bagr => new Vector4(storage[2], storage[3], storage[1], storage[0]);
  Vector4 get bagg => new Vector4(storage[2], storage[3], storage[1], storage[1]);
  Vector4 get bagb => new Vector4(storage[2], storage[3], storage[1], storage[2]);
  Vector4 get baga => new Vector4(storage[2], storage[3], storage[1], storage[3]);
  Vector4 get babr => new Vector4(storage[2], storage[3], storage[2], storage[0]);
  Vector4 get babg => new Vector4(storage[2], storage[3], storage[2], storage[1]);
  Vector4 get babb => new Vector4(storage[2], storage[3], storage[2], storage[2]);
  Vector4 get baba => new Vector4(storage[2], storage[3], storage[2], storage[3]);
  Vector4 get baar => new Vector4(storage[2], storage[3], storage[3], storage[0]);
  Vector4 get baag => new Vector4(storage[2], storage[3], storage[3], storage[1]);
  Vector4 get baab => new Vector4(storage[2], storage[3], storage[3], storage[2]);
  Vector4 get baaa => new Vector4(storage[2], storage[3], storage[3], storage[3]);
  Vector4 get arrr => new Vector4(storage[3], storage[0], storage[0], storage[0]);
  Vector4 get arrg => new Vector4(storage[3], storage[0], storage[0], storage[1]);
  Vector4 get arrb => new Vector4(storage[3], storage[0], storage[0], storage[2]);
  Vector4 get arra => new Vector4(storage[3], storage[0], storage[0], storage[3]);
  Vector4 get argr => new Vector4(storage[3], storage[0], storage[1], storage[0]);
  Vector4 get argg => new Vector4(storage[3], storage[0], storage[1], storage[1]);
  Vector4 get argb => new Vector4(storage[3], storage[0], storage[1], storage[2]);
  Vector4 get arga => new Vector4(storage[3], storage[0], storage[1], storage[3]);
  Vector4 get arbr => new Vector4(storage[3], storage[0], storage[2], storage[0]);
  Vector4 get arbg => new Vector4(storage[3], storage[0], storage[2], storage[1]);
  Vector4 get arbb => new Vector4(storage[3], storage[0], storage[2], storage[2]);
  Vector4 get arba => new Vector4(storage[3], storage[0], storage[2], storage[3]);
  Vector4 get arar => new Vector4(storage[3], storage[0], storage[3], storage[0]);
  Vector4 get arag => new Vector4(storage[3], storage[0], storage[3], storage[1]);
  Vector4 get arab => new Vector4(storage[3], storage[0], storage[3], storage[2]);
  Vector4 get araa => new Vector4(storage[3], storage[0], storage[3], storage[3]);
  Vector4 get agrr => new Vector4(storage[3], storage[1], storage[0], storage[0]);
  Vector4 get agrg => new Vector4(storage[3], storage[1], storage[0], storage[1]);
  Vector4 get agrb => new Vector4(storage[3], storage[1], storage[0], storage[2]);
  Vector4 get agra => new Vector4(storage[3], storage[1], storage[0], storage[3]);
  Vector4 get aggr => new Vector4(storage[3], storage[1], storage[1], storage[0]);
  Vector4 get aggg => new Vector4(storage[3], storage[1], storage[1], storage[1]);
  Vector4 get aggb => new Vector4(storage[3], storage[1], storage[1], storage[2]);
  Vector4 get agga => new Vector4(storage[3], storage[1], storage[1], storage[3]);
  Vector4 get agbr => new Vector4(storage[3], storage[1], storage[2], storage[0]);
  Vector4 get agbg => new Vector4(storage[3], storage[1], storage[2], storage[1]);
  Vector4 get agbb => new Vector4(storage[3], storage[1], storage[2], storage[2]);
  Vector4 get agba => new Vector4(storage[3], storage[1], storage[2], storage[3]);
  Vector4 get agar => new Vector4(storage[3], storage[1], storage[3], storage[0]);
  Vector4 get agag => new Vector4(storage[3], storage[1], storage[3], storage[1]);
  Vector4 get agab => new Vector4(storage[3], storage[1], storage[3], storage[2]);
  Vector4 get agaa => new Vector4(storage[3], storage[1], storage[3], storage[3]);
  Vector4 get abrr => new Vector4(storage[3], storage[2], storage[0], storage[0]);
  Vector4 get abrg => new Vector4(storage[3], storage[2], storage[0], storage[1]);
  Vector4 get abrb => new Vector4(storage[3], storage[2], storage[0], storage[2]);
  Vector4 get abra => new Vector4(storage[3], storage[2], storage[0], storage[3]);
  Vector4 get abgr => new Vector4(storage[3], storage[2], storage[1], storage[0]);
  Vector4 get abgg => new Vector4(storage[3], storage[2], storage[1], storage[1]);
  Vector4 get abgb => new Vector4(storage[3], storage[2], storage[1], storage[2]);
  Vector4 get abga => new Vector4(storage[3], storage[2], storage[1], storage[3]);
  Vector4 get abbr => new Vector4(storage[3], storage[2], storage[2], storage[0]);
  Vector4 get abbg => new Vector4(storage[3], storage[2], storage[2], storage[1]);
  Vector4 get abbb => new Vector4(storage[3], storage[2], storage[2], storage[2]);
  Vector4 get abba => new Vector4(storage[3], storage[2], storage[2], storage[3]);
  Vector4 get abar => new Vector4(storage[3], storage[2], storage[3], storage[0]);
  Vector4 get abag => new Vector4(storage[3], storage[2], storage[3], storage[1]);
  Vector4 get abab => new Vector4(storage[3], storage[2], storage[3], storage[2]);
  Vector4 get abaa => new Vector4(storage[3], storage[2], storage[3], storage[3]);
  Vector4 get aarr => new Vector4(storage[3], storage[3], storage[0], storage[0]);
  Vector4 get aarg => new Vector4(storage[3], storage[3], storage[0], storage[1]);
  Vector4 get aarb => new Vector4(storage[3], storage[3], storage[0], storage[2]);
  Vector4 get aara => new Vector4(storage[3], storage[3], storage[0], storage[3]);
  Vector4 get aagr => new Vector4(storage[3], storage[3], storage[1], storage[0]);
  Vector4 get aagg => new Vector4(storage[3], storage[3], storage[1], storage[1]);
  Vector4 get aagb => new Vector4(storage[3], storage[3], storage[1], storage[2]);
  Vector4 get aaga => new Vector4(storage[3], storage[3], storage[1], storage[3]);
  Vector4 get aabr => new Vector4(storage[3], storage[3], storage[2], storage[0]);
  Vector4 get aabg => new Vector4(storage[3], storage[3], storage[2], storage[1]);
  Vector4 get aabb => new Vector4(storage[3], storage[3], storage[2], storage[2]);
  Vector4 get aaba => new Vector4(storage[3], storage[3], storage[2], storage[3]);
  Vector4 get aaar => new Vector4(storage[3], storage[3], storage[3], storage[0]);
  Vector4 get aaag => new Vector4(storage[3], storage[3], storage[3], storage[1]);
  Vector4 get aaab => new Vector4(storage[3], storage[3], storage[3], storage[2]);
  Vector4 get aaaa => new Vector4(storage[3], storage[3], storage[3], storage[3]);
  Vector2 get ss => new Vector2(storage[0], storage[0]);
  Vector2 get st => new Vector2(storage[0], storage[1]);
  Vector2 get sp => new Vector2(storage[0], storage[2]);
  Vector2 get sq => new Vector2(storage[0], storage[3]);
  Vector2 get ts => new Vector2(storage[1], storage[0]);
  Vector2 get tt => new Vector2(storage[1], storage[1]);
  Vector2 get tp => new Vector2(storage[1], storage[2]);
  Vector2 get tq => new Vector2(storage[1], storage[3]);
  Vector2 get ps => new Vector2(storage[2], storage[0]);
  Vector2 get pt => new Vector2(storage[2], storage[1]);
  Vector2 get pp => new Vector2(storage[2], storage[2]);
  Vector2 get pq => new Vector2(storage[2], storage[3]);
  Vector2 get qs => new Vector2(storage[3], storage[0]);
  Vector2 get qt => new Vector2(storage[3], storage[1]);
  Vector2 get qp => new Vector2(storage[3], storage[2]);
  Vector2 get qq => new Vector2(storage[3], storage[3]);
  Vector3 get sss => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get sst => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get ssp => new Vector3(storage[0], storage[0], storage[2]);
  Vector3 get ssq => new Vector3(storage[0], storage[0], storage[3]);
  Vector3 get sts => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get stt => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get stp => new Vector3(storage[0], storage[1], storage[2]);
  Vector3 get stq => new Vector3(storage[0], storage[1], storage[3]);
  Vector3 get sps => new Vector3(storage[0], storage[2], storage[0]);
  Vector3 get spt => new Vector3(storage[0], storage[2], storage[1]);
  Vector3 get spp => new Vector3(storage[0], storage[2], storage[2]);
  Vector3 get spq => new Vector3(storage[0], storage[2], storage[3]);
  Vector3 get sqs => new Vector3(storage[0], storage[3], storage[0]);
  Vector3 get sqt => new Vector3(storage[0], storage[3], storage[1]);
  Vector3 get sqp => new Vector3(storage[0], storage[3], storage[2]);
  Vector3 get sqq => new Vector3(storage[0], storage[3], storage[3]);
  Vector3 get tss => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get tst => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get tsp => new Vector3(storage[1], storage[0], storage[2]);
  Vector3 get tsq => new Vector3(storage[1], storage[0], storage[3]);
  Vector3 get tts => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get ttt => new Vector3(storage[1], storage[1], storage[1]);
  Vector3 get ttp => new Vector3(storage[1], storage[1], storage[2]);
  Vector3 get ttq => new Vector3(storage[1], storage[1], storage[3]);
  Vector3 get tps => new Vector3(storage[1], storage[2], storage[0]);
  Vector3 get tpt => new Vector3(storage[1], storage[2], storage[1]);
  Vector3 get tpp => new Vector3(storage[1], storage[2], storage[2]);
  Vector3 get tpq => new Vector3(storage[1], storage[2], storage[3]);
  Vector3 get tqs => new Vector3(storage[1], storage[3], storage[0]);
  Vector3 get tqt => new Vector3(storage[1], storage[3], storage[1]);
  Vector3 get tqp => new Vector3(storage[1], storage[3], storage[2]);
  Vector3 get tqq => new Vector3(storage[1], storage[3], storage[3]);
  Vector3 get pss => new Vector3(storage[2], storage[0], storage[0]);
  Vector3 get pst => new Vector3(storage[2], storage[0], storage[1]);
  Vector3 get psp => new Vector3(storage[2], storage[0], storage[2]);
  Vector3 get psq => new Vector3(storage[2], storage[0], storage[3]);
  Vector3 get pts => new Vector3(storage[2], storage[1], storage[0]);
  Vector3 get ptt => new Vector3(storage[2], storage[1], storage[1]);
  Vector3 get ptp => new Vector3(storage[2], storage[1], storage[2]);
  Vector3 get ptq => new Vector3(storage[2], storage[1], storage[3]);
  Vector3 get pps => new Vector3(storage[2], storage[2], storage[0]);
  Vector3 get ppt => new Vector3(storage[2], storage[2], storage[1]);
  Vector3 get ppp => new Vector3(storage[2], storage[2], storage[2]);
  Vector3 get ppq => new Vector3(storage[2], storage[2], storage[3]);
  Vector3 get pqs => new Vector3(storage[2], storage[3], storage[0]);
  Vector3 get pqt => new Vector3(storage[2], storage[3], storage[1]);
  Vector3 get pqp => new Vector3(storage[2], storage[3], storage[2]);
  Vector3 get pqq => new Vector3(storage[2], storage[3], storage[3]);
  Vector3 get qss => new Vector3(storage[3], storage[0], storage[0]);
  Vector3 get qst => new Vector3(storage[3], storage[0], storage[1]);
  Vector3 get qsp => new Vector3(storage[3], storage[0], storage[2]);
  Vector3 get qsq => new Vector3(storage[3], storage[0], storage[3]);
  Vector3 get qts => new Vector3(storage[3], storage[1], storage[0]);
  Vector3 get qtt => new Vector3(storage[3], storage[1], storage[1]);
  Vector3 get qtp => new Vector3(storage[3], storage[1], storage[2]);
  Vector3 get qtq => new Vector3(storage[3], storage[1], storage[3]);
  Vector3 get qps => new Vector3(storage[3], storage[2], storage[0]);
  Vector3 get qpt => new Vector3(storage[3], storage[2], storage[1]);
  Vector3 get qpp => new Vector3(storage[3], storage[2], storage[2]);
  Vector3 get qpq => new Vector3(storage[3], storage[2], storage[3]);
  Vector3 get qqs => new Vector3(storage[3], storage[3], storage[0]);
  Vector3 get qqt => new Vector3(storage[3], storage[3], storage[1]);
  Vector3 get qqp => new Vector3(storage[3], storage[3], storage[2]);
  Vector3 get qqq => new Vector3(storage[3], storage[3], storage[3]);
  Vector4 get ssss => new Vector4(storage[0], storage[0], storage[0], storage[0]);
  Vector4 get ssst => new Vector4(storage[0], storage[0], storage[0], storage[1]);
  Vector4 get sssp => new Vector4(storage[0], storage[0], storage[0], storage[2]);
  Vector4 get sssq => new Vector4(storage[0], storage[0], storage[0], storage[3]);
  Vector4 get ssts => new Vector4(storage[0], storage[0], storage[1], storage[0]);
  Vector4 get sstt => new Vector4(storage[0], storage[0], storage[1], storage[1]);
  Vector4 get sstp => new Vector4(storage[0], storage[0], storage[1], storage[2]);
  Vector4 get sstq => new Vector4(storage[0], storage[0], storage[1], storage[3]);
  Vector4 get ssps => new Vector4(storage[0], storage[0], storage[2], storage[0]);
  Vector4 get sspt => new Vector4(storage[0], storage[0], storage[2], storage[1]);
  Vector4 get sspp => new Vector4(storage[0], storage[0], storage[2], storage[2]);
  Vector4 get sspq => new Vector4(storage[0], storage[0], storage[2], storage[3]);
  Vector4 get ssqs => new Vector4(storage[0], storage[0], storage[3], storage[0]);
  Vector4 get ssqt => new Vector4(storage[0], storage[0], storage[3], storage[1]);
  Vector4 get ssqp => new Vector4(storage[0], storage[0], storage[3], storage[2]);
  Vector4 get ssqq => new Vector4(storage[0], storage[0], storage[3], storage[3]);
  Vector4 get stss => new Vector4(storage[0], storage[1], storage[0], storage[0]);
  Vector4 get stst => new Vector4(storage[0], storage[1], storage[0], storage[1]);
  Vector4 get stsp => new Vector4(storage[0], storage[1], storage[0], storage[2]);
  Vector4 get stsq => new Vector4(storage[0], storage[1], storage[0], storage[3]);
  Vector4 get stts => new Vector4(storage[0], storage[1], storage[1], storage[0]);
  Vector4 get sttt => new Vector4(storage[0], storage[1], storage[1], storage[1]);
  Vector4 get sttp => new Vector4(storage[0], storage[1], storage[1], storage[2]);
  Vector4 get sttq => new Vector4(storage[0], storage[1], storage[1], storage[3]);
  Vector4 get stps => new Vector4(storage[0], storage[1], storage[2], storage[0]);
  Vector4 get stpt => new Vector4(storage[0], storage[1], storage[2], storage[1]);
  Vector4 get stpp => new Vector4(storage[0], storage[1], storage[2], storage[2]);
  Vector4 get stpq => new Vector4(storage[0], storage[1], storage[2], storage[3]);
  Vector4 get stqs => new Vector4(storage[0], storage[1], storage[3], storage[0]);
  Vector4 get stqt => new Vector4(storage[0], storage[1], storage[3], storage[1]);
  Vector4 get stqp => new Vector4(storage[0], storage[1], storage[3], storage[2]);
  Vector4 get stqq => new Vector4(storage[0], storage[1], storage[3], storage[3]);
  Vector4 get spss => new Vector4(storage[0], storage[2], storage[0], storage[0]);
  Vector4 get spst => new Vector4(storage[0], storage[2], storage[0], storage[1]);
  Vector4 get spsp => new Vector4(storage[0], storage[2], storage[0], storage[2]);
  Vector4 get spsq => new Vector4(storage[0], storage[2], storage[0], storage[3]);
  Vector4 get spts => new Vector4(storage[0], storage[2], storage[1], storage[0]);
  Vector4 get sptt => new Vector4(storage[0], storage[2], storage[1], storage[1]);
  Vector4 get sptp => new Vector4(storage[0], storage[2], storage[1], storage[2]);
  Vector4 get sptq => new Vector4(storage[0], storage[2], storage[1], storage[3]);
  Vector4 get spps => new Vector4(storage[0], storage[2], storage[2], storage[0]);
  Vector4 get sppt => new Vector4(storage[0], storage[2], storage[2], storage[1]);
  Vector4 get sppp => new Vector4(storage[0], storage[2], storage[2], storage[2]);
  Vector4 get sppq => new Vector4(storage[0], storage[2], storage[2], storage[3]);
  Vector4 get spqs => new Vector4(storage[0], storage[2], storage[3], storage[0]);
  Vector4 get spqt => new Vector4(storage[0], storage[2], storage[3], storage[1]);
  Vector4 get spqp => new Vector4(storage[0], storage[2], storage[3], storage[2]);
  Vector4 get spqq => new Vector4(storage[0], storage[2], storage[3], storage[3]);
  Vector4 get sqss => new Vector4(storage[0], storage[3], storage[0], storage[0]);
  Vector4 get sqst => new Vector4(storage[0], storage[3], storage[0], storage[1]);
  Vector4 get sqsp => new Vector4(storage[0], storage[3], storage[0], storage[2]);
  Vector4 get sqsq => new Vector4(storage[0], storage[3], storage[0], storage[3]);
  Vector4 get sqts => new Vector4(storage[0], storage[3], storage[1], storage[0]);
  Vector4 get sqtt => new Vector4(storage[0], storage[3], storage[1], storage[1]);
  Vector4 get sqtp => new Vector4(storage[0], storage[3], storage[1], storage[2]);
  Vector4 get sqtq => new Vector4(storage[0], storage[3], storage[1], storage[3]);
  Vector4 get sqps => new Vector4(storage[0], storage[3], storage[2], storage[0]);
  Vector4 get sqpt => new Vector4(storage[0], storage[3], storage[2], storage[1]);
  Vector4 get sqpp => new Vector4(storage[0], storage[3], storage[2], storage[2]);
  Vector4 get sqpq => new Vector4(storage[0], storage[3], storage[2], storage[3]);
  Vector4 get sqqs => new Vector4(storage[0], storage[3], storage[3], storage[0]);
  Vector4 get sqqt => new Vector4(storage[0], storage[3], storage[3], storage[1]);
  Vector4 get sqqp => new Vector4(storage[0], storage[3], storage[3], storage[2]);
  Vector4 get sqqq => new Vector4(storage[0], storage[3], storage[3], storage[3]);
  Vector4 get tsss => new Vector4(storage[1], storage[0], storage[0], storage[0]);
  Vector4 get tsst => new Vector4(storage[1], storage[0], storage[0], storage[1]);
  Vector4 get tssp => new Vector4(storage[1], storage[0], storage[0], storage[2]);
  Vector4 get tssq => new Vector4(storage[1], storage[0], storage[0], storage[3]);
  Vector4 get tsts => new Vector4(storage[1], storage[0], storage[1], storage[0]);
  Vector4 get tstt => new Vector4(storage[1], storage[0], storage[1], storage[1]);
  Vector4 get tstp => new Vector4(storage[1], storage[0], storage[1], storage[2]);
  Vector4 get tstq => new Vector4(storage[1], storage[0], storage[1], storage[3]);
  Vector4 get tsps => new Vector4(storage[1], storage[0], storage[2], storage[0]);
  Vector4 get tspt => new Vector4(storage[1], storage[0], storage[2], storage[1]);
  Vector4 get tspp => new Vector4(storage[1], storage[0], storage[2], storage[2]);
  Vector4 get tspq => new Vector4(storage[1], storage[0], storage[2], storage[3]);
  Vector4 get tsqs => new Vector4(storage[1], storage[0], storage[3], storage[0]);
  Vector4 get tsqt => new Vector4(storage[1], storage[0], storage[3], storage[1]);
  Vector4 get tsqp => new Vector4(storage[1], storage[0], storage[3], storage[2]);
  Vector4 get tsqq => new Vector4(storage[1], storage[0], storage[3], storage[3]);
  Vector4 get ttss => new Vector4(storage[1], storage[1], storage[0], storage[0]);
  Vector4 get ttst => new Vector4(storage[1], storage[1], storage[0], storage[1]);
  Vector4 get ttsp => new Vector4(storage[1], storage[1], storage[0], storage[2]);
  Vector4 get ttsq => new Vector4(storage[1], storage[1], storage[0], storage[3]);
  Vector4 get ttts => new Vector4(storage[1], storage[1], storage[1], storage[0]);
  Vector4 get tttt => new Vector4(storage[1], storage[1], storage[1], storage[1]);
  Vector4 get tttp => new Vector4(storage[1], storage[1], storage[1], storage[2]);
  Vector4 get tttq => new Vector4(storage[1], storage[1], storage[1], storage[3]);
  Vector4 get ttps => new Vector4(storage[1], storage[1], storage[2], storage[0]);
  Vector4 get ttpt => new Vector4(storage[1], storage[1], storage[2], storage[1]);
  Vector4 get ttpp => new Vector4(storage[1], storage[1], storage[2], storage[2]);
  Vector4 get ttpq => new Vector4(storage[1], storage[1], storage[2], storage[3]);
  Vector4 get ttqs => new Vector4(storage[1], storage[1], storage[3], storage[0]);
  Vector4 get ttqt => new Vector4(storage[1], storage[1], storage[3], storage[1]);
  Vector4 get ttqp => new Vector4(storage[1], storage[1], storage[3], storage[2]);
  Vector4 get ttqq => new Vector4(storage[1], storage[1], storage[3], storage[3]);
  Vector4 get tpss => new Vector4(storage[1], storage[2], storage[0], storage[0]);
  Vector4 get tpst => new Vector4(storage[1], storage[2], storage[0], storage[1]);
  Vector4 get tpsp => new Vector4(storage[1], storage[2], storage[0], storage[2]);
  Vector4 get tpsq => new Vector4(storage[1], storage[2], storage[0], storage[3]);
  Vector4 get tpts => new Vector4(storage[1], storage[2], storage[1], storage[0]);
  Vector4 get tptt => new Vector4(storage[1], storage[2], storage[1], storage[1]);
  Vector4 get tptp => new Vector4(storage[1], storage[2], storage[1], storage[2]);
  Vector4 get tptq => new Vector4(storage[1], storage[2], storage[1], storage[3]);
  Vector4 get tpps => new Vector4(storage[1], storage[2], storage[2], storage[0]);
  Vector4 get tppt => new Vector4(storage[1], storage[2], storage[2], storage[1]);
  Vector4 get tppp => new Vector4(storage[1], storage[2], storage[2], storage[2]);
  Vector4 get tppq => new Vector4(storage[1], storage[2], storage[2], storage[3]);
  Vector4 get tpqs => new Vector4(storage[1], storage[2], storage[3], storage[0]);
  Vector4 get tpqt => new Vector4(storage[1], storage[2], storage[3], storage[1]);
  Vector4 get tpqp => new Vector4(storage[1], storage[2], storage[3], storage[2]);
  Vector4 get tpqq => new Vector4(storage[1], storage[2], storage[3], storage[3]);
  Vector4 get tqss => new Vector4(storage[1], storage[3], storage[0], storage[0]);
  Vector4 get tqst => new Vector4(storage[1], storage[3], storage[0], storage[1]);
  Vector4 get tqsp => new Vector4(storage[1], storage[3], storage[0], storage[2]);
  Vector4 get tqsq => new Vector4(storage[1], storage[3], storage[0], storage[3]);
  Vector4 get tqts => new Vector4(storage[1], storage[3], storage[1], storage[0]);
  Vector4 get tqtt => new Vector4(storage[1], storage[3], storage[1], storage[1]);
  Vector4 get tqtp => new Vector4(storage[1], storage[3], storage[1], storage[2]);
  Vector4 get tqtq => new Vector4(storage[1], storage[3], storage[1], storage[3]);
  Vector4 get tqps => new Vector4(storage[1], storage[3], storage[2], storage[0]);
  Vector4 get tqpt => new Vector4(storage[1], storage[3], storage[2], storage[1]);
  Vector4 get tqpp => new Vector4(storage[1], storage[3], storage[2], storage[2]);
  Vector4 get tqpq => new Vector4(storage[1], storage[3], storage[2], storage[3]);
  Vector4 get tqqs => new Vector4(storage[1], storage[3], storage[3], storage[0]);
  Vector4 get tqqt => new Vector4(storage[1], storage[3], storage[3], storage[1]);
  Vector4 get tqqp => new Vector4(storage[1], storage[3], storage[3], storage[2]);
  Vector4 get tqqq => new Vector4(storage[1], storage[3], storage[3], storage[3]);
  Vector4 get psss => new Vector4(storage[2], storage[0], storage[0], storage[0]);
  Vector4 get psst => new Vector4(storage[2], storage[0], storage[0], storage[1]);
  Vector4 get pssp => new Vector4(storage[2], storage[0], storage[0], storage[2]);
  Vector4 get pssq => new Vector4(storage[2], storage[0], storage[0], storage[3]);
  Vector4 get psts => new Vector4(storage[2], storage[0], storage[1], storage[0]);
  Vector4 get pstt => new Vector4(storage[2], storage[0], storage[1], storage[1]);
  Vector4 get pstp => new Vector4(storage[2], storage[0], storage[1], storage[2]);
  Vector4 get pstq => new Vector4(storage[2], storage[0], storage[1], storage[3]);
  Vector4 get psps => new Vector4(storage[2], storage[0], storage[2], storage[0]);
  Vector4 get pspt => new Vector4(storage[2], storage[0], storage[2], storage[1]);
  Vector4 get pspp => new Vector4(storage[2], storage[0], storage[2], storage[2]);
  Vector4 get pspq => new Vector4(storage[2], storage[0], storage[2], storage[3]);
  Vector4 get psqs => new Vector4(storage[2], storage[0], storage[3], storage[0]);
  Vector4 get psqt => new Vector4(storage[2], storage[0], storage[3], storage[1]);
  Vector4 get psqp => new Vector4(storage[2], storage[0], storage[3], storage[2]);
  Vector4 get psqq => new Vector4(storage[2], storage[0], storage[3], storage[3]);
  Vector4 get ptss => new Vector4(storage[2], storage[1], storage[0], storage[0]);
  Vector4 get ptst => new Vector4(storage[2], storage[1], storage[0], storage[1]);
  Vector4 get ptsp => new Vector4(storage[2], storage[1], storage[0], storage[2]);
  Vector4 get ptsq => new Vector4(storage[2], storage[1], storage[0], storage[3]);
  Vector4 get ptts => new Vector4(storage[2], storage[1], storage[1], storage[0]);
  Vector4 get pttt => new Vector4(storage[2], storage[1], storage[1], storage[1]);
  Vector4 get pttp => new Vector4(storage[2], storage[1], storage[1], storage[2]);
  Vector4 get pttq => new Vector4(storage[2], storage[1], storage[1], storage[3]);
  Vector4 get ptps => new Vector4(storage[2], storage[1], storage[2], storage[0]);
  Vector4 get ptpt => new Vector4(storage[2], storage[1], storage[2], storage[1]);
  Vector4 get ptpp => new Vector4(storage[2], storage[1], storage[2], storage[2]);
  Vector4 get ptpq => new Vector4(storage[2], storage[1], storage[2], storage[3]);
  Vector4 get ptqs => new Vector4(storage[2], storage[1], storage[3], storage[0]);
  Vector4 get ptqt => new Vector4(storage[2], storage[1], storage[3], storage[1]);
  Vector4 get ptqp => new Vector4(storage[2], storage[1], storage[3], storage[2]);
  Vector4 get ptqq => new Vector4(storage[2], storage[1], storage[3], storage[3]);
  Vector4 get ppss => new Vector4(storage[2], storage[2], storage[0], storage[0]);
  Vector4 get ppst => new Vector4(storage[2], storage[2], storage[0], storage[1]);
  Vector4 get ppsp => new Vector4(storage[2], storage[2], storage[0], storage[2]);
  Vector4 get ppsq => new Vector4(storage[2], storage[2], storage[0], storage[3]);
  Vector4 get ppts => new Vector4(storage[2], storage[2], storage[1], storage[0]);
  Vector4 get pptt => new Vector4(storage[2], storage[2], storage[1], storage[1]);
  Vector4 get pptp => new Vector4(storage[2], storage[2], storage[1], storage[2]);
  Vector4 get pptq => new Vector4(storage[2], storage[2], storage[1], storage[3]);
  Vector4 get ppps => new Vector4(storage[2], storage[2], storage[2], storage[0]);
  Vector4 get pppt => new Vector4(storage[2], storage[2], storage[2], storage[1]);
  Vector4 get pppp => new Vector4(storage[2], storage[2], storage[2], storage[2]);
  Vector4 get pppq => new Vector4(storage[2], storage[2], storage[2], storage[3]);
  Vector4 get ppqs => new Vector4(storage[2], storage[2], storage[3], storage[0]);
  Vector4 get ppqt => new Vector4(storage[2], storage[2], storage[3], storage[1]);
  Vector4 get ppqp => new Vector4(storage[2], storage[2], storage[3], storage[2]);
  Vector4 get ppqq => new Vector4(storage[2], storage[2], storage[3], storage[3]);
  Vector4 get pqss => new Vector4(storage[2], storage[3], storage[0], storage[0]);
  Vector4 get pqst => new Vector4(storage[2], storage[3], storage[0], storage[1]);
  Vector4 get pqsp => new Vector4(storage[2], storage[3], storage[0], storage[2]);
  Vector4 get pqsq => new Vector4(storage[2], storage[3], storage[0], storage[3]);
  Vector4 get pqts => new Vector4(storage[2], storage[3], storage[1], storage[0]);
  Vector4 get pqtt => new Vector4(storage[2], storage[3], storage[1], storage[1]);
  Vector4 get pqtp => new Vector4(storage[2], storage[3], storage[1], storage[2]);
  Vector4 get pqtq => new Vector4(storage[2], storage[3], storage[1], storage[3]);
  Vector4 get pqps => new Vector4(storage[2], storage[3], storage[2], storage[0]);
  Vector4 get pqpt => new Vector4(storage[2], storage[3], storage[2], storage[1]);
  Vector4 get pqpp => new Vector4(storage[2], storage[3], storage[2], storage[2]);
  Vector4 get pqpq => new Vector4(storage[2], storage[3], storage[2], storage[3]);
  Vector4 get pqqs => new Vector4(storage[2], storage[3], storage[3], storage[0]);
  Vector4 get pqqt => new Vector4(storage[2], storage[3], storage[3], storage[1]);
  Vector4 get pqqp => new Vector4(storage[2], storage[3], storage[3], storage[2]);
  Vector4 get pqqq => new Vector4(storage[2], storage[3], storage[3], storage[3]);
  Vector4 get qsss => new Vector4(storage[3], storage[0], storage[0], storage[0]);
  Vector4 get qsst => new Vector4(storage[3], storage[0], storage[0], storage[1]);
  Vector4 get qssp => new Vector4(storage[3], storage[0], storage[0], storage[2]);
  Vector4 get qssq => new Vector4(storage[3], storage[0], storage[0], storage[3]);
  Vector4 get qsts => new Vector4(storage[3], storage[0], storage[1], storage[0]);
  Vector4 get qstt => new Vector4(storage[3], storage[0], storage[1], storage[1]);
  Vector4 get qstp => new Vector4(storage[3], storage[0], storage[1], storage[2]);
  Vector4 get qstq => new Vector4(storage[3], storage[0], storage[1], storage[3]);
  Vector4 get qsps => new Vector4(storage[3], storage[0], storage[2], storage[0]);
  Vector4 get qspt => new Vector4(storage[3], storage[0], storage[2], storage[1]);
  Vector4 get qspp => new Vector4(storage[3], storage[0], storage[2], storage[2]);
  Vector4 get qspq => new Vector4(storage[3], storage[0], storage[2], storage[3]);
  Vector4 get qsqs => new Vector4(storage[3], storage[0], storage[3], storage[0]);
  Vector4 get qsqt => new Vector4(storage[3], storage[0], storage[3], storage[1]);
  Vector4 get qsqp => new Vector4(storage[3], storage[0], storage[3], storage[2]);
  Vector4 get qsqq => new Vector4(storage[3], storage[0], storage[3], storage[3]);
  Vector4 get qtss => new Vector4(storage[3], storage[1], storage[0], storage[0]);
  Vector4 get qtst => new Vector4(storage[3], storage[1], storage[0], storage[1]);
  Vector4 get qtsp => new Vector4(storage[3], storage[1], storage[0], storage[2]);
  Vector4 get qtsq => new Vector4(storage[3], storage[1], storage[0], storage[3]);
  Vector4 get qtts => new Vector4(storage[3], storage[1], storage[1], storage[0]);
  Vector4 get qttt => new Vector4(storage[3], storage[1], storage[1], storage[1]);
  Vector4 get qttp => new Vector4(storage[3], storage[1], storage[1], storage[2]);
  Vector4 get qttq => new Vector4(storage[3], storage[1], storage[1], storage[3]);
  Vector4 get qtps => new Vector4(storage[3], storage[1], storage[2], storage[0]);
  Vector4 get qtpt => new Vector4(storage[3], storage[1], storage[2], storage[1]);
  Vector4 get qtpp => new Vector4(storage[3], storage[1], storage[2], storage[2]);
  Vector4 get qtpq => new Vector4(storage[3], storage[1], storage[2], storage[3]);
  Vector4 get qtqs => new Vector4(storage[3], storage[1], storage[3], storage[0]);
  Vector4 get qtqt => new Vector4(storage[3], storage[1], storage[3], storage[1]);
  Vector4 get qtqp => new Vector4(storage[3], storage[1], storage[3], storage[2]);
  Vector4 get qtqq => new Vector4(storage[3], storage[1], storage[3], storage[3]);
  Vector4 get qpss => new Vector4(storage[3], storage[2], storage[0], storage[0]);
  Vector4 get qpst => new Vector4(storage[3], storage[2], storage[0], storage[1]);
  Vector4 get qpsp => new Vector4(storage[3], storage[2], storage[0], storage[2]);
  Vector4 get qpsq => new Vector4(storage[3], storage[2], storage[0], storage[3]);
  Vector4 get qpts => new Vector4(storage[3], storage[2], storage[1], storage[0]);
  Vector4 get qptt => new Vector4(storage[3], storage[2], storage[1], storage[1]);
  Vector4 get qptp => new Vector4(storage[3], storage[2], storage[1], storage[2]);
  Vector4 get qptq => new Vector4(storage[3], storage[2], storage[1], storage[3]);
  Vector4 get qpps => new Vector4(storage[3], storage[2], storage[2], storage[0]);
  Vector4 get qppt => new Vector4(storage[3], storage[2], storage[2], storage[1]);
  Vector4 get qppp => new Vector4(storage[3], storage[2], storage[2], storage[2]);
  Vector4 get qppq => new Vector4(storage[3], storage[2], storage[2], storage[3]);
  Vector4 get qpqs => new Vector4(storage[3], storage[2], storage[3], storage[0]);
  Vector4 get qpqt => new Vector4(storage[3], storage[2], storage[3], storage[1]);
  Vector4 get qpqp => new Vector4(storage[3], storage[2], storage[3], storage[2]);
  Vector4 get qpqq => new Vector4(storage[3], storage[2], storage[3], storage[3]);
  Vector4 get qqss => new Vector4(storage[3], storage[3], storage[0], storage[0]);
  Vector4 get qqst => new Vector4(storage[3], storage[3], storage[0], storage[1]);
  Vector4 get qqsp => new Vector4(storage[3], storage[3], storage[0], storage[2]);
  Vector4 get qqsq => new Vector4(storage[3], storage[3], storage[0], storage[3]);
  Vector4 get qqts => new Vector4(storage[3], storage[3], storage[1], storage[0]);
  Vector4 get qqtt => new Vector4(storage[3], storage[3], storage[1], storage[1]);
  Vector4 get qqtp => new Vector4(storage[3], storage[3], storage[1], storage[2]);
  Vector4 get qqtq => new Vector4(storage[3], storage[3], storage[1], storage[3]);
  Vector4 get qqps => new Vector4(storage[3], storage[3], storage[2], storage[0]);
  Vector4 get qqpt => new Vector4(storage[3], storage[3], storage[2], storage[1]);
  Vector4 get qqpp => new Vector4(storage[3], storage[3], storage[2], storage[2]);
  Vector4 get qqpq => new Vector4(storage[3], storage[3], storage[2], storage[3]);
  Vector4 get qqqs => new Vector4(storage[3], storage[3], storage[3], storage[0]);
  Vector4 get qqqt => new Vector4(storage[3], storage[3], storage[3], storage[1]);
  Vector4 get qqqp => new Vector4(storage[3], storage[3], storage[3], storage[2]);
  Vector4 get qqqq => new Vector4(storage[3], storage[3], storage[3], storage[3]);
}
