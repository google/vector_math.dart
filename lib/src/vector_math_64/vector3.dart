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

//TODO (fox32): Update documentation comments!

/// 3D column vector.
class Vector3 {
  final Float64List _storage;

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
  Float64List get storage => _storage;

  /// Construct a new vector with the specified values.
  Vector3(double x, double y, double z)
      : _storage = new Float64List(3) {
    setValues(x, y, z);
  }

  /// Initialized with values from [array] starting at [offset].
  Vector3.array(List<double> array, [int offset = 0])
      : _storage = new Float64List(3) {
    int i = offset;
    storage[2] = array[i + 2];
    storage[1] = array[i + 1];
    storage[0] = array[i + 0];
  }

  /// Zero vector.
  Vector3.zero()
      : _storage = new Float64List(3);

  /// Splat [value] into all lanes of the vector.
  Vector3.all(double value)
      : this(value, value, value);

  /// Copy of [other].
  Vector3.copy(Vector3 other)
      : _storage = new Float64List(3) {
    setFrom(other);
  }

  /// Constructs Vector3 with given Float64List as [storage].
  Vector3.fromFloat64List(this._storage);

  /// Constructs Vector3 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float64List.BYTES_PER_ELEMENT].
  Vector3.fromBuffer(ByteBuffer buffer, int offset)
      : _storage = new Float64List.view(buffer, offset, 3);

  /// Set the values of the vector.
  void setValues(double x, double y, double z) {
    _storage[0] = x;
    _storage[1] = y;
    _storage[2] = z;
  }

  /// Zero vector.
  void setZero() {
    _storage[2] = 0.0;
    _storage[1] = 0.0;
    _storage[0] = 0.0;
  }

