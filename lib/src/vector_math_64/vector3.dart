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

part of vector_math_64;

/// 3D column vector.
class Vector3 {
  final Float64List storage = new Float64List(3);

  /// Set the values of [result] to the minimum of [a] and [b] for each line.
  static void min(Vector3 a, Vector3 b, Vector3 result) {
    result.x = Math.min(a.x, b.x);
    result.y = Math.min(a.y, b.y);
    result.z = Math.min(a.z, b.z);
  }

  /// Set the values of [result] to the maximum of [a] and [b] for each line.
  static void max(Vector3 a, Vector3 b, Vector3 result) {
    result.x = Math.max(a.x, b.x);
    result.y = Math.max(a.y, b.y);
    result.z = Math.max(a.z, b.z);
  }

  /// Construct a new vector with the specified values.
  Vector3(double x_, double y_, double z_) {
    setValues(x_, y_, z_);
  }

  /// Initialized with values from [array] starting at [offset].
  Vector3.array(List<double> array, [int offset=0]) {
    int i = offset;
    storage[2] = array[i+2];
    storage[1] = array[i+1];
    storage[0] = array[i+0];
  }

  //// Zero vector.
  Vector3.zero();

  /// Copy of [other].
  Vector3.copy(Vector3 other) {
    setFrom(other);
  }

  /// Set the values of the vector.
  Vector3 setValues(double x_, double y_, double z_) {
    storage[0] = x_;
    storage[1] = y_;
    storage[2] = z_;
    return this;
  }

  /// Zero vector.
  Vector3 setZero() {
    storage[2] = 0.0;
    storage[1] = 0.0;
    storage[0] = 0.0;
    return this;
  }

  /// Set the values by copying them from [other].
  Vector3 setFrom(Vector3 other) {
    storage[0] = other.storage[0];
    storage[1] = other.storage[1];
    storage[2] = other.storage[2];
    return this;
  }

  /// Splat [arg] into all lanes of the vector.
  Vector3 splat(double arg) {
    storage[2] = arg;
    storage[1] = arg;
    storage[0] = arg;
    return this;
  }

  /// Returns a printable string
  String toString() => '[${storage[0]},${storage[1]},${storage[2]}]';

  /// Negate
  Vector3 operator-() => new Vector3(- storage[0], - storage[1], - storage[2]);

  /// Subtract two vectors.
  Vector3 operator-(Vector3 other) => new Vector3(storage[0] - other.storage[0],
                                         storage[1] - other.storage[1],
                                         storage[2] - other.storage[2]);
  /// Add two vectors.
  Vector3 operator+(Vector3 other) => new Vector3(storage[0] + other.storage[0],
                                         storage[1] + other.storage[1],
                                         storage[2] + other.storage[2]);

  /// Scale.
  Vector3 operator/(double scale) {
    var o = 1.0 / scale;
    return new Vector3(storage[0] * o, storage[1] * o, storage[2] * o);
  }

  /// Scale.
  Vector3 operator*(double scale) {
    var o = scale;
    return new Vector3(storage[0] * o, storage[1] * o, storage[2] * o);
  }

  double operator[](int i) => storage[i];

  void operator[]=(int i, double v) { storage[i] = v; }

  /// Length.
  double get length {
    double sum;
    sum = (storage[0] * storage[0]);
    sum += (storage[1] * storage[1]);
    sum += (storage[2] * storage[2]);
    return Math.sqrt(sum);
  }

  /// Length squared.
  double get length2 {
    double sum;
    sum = (storage[0] * storage[0]);
    sum += (storage[1] * storage[1]);
    sum += (storage[2] * storage[2]);
    return sum;
  }

