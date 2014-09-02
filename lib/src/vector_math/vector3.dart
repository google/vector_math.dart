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

/// 3D column vector.
class Vector3 implements Vector {
  final Float32List _storage3;

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

  /// Interpolate between [min] and [max] with the amount of [a] using a linear
  /// interpolation and set the values to [result].
  static void mix(Vector3 min, Vector3 max, double a, Vector3 result) {
    result.x = min.x + a * (max.x - min.x);
    result.y = min.y + a * (max.y - min.y);
    result.z = min.z + a * (max.z - min.z);
  }

  /// The components of the vector.
  Float32List get storage => _storage3;

  /// Construct a new vector with the specified values.
  factory Vector3(double x, double y, double z) =>
      new Vector3.zero()..setValues(x, y, z);

  /// Initialized with values from [array] starting at [offset].
  factory Vector3.array(List<double> array, [int offset = 0]) =>
      new Vector3.zero()..copyFromArray(array, offset);

  /// Zero vector.
  Vector3.zero()
      : _storage3 = new Float32List(3);

  /// Splat [value] into all lanes of the vector.
  factory Vector3.all(double value) => new Vector3.zero()..splat(value);

  /// Copy of [other].
  factory Vector3.copy(Vector3 other) => new Vector3.zero()..setFrom(other);

  /// Constructs Vector3 with given Float32List as [storage].
  Vector3.fromFloat32List(this._storage3);

  /// Constructs Vector3 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float32List.BYTES_PER_ELEMENT].
  Vector3.fromBuffer(ByteBuffer buffer, int offset)
      : _storage3 = new Float32List.view(buffer, offset, 3);

  /// Set the values of the vector.
  void setValues(double x, double y, double z) {
    _storage3[0] = x;
    _storage3[1] = y;
    _storage3[2] = z;
  }

  /// Zero vector.
  void setZero() {
    _storage3[2] = 0.0;
    _storage3[1] = 0.0;
    _storage3[0] = 0.0;
  }