  /// Set the values by copying them from [other].
  void setFrom(Vector3 other) {
    final otherStorage = other._storage;

    _storage[0] = otherStorage[0];
    _storage[1] = otherStorage[1];
    _storage[2] = otherStorage[2];
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(double arg) {
    _storage[2] = arg;
    _storage[1] = arg;
    _storage[0] = arg;
  }

  /// Returns a printable string
  String toString() => '[${_storage[0]},${_storage[1]},${_storage[2]}]';

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
  double operator [](int i) => _storage[i];

  /// Set the component of the vector at the index [i].
  void operator []=(int i, double v) {
    _storage[i] = v;
  }

  /// Length.
  double get length => Math.sqrt(length2);

  /// Length squared.
  double get length2 {
    var sum;
    sum = (_storage[0] * _storage[0]);
    sum += (_storage[1] * _storage[1]);
    sum += (_storage[2] * _storage[2]);
    return sum;
  }

  /// Normalizes [this].
  void normalize() {
    var l = length;
    if (l == 0.0) {
      return;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    _storage[2] *= l;
  }

  /// Normalize [this]. Returns length of vector before normalization.
  double normalizeLength() {
    var l = length;
    if (l == 0.0) {
      return 0.0;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
    _storage[2] *= l;
    return l;
  }

  /// Normalizes copy of [this].
  Vector3 normalized() => new Vector3.copy(this)..normalize();

  /// Normalize vector into [out].
  Vector3 normalizeInto(Vector3 out) {
    //TODO (fox32): Remove this method?
    out.setFrom(this);
    return out..normalize();
  }

  /// Distance from [this] to [arg]
  double distanceTo(Vector3 arg) => (clone()..sub(arg)).length;

  /// Squared distance from [this] to [arg]
  double distanceToSquared(Vector3 arg) => (clone()..sub(arg)).length2;

  /// Inner product.
  double dot(Vector3 other) {
    final otherStorage = other._storage;
    var sum;
    sum = _storage[0] * otherStorage[0];
    sum += _storage[1] * otherStorage[1];
    sum += _storage[2] * otherStorage[2];
    return sum;
  }

  /// Transforms [this] into the product of [this] as a row vector,
  /// postmultiplied by matrix, [arg].
  /// If [arg] is a rotation matrix, this is a computational shortcut for applying,
  /// the inverse of the transformation.
  ///
  void postmultiply(Matrix3 arg) {
    final argStorage = arg.storage;
    final v0 = _storage[0];
    final v1 = _storage[1];
    final v2 = _storage[2];

    _storage[0] = v0 * argStorage[0] + v1 * argStorage[1] + v2 * argStorage[2];
    _storage[1] = v0 * argStorage[3] + v1 * argStorage[4] + v2 * argStorage[5];
    _storage[2] = v0 * argStorage[6] + v1 * argStorage[7] + v2 * argStorage[8];
  }

  /// Cross product.
  Vector3 cross(Vector3 other) {
    final _x = _storage[0];
    final _y = _storage[1];
    final _z = _storage[2];
    final otherStorage = other._storage;
    final ox = otherStorage[0];
    final oy = otherStorage[1];
    final oz = otherStorage[2];
    return new Vector3(_y * oz - _z * oy, _z * ox - _x * oz, _x * oy - _y * ox);
  }

  /// Cross product. Stores result in [out].
  Vector3 crossInto(Vector3 other, Vector3 out) {
    final x = _storage[0];
    final y = _storage[1];
    final z = _storage[2];
    final otherStorage = other._storage;
    final ox = otherStorage[0];
    final oy = otherStorage[1];
    final oz = otherStorage[2];
    final outStorage = out._storage;
    outStorage[0] = y * oz - z * oy;
    outStorage[1] = z * ox - x * oz;
    outStorage[2] = x * oy - y * ox;
    return out; //TODO (fox32): Remove return type?
  }

  /// Reflect [this].
  void reflect(Vector3 normal) {
    sub(normal.scaled(2.0 * normal.dot(this)));
  }

  /// Reflected copy of [this].
  Vector3 reflected(Vector3 normal) => clone()..reflect(normal);

  /// Projects [this] using the projection matrix [arg]
  void applyProjection(Matrix4 arg) {
    final argStorage = arg.storage;
    final x = _storage[0];
    final y = _storage[1];
    final z = _storage[2];
    final d = 1.0 / (argStorage[3] * x + argStorage[7] * y + argStorage[11] * z
        + argStorage[15]);
    _storage[0] = (argStorage[0] * x + argStorage[4] * y + argStorage[8] * z +
        argStorage[12]) * d;
    _storage[1] = (argStorage[1] * x + argStorage[5] * y + argStorage[9] * z +
        argStorage[13]) * d;
    _storage[2] = (argStorage[2] * x + argStorage[6] * y + argStorage[10] * z +
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
    is_infinite = is_infinite || _storage[0].isInfinite;
    is_infinite = is_infinite || _storage[1].isInfinite;
    is_infinite = is_infinite || _storage[2].isInfinite;
    return is_infinite;
  }

  /// True if any component is NaN.
  bool get isNaN {
    var is_nan = false;
    is_nan = is_nan || _storage[0].isNaN;
    is_nan = is_nan || _storage[1].isNaN;
    is_nan = is_nan || _storage[2].isNaN;
    return is_nan;
  }

  /// Add [arg] to [this].
  void add(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] + argStorage[0];
    _storage[1] = _storage[1] + argStorage[1];
    _storage[2] = _storage[2] + argStorage[2];
  }

  /// Add [arg] scaled by [factor] to [this].
  void addScaled(Vector3 arg, double factor) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] + argStorage[0] * factor;
    _storage[1] = _storage[1] + argStorage[1] * factor;
    _storage[2] = _storage[2] + argStorage[2] * factor;
  }

  /// Subtract [arg] from [this].
  void sub(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] - argStorage[0];
    _storage[1] = _storage[1] - argStorage[1];
    _storage[2] = _storage[2] - argStorage[2];
  }