  /// Normalizes [this].
  Vector3 normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    storage[0] *= l;
    storage[1] *= l;
    storage[2] *= l;
    return this;
  }

  /// Normalize [this]. Returns length of vector before normalization.
  double normalizeLength() {
    double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    l = 1.0 / l;
    storage[0] *= l;
    storage[1] *= l;
    storage[2] *= l;
    return l;
  }

  /// Normalizes copy of [this].
  Vector3 normalized() {
    return new Vector3.copy(this).normalize();
  }

  /// Normalize vector into [out].
  Vector3 normalizeInto(Vector3 out) {
    out.setFrom(this);
    return out.normalize();
  }

  /// Inner product.
  double dot(Vector3 other) {
    double sum;
    sum = storage[0] * other.storage[0];
    sum += storage[1] * other.storage[1];
    sum += storage[2] * other.storage[2];
    return sum;
  }

  /**
   * Transforms [this] into the product of [this] as a row vector,
   * postmultiplied by matrix, [arg].
   * If [arg] is a rotation matrix, this is a computational shortcut for applying,
   * the inverse of the transformation.
   */
  Vector3 postmultiply(Matrix3 arg) {
    double v0 = storage[0];
    double v1 = storage[1];
    double v2 = storage[2];
    storage[0] = v0*arg.storage[0]+v1*arg.storage[1]+v2*arg.storage[2];
    storage[1] = v0*arg.storage[3]+v1*arg.storage[4]+v2*arg.storage[5];
    storage[2] = v0*arg.storage[6]+v1*arg.storage[7]+v2*arg.storage[8];

    return this;
  }

  /// Cross product.
  Vector3 cross(Vector3 other) {
    double _x = storage[0];
    double _y = storage[1];
    double _z = storage[2];
    double ox = other.storage[0];
    double oy = other.storage[1];
    double oz = other.storage[2];
    return new Vector3(_y * oz - _z * oy, _z * ox - _x * oz, _x * oy - _y * ox);
  }

  /// Cross product. Stores result in [out].
  Vector3 crossInto(Vector3 other, Vector3 out) {
    double _x = storage[0];
    double _y = storage[1];
    double _z = storage[2];
    double ox = other.storage[0];
    double oy = other.storage[1];
    double oz = other.storage[2];
    out.storage[0] = _y * oz - _z * oy;
    out.storage[1] = _z * ox - _x * oz;
    out.storage[2] = _x * oy - _y * ox;
    return out;
  }

  /// Reflect [this].
  Vector3 reflect(Vector3 normal) {
    sub(normal.scaled(2 * normal.dot(this)));
    return this;
  }

  /// Reflected copy of [this].
  Vector3 reflected(Vector3 normal) {
    return new Vector3.copy(this).reflect(normal);
  }

  /// Projects [this] using the projection matrix [arg]
  Vector3 applyProjection(Matrix4 arg) {
    double _x = storage[0];
    double _y = storage[1];
    double _z = storage[2];
    double d = 1.0 / (arg.storage[3] * _x + arg.storage[7] * _y
                      + arg.storage[11] * _z + arg.storage[15]);
    storage[0] = (arg.storage[0] * _x + arg.storage[4] * _y
                  + arg.storage[8]  * _z + arg.storage[12]) * d;
    storage[1] = (arg.storage[1] * _x + arg.storage[5] * _y
                  + arg.storage[9]  * _z + arg.storage[13]) * d;
    storage[2] = (arg.storage[2] * _x + arg.storage[6] * _y
                  + arg.storage[10] * _z + arg.storage[14]) * d;
    return this;
  }

  /// Relative error between [this] and [correct]
  double relativeError(Vector3 correct) {
    double correct_norm = correct.length;
    double diff_norm = (this - correct).length;
    return diff_norm/correct_norm;
  }

  /// Absolute error between [this] and [correct]
  double absoluteError(Vector3 correct) {
    return (this - correct).length;
  }

  /// True if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || storage[0].isInfinite;
    is_infinite = is_infinite || storage[1].isInfinite;
    is_infinite = is_infinite || storage[2].isInfinite;
    return is_infinite;
  }

  /// True if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || storage[0].isNaN;
    is_nan = is_nan || storage[1].isNaN;
    is_nan = is_nan || storage[2].isNaN;
    return is_nan;
  }

  /// Add [arg] to [this].
  Vector3 add(Vector3 arg) {
    storage[0] = storage[0] + arg.storage[0];
    storage[1] = storage[1] + arg.storage[1];
    storage[2] = storage[2] + arg.storage[2];
    return this;
  }

  /// Subtract [arg] from [this].
  Vector3 sub(Vector3 arg) {
    storage[0] = storage[0] - arg.storage[0];
    storage[1] = storage[1] - arg.storage[1];
    storage[2] = storage[2] - arg.storage[2];
    return this;
  }

  /// Multiply entries in [this] with entries in [arg].
  Vector3 multiply(Vector3 arg) {
    storage[0] = storage[0] * arg.storage[0];
    storage[1] = storage[1] * arg.storage[1];
    storage[2] = storage[2] * arg.storage[2];
    return this;
  }

  /// Divide entries in [this] with entries in [arg].
  Vector3 divide(Vector3 arg) {
    storage[0] = storage[0] / arg.storage[0];
    storage[1] = storage[1] / arg.storage[1];
    storage[2] = storage[2] / arg.storage[2];
    return this;
  }

  /// Scale [this].
  Vector3 scale(double arg) {
    storage[2] = storage[2] * arg;
    storage[1] = storage[1] * arg;
    storage[0] = storage[0] * arg;
    return this;
  }

  Vector3 scaled(double arg) {
    return clone().scale(arg);
  }

  Vector3 negate() {
    storage[2] = -storage[2];
    storage[1] = -storage[1];
    storage[0] = -storage[0];
    return this;
  }

  /// Absolute value.
  Vector3 absolute() {
    storage[0] = storage[0].abs();
    storage[1] = storage[1].abs();
    storage[2] = storage[2].abs();
    return this;
  }

  /// Clone of [this].
  Vector3 clone() {
    return new Vector3.copy(this);
  }

  Vector3 copyInto(Vector3 arg) {
    arg.storage[0] = storage[0];
    arg.storage[1] = storage[1];
    arg.storage[2] = storage[2];
    return arg;
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset=0]) {
    array[offset+2] = storage[2];
    array[offset+1] = storage[1];
    array[offset+0] = storage[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset=0]) {
    storage[2] = array[offset+2];
    storage[1] = array[offset+1];
    storage[0] = array[offset+0];
  }

  set xy(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set xz(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set yx(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set yz(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set zx(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set zy(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set xyz(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set xzy(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set yxz(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set yzx(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set zxy(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set zyx(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set r(double arg) => storage[0] = arg;
  set g(double arg) => storage[1] = arg;
  set b(double arg) => storage[2] = arg;
  set s(double arg) => storage[0] = arg;
  set t(double arg) => storage[1] = arg;
  set p(double arg) => storage[2] = arg;
  set x(double arg) => storage[0] = arg;
  set y(double arg) => storage[1] = arg;
  set z(double arg) => storage[2] = arg;
  set rg(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set rb(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set gr(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set gb(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set br(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set bg(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set rgb(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set rbg(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set grb(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set gbr(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set brg(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set bgr(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set st(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set sp(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set ts(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set tp(Vector2 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
  }
  set ps(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
  }
  set pt(Vector2 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
  }
  set stp(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set spt(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set tsp(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[2] = arg.storage[2];
  }
  set tps(Vector3 arg) {
    storage[1] = arg.storage[0];
    storage[2] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  set pst(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[0] = arg.storage[1];
    storage[1] = arg.storage[2];
  }
  set pts(Vector3 arg) {
    storage[2] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[2];
  }
  Vector2 get xx => new Vector2(storage[0], storage[0]);
  Vector2 get xy => new Vector2(storage[0], storage[1]);
  Vector2 get xz => new Vector2(storage[0], storage[2]);
  Vector2 get yx => new Vector2(storage[1], storage[0]);
  Vector2 get yy => new Vector2(storage[1], storage[1]);
  Vector2 get yz => new Vector2(storage[1], storage[2]);
  Vector2 get zx => new Vector2(storage[2], storage[0]);
  Vector2 get zy => new Vector2(storage[2], storage[1]);
  Vector2 get zz => new Vector2(storage[2], storage[2]);
  Vector3 get xxx => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get xxy => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get xxz => new Vector3(storage[0], storage[0], storage[2]);
  Vector3 get xyx => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get xyy => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get xyz => new Vector3(storage[0], storage[1], storage[2]);
  Vector3 get xzx => new Vector3(storage[0], storage[2], storage[0]);
  Vector3 get xzy => new Vector3(storage[0], storage[2], storage[1]);
  Vector3 get xzz => new Vector3(storage[0], storage[2], storage[2]);
  Vector3 get yxx => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get yxy => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get yxz => new Vector3(storage[1], storage[0], storage[2]);
  Vector3 get yyx => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get yyy => new Vector3(storage[1], storage[1], storage[1]);
  Vector3 get yyz => new Vector3(storage[1], storage[1], storage[2]);
  Vector3 get yzx => new Vector3(storage[1], storage[2], storage[0]);
  Vector3 get yzy => new Vector3(storage[1], storage[2], storage[1]);
  Vector3 get yzz => new Vector3(storage[1], storage[2], storage[2]);
  Vector3 get zxx => new Vector3(storage[2], storage[0], storage[0]);
  Vector3 get zxy => new Vector3(storage[2], storage[0], storage[1]);
  Vector3 get zxz => new Vector3(storage[2], storage[0], storage[2]);
  Vector3 get zyx => new Vector3(storage[2], storage[1], storage[0]);
  Vector3 get zyy => new Vector3(storage[2], storage[1], storage[1]);
  Vector3 get zyz => new Vector3(storage[2], storage[1], storage[2]);
  Vector3 get zzx => new Vector3(storage[2], storage[2], storage[0]);
  Vector3 get zzy => new Vector3(storage[2], storage[2], storage[1]);
  Vector3 get zzz => new Vector3(storage[2], storage[2], storage[2]);
  Vector4 get xxxx => new Vector4(storage[0], storage[0], storage[0], storage[0]);
  Vector4 get xxxy => new Vector4(storage[0], storage[0], storage[0], storage[1]);
  Vector4 get xxxz => new Vector4(storage[0], storage[0], storage[0], storage[2]);
  Vector4 get xxyx => new Vector4(storage[0], storage[0], storage[1], storage[0]);
  Vector4 get xxyy => new Vector4(storage[0], storage[0], storage[1], storage[1]);
  Vector4 get xxyz => new Vector4(storage[0], storage[0], storage[1], storage[2]);
  Vector4 get xxzx => new Vector4(storage[0], storage[0], storage[2], storage[0]);
  Vector4 get xxzy => new Vector4(storage[0], storage[0], storage[2], storage[1]);
  Vector4 get xxzz => new Vector4(storage[0], storage[0], storage[2], storage[2]);
  Vector4 get xyxx => new Vector4(storage[0], storage[1], storage[0], storage[0]);
  Vector4 get xyxy => new Vector4(storage[0], storage[1], storage[0], storage[1]);
  Vector4 get xyxz => new Vector4(storage[0], storage[1], storage[0], storage[2]);
  Vector4 get xyyx => new Vector4(storage[0], storage[1], storage[1], storage[0]);
  Vector4 get xyyy => new Vector4(storage[0], storage[1], storage[1], storage[1]);
  Vector4 get xyyz => new Vector4(storage[0], storage[1], storage[1], storage[2]);
  Vector4 get xyzx => new Vector4(storage[0], storage[1], storage[2], storage[0]);
  Vector4 get xyzy => new Vector4(storage[0], storage[1], storage[2], storage[1]);
  Vector4 get xyzz => new Vector4(storage[0], storage[1], storage[2], storage[2]);
  Vector4 get xzxx => new Vector4(storage[0], storage[2], storage[0], storage[0]);
  Vector4 get xzxy => new Vector4(storage[0], storage[2], storage[0], storage[1]);
  Vector4 get xzxz => new Vector4(storage[0], storage[2], storage[0], storage[2]);
  Vector4 get xzyx => new Vector4(storage[0], storage[2], storage[1], storage[0]);
  Vector4 get xzyy => new Vector4(storage[0], storage[2], storage[1], storage[1]);
  Vector4 get xzyz => new Vector4(storage[0], storage[2], storage[1], storage[2]);
  Vector4 get xzzx => new Vector4(storage[0], storage[2], storage[2], storage[0]);
  Vector4 get xzzy => new Vector4(storage[0], storage[2], storage[2], storage[1]);
  Vector4 get xzzz => new Vector4(storage[0], storage[2], storage[2], storage[2]);
  Vector4 get yxxx => new Vector4(storage[1], storage[0], storage[0], storage[0]);
  Vector4 get yxxy => new Vector4(storage[1], storage[0], storage[0], storage[1]);
  Vector4 get yxxz => new Vector4(storage[1], storage[0], storage[0], storage[2]);
  Vector4 get yxyx => new Vector4(storage[1], storage[0], storage[1], storage[0]);
  Vector4 get yxyy => new Vector4(storage[1], storage[0], storage[1], storage[1]);
  Vector4 get yxyz => new Vector4(storage[1], storage[0], storage[1], storage[2]);
  Vector4 get yxzx => new Vector4(storage[1], storage[0], storage[2], storage[0]);
  Vector4 get yxzy => new Vector4(storage[1], storage[0], storage[2], storage[1]);
  Vector4 get yxzz => new Vector4(storage[1], storage[0], storage[2], storage[2]);
  Vector4 get yyxx => new Vector4(storage[1], storage[1], storage[0], storage[0]);
  Vector4 get yyxy => new Vector4(storage[1], storage[1], storage[0], storage[1]);
  Vector4 get yyxz => new Vector4(storage[1], storage[1], storage[0], storage[2]);
  Vector4 get yyyx => new Vector4(storage[1], storage[1], storage[1], storage[0]);
  Vector4 get yyyy => new Vector4(storage[1], storage[1], storage[1], storage[1]);
  Vector4 get yyyz => new Vector4(storage[1], storage[1], storage[1], storage[2]);
  Vector4 get yyzx => new Vector4(storage[1], storage[1], storage[2], storage[0]);
  Vector4 get yyzy => new Vector4(storage[1], storage[1], storage[2], storage[1]);
  Vector4 get yyzz => new Vector4(storage[1], storage[1], storage[2], storage[2]);
  Vector4 get yzxx => new Vector4(storage[1], storage[2], storage[0], storage[0]);
  Vector4 get yzxy => new Vector4(storage[1], storage[2], storage[0], storage[1]);
  Vector4 get yzxz => new Vector4(storage[1], storage[2], storage[0], storage[2]);
  Vector4 get yzyx => new Vector4(storage[1], storage[2], storage[1], storage[0]);
  Vector4 get yzyy => new Vector4(storage[1], storage[2], storage[1], storage[1]);
  Vector4 get yzyz => new Vector4(storage[1], storage[2], storage[1], storage[2]);
  Vector4 get yzzx => new Vector4(storage[1], storage[2], storage[2], storage[0]);
  Vector4 get yzzy => new Vector4(storage[1], storage[2], storage[2], storage[1]);
  Vector4 get yzzz => new Vector4(storage[1], storage[2], storage[2], storage[2]);
  Vector4 get zxxx => new Vector4(storage[2], storage[0], storage[0], storage[0]);
  Vector4 get zxxy => new Vector4(storage[2], storage[0], storage[0], storage[1]);
  Vector4 get zxxz => new Vector4(storage[2], storage[0], storage[0], storage[2]);
  Vector4 get zxyx => new Vector4(storage[2], storage[0], storage[1], storage[0]);
  Vector4 get zxyy => new Vector4(storage[2], storage[0], storage[1], storage[1]);
  Vector4 get zxyz => new Vector4(storage[2], storage[0], storage[1], storage[2]);
  Vector4 get zxzx => new Vector4(storage[2], storage[0], storage[2], storage[0]);
  Vector4 get zxzy => new Vector4(storage[2], storage[0], storage[2], storage[1]);
  Vector4 get zxzz => new Vector4(storage[2], storage[0], storage[2], storage[2]);
  Vector4 get zyxx => new Vector4(storage[2], storage[1], storage[0], storage[0]);
  Vector4 get zyxy => new Vector4(storage[2], storage[1], storage[0], storage[1]);
  Vector4 get zyxz => new Vector4(storage[2], storage[1], storage[0], storage[2]);
  Vector4 get zyyx => new Vector4(storage[2], storage[1], storage[1], storage[0]);
  Vector4 get zyyy => new Vector4(storage[2], storage[1], storage[1], storage[1]);
  Vector4 get zyyz => new Vector4(storage[2], storage[1], storage[1], storage[2]);
  Vector4 get zyzx => new Vector4(storage[2], storage[1], storage[2], storage[0]);
  Vector4 get zyzy => new Vector4(storage[2], storage[1], storage[2], storage[1]);
  Vector4 get zyzz => new Vector4(storage[2], storage[1], storage[2], storage[2]);
  Vector4 get zzxx => new Vector4(storage[2], storage[2], storage[0], storage[0]);
  Vector4 get zzxy => new Vector4(storage[2], storage[2], storage[0], storage[1]);
  Vector4 get zzxz => new Vector4(storage[2], storage[2], storage[0], storage[2]);
  Vector4 get zzyx => new Vector4(storage[2], storage[2], storage[1], storage[0]);
  Vector4 get zzyy => new Vector4(storage[2], storage[2], storage[1], storage[1]);
  Vector4 get zzyz => new Vector4(storage[2], storage[2], storage[1], storage[2]);
  Vector4 get zzzx => new Vector4(storage[2], storage[2], storage[2], storage[0]);
  Vector4 get zzzy => new Vector4(storage[2], storage[2], storage[2], storage[1]);
  Vector4 get zzzz => new Vector4(storage[2], storage[2], storage[2], storage[2]);
  double get r => storage[0];
  double get g => storage[1];
  double get b => storage[2];
  double get s => storage[0];
  double get t => storage[1];
  double get p => storage[2];
  double get x => storage[0];
  double get y => storage[1];
  double get z => storage[2];
  Vector2 get rr => new Vector2(storage[0], storage[0]);
  Vector2 get rg => new Vector2(storage[0], storage[1]);
  Vector2 get rb => new Vector2(storage[0], storage[2]);
  Vector2 get gr => new Vector2(storage[1], storage[0]);
  Vector2 get gg => new Vector2(storage[1], storage[1]);
  Vector2 get gb => new Vector2(storage[1], storage[2]);
  Vector2 get br => new Vector2(storage[2], storage[0]);
  Vector2 get bg => new Vector2(storage[2], storage[1]);
  Vector2 get bb => new Vector2(storage[2], storage[2]);
  Vector3 get rrr => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get rrg => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get rrb => new Vector3(storage[0], storage[0], storage[2]);
  Vector3 get rgr => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get rgg => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get rgb => new Vector3(storage[0], storage[1], storage[2]);
  Vector3 get rbr => new Vector3(storage[0], storage[2], storage[0]);
  Vector3 get rbg => new Vector3(storage[0], storage[2], storage[1]);
  Vector3 get rbb => new Vector3(storage[0], storage[2], storage[2]);
  Vector3 get grr => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get grg => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get grb => new Vector3(storage[1], storage[0], storage[2]);
  Vector3 get ggr => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get ggg => new Vector3(storage[1], storage[1], storage[1]);
  Vector3 get ggb => new Vector3(storage[1], storage[1], storage[2]);
  Vector3 get gbr => new Vector3(storage[1], storage[2], storage[0]);
  Vector3 get gbg => new Vector3(storage[1], storage[2], storage[1]);
  Vector3 get gbb => new Vector3(storage[1], storage[2], storage[2]);
  Vector3 get brr => new Vector3(storage[2], storage[0], storage[0]);
  Vector3 get brg => new Vector3(storage[2], storage[0], storage[1]);
  Vector3 get brb => new Vector3(storage[2], storage[0], storage[2]);
  Vector3 get bgr => new Vector3(storage[2], storage[1], storage[0]);
  Vector3 get bgg => new Vector3(storage[2], storage[1], storage[1]);
  Vector3 get bgb => new Vector3(storage[2], storage[1], storage[2]);
  Vector3 get bbr => new Vector3(storage[2], storage[2], storage[0]);
  Vector3 get bbg => new Vector3(storage[2], storage[2], storage[1]);
  Vector3 get bbb => new Vector3(storage[2], storage[2], storage[2]);
  Vector4 get rrrr => new Vector4(storage[0], storage[0], storage[0], storage[0]);
  Vector4 get rrrg => new Vector4(storage[0], storage[0], storage[0], storage[1]);
  Vector4 get rrrb => new Vector4(storage[0], storage[0], storage[0], storage[2]);
  Vector4 get rrgr => new Vector4(storage[0], storage[0], storage[1], storage[0]);
  Vector4 get rrgg => new Vector4(storage[0], storage[0], storage[1], storage[1]);
  Vector4 get rrgb => new Vector4(storage[0], storage[0], storage[1], storage[2]);
  Vector4 get rrbr => new Vector4(storage[0], storage[0], storage[2], storage[0]);
  Vector4 get rrbg => new Vector4(storage[0], storage[0], storage[2], storage[1]);
  Vector4 get rrbb => new Vector4(storage[0], storage[0], storage[2], storage[2]);
  Vector4 get rgrr => new Vector4(storage[0], storage[1], storage[0], storage[0]);
  Vector4 get rgrg => new Vector4(storage[0], storage[1], storage[0], storage[1]);
  Vector4 get rgrb => new Vector4(storage[0], storage[1], storage[0], storage[2]);
  Vector4 get rggr => new Vector4(storage[0], storage[1], storage[1], storage[0]);
  Vector4 get rggg => new Vector4(storage[0], storage[1], storage[1], storage[1]);
  Vector4 get rggb => new Vector4(storage[0], storage[1], storage[1], storage[2]);
  Vector4 get rgbr => new Vector4(storage[0], storage[1], storage[2], storage[0]);
  Vector4 get rgbg => new Vector4(storage[0], storage[1], storage[2], storage[1]);
  Vector4 get rgbb => new Vector4(storage[0], storage[1], storage[2], storage[2]);
  Vector4 get rbrr => new Vector4(storage[0], storage[2], storage[0], storage[0]);
  Vector4 get rbrg => new Vector4(storage[0], storage[2], storage[0], storage[1]);
  Vector4 get rbrb => new Vector4(storage[0], storage[2], storage[0], storage[2]);
  Vector4 get rbgr => new Vector4(storage[0], storage[2], storage[1], storage[0]);
  Vector4 get rbgg => new Vector4(storage[0], storage[2], storage[1], storage[1]);
  Vector4 get rbgb => new Vector4(storage[0], storage[2], storage[1], storage[2]);
  Vector4 get rbbr => new Vector4(storage[0], storage[2], storage[2], storage[0]);
  Vector4 get rbbg => new Vector4(storage[0], storage[2], storage[2], storage[1]);
  Vector4 get rbbb => new Vector4(storage[0], storage[2], storage[2], storage[2]);
  Vector4 get grrr => new Vector4(storage[1], storage[0], storage[0], storage[0]);
  Vector4 get grrg => new Vector4(storage[1], storage[0], storage[0], storage[1]);
  Vector4 get grrb => new Vector4(storage[1], storage[0], storage[0], storage[2]);
  Vector4 get grgr => new Vector4(storage[1], storage[0], storage[1], storage[0]);
  Vector4 get grgg => new Vector4(storage[1], storage[0], storage[1], storage[1]);
  Vector4 get grgb => new Vector4(storage[1], storage[0], storage[1], storage[2]);
  Vector4 get grbr => new Vector4(storage[1], storage[0], storage[2], storage[0]);
  Vector4 get grbg => new Vector4(storage[1], storage[0], storage[2], storage[1]);
  Vector4 get grbb => new Vector4(storage[1], storage[0], storage[2], storage[2]);
  Vector4 get ggrr => new Vector4(storage[1], storage[1], storage[0], storage[0]);
  Vector4 get ggrg => new Vector4(storage[1], storage[1], storage[0], storage[1]);
  Vector4 get ggrb => new Vector4(storage[1], storage[1], storage[0], storage[2]);
  Vector4 get gggr => new Vector4(storage[1], storage[1], storage[1], storage[0]);
  Vector4 get gggg => new Vector4(storage[1], storage[1], storage[1], storage[1]);
  Vector4 get gggb => new Vector4(storage[1], storage[1], storage[1], storage[2]);
  Vector4 get ggbr => new Vector4(storage[1], storage[1], storage[2], storage[0]);
  Vector4 get ggbg => new Vector4(storage[1], storage[1], storage[2], storage[1]);
  Vector4 get ggbb => new Vector4(storage[1], storage[1], storage[2], storage[2]);
  Vector4 get gbrr => new Vector4(storage[1], storage[2], storage[0], storage[0]);
  Vector4 get gbrg => new Vector4(storage[1], storage[2], storage[0], storage[1]);
  Vector4 get gbrb => new Vector4(storage[1], storage[2], storage[0], storage[2]);
  Vector4 get gbgr => new Vector4(storage[1], storage[2], storage[1], storage[0]);
  Vector4 get gbgg => new Vector4(storage[1], storage[2], storage[1], storage[1]);
  Vector4 get gbgb => new Vector4(storage[1], storage[2], storage[1], storage[2]);
  Vector4 get gbbr => new Vector4(storage[1], storage[2], storage[2], storage[0]);
  Vector4 get gbbg => new Vector4(storage[1], storage[2], storage[2], storage[1]);
  Vector4 get gbbb => new Vector4(storage[1], storage[2], storage[2], storage[2]);
  Vector4 get brrr => new Vector4(storage[2], storage[0], storage[0], storage[0]);
  Vector4 get brrg => new Vector4(storage[2], storage[0], storage[0], storage[1]);
  Vector4 get brrb => new Vector4(storage[2], storage[0], storage[0], storage[2]);
  Vector4 get brgr => new Vector4(storage[2], storage[0], storage[1], storage[0]);
  Vector4 get brgg => new Vector4(storage[2], storage[0], storage[1], storage[1]);
  Vector4 get brgb => new Vector4(storage[2], storage[0], storage[1], storage[2]);
  Vector4 get brbr => new Vector4(storage[2], storage[0], storage[2], storage[0]);
  Vector4 get brbg => new Vector4(storage[2], storage[0], storage[2], storage[1]);
  Vector4 get brbb => new Vector4(storage[2], storage[0], storage[2], storage[2]);
  Vector4 get bgrr => new Vector4(storage[2], storage[1], storage[0], storage[0]);
  Vector4 get bgrg => new Vector4(storage[2], storage[1], storage[0], storage[1]);
  Vector4 get bgrb => new Vector4(storage[2], storage[1], storage[0], storage[2]);
  Vector4 get bggr => new Vector4(storage[2], storage[1], storage[1], storage[0]);
  Vector4 get bggg => new Vector4(storage[2], storage[1], storage[1], storage[1]);
  Vector4 get bggb => new Vector4(storage[2], storage[1], storage[1], storage[2]);
  Vector4 get bgbr => new Vector4(storage[2], storage[1], storage[2], storage[0]);
  Vector4 get bgbg => new Vector4(storage[2], storage[1], storage[2], storage[1]);
  Vector4 get bgbb => new Vector4(storage[2], storage[1], storage[2], storage[2]);
  Vector4 get bbrr => new Vector4(storage[2], storage[2], storage[0], storage[0]);
  Vector4 get bbrg => new Vector4(storage[2], storage[2], storage[0], storage[1]);
  Vector4 get bbrb => new Vector4(storage[2], storage[2], storage[0], storage[2]);
  Vector4 get bbgr => new Vector4(storage[2], storage[2], storage[1], storage[0]);
  Vector4 get bbgg => new Vector4(storage[2], storage[2], storage[1], storage[1]);
  Vector4 get bbgb => new Vector4(storage[2], storage[2], storage[1], storage[2]);
  Vector4 get bbbr => new Vector4(storage[2], storage[2], storage[2], storage[0]);
  Vector4 get bbbg => new Vector4(storage[2], storage[2], storage[2], storage[1]);
  Vector4 get bbbb => new Vector4(storage[2], storage[2], storage[2], storage[2]);
  Vector2 get ss => new Vector2(storage[0], storage[0]);
  Vector2 get st => new Vector2(storage[0], storage[1]);
  Vector2 get sp => new Vector2(storage[0], storage[2]);
  Vector2 get ts => new Vector2(storage[1], storage[0]);
  Vector2 get tt => new Vector2(storage[1], storage[1]);
  Vector2 get tp => new Vector2(storage[1], storage[2]);
  Vector2 get ps => new Vector2(storage[2], storage[0]);
  Vector2 get pt => new Vector2(storage[2], storage[1]);
  Vector2 get pp => new Vector2(storage[2], storage[2]);
  Vector3 get sss => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get sst => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get ssp => new Vector3(storage[0], storage[0], storage[2]);
  Vector3 get sts => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get stt => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get stp => new Vector3(storage[0], storage[1], storage[2]);
  Vector3 get sps => new Vector3(storage[0], storage[2], storage[0]);
  Vector3 get spt => new Vector3(storage[0], storage[2], storage[1]);
  Vector3 get spp => new Vector3(storage[0], storage[2], storage[2]);
  Vector3 get tss => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get tst => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get tsp => new Vector3(storage[1], storage[0], storage[2]);
  Vector3 get tts => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get ttt => new Vector3(storage[1], storage[1], storage[1]);
  Vector3 get ttp => new Vector3(storage[1], storage[1], storage[2]);
  Vector3 get tps => new Vector3(storage[1], storage[2], storage[0]);
  Vector3 get tpt => new Vector3(storage[1], storage[2], storage[1]);
  Vector3 get tpp => new Vector3(storage[1], storage[2], storage[2]);
  Vector3 get pss => new Vector3(storage[2], storage[0], storage[0]);
  Vector3 get pst => new Vector3(storage[2], storage[0], storage[1]);
  Vector3 get psp => new Vector3(storage[2], storage[0], storage[2]);
  Vector3 get pts => new Vector3(storage[2], storage[1], storage[0]);
  Vector3 get ptt => new Vector3(storage[2], storage[1], storage[1]);
  Vector3 get ptp => new Vector3(storage[2], storage[1], storage[2]);
  Vector3 get pps => new Vector3(storage[2], storage[2], storage[0]);
  Vector3 get ppt => new Vector3(storage[2], storage[2], storage[1]);
  Vector3 get ppp => new Vector3(storage[2], storage[2], storage[2]);
  Vector4 get ssss => new Vector4(storage[0], storage[0], storage[0], storage[0]);
  Vector4 get ssst => new Vector4(storage[0], storage[0], storage[0], storage[1]);
  Vector4 get sssp => new Vector4(storage[0], storage[0], storage[0], storage[2]);
  Vector4 get ssts => new Vector4(storage[0], storage[0], storage[1], storage[0]);
  Vector4 get sstt => new Vector4(storage[0], storage[0], storage[1], storage[1]);
  Vector4 get sstp => new Vector4(storage[0], storage[0], storage[1], storage[2]);
  Vector4 get ssps => new Vector4(storage[0], storage[0], storage[2], storage[0]);
  Vector4 get sspt => new Vector4(storage[0], storage[0], storage[2], storage[1]);
  Vector4 get sspp => new Vector4(storage[0], storage[0], storage[2], storage[2]);
  Vector4 get stss => new Vector4(storage[0], storage[1], storage[0], storage[0]);
  Vector4 get stst => new Vector4(storage[0], storage[1], storage[0], storage[1]);
  Vector4 get stsp => new Vector4(storage[0], storage[1], storage[0], storage[2]);
  Vector4 get stts => new Vector4(storage[0], storage[1], storage[1], storage[0]);
  Vector4 get sttt => new Vector4(storage[0], storage[1], storage[1], storage[1]);
  Vector4 get sttp => new Vector4(storage[0], storage[1], storage[1], storage[2]);
  Vector4 get stps => new Vector4(storage[0], storage[1], storage[2], storage[0]);
  Vector4 get stpt => new Vector4(storage[0], storage[1], storage[2], storage[1]);
  Vector4 get stpp => new Vector4(storage[0], storage[1], storage[2], storage[2]);
  Vector4 get spss => new Vector4(storage[0], storage[2], storage[0], storage[0]);
  Vector4 get spst => new Vector4(storage[0], storage[2], storage[0], storage[1]);
  Vector4 get spsp => new Vector4(storage[0], storage[2], storage[0], storage[2]);
  Vector4 get spts => new Vector4(storage[0], storage[2], storage[1], storage[0]);
  Vector4 get sptt => new Vector4(storage[0], storage[2], storage[1], storage[1]);
  Vector4 get sptp => new Vector4(storage[0], storage[2], storage[1], storage[2]);
  Vector4 get spps => new Vector4(storage[0], storage[2], storage[2], storage[0]);
  Vector4 get sppt => new Vector4(storage[0], storage[2], storage[2], storage[1]);
  Vector4 get sppp => new Vector4(storage[0], storage[2], storage[2], storage[2]);
  Vector4 get tsss => new Vector4(storage[1], storage[0], storage[0], storage[0]);
  Vector4 get tsst => new Vector4(storage[1], storage[0], storage[0], storage[1]);
  Vector4 get tssp => new Vector4(storage[1], storage[0], storage[0], storage[2]);
  Vector4 get tsts => new Vector4(storage[1], storage[0], storage[1], storage[0]);
  Vector4 get tstt => new Vector4(storage[1], storage[0], storage[1], storage[1]);
  Vector4 get tstp => new Vector4(storage[1], storage[0], storage[1], storage[2]);
  Vector4 get tsps => new Vector4(storage[1], storage[0], storage[2], storage[0]);
  Vector4 get tspt => new Vector4(storage[1], storage[0], storage[2], storage[1]);
  Vector4 get tspp => new Vector4(storage[1], storage[0], storage[2], storage[2]);
  Vector4 get ttss => new Vector4(storage[1], storage[1], storage[0], storage[0]);
  Vector4 get ttst => new Vector4(storage[1], storage[1], storage[0], storage[1]);
  Vector4 get ttsp => new Vector4(storage[1], storage[1], storage[0], storage[2]);
  Vector4 get ttts => new Vector4(storage[1], storage[1], storage[1], storage[0]);
  Vector4 get tttt => new Vector4(storage[1], storage[1], storage[1], storage[1]);
  Vector4 get tttp => new Vector4(storage[1], storage[1], storage[1], storage[2]);
  Vector4 get ttps => new Vector4(storage[1], storage[1], storage[2], storage[0]);
  Vector4 get ttpt => new Vector4(storage[1], storage[1], storage[2], storage[1]);
  Vector4 get ttpp => new Vector4(storage[1], storage[1], storage[2], storage[2]);
  Vector4 get tpss => new Vector4(storage[1], storage[2], storage[0], storage[0]);
  Vector4 get tpst => new Vector4(storage[1], storage[2], storage[0], storage[1]);
  Vector4 get tpsp => new Vector4(storage[1], storage[2], storage[0], storage[2]);
  Vector4 get tpts => new Vector4(storage[1], storage[2], storage[1], storage[0]);
  Vector4 get tptt => new Vector4(storage[1], storage[2], storage[1], storage[1]);
  Vector4 get tptp => new Vector4(storage[1], storage[2], storage[1], storage[2]);
  Vector4 get tpps => new Vector4(storage[1], storage[2], storage[2], storage[0]);
  Vector4 get tppt => new Vector4(storage[1], storage[2], storage[2], storage[1]);
  Vector4 get tppp => new Vector4(storage[1], storage[2], storage[2], storage[2]);
  Vector4 get psss => new Vector4(storage[2], storage[0], storage[0], storage[0]);
  Vector4 get psst => new Vector4(storage[2], storage[0], storage[0], storage[1]);
  Vector4 get pssp => new Vector4(storage[2], storage[0], storage[0], storage[2]);
  Vector4 get psts => new Vector4(storage[2], storage[0], storage[1], storage[0]);
  Vector4 get pstt => new Vector4(storage[2], storage[0], storage[1], storage[1]);
  Vector4 get pstp => new Vector4(storage[2], storage[0], storage[1], storage[2]);
  Vector4 get psps => new Vector4(storage[2], storage[0], storage[2], storage[0]);
  Vector4 get pspt => new Vector4(storage[2], storage[0], storage[2], storage[1]);
  Vector4 get pspp => new Vector4(storage[2], storage[0], storage[2], storage[2]);
  Vector4 get ptss => new Vector4(storage[2], storage[1], storage[0], storage[0]);
  Vector4 get ptst => new Vector4(storage[2], storage[1], storage[0], storage[1]);
  Vector4 get ptsp => new Vector4(storage[2], storage[1], storage[0], storage[2]);
  Vector4 get ptts => new Vector4(storage[2], storage[1], storage[1], storage[0]);
  Vector4 get pttt => new Vector4(storage[2], storage[1], storage[1], storage[1]);
  Vector4 get pttp => new Vector4(storage[2], storage[1], storage[1], storage[2]);
  Vector4 get ptps => new Vector4(storage[2], storage[1], storage[2], storage[0]);
  Vector4 get ptpt => new Vector4(storage[2], storage[1], storage[2], storage[1]);
  Vector4 get ptpp => new Vector4(storage[2], storage[1], storage[2], storage[2]);
  Vector4 get ppss => new Vector4(storage[2], storage[2], storage[0], storage[0]);
  Vector4 get ppst => new Vector4(storage[2], storage[2], storage[0], storage[1]);
  Vector4 get ppsp => new Vector4(storage[2], storage[2], storage[0], storage[2]);
  Vector4 get ppts => new Vector4(storage[2], storage[2], storage[1], storage[0]);
  Vector4 get pptt => new Vector4(storage[2], storage[2], storage[1], storage[1]);
  Vector4 get pptp => new Vector4(storage[2], storage[2], storage[1], storage[2]);
  Vector4 get ppps => new Vector4(storage[2], storage[2], storage[2], storage[0]);
  Vector4 get pppt => new Vector4(storage[2], storage[2], storage[2], storage[1]);
  Vector4 get pppp => new Vector4(storage[2], storage[2], storage[2], storage[2]);
}