  /// Set the values by copying them from [other].
  void setFrom(Vector3 other) {
    final otherStorage = other._storage3;

    _storage3[0] = otherStorage[0];
    _storage3[1] = otherStorage[1];
    _storage3[2] = otherStorage[2];
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(double arg) {
    _storage3[2] = arg;
    _storage3[1] = arg;
    _storage3[0] = arg;
  }

  /// Returns a printable string
  String toString() => '[${_storage3[0]},${_storage3[1]},${_storage3[2]}]';

  /// Negate
  Vector3 operator -() => clone()..negate();

  /// Subtract two vectors.
  Vector3 operator -(Vector3 other) => clone()..sub(other);

  /// Add two vectors.
  Vector3 operator +(Vector3 other) => clone()..add(other);

  /// Scale.
  Vector3 operator /(double scale) => scaled(1.0 / scale);

  /// Scale by [scale].
  Vector3 operator *(double scale) => scaled(scale);

  /// Access the component of the vector at the index [i].
  double operator [](int i) => _storage3[i];

  /// Set the component of the vector at the index [i].
  void operator []=(int i, double v) {
    _storage3[i] = v;
  }

  /// Length.
  double get length => Math.sqrt(length2);

  /// Length squared.
  double get length2 {
    var sum;
    sum = (_storage3[0] * _storage3[0]);
    sum += (_storage3[1] * _storage3[1]);
    sum += (_storage3[2] * _storage3[2]);
    return sum;
  }

  /// Normalizes [this]. Returns length of vector before normalization.
  double normalize() {
    var l = length;
    if (l == 0.0) {
      return 0.0;
    }
    final d = 1.0 / l;
    _storage3[0] *= d;
    _storage3[1] *= d;
    _storage3[2] *= d;
    return l;
  }

  /// Normalize [this]. Returns length of vector before normalization.
  ///
  /// DEPREACTED: [normalize] does the same now.
  @deprecated
  double normalizeLength() => normalize();

  /// Normalizes copy of [this].
  Vector3 normalized() => new Vector3.copy(this)..normalize();

  /// Normalize vector into [out].
  Vector3 normalizeInto(Vector3 out) {
    out.setFrom(this);
    return out..normalize();
  }

  /// Distance from [this] to [arg]
  double distanceTo(Vector3 arg) => Math.sqrt(distanceToSquared(arg));

  /// Squared distance from [this] to [arg]
  double distanceToSquared(Vector3 arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;
    final dz = z - arg.z;

    return dx * dx + dy * dy + dz * dz;
  }

  /// Inner product.
  double dot(Vector3 other) {
    final otherStorage = other._storage3;
    var sum;
    sum = _storage3[0] * otherStorage[0];
    sum += _storage3[1] * otherStorage[1];
    sum += _storage3[2] * otherStorage[2];
    return sum;
  }

  /// Transforms [this] into the product of [this] as a row vector,
  /// postmultiplied by matrix, [arg].
  /// If [arg] is a rotation matrix, this is a computational shortcut for applying,
  /// the inverse of the transformation.
  void postmultiply(Matrix3 arg) {
    final argStorage = arg._storage33;
    final v0 = _storage3[0];
    final v1 = _storage3[1];
    final v2 = _storage3[2];

    _storage3[0] = v0 * argStorage[0] + v1 * argStorage[1] + v2 * argStorage[2];
    _storage3[1] = v0 * argStorage[3] + v1 * argStorage[4] + v2 * argStorage[5];
    _storage3[2] = v0 * argStorage[6] + v1 * argStorage[7] + v2 * argStorage[8];
  }

  /// Cross product.
  Vector3 cross(Vector3 other) {
    final _x = _storage3[0];
    final _y = _storage3[1];
    final _z = _storage3[2];
    final otherStorage = other._storage3;
    final ox = otherStorage[0];
    final oy = otherStorage[1];
    final oz = otherStorage[2];
    return new Vector3(_y * oz - _z * oy, _z * ox - _x * oz, _x * oy - _y * ox);
  }

  /// Cross product. Stores result in [out].
  Vector3 crossInto(Vector3 other, Vector3 out) {
    final x = _storage3[0];
    final y = _storage3[1];
    final z = _storage3[2];
    final otherStorage = other._storage3;
    final ox = otherStorage[0];
    final oy = otherStorage[1];
    final oz = otherStorage[2];
    final outStorage = out._storage3;
    outStorage[0] = y * oz - z * oy;
    outStorage[1] = z * ox - x * oz;
    outStorage[2] = x * oy - y * ox;
    return out;
  }

  /// Reflect [this].
  void reflect(Vector3 normal) {
    sub(normal.scaled(2.0 * normal.dot(this)));
  }

  /// Reflected copy of [this].
  Vector3 reflected(Vector3 normal) => clone()..reflect(normal);

  /// Projects [this] using the projection matrix [arg]
  void applyProjection(Matrix4 arg) {
    final argStorage = arg._storage44;
    final x = _storage3[0];
    final y = _storage3[1];
    final z = _storage3[2];
    final d = 1.0 / (argStorage[3] * x + argStorage[7] * y + argStorage[11] * z
        + argStorage[15]);
    _storage3[0] = (argStorage[0] * x + argStorage[4] * y + argStorage[8] * z +
        argStorage[12]) * d;
    _storage3[1] = (argStorage[1] * x + argStorage[5] * y + argStorage[9] * z +
        argStorage[13]) * d;
    _storage3[2] = (argStorage[2] * x + argStorage[6] * y + argStorage[10] * z +
        argStorage[14]) * d;
  }

  /// Relative error between [this] and [correct]
  double relativeError(Vector3 correct) {
    final correct_norm = correct.length;
    final diff_norm = (this - correct).length;
    return diff_norm / correct_norm;
  }

  /// Absolute error between [this] and [correct]
  double absoluteError(Vector3 correct) => (this - correct).length;

  /// True if any component is infinite.
  bool get isInfinite {
    var is_infinite = false;
    is_infinite = is_infinite || _storage3[0].isInfinite;
    is_infinite = is_infinite || _storage3[1].isInfinite;
    is_infinite = is_infinite || _storage3[2].isInfinite;
    return is_infinite;
  }

  /// True if any component is NaN.
  bool get isNaN {
    var is_nan = false;
    is_nan = is_nan || _storage3[0].isNaN;
    is_nan = is_nan || _storage3[1].isNaN;
    is_nan = is_nan || _storage3[2].isNaN;
    return is_nan;
  }

  /// Add [arg] to [this].
  void add(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[0] = _storage3[0] + argStorage[0];
    _storage3[1] = _storage3[1] + argStorage[1];
    _storage3[2] = _storage3[2] + argStorage[2];
  }

  /// Add [arg] scaled by [factor] to [this].
  void addScaled(Vector3 arg, double factor) {
    final argStorage = arg._storage3;
    _storage3[0] = _storage3[0] + argStorage[0] * factor;
    _storage3[1] = _storage3[1] + argStorage[1] * factor;
    _storage3[2] = _storage3[2] + argStorage[2] * factor;
  }

  /// Subtract [arg] from [this].
  void sub(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[0] = _storage3[0] - argStorage[0];
    _storage3[1] = _storage3[1] - argStorage[1];
    _storage3[2] = _storage3[2] - argStorage[2];
  }

  /// Multiply entries in [this] with entries in [arg].
  void multiply(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[0] = _storage3[0] * argStorage[0];
    _storage3[1] = _storage3[1] * argStorage[1];
    _storage3[2] = _storage3[2] * argStorage[2];
  }

  /// Divide entries in [this] with entries in [arg].
  void divide(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[0] = _storage3[0] / argStorage[0];
    _storage3[1] = _storage3[1] / argStorage[1];
    _storage3[2] = _storage3[2] / argStorage[2];
  }

  /// Scale [this].
  void scale(double arg) {
    _storage3[2] = _storage3[2] * arg;
    _storage3[1] = _storage3[1] * arg;
    _storage3[0] = _storage3[0] * arg;
  }

  /// Create a copy of [this] and scale it by [arg].
  Vector3 scaled(double arg) => clone()..scale(arg);

  /// Negate [this].
  void negate() {
    _storage3[2] = -_storage3[2];
    _storage3[1] = -_storage3[1];
    _storage3[0] = -_storage3[0];
  }

  /// Absolute value.
  void absolute() {
    _storage3[0] = _storage3[0].abs();
    _storage3[1] = _storage3[1].abs();
    _storage3[2] = _storage3[2].abs();
  }

  /// Clone of [this].
  Vector3 clone() => new Vector3.copy(this);

  /// Copy [this] into [arg].
  Vector3 copyInto(Vector3 arg) {
    final argStorage = arg._storage3;
    argStorage[0] = _storage3[0];
    argStorage[1] = _storage3[1];
    argStorage[2] = _storage3[2];
    return arg;
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset = 0]) {
    array[offset + 2] = _storage3[2];
    array[offset + 1] = _storage3[1];
    array[offset + 0] = _storage3[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    _storage3[2] = array[offset + 2];
    _storage3[1] = array[offset + 1];
    _storage3[0] = array[offset + 0];
  }

  set xy(Vector2 arg) {
    final argStorage = arg._storage2;
    _storage3[0] = argStorage[0];
    _storage3[1] = argStorage[1];
  }
  set xz(Vector2 arg) {
    final argStorage = arg._storage2;
    _storage3[0] = argStorage[0];
    _storage3[2] = argStorage[1];
  }
  set yx(Vector2 arg) {
    final argStorage = arg._storage2;
    _storage3[1] = argStorage[0];
    _storage3[0] = argStorage[1];
  }
  set yz(Vector2 arg) {
    final argStorage = arg._storage2;
    _storage3[1] = argStorage[0];
    _storage3[2] = argStorage[1];
  }
  set zx(Vector2 arg) {
    final argStorage = arg._storage2;
    _storage3[2] = argStorage[0];
    _storage3[0] = argStorage[1];
  }
  set zy(Vector2 arg) {
    final argStorage = arg._storage2;
    _storage3[2] = argStorage[0];
    _storage3[1] = argStorage[1];
  }
  set xyz(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[0] = argStorage[0];
    _storage3[1] = argStorage[1];
    _storage3[2] = argStorage[2];
  }
  set xzy(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[0] = argStorage[0];
    _storage3[2] = argStorage[1];
    _storage3[1] = argStorage[2];
  }
  set yxz(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[1] = argStorage[0];
    _storage3[0] = argStorage[1];
    _storage3[2] = argStorage[2];
  }
  set yzx(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[1] = argStorage[0];
    _storage3[2] = argStorage[1];
    _storage3[0] = argStorage[2];
  }
  set zxy(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[2] = argStorage[0];
    _storage3[0] = argStorage[1];
    _storage3[1] = argStorage[2];
  }
  set zyx(Vector3 arg) {
    final argStorage = arg._storage3;
    _storage3[2] = argStorage[0];
    _storage3[1] = argStorage[1];
    _storage3[0] = argStorage[2];
  }
  set r(double arg) => x = arg;
  set g(double arg) => y = arg;
  set b(double arg) => z = arg;
  set s(double arg) => x = arg;
  set t(double arg) => y = arg;
  set p(double arg) => z = arg;
  set x(double arg) => _storage3[0] = arg;
  set y(double arg) => _storage3[1] = arg;
  set z(double arg) => _storage3[2] = arg;
  set rg(Vector2 arg) => xy = arg;
  set rb(Vector2 arg) => xz = arg;
  set gr(Vector2 arg) => yx = arg;
  set gb(Vector2 arg) => yz = arg;
  set br(Vector2 arg) => zx = arg;
  set bg(Vector2 arg) => zy = arg;
  set rgb(Vector3 arg) => xyz = arg;
  set rbg(Vector3 arg) => xzy = arg;
  set grb(Vector3 arg) => yxz = arg;
  set gbr(Vector3 arg) => yzx = arg;
  set brg(Vector3 arg) => zxy = arg;
  set bgr(Vector3 arg) => zyx = arg;
  set st(Vector2 arg) => xy = arg;
  set sp(Vector2 arg) => xz = arg;
  set ts(Vector2 arg) => yx = arg;
  set tp(Vector2 arg) => yz = arg;
  set ps(Vector2 arg) => zx = arg;
  set pt(Vector2 arg) => zy = arg;
  set stp(Vector3 arg) => xyz = arg;
  set spt(Vector3 arg) => xzy = arg;
  set tsp(Vector3 arg) => yxz = arg;
  set tps(Vector3 arg) => yzx = arg;
  set pst(Vector3 arg) => zxy = arg;
  set pts(Vector3 arg) => zyx = arg;
  Vector2 get xx => new Vector2(_storage3[0], _storage3[0]);
  Vector2 get xy => new Vector2(_storage3[0], _storage3[1]);
  Vector2 get xz => new Vector2(_storage3[0], _storage3[2]);
  Vector2 get yx => new Vector2(_storage3[1], _storage3[0]);
  Vector2 get yy => new Vector2(_storage3[1], _storage3[1]);
  Vector2 get yz => new Vector2(_storage3[1], _storage3[2]);
  Vector2 get zx => new Vector2(_storage3[2], _storage3[0]);
  Vector2 get zy => new Vector2(_storage3[2], _storage3[1]);
  Vector2 get zz => new Vector2(_storage3[2], _storage3[2]);
  Vector3 get xxx => new Vector3(_storage3[0], _storage3[0], _storage3[0]);
  Vector3 get xxy => new Vector3(_storage3[0], _storage3[0], _storage3[1]);
  Vector3 get xxz => new Vector3(_storage3[0], _storage3[0], _storage3[2]);
  Vector3 get xyx => new Vector3(_storage3[0], _storage3[1], _storage3[0]);
  Vector3 get xyy => new Vector3(_storage3[0], _storage3[1], _storage3[1]);
  Vector3 get xyz => new Vector3(_storage3[0], _storage3[1], _storage3[2]);
  Vector3 get xzx => new Vector3(_storage3[0], _storage3[2], _storage3[0]);
  Vector3 get xzy => new Vector3(_storage3[0], _storage3[2], _storage3[1]);
  Vector3 get xzz => new Vector3(_storage3[0], _storage3[2], _storage3[2]);
  Vector3 get yxx => new Vector3(_storage3[1], _storage3[0], _storage3[0]);
  Vector3 get yxy => new Vector3(_storage3[1], _storage3[0], _storage3[1]);
  Vector3 get yxz => new Vector3(_storage3[1], _storage3[0], _storage3[2]);
  Vector3 get yyx => new Vector3(_storage3[1], _storage3[1], _storage3[0]);
  Vector3 get yyy => new Vector3(_storage3[1], _storage3[1], _storage3[1]);
  Vector3 get yyz => new Vector3(_storage3[1], _storage3[1], _storage3[2]);
  Vector3 get yzx => new Vector3(_storage3[1], _storage3[2], _storage3[0]);
  Vector3 get yzy => new Vector3(_storage3[1], _storage3[2], _storage3[1]);
  Vector3 get yzz => new Vector3(_storage3[1], _storage3[2], _storage3[2]);
  Vector3 get zxx => new Vector3(_storage3[2], _storage3[0], _storage3[0]);
  Vector3 get zxy => new Vector3(_storage3[2], _storage3[0], _storage3[1]);
  Vector3 get zxz => new Vector3(_storage3[2], _storage3[0], _storage3[2]);
  Vector3 get zyx => new Vector3(_storage3[2], _storage3[1], _storage3[0]);
  Vector3 get zyy => new Vector3(_storage3[2], _storage3[1], _storage3[1]);
  Vector3 get zyz => new Vector3(_storage3[2], _storage3[1], _storage3[2]);
  Vector3 get zzx => new Vector3(_storage3[2], _storage3[2], _storage3[0]);
  Vector3 get zzy => new Vector3(_storage3[2], _storage3[2], _storage3[1]);
  Vector3 get zzz => new Vector3(_storage3[2], _storage3[2], _storage3[2]);
  Vector4 get xxxx => new Vector4(_storage3[0], _storage3[0], _storage3[0], _storage3[0]);
  Vector4 get xxxy => new Vector4(_storage3[0], _storage3[0], _storage3[0], _storage3[1]);
  Vector4 get xxxz => new Vector4(_storage3[0], _storage3[0], _storage3[0], _storage3[2]);
  Vector4 get xxyx => new Vector4(_storage3[0], _storage3[0], _storage3[1], _storage3[0]);
  Vector4 get xxyy => new Vector4(_storage3[0], _storage3[0], _storage3[1], _storage3[1]);
  Vector4 get xxyz => new Vector4(_storage3[0], _storage3[0], _storage3[1], _storage3[2]);
  Vector4 get xxzx => new Vector4(_storage3[0], _storage3[0], _storage3[2], _storage3[0]);
  Vector4 get xxzy => new Vector4(_storage3[0], _storage3[0], _storage3[2], _storage3[1]);
  Vector4 get xxzz => new Vector4(_storage3[0], _storage3[0], _storage3[2], _storage3[2]);
  Vector4 get xyxx => new Vector4(_storage3[0], _storage3[1], _storage3[0], _storage3[0]);
  Vector4 get xyxy => new Vector4(_storage3[0], _storage3[1], _storage3[0], _storage3[1]);
  Vector4 get xyxz => new Vector4(_storage3[0], _storage3[1], _storage3[0], _storage3[2]);
  Vector4 get xyyx => new Vector4(_storage3[0], _storage3[1], _storage3[1], _storage3[0]);
  Vector4 get xyyy => new Vector4(_storage3[0], _storage3[1], _storage3[1], _storage3[1]);
  Vector4 get xyyz => new Vector4(_storage3[0], _storage3[1], _storage3[1], _storage3[2]);
  Vector4 get xyzx => new Vector4(_storage3[0], _storage3[1], _storage3[2], _storage3[0]);
  Vector4 get xyzy => new Vector4(_storage3[0], _storage3[1], _storage3[2], _storage3[1]);
  Vector4 get xyzz => new Vector4(_storage3[0], _storage3[1], _storage3[2], _storage3[2]);
  Vector4 get xzxx => new Vector4(_storage3[0], _storage3[2], _storage3[0], _storage3[0]);
  Vector4 get xzxy => new Vector4(_storage3[0], _storage3[2], _storage3[0], _storage3[1]);
  Vector4 get xzxz => new Vector4(_storage3[0], _storage3[2], _storage3[0], _storage3[2]);
  Vector4 get xzyx => new Vector4(_storage3[0], _storage3[2], _storage3[1], _storage3[0]);
  Vector4 get xzyy => new Vector4(_storage3[0], _storage3[2], _storage3[1], _storage3[1]);
  Vector4 get xzyz => new Vector4(_storage3[0], _storage3[2], _storage3[1], _storage3[2]);
  Vector4 get xzzx => new Vector4(_storage3[0], _storage3[2], _storage3[2], _storage3[0]);
  Vector4 get xzzy => new Vector4(_storage3[0], _storage3[2], _storage3[2], _storage3[1]);
  Vector4 get xzzz => new Vector4(_storage3[0], _storage3[2], _storage3[2], _storage3[2]);
  Vector4 get yxxx => new Vector4(_storage3[1], _storage3[0], _storage3[0], _storage3[0]);
  Vector4 get yxxy => new Vector4(_storage3[1], _storage3[0], _storage3[0], _storage3[1]);
  Vector4 get yxxz => new Vector4(_storage3[1], _storage3[0], _storage3[0], _storage3[2]);
  Vector4 get yxyx => new Vector4(_storage3[1], _storage3[0], _storage3[1], _storage3[0]);
  Vector4 get yxyy => new Vector4(_storage3[1], _storage3[0], _storage3[1], _storage3[1]);
  Vector4 get yxyz => new Vector4(_storage3[1], _storage3[0], _storage3[1], _storage3[2]);
  Vector4 get yxzx => new Vector4(_storage3[1], _storage3[0], _storage3[2], _storage3[0]);
  Vector4 get yxzy => new Vector4(_storage3[1], _storage3[0], _storage3[2], _storage3[1]);
  Vector4 get yxzz => new Vector4(_storage3[1], _storage3[0], _storage3[2], _storage3[2]);
  Vector4 get yyxx => new Vector4(_storage3[1], _storage3[1], _storage3[0], _storage3[0]);
  Vector4 get yyxy => new Vector4(_storage3[1], _storage3[1], _storage3[0], _storage3[1]);
  Vector4 get yyxz => new Vector4(_storage3[1], _storage3[1], _storage3[0], _storage3[2]);
  Vector4 get yyyx => new Vector4(_storage3[1], _storage3[1], _storage3[1], _storage3[0]);
  Vector4 get yyyy => new Vector4(_storage3[1], _storage3[1], _storage3[1], _storage3[1]);
  Vector4 get yyyz => new Vector4(_storage3[1], _storage3[1], _storage3[1], _storage3[2]);
  Vector4 get yyzx => new Vector4(_storage3[1], _storage3[1], _storage3[2], _storage3[0]);
  Vector4 get yyzy => new Vector4(_storage3[1], _storage3[1], _storage3[2], _storage3[1]);
  Vector4 get yyzz => new Vector4(_storage3[1], _storage3[1], _storage3[2], _storage3[2]);
  Vector4 get yzxx => new Vector4(_storage3[1], _storage3[2], _storage3[0], _storage3[0]);
  Vector4 get yzxy => new Vector4(_storage3[1], _storage3[2], _storage3[0], _storage3[1]);
  Vector4 get yzxz => new Vector4(_storage3[1], _storage3[2], _storage3[0], _storage3[2]);
  Vector4 get yzyx => new Vector4(_storage3[1], _storage3[2], _storage3[1], _storage3[0]);
  Vector4 get yzyy => new Vector4(_storage3[1], _storage3[2], _storage3[1], _storage3[1]);
  Vector4 get yzyz => new Vector4(_storage3[1], _storage3[2], _storage3[1], _storage3[2]);
  Vector4 get yzzx => new Vector4(_storage3[1], _storage3[2], _storage3[2], _storage3[0]);
  Vector4 get yzzy => new Vector4(_storage3[1], _storage3[2], _storage3[2], _storage3[1]);
  Vector4 get yzzz => new Vector4(_storage3[1], _storage3[2], _storage3[2], _storage3[2]);
  Vector4 get zxxx => new Vector4(_storage3[2], _storage3[0], _storage3[0], _storage3[0]);
  Vector4 get zxxy => new Vector4(_storage3[2], _storage3[0], _storage3[0], _storage3[1]);
  Vector4 get zxxz => new Vector4(_storage3[2], _storage3[0], _storage3[0], _storage3[2]);
  Vector4 get zxyx => new Vector4(_storage3[2], _storage3[0], _storage3[1], _storage3[0]);
  Vector4 get zxyy => new Vector4(_storage3[2], _storage3[0], _storage3[1], _storage3[1]);
  Vector4 get zxyz => new Vector4(_storage3[2], _storage3[0], _storage3[1], _storage3[2]);
  Vector4 get zxzx => new Vector4(_storage3[2], _storage3[0], _storage3[2], _storage3[0]);
  Vector4 get zxzy => new Vector4(_storage3[2], _storage3[0], _storage3[2], _storage3[1]);
  Vector4 get zxzz => new Vector4(_storage3[2], _storage3[0], _storage3[2], _storage3[2]);
  Vector4 get zyxx => new Vector4(_storage3[2], _storage3[1], _storage3[0], _storage3[0]);
  Vector4 get zyxy => new Vector4(_storage3[2], _storage3[1], _storage3[0], _storage3[1]);
  Vector4 get zyxz => new Vector4(_storage3[2], _storage3[1], _storage3[0], _storage3[2]);
  Vector4 get zyyx => new Vector4(_storage3[2], _storage3[1], _storage3[1], _storage3[0]);
  Vector4 get zyyy => new Vector4(_storage3[2], _storage3[1], _storage3[1], _storage3[1]);
  Vector4 get zyyz => new Vector4(_storage3[2], _storage3[1], _storage3[1], _storage3[2]);
  Vector4 get zyzx => new Vector4(_storage3[2], _storage3[1], _storage3[2], _storage3[0]);
  Vector4 get zyzy => new Vector4(_storage3[2], _storage3[1], _storage3[2], _storage3[1]);
  Vector4 get zyzz => new Vector4(_storage3[2], _storage3[1], _storage3[2], _storage3[2]);
  Vector4 get zzxx => new Vector4(_storage3[2], _storage3[2], _storage3[0], _storage3[0]);
  Vector4 get zzxy => new Vector4(_storage3[2], _storage3[2], _storage3[0], _storage3[1]);
  Vector4 get zzxz => new Vector4(_storage3[2], _storage3[2], _storage3[0], _storage3[2]);
  Vector4 get zzyx => new Vector4(_storage3[2], _storage3[2], _storage3[1], _storage3[0]);
  Vector4 get zzyy => new Vector4(_storage3[2], _storage3[2], _storage3[1], _storage3[1]);
  Vector4 get zzyz => new Vector4(_storage3[2], _storage3[2], _storage3[1], _storage3[2]);
  Vector4 get zzzx => new Vector4(_storage3[2], _storage3[2], _storage3[2], _storage3[0]);
  Vector4 get zzzy => new Vector4(_storage3[2], _storage3[2], _storage3[2], _storage3[1]);
  Vector4 get zzzz => new Vector4(_storage3[2], _storage3[2], _storage3[2], _storage3[2]);
  double get r => x;
  double get g => y;
  double get b => z;
  double get s => x;
  double get t => y;
  double get p => z;
  double get x => _storage3[0];
  double get y => _storage3[1];
  double get z => _storage3[2];
  Vector2 get rr => xx;
  Vector2 get rg => xy;
  Vector2 get rb => xz;
  Vector2 get gr => yx;
  Vector2 get gg => yy;
  Vector2 get gb => yz;
  Vector2 get br => zx;
  Vector2 get bg => zy;
  Vector2 get bb => zz;
  Vector3 get rrr => xxx;
  Vector3 get rrg => xxy;
  Vector3 get rrb => xxz;
  Vector3 get rgr => xzx;
  Vector3 get rgg => xyy;
  Vector3 get rgb => xyz;
  Vector3 get rbr => xzx;
  Vector3 get rbg => xzy;
  Vector3 get rbb => xzz;
  Vector3 get grr => yxx;
  Vector3 get grg => yxy;
  Vector3 get grb => yxz;
  Vector3 get ggr => yyx;
  Vector3 get ggg => yyy;
  Vector3 get ggb => yyz;
  Vector3 get gbr => yxz;
  Vector3 get gbg => yzy;
  Vector3 get gbb => yzz;
  Vector3 get brr => zxx;
  Vector3 get brg => zxy;
  Vector3 get brb => zxz;
  Vector3 get bgr => zyx;
  Vector3 get bgg => zyy;
  Vector3 get bgb => zyz;
  Vector3 get bbr => zzx;
  Vector3 get bbg => zzy;
  Vector3 get bbb => zzz;
  Vector4 get rrrr => xxxx;
  Vector4 get rrrg => xxxy;
  Vector4 get rrrb => xxxz;
  Vector4 get rrgr => xxyx;
  Vector4 get rrgg => xxyy;
  Vector4 get rrgb => xxyz;
  Vector4 get rrbr => xxzx;
  Vector4 get rrbg => xxzy;
  Vector4 get rrbb => xxzz;
  Vector4 get rgrr => xyxx;
  Vector4 get rgrg => xyxy;
  Vector4 get rgrb => xyxz;
  Vector4 get rggr => xyyx;
  Vector4 get rggg => xyyy;
  Vector4 get rggb => xyyz;
  Vector4 get rgbr => xyzx;
  Vector4 get rgbg => xyzy;
  Vector4 get rgbb => xyzz;
  Vector4 get rbrr => xzxx;
  Vector4 get rbrg => xzxy;
  Vector4 get rbrb => xzxz;
  Vector4 get rbgr => xzyx;
  Vector4 get rbgg => xzyy;
  Vector4 get rbgb => xzyz;
  Vector4 get rbbr => xzzx;
  Vector4 get rbbg => xzzy;
  Vector4 get rbbb => xzzz;
  Vector4 get grrr => yxxx;
  Vector4 get grrg => yxxy;
  Vector4 get grrb => yxxz;
  Vector4 get grgr => yxyx;
  Vector4 get grgg => yxyy;
  Vector4 get grgb => yxyz;
  Vector4 get grbr => yxzx;
  Vector4 get grbg => yxzy;
  Vector4 get grbb => yxzz;
  Vector4 get ggrr => yyxx;
  Vector4 get ggrg => yyxy;
  Vector4 get ggrb => yyxz;
  Vector4 get gggr => yyyx;
  Vector4 get gggg => yyyy;
  Vector4 get gggb => yyyz;
  Vector4 get ggbr => yyzx;
  Vector4 get ggbg => yyzy;
  Vector4 get ggbb => yyzz;
  Vector4 get gbrr => yzxx;
  Vector4 get gbrg => yzxy;
  Vector4 get gbrb => yzxz;
  Vector4 get gbgr => yzyx;
  Vector4 get gbgg => yzyy;
  Vector4 get gbgb => yzyz;
  Vector4 get gbbr => yzzx;
  Vector4 get gbbg => yzzy;
  Vector4 get gbbb => yzzz;
  Vector4 get brrr => zxxx;
  Vector4 get brrg => zxxy;
  Vector4 get brrb => zxxz;
  Vector4 get brgr => zxyx;
  Vector4 get brgg => zxyy;
  Vector4 get brgb => zxyz;
  Vector4 get brbr => zxzx;
  Vector4 get brbg => zxzy;
  Vector4 get brbb => zxzz;
  Vector4 get bgrr => zyxx;
  Vector4 get bgrg => zyxy;
  Vector4 get bgrb => zyxz;
  Vector4 get bggr => zyyx;
  Vector4 get bggg => zyyy;
  Vector4 get bggb => zyyz;
  Vector4 get bgbr => zyzx;
  Vector4 get bgbg => zyzy;
  Vector4 get bgbb => zyzz;
  Vector4 get bbrr => zzxx;
  Vector4 get bbrg => zzxy;
  Vector4 get bbrb => zzxz;
  Vector4 get bbgr => zzyx;
  Vector4 get bbgg => zzyy;
  Vector4 get bbgb => zzyz;
  Vector4 get bbbr => zzzx;
  Vector4 get bbbg => zzzy;
  Vector4 get bbbb => zzzz;
  Vector2 get ss => xx;
  Vector2 get st => xy;
  Vector2 get sp => xz;
  Vector2 get ts => yx;
  Vector2 get tt => yy;
  Vector2 get tp => yz;
  Vector2 get ps => zx;
  Vector2 get pt => zy;
  Vector2 get pp => zz;
  Vector3 get sss => xxx;
  Vector3 get sst => xxy;
  Vector3 get ssp => xxz;
  Vector3 get sts => xyx;
  Vector3 get stt => xyy;
  Vector3 get stp => xyz;
  Vector3 get sps => xzx;
  Vector3 get spt => xzy;
  Vector3 get spp => xzz;
  Vector3 get tss => yxx;
  Vector3 get tst => yxy;
  Vector3 get tsp => yxz;
  Vector3 get tts => yyx;
  Vector3 get ttt => yyy;
  Vector3 get ttp => yyz;
  Vector3 get tps => yzx;
  Vector3 get tpt => yzy;
  Vector3 get tpp => yzz;
  Vector3 get pss => zxx;
  Vector3 get pst => zxy;
  Vector3 get psp => zxz;
  Vector3 get pts => zyx;
  Vector3 get ptt => zyy;
  Vector3 get ptp => zyz;
  Vector3 get pps => zzx;
  Vector3 get ppt => zzy;
  Vector3 get ppp => zzz;
  Vector4 get ssss => xxxx;
  Vector4 get ssst => xxxy;
  Vector4 get sssp => xxxz;
  Vector4 get ssts => xxyx;
  Vector4 get sstt => xxyy;
  Vector4 get sstp => xxyz;
  Vector4 get ssps => xxzx;
  Vector4 get sspt => xxzy;
  Vector4 get sspp => xxzz;
  Vector4 get stss => xyxx;
  Vector4 get stst => xyxy;
  Vector4 get stsp => xyxz;
  Vector4 get stts => xyyx;
  Vector4 get sttt => xyyy;
  Vector4 get sttp => xyyz;
  Vector4 get stps => xyzx;
  Vector4 get stpt => xyzy;
  Vector4 get stpp => xyzz;
  Vector4 get spss => xzxx;
  Vector4 get spst => xzxy;
  Vector4 get spsp => xzxz;
  Vector4 get spts => xzyx;
  Vector4 get sptt => xzyy;
  Vector4 get sptp => xzyz;
  Vector4 get spps => xzzx;
  Vector4 get sppt => xzzy;
  Vector4 get sppp => xzzz;
  Vector4 get tsss => yxxx;
  Vector4 get tsst => yxxy;
  Vector4 get tssp => yxxz;
  Vector4 get tsts => yxyx;
  Vector4 get tstt => yxyy;
  Vector4 get tstp => yxyz;
  Vector4 get tsps => yxzx;
  Vector4 get tspt => yxzy;
  Vector4 get tspp => yxzz;
  Vector4 get ttss => yyxx;
  Vector4 get ttst => yyxy;
  Vector4 get ttsp => yyxz;
  Vector4 get ttts => yyyx;
  Vector4 get tttt => yyyy;
  Vector4 get tttp => yyyz;
  Vector4 get ttps => yyzx;
  Vector4 get ttpt => yyzy;
  Vector4 get ttpp => yyzz;
  Vector4 get tpss => yzxx;
  Vector4 get tpst => yzxy;
  Vector4 get tpsp => yzxz;
  Vector4 get tpts => yzyx;
  Vector4 get tptt => yzyy;
  Vector4 get tptp => yzyz;
  Vector4 get tpps => yzzx;
  Vector4 get tppt => yzzy;
  Vector4 get tppp => yzzz;
  Vector4 get psss => zxxx;
  Vector4 get psst => zxxy;
  Vector4 get pssp => zxxz;
  Vector4 get psts => zxyx;
  Vector4 get pstt => zxyy;
  Vector4 get pstp => zxyz;
  Vector4 get psps => zxzx;
  Vector4 get pspt => zxzy;
  Vector4 get pspp => zxzz;
  Vector4 get ptss => zyxx;
  Vector4 get ptst => zyxy;
  Vector4 get ptsp => zyxz;
  Vector4 get ptts => zyyx;
  Vector4 get pttt => zyyy;
  Vector4 get pttp => zyyz;
  Vector4 get ptps => zyzx;
  Vector4 get ptpt => zyzy;
  Vector4 get ptpp => zyzz;
  Vector4 get ppss => zzxx;
  Vector4 get ppst => zzxy;
  Vector4 get ppsp => zzxz;
  Vector4 get ppts => zzyx;
  Vector4 get pptt => zzyy;
  Vector4 get pptp => zzyz;
  Vector4 get ppps => zzzx;
  Vector4 get pppt => zzzy;
  Vector4 get pppp => zzzz;
}