  /// Multiply entries in [this] with entries in [arg].
  void multiply(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] * argStorage[0];
    _storage[1] = _storage[1] * argStorage[1];
    _storage[2] = _storage[2] * argStorage[2];
  }

  /// Divide entries in [this] with entries in [arg].
  void divide(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] / argStorage[0];
    _storage[1] = _storage[1] / argStorage[1];
    _storage[2] = _storage[2] / argStorage[2];
  }

  /// Scale [this].
  void scale(double arg) {
    _storage[2] = _storage[2] * arg;
    _storage[1] = _storage[1] * arg;
    _storage[0] = _storage[0] * arg;
  }

  Vector3 scaled(double arg) => clone()..scale(arg);

  void negate() {
    _storage[2] = -_storage[2];
    _storage[1] = -_storage[1];
    _storage[0] = -_storage[0];
  }

  /// Absolute value.
  void absolute() {
    _storage[0] = _storage[0].abs();
    _storage[1] = _storage[1].abs();
    _storage[2] = _storage[2].abs();
  }

  /// Clone of [this].
  Vector3 clone() => new Vector3.copy(this);

  Vector3 copyInto(Vector3 arg) {
    final argStorage = arg._storage;
    argStorage[0] = _storage[0];
    argStorage[1] = _storage[1];
    argStorage[2] = _storage[2];
    return arg; //TODO (fox32): Remove return value?
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset = 0]) {
    array[offset + 2] = _storage[2];
    array[offset + 1] = _storage[1];
    array[offset + 0] = _storage[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    _storage[2] = array[offset + 2];
    _storage[1] = array[offset + 1];
    _storage[0] = array[offset + 0];
  }

  set xy(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set xz(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[2] = argStorage[1];
  }
  set yx(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set yz(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[2] = argStorage[1];
  }
  set zx(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set zy(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set xyz(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
    _storage[2] = argStorage[2];
  }
  set xzy(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[2] = argStorage[1];
    _storage[1] = argStorage[2];
  }
  set yxz(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
    _storage[2] = argStorage[2];
  }
  set yzx(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[2] = argStorage[1];
    _storage[0] = argStorage[2];
  }
  set zxy(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[0] = argStorage[1];
    _storage[1] = argStorage[2];
  }
  set zyx(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[1] = argStorage[1];
    _storage[0] = argStorage[2];
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
  set rg(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set rb(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[2] = argStorage[1];
  }
  set gr(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set gb(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[2] = argStorage[1];
  }
  set br(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set bg(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set rgb(Vector3 arg) {
    final argStorage = arg.storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
    _storage[2] = argStorage[2];
  }
  set rbg(Vector3 arg) {
    final argStorage = arg.storage;
    _storage[0] = argStorage[0];
    _storage[2] = argStorage[1];
    _storage[1] = argStorage[2];
  }
  set grb(Vector3 arg) {
    final argStorage = arg.storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
    _storage[2] = argStorage[2];
  }
  set gbr(Vector3 arg) {
    final argStorage = arg.storage;
    _storage[1] = argStorage[0];
    _storage[2] = argStorage[1];
    _storage[0] = argStorage[2];
  }
  set brg(Vector3 arg) {
    final argStorage = arg.storage;
    _storage[2] = argStorage[0];
    _storage[0] = argStorage[1];
    _storage[1] = argStorage[2];
  }
  set bgr(Vector3 arg) {
    final argStorage = arg.storage;
    _storage[2] = argStorage[0];
    _storage[1] = argStorage[1];
    _storage[0] = argStorage[2];
  }
  set st(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set sp(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[2] = argStorage[1];
  }
  set ts(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set tp(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[2] = argStorage[1];
  }
  set ps(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set pt(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set stp(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
    _storage[2] = argStorage[2];
  }
  set spt(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[2] = argStorage[1];
    _storage[1] = argStorage[2];
  }
  set tsp(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
    _storage[2] = argStorage[2];
  }
  set tps(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[2] = argStorage[1];
    _storage[0] = argStorage[2];
  }
  set pst(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[0] = argStorage[1];
    _storage[1] = argStorage[2];
  }
  set pts(Vector3 arg) {
    final argStorage = arg._storage;
    _storage[2] = argStorage[0];
    _storage[1] = argStorage[1];
    _storage[0] = argStorage[2];
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
  Vector4 get xxxx => new Vector4(storage[0], storage[0], storage[0], storage[0]
      );
  Vector4 get xxxy => new Vector4(storage[0], storage[0], storage[0], storage[1]
      );
  Vector4 get xxxz => new Vector4(storage[0], storage[0], storage[0], storage[2]
      );
  Vector4 get xxyx => new Vector4(storage[0], storage[0], storage[1], storage[0]
      );
  Vector4 get xxyy => new Vector4(storage[0], storage[0], storage[1], storage[1]
      );
  Vector4 get xxyz => new Vector4(storage[0], storage[0], storage[1], storage[2]
      );
  Vector4 get xxzx => new Vector4(storage[0], storage[0], storage[2], storage[0]
      );
  Vector4 get xxzy => new Vector4(storage[0], storage[0], storage[2], storage[1]
      );
  Vector4 get xxzz => new Vector4(storage[0], storage[0], storage[2], storage[2]
      );
  Vector4 get xyxx => new Vector4(storage[0], storage[1], storage[0], storage[0]
      );
  Vector4 get xyxy => new Vector4(storage[0], storage[1], storage[0], storage[1]
      );
  Vector4 get xyxz => new Vector4(storage[0], storage[1], storage[0], storage[2]
      );
  Vector4 get xyyx => new Vector4(storage[0], storage[1], storage[1], storage[0]
      );
  Vector4 get xyyy => new Vector4(storage[0], storage[1], storage[1], storage[1]
      );
  Vector4 get xyyz => new Vector4(storage[0], storage[1], storage[1], storage[2]
      );
  Vector4 get xyzx => new Vector4(storage[0], storage[1], storage[2], storage[0]
      );
  Vector4 get xyzy => new Vector4(storage[0], storage[1], storage[2], storage[1]
      );
  Vector4 get xyzz => new Vector4(storage[0], storage[1], storage[2], storage[2]
      );
  Vector4 get xzxx => new Vector4(storage[0], storage[2], storage[0], storage[0]
      );
  Vector4 get xzxy => new Vector4(storage[0], storage[2], storage[0], storage[1]
      );
  Vector4 get xzxz => new Vector4(storage[0], storage[2], storage[0], storage[2]
      );
  Vector4 get xzyx => new Vector4(storage[0], storage[2], storage[1], storage[0]
      );
  Vector4 get xzyy => new Vector4(storage[0], storage[2], storage[1], storage[1]
      );
  Vector4 get xzyz => new Vector4(storage[0], storage[2], storage[1], storage[2]
      );
  Vector4 get xzzx => new Vector4(storage[0], storage[2], storage[2], storage[0]
      );
  Vector4 get xzzy => new Vector4(storage[0], storage[2], storage[2], storage[1]
      );
  Vector4 get xzzz => new Vector4(storage[0], storage[2], storage[2], storage[2]
      );
  Vector4 get yxxx => new Vector4(storage[1], storage[0], storage[0], storage[0]
      );
  Vector4 get yxxy => new Vector4(storage[1], storage[0], storage[0], storage[1]
      );
  Vector4 get yxxz => new Vector4(storage[1], storage[0], storage[0], storage[2]
      );
  Vector4 get yxyx => new Vector4(storage[1], storage[0], storage[1], storage[0]
      );
  Vector4 get yxyy => new Vector4(storage[1], storage[0], storage[1], storage[1]
      );
  Vector4 get yxyz => new Vector4(storage[1], storage[0], storage[1], storage[2]
      );
  Vector4 get yxzx => new Vector4(storage[1], storage[0], storage[2], storage[0]
      );
  Vector4 get yxzy => new Vector4(storage[1], storage[0], storage[2], storage[1]
      );
  Vector4 get yxzz => new Vector4(storage[1], storage[0], storage[2], storage[2]
      );
  Vector4 get yyxx => new Vector4(storage[1], storage[1], storage[0], storage[0]
      );
  Vector4 get yyxy => new Vector4(storage[1], storage[1], storage[0], storage[1]
      );
  Vector4 get yyxz => new Vector4(storage[1], storage[1], storage[0], storage[2]
      );
  Vector4 get yyyx => new Vector4(storage[1], storage[1], storage[1], storage[0]
      );
  Vector4 get yyyy => new Vector4(storage[1], storage[1], storage[1], storage[1]
      );
  Vector4 get yyyz => new Vector4(storage[1], storage[1], storage[1], storage[2]
      );
  Vector4 get yyzx => new Vector4(storage[1], storage[1], storage[2], storage[0]
      );
  Vector4 get yyzy => new Vector4(storage[1], storage[1], storage[2], storage[1]
      );
  Vector4 get yyzz => new Vector4(storage[1], storage[1], storage[2], storage[2]
      );
  Vector4 get yzxx => new Vector4(storage[1], storage[2], storage[0], storage[0]
      );
  Vector4 get yzxy => new Vector4(storage[1], storage[2], storage[0], storage[1]
      );
  Vector4 get yzxz => new Vector4(storage[1], storage[2], storage[0], storage[2]
      );
  Vector4 get yzyx => new Vector4(storage[1], storage[2], storage[1], storage[0]
      );
  Vector4 get yzyy => new Vector4(storage[1], storage[2], storage[1], storage[1]
      );
  Vector4 get yzyz => new Vector4(storage[1], storage[2], storage[1], storage[2]
      );
  Vector4 get yzzx => new Vector4(storage[1], storage[2], storage[2], storage[0]
      );
  Vector4 get yzzy => new Vector4(storage[1], storage[2], storage[2], storage[1]
      );
  Vector4 get yzzz => new Vector4(storage[1], storage[2], storage[2], storage[2]
      );
  Vector4 get zxxx => new Vector4(storage[2], storage[0], storage[0], storage[0]
      );
  Vector4 get zxxy => new Vector4(storage[2], storage[0], storage[0], storage[1]
      );
  Vector4 get zxxz => new Vector4(storage[2], storage[0], storage[0], storage[2]
      );
  Vector4 get zxyx => new Vector4(storage[2], storage[0], storage[1], storage[0]
      );
  Vector4 get zxyy => new Vector4(storage[2], storage[0], storage[1], storage[1]
      );
  Vector4 get zxyz => new Vector4(storage[2], storage[0], storage[1], storage[2]
      );
  Vector4 get zxzx => new Vector4(storage[2], storage[0], storage[2], storage[0]
      );
  Vector4 get zxzy => new Vector4(storage[2], storage[0], storage[2], storage[1]
      );
  Vector4 get zxzz => new Vector4(storage[2], storage[0], storage[2], storage[2]
      );
  Vector4 get zyxx => new Vector4(storage[2], storage[1], storage[0], storage[0]
      );
  Vector4 get zyxy => new Vector4(storage[2], storage[1], storage[0], storage[1]
      );
  Vector4 get zyxz => new Vector4(storage[2], storage[1], storage[0], storage[2]
      );
  Vector4 get zyyx => new Vector4(storage[2], storage[1], storage[1], storage[0]
      );
  Vector4 get zyyy => new Vector4(storage[2], storage[1], storage[1], storage[1]
      );
  Vector4 get zyyz => new Vector4(storage[2], storage[1], storage[1], storage[2]
      );
  Vector4 get zyzx => new Vector4(storage[2], storage[1], storage[2], storage[0]
      );
  Vector4 get zyzy => new Vector4(storage[2], storage[1], storage[2], storage[1]
      );
  Vector4 get zyzz => new Vector4(storage[2], storage[1], storage[2], storage[2]
      );
  Vector4 get zzxx => new Vector4(storage[2], storage[2], storage[0], storage[0]
      );
  Vector4 get zzxy => new Vector4(storage[2], storage[2], storage[0], storage[1]
      );
  Vector4 get zzxz => new Vector4(storage[2], storage[2], storage[0], storage[2]
      );
  Vector4 get zzyx => new Vector4(storage[2], storage[2], storage[1], storage[0]
      );
  Vector4 get zzyy => new Vector4(storage[2], storage[2], storage[1], storage[1]
      );
  Vector4 get zzyz => new Vector4(storage[2], storage[2], storage[1], storage[2]
      );
  Vector4 get zzzx => new Vector4(storage[2], storage[2], storage[2], storage[0]
      );
  Vector4 get zzzy => new Vector4(storage[2], storage[2], storage[2], storage[1]
      );
  Vector4 get zzzz => new Vector4(storage[2], storage[2], storage[2], storage[2]
      );
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
  Vector4 get rrrr => new Vector4(storage[0], storage[0], storage[0], storage[0]
      );
  Vector4 get rrrg => new Vector4(storage[0], storage[0], storage[0], storage[1]
      );
  Vector4 get rrrb => new Vector4(storage[0], storage[0], storage[0], storage[2]
      );
  Vector4 get rrgr => new Vector4(storage[0], storage[0], storage[1], storage[0]
      );
  Vector4 get rrgg => new Vector4(storage[0], storage[0], storage[1], storage[1]
      );
  Vector4 get rrgb => new Vector4(storage[0], storage[0], storage[1], storage[2]
      );
  Vector4 get rrbr => new Vector4(storage[0], storage[0], storage[2], storage[0]
      );
  Vector4 get rrbg => new Vector4(storage[0], storage[0], storage[2], storage[1]
      );
  Vector4 get rrbb => new Vector4(storage[0], storage[0], storage[2], storage[2]
      );
  Vector4 get rgrr => new Vector4(storage[0], storage[1], storage[0], storage[0]
      );
  Vector4 get rgrg => new Vector4(storage[0], storage[1], storage[0], storage[1]
      );
  Vector4 get rgrb => new Vector4(storage[0], storage[1], storage[0], storage[2]
      );
  Vector4 get rggr => new Vector4(storage[0], storage[1], storage[1], storage[0]
      );
  Vector4 get rggg => new Vector4(storage[0], storage[1], storage[1], storage[1]
      );
  Vector4 get rggb => new Vector4(storage[0], storage[1], storage[1], storage[2]
      );
  Vector4 get rgbr => new Vector4(storage[0], storage[1], storage[2], storage[0]
      );
  Vector4 get rgbg => new Vector4(storage[0], storage[1], storage[2], storage[1]
      );
  Vector4 get rgbb => new Vector4(storage[0], storage[1], storage[2], storage[2]
      );
  Vector4 get rbrr => new Vector4(storage[0], storage[2], storage[0], storage[0]
      );
  Vector4 get rbrg => new Vector4(storage[0], storage[2], storage[0], storage[1]
      );
  Vector4 get rbrb => new Vector4(storage[0], storage[2], storage[0], storage[2]
      );
  Vector4 get rbgr => new Vector4(storage[0], storage[2], storage[1], storage[0]
      );
  Vector4 get rbgg => new Vector4(storage[0], storage[2], storage[1], storage[1]
      );
  Vector4 get rbgb => new Vector4(storage[0], storage[2], storage[1], storage[2]
      );
  Vector4 get rbbr => new Vector4(storage[0], storage[2], storage[2], storage[0]
      );
  Vector4 get rbbg => new Vector4(storage[0], storage[2], storage[2], storage[1]
      );
  Vector4 get rbbb => new Vector4(storage[0], storage[2], storage[2], storage[2]
      );
  Vector4 get grrr => new Vector4(storage[1], storage[0], storage[0], storage[0]
      );
  Vector4 get grrg => new Vector4(storage[1], storage[0], storage[0], storage[1]
      );
  Vector4 get grrb => new Vector4(storage[1], storage[0], storage[0], storage[2]
      );
  Vector4 get grgr => new Vector4(storage[1], storage[0], storage[1], storage[0]
      );
  Vector4 get grgg => new Vector4(storage[1], storage[0], storage[1], storage[1]
      );
  Vector4 get grgb => new Vector4(storage[1], storage[0], storage[1], storage[2]
      );
  Vector4 get grbr => new Vector4(storage[1], storage[0], storage[2], storage[0]
      );
  Vector4 get grbg => new Vector4(storage[1], storage[0], storage[2], storage[1]
      );
  Vector4 get grbb => new Vector4(storage[1], storage[0], storage[2], storage[2]
      );
  Vector4 get ggrr => new Vector4(storage[1], storage[1], storage[0], storage[0]
      );
  Vector4 get ggrg => new Vector4(storage[1], storage[1], storage[0], storage[1]
      );
  Vector4 get ggrb => new Vector4(storage[1], storage[1], storage[0], storage[2]
      );
  Vector4 get gggr => new Vector4(storage[1], storage[1], storage[1], storage[0]
      );
  Vector4 get gggg => new Vector4(storage[1], storage[1], storage[1], storage[1]
      );
  Vector4 get gggb => new Vector4(storage[1], storage[1], storage[1], storage[2]
      );
  Vector4 get ggbr => new Vector4(storage[1], storage[1], storage[2], storage[0]
      );
  Vector4 get ggbg => new Vector4(storage[1], storage[1], storage[2], storage[1]
      );
  Vector4 get ggbb => new Vector4(storage[1], storage[1], storage[2], storage[2]
      );
  Vector4 get gbrr => new Vector4(storage[1], storage[2], storage[0], storage[0]
      );
  Vector4 get gbrg => new Vector4(storage[1], storage[2], storage[0], storage[1]
      );
  Vector4 get gbrb => new Vector4(storage[1], storage[2], storage[0], storage[2]
      );
  Vector4 get gbgr => new Vector4(storage[1], storage[2], storage[1], storage[0]
      );
  Vector4 get gbgg => new Vector4(storage[1], storage[2], storage[1], storage[1]
      );
  Vector4 get gbgb => new Vector4(storage[1], storage[2], storage[1], storage[2]
      );
  Vector4 get gbbr => new Vector4(storage[1], storage[2], storage[2], storage[0]
      );
  Vector4 get gbbg => new Vector4(storage[1], storage[2], storage[2], storage[1]
      );
  Vector4 get gbbb => new Vector4(storage[1], storage[2], storage[2], storage[2]
      );
  Vector4 get brrr => new Vector4(storage[2], storage[0], storage[0], storage[0]
      );
  Vector4 get brrg => new Vector4(storage[2], storage[0], storage[0], storage[1]
      );
  Vector4 get brrb => new Vector4(storage[2], storage[0], storage[0], storage[2]
      );
  Vector4 get brgr => new Vector4(storage[2], storage[0], storage[1], storage[0]
      );
  Vector4 get brgg => new Vector4(storage[2], storage[0], storage[1], storage[1]
      );
  Vector4 get brgb => new Vector4(storage[2], storage[0], storage[1], storage[2]
      );
  Vector4 get brbr => new Vector4(storage[2], storage[0], storage[2], storage[0]
      );
  Vector4 get brbg => new Vector4(storage[2], storage[0], storage[2], storage[1]
      );
  Vector4 get brbb => new Vector4(storage[2], storage[0], storage[2], storage[2]
      );
  Vector4 get bgrr => new Vector4(storage[2], storage[1], storage[0], storage[0]
      );
  Vector4 get bgrg => new Vector4(storage[2], storage[1], storage[0], storage[1]
      );
  Vector4 get bgrb => new Vector4(storage[2], storage[1], storage[0], storage[2]
      );
  Vector4 get bggr => new Vector4(storage[2], storage[1], storage[1], storage[0]
      );
  Vector4 get bggg => new Vector4(storage[2], storage[1], storage[1], storage[1]
      );
  Vector4 get bggb => new Vector4(storage[2], storage[1], storage[1], storage[2]
      );
  Vector4 get bgbr => new Vector4(storage[2], storage[1], storage[2], storage[0]
      );
  Vector4 get bgbg => new Vector4(storage[2], storage[1], storage[2], storage[1]
      );
  Vector4 get bgbb => new Vector4(storage[2], storage[1], storage[2], storage[2]
      );
  Vector4 get bbrr => new Vector4(storage[2], storage[2], storage[0], storage[0]
      );
  Vector4 get bbrg => new Vector4(storage[2], storage[2], storage[0], storage[1]
      );
  Vector4 get bbrb => new Vector4(storage[2], storage[2], storage[0], storage[2]
      );
  Vector4 get bbgr => new Vector4(storage[2], storage[2], storage[1], storage[0]
      );
  Vector4 get bbgg => new Vector4(storage[2], storage[2], storage[1], storage[1]
      );
  Vector4 get bbgb => new Vector4(storage[2], storage[2], storage[1], storage[2]
      );
  Vector4 get bbbr => new Vector4(storage[2], storage[2], storage[2], storage[0]
      );
  Vector4 get bbbg => new Vector4(storage[2], storage[2], storage[2], storage[1]
      );
  Vector4 get bbbb => new Vector4(storage[2], storage[2], storage[2], storage[2]
      );
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
  Vector4 get ssss => new Vector4(storage[0], storage[0], storage[0], storage[0]
      );
  Vector4 get ssst => new Vector4(storage[0], storage[0], storage[0], storage[1]
      );
  Vector4 get sssp => new Vector4(storage[0], storage[0], storage[0], storage[2]
      );
  Vector4 get ssts => new Vector4(storage[0], storage[0], storage[1], storage[0]
      );
  Vector4 get sstt => new Vector4(storage[0], storage[0], storage[1], storage[1]
      );
  Vector4 get sstp => new Vector4(storage[0], storage[0], storage[1], storage[2]
      );
  Vector4 get ssps => new Vector4(storage[0], storage[0], storage[2], storage[0]
      );
  Vector4 get sspt => new Vector4(storage[0], storage[0], storage[2], storage[1]
      );
  Vector4 get sspp => new Vector4(storage[0], storage[0], storage[2], storage[2]
      );
  Vector4 get stss => new Vector4(storage[0], storage[1], storage[0], storage[0]
      );
  Vector4 get stst => new Vector4(storage[0], storage[1], storage[0], storage[1]
      );
  Vector4 get stsp => new Vector4(storage[0], storage[1], storage[0], storage[2]
      );
  Vector4 get stts => new Vector4(storage[0], storage[1], storage[1], storage[0]
      );
  Vector4 get sttt => new Vector4(storage[0], storage[1], storage[1], storage[1]
      );
  Vector4 get sttp => new Vector4(storage[0], storage[1], storage[1], storage[2]
      );
  Vector4 get stps => new Vector4(storage[0], storage[1], storage[2], storage[0]
      );
  Vector4 get stpt => new Vector4(storage[0], storage[1], storage[2], storage[1]
      );
  Vector4 get stpp => new Vector4(storage[0], storage[1], storage[2], storage[2]
      );
  Vector4 get spss => new Vector4(storage[0], storage[2], storage[0], storage[0]
      );
  Vector4 get spst => new Vector4(storage[0], storage[2], storage[0], storage[1]
      );
  Vector4 get spsp => new Vector4(storage[0], storage[2], storage[0], storage[2]
      );
  Vector4 get spts => new Vector4(storage[0], storage[2], storage[1], storage[0]
      );
  Vector4 get sptt => new Vector4(storage[0], storage[2], storage[1], storage[1]
      );
  Vector4 get sptp => new Vector4(storage[0], storage[2], storage[1], storage[2]
      );
  Vector4 get spps => new Vector4(storage[0], storage[2], storage[2], storage[0]
      );
  Vector4 get sppt => new Vector4(storage[0], storage[2], storage[2], storage[1]
      );
  Vector4 get sppp => new Vector4(storage[0], storage[2], storage[2], storage[2]
      );
  Vector4 get tsss => new Vector4(storage[1], storage[0], storage[0], storage[0]
      );
  Vector4 get tsst => new Vector4(storage[1], storage[0], storage[0], storage[1]
      );
  Vector4 get tssp => new Vector4(storage[1], storage[0], storage[0], storage[2]
      );
  Vector4 get tsts => new Vector4(storage[1], storage[0], storage[1], storage[0]
      );
  Vector4 get tstt => new Vector4(storage[1], storage[0], storage[1], storage[1]
      );
  Vector4 get tstp => new Vector4(storage[1], storage[0], storage[1], storage[2]
      );
  Vector4 get tsps => new Vector4(storage[1], storage[0], storage[2], storage[0]
      );
  Vector4 get tspt => new Vector4(storage[1], storage[0], storage[2], storage[1]
      );
  Vector4 get tspp => new Vector4(storage[1], storage[0], storage[2], storage[2]
      );
  Vector4 get ttss => new Vector4(storage[1], storage[1], storage[0], storage[0]
      );
  Vector4 get ttst => new Vector4(storage[1], storage[1], storage[0], storage[1]
      );
  Vector4 get ttsp => new Vector4(storage[1], storage[1], storage[0], storage[2]
      );
  Vector4 get ttts => new Vector4(storage[1], storage[1], storage[1], storage[0]
      );
  Vector4 get tttt => new Vector4(storage[1], storage[1], storage[1], storage[1]
      );
  Vector4 get tttp => new Vector4(storage[1], storage[1], storage[1], storage[2]
      );
  Vector4 get ttps => new Vector4(storage[1], storage[1], storage[2], storage[0]
      );
  Vector4 get ttpt => new Vector4(storage[1], storage[1], storage[2], storage[1]
      );
  Vector4 get ttpp => new Vector4(storage[1], storage[1], storage[2], storage[2]
      );
  Vector4 get tpss => new Vector4(storage[1], storage[2], storage[0], storage[0]
      );
  Vector4 get tpst => new Vector4(storage[1], storage[2], storage[0], storage[1]
      );
  Vector4 get tpsp => new Vector4(storage[1], storage[2], storage[0], storage[2]
      );
  Vector4 get tpts => new Vector4(storage[1], storage[2], storage[1], storage[0]
      );
  Vector4 get tptt => new Vector4(storage[1], storage[2], storage[1], storage[1]
      );
  Vector4 get tptp => new Vector4(storage[1], storage[2], storage[1], storage[2]
      );
  Vector4 get tpps => new Vector4(storage[1], storage[2], storage[2], storage[0]
      );
  Vector4 get tppt => new Vector4(storage[1], storage[2], storage[2], storage[1]
      );
  Vector4 get tppp => new Vector4(storage[1], storage[2], storage[2], storage[2]
      );
  Vector4 get psss => new Vector4(storage[2], storage[0], storage[0], storage[0]
      );
  Vector4 get psst => new Vector4(storage[2], storage[0], storage[0], storage[1]
      );
  Vector4 get pssp => new Vector4(storage[2], storage[0], storage[0], storage[2]
      );
  Vector4 get psts => new Vector4(storage[2], storage[0], storage[1], storage[0]
      );
  Vector4 get pstt => new Vector4(storage[2], storage[0], storage[1], storage[1]
      );
  Vector4 get pstp => new Vector4(storage[2], storage[0], storage[1], storage[2]
      );
  Vector4 get psps => new Vector4(storage[2], storage[0], storage[2], storage[0]
      );
  Vector4 get pspt => new Vector4(storage[2], storage[0], storage[2], storage[1]
      );
  Vector4 get pspp => new Vector4(storage[2], storage[0], storage[2], storage[2]
      );
  Vector4 get ptss => new Vector4(storage[2], storage[1], storage[0], storage[0]
      );
  Vector4 get ptst => new Vector4(storage[2], storage[1], storage[0], storage[1]
      );
  Vector4 get ptsp => new Vector4(storage[2], storage[1], storage[0], storage[2]
      );
  Vector4 get ptts => new Vector4(storage[2], storage[1], storage[1], storage[0]
      );
  Vector4 get pttt => new Vector4(storage[2], storage[1], storage[1], storage[1]
      );
  Vector4 get pttp => new Vector4(storage[2], storage[1], storage[1], storage[2]
      );
  Vector4 get ptps => new Vector4(storage[2], storage[1], storage[2], storage[0]
      );
  Vector4 get ptpt => new Vector4(storage[2], storage[1], storage[2], storage[1]
      );
  Vector4 get ptpp => new Vector4(storage[2], storage[1], storage[2], storage[2]
      );
  Vector4 get ppss => new Vector4(storage[2], storage[2], storage[0], storage[0]
      );
  Vector4 get ppst => new Vector4(storage[2], storage[2], storage[0], storage[1]
      );
  Vector4 get ppsp => new Vector4(storage[2], storage[2], storage[0], storage[2]
      );
  Vector4 get ppts => new Vector4(storage[2], storage[2], storage[1], storage[0]
      );
  Vector4 get pptt => new Vector4(storage[2], storage[2], storage[1], storage[1]
      );
  Vector4 get pptp => new Vector4(storage[2], storage[2], storage[1], storage[2]
      );
  Vector4 get ppps => new Vector4(storage[2], storage[2], storage[2], storage[0]
      );
  Vector4 get pppt => new Vector4(storage[2], storage[2], storage[2], storage[1]
      );
  Vector4 get pppp => new Vector4(storage[2], storage[2], storage[2], storage[2]
      );
}
