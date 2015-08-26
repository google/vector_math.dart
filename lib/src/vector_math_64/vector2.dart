// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_64;

/// 2D column vector.
class Vector2 implements Vector {
  final Float64List _v2storage;

  /// The components of the vector.
  Float64List get storage => _v2storage;

  /// Set the values of [result] to the minimum of [a] and [b] for each line.
  static void min(Vector2 a, Vector2 b, Vector2 result) {
    result.x = Math.min(a.x, b.x);
    result.y = Math.min(a.y, b.y);
  }

  /// Set the values of [result] to the maximum of [a] and [b] for each line.
  static void max(Vector2 a, Vector2 b, Vector2 result) {
    result.x = Math.max(a.x, b.x);
    result.y = Math.max(a.y, b.y);
  }

  /// Interpolate between [min] and [max] with the amount of [a] using a linear
  /// interpolation and store the values in [result].
  static void mix(Vector2 min, Vector2 max, double a, Vector2 result) {
    result.x = min.x + a * (max.x - min.x);
    result.y = min.y + a * (max.y - min.y);
  }

  /// Construct a new vector with the specified values.
  factory Vector2(double x, double y) => new Vector2.zero()..setValues(x, y);

  /// Initialized with values from [array] starting at [offset].
  factory Vector2.array(List<double> array, [int offset = 0]) =>
      new Vector2.zero()..copyFromArray(array, offset);

  /// Zero vector.
  Vector2.zero() : _v2storage = new Float64List(2);

  /// Splat [value] into all lanes of the vector.
  factory Vector2.all(double value) => new Vector2.zero()..splat(value);

  /// Copy of [other].
  factory Vector2.copy(Vector2 other) => new Vector2.zero()..setFrom(other);

  /// Constructs Vector2 with a given [Float64List] as [storage].
  Vector2.fromFloat64List(this._v2storage);

  /// Constructs Vector2 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float64List.BYTES_PER_ELEMENT].
  Vector2.fromBuffer(ByteBuffer buffer, int offset)
      : _v2storage = new Float64List.view(buffer, offset, 2);

  /// Set the values of the vector.
  Vector2 setValues(double x_, double y_) {
    _v2storage[0] = x_;
    _v2storage[1] = y_;
    return this;
  }

  /// Zero the vector.
  Vector2 setZero() {
    _v2storage[0] = 0.0;
    _v2storage[1] = 0.0;
    return this;
  }

  /// Set the values by copying them from [other].
  Vector2 setFrom(Vector2 other) {
    final otherStorage = other._v2storage;
    _v2storage[1] = otherStorage[1];
    _v2storage[0] = otherStorage[0];
    return this;
  }

  /// Splat [arg] into all lanes of the vector.
  Vector2 splat(double arg) {
    _v2storage[0] = arg;
    _v2storage[1] = arg;
    return this;
  }

  /// Returns a printable string
  String toString() => '[${_v2storage[0]},${_v2storage[1]}]';

  /// Check if two vectors are the same.
  bool operator ==(other) {
    return (other is Vector2) &&
        (_v2storage[0] == other._v2storage[0]) &&
        (_v2storage[1] == other._v2storage[1]);
  }

  int get hashCode => quiver.hashObjects(_v2storage);

  /// Negate.
  Vector2 operator -() => clone()..negate();

  /// Subtract two vectors.
  Vector2 operator -(Vector2 other) => clone()..sub(other);

  /// Add two vectors.
  Vector2 operator +(Vector2 other) => clone()..add(other);

  /// Scale.
  Vector2 operator /(double scale) => clone()..scale(1.0 / scale);

  /// Scale.
  Vector2 operator *(double scale) => clone()..scale(scale);

  /// Access the component of the vector at the index [i].
  double operator [](int i) => _v2storage[i];

  /// Set the component of the vector at the index [i].
  void operator []=(int i, double v) {
    _v2storage[i] = v;
  }

  /// Set the length of the vector. A negative [value] will change the vectors
  /// orientation and a [value] of zero will set the vector to zero.
  set length(double value) {
    if (value == 0.0) {
      setZero();
    } else {
      double l = length;
      if (l == 0.0) {
        return;
      }
      l = value / l;
      _v2storage[0] *= l;
      _v2storage[1] *= l;
    }
  }

  /// Length.
  double get length => Math.sqrt(length2);

  /// Length squared.
  double get length2 {
    var sum;
    sum = (_v2storage[0] * _v2storage[0]);
    sum += (_v2storage[1] * _v2storage[1]);
    return sum;
  }

  /// Normalize [this].
  Vector2 normalize() {
    double l = length;
    // TODO(johnmccutchan): Use an epsilon.
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    _v2storage[0] *= l;
    _v2storage[1] *= l;
    return this;
  }

  /// Normalize [this]. Returns length of vector before normalization.
  double normalizeLength() {
    double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    var d = 1.0 / l;
    _v2storage[0] *= d;
    _v2storage[1] *= d;
    return l;
  }

  /// Normalized copy of [this].
  Vector2 normalized() => clone()..normalize();

  /// Normalize vector into [out].
  Vector2 normalizeInto(Vector2 out) {
    out.setFrom(this);
    return out.normalize();
  }

  /// Distance from [this] to [arg]
  double distanceTo(Vector2 arg) => Math.sqrt(distanceToSquared(arg));

  /// Squared distance from [this] to [arg]
  double distanceToSquared(Vector2 arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;

    return dx * dx + dy * dy;
  }

  /// Inner product.
  double dot(Vector2 other) {
    final otherStorage = other._v2storage;
    double sum;
    sum = _v2storage[0] * otherStorage[0];
    sum += _v2storage[1] * otherStorage[1];
    return sum;
  }

  /**
   * Transforms [this] into the product of [this] as a row vector,
   * postmultiplied by matrix, [arg].
   * If [arg] is a rotation matrix, this is a computational shortcut for applying,
   * the inverse of the transformation.
   */
  Vector2 postmultiply(Matrix2 arg) {
    final argStorage = arg.storage;
    double v0 = _v2storage[0];
    double v1 = _v2storage[1];
    _v2storage[0] = v0 * argStorage[0] + v1 * argStorage[1];
    _v2storage[1] = v0 * argStorage[2] + v1 * argStorage[3];

    return this;
  }

  /// Cross product.
  double cross(Vector2 other) {
    final otherStorage = other._v2storage;
    return _v2storage[0] * otherStorage[1] - _v2storage[1] * otherStorage[0];
  }

  /// Rotate [this] by 90 degrees then scale it. Store result in [out]. Return [out].
  Vector2 scaleOrthogonalInto(double scale, Vector2 out) {
    out.setValues(-scale * _v2storage[1], scale * _v2storage[0]);
    return out;
  }

  /// Reflect [this].
  Vector2 reflect(Vector2 normal) {
    sub(normal.scaled(2.0 * normal.dot(this)));
    return this;
  }

  /// Reflected copy of [this].
  Vector2 reflected(Vector2 normal) => clone()..reflect(normal);

  /// Relative error between [this] and [correct]
  double relativeError(Vector2 correct) {
    double correct_norm = correct.length;
    double diff_norm = (this - correct).length;
    return diff_norm / correct_norm;
  }

  /// Absolute error between [this] and [correct]
  double absoluteError(Vector2 correct) {
    return (this - correct).length;
  }

  /// True if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || _v2storage[0].isInfinite;
    is_infinite = is_infinite || _v2storage[1].isInfinite;
    return is_infinite;
  }

  /// True if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || _v2storage[0].isNaN;
    is_nan = is_nan || _v2storage[1].isNaN;
    return is_nan;
  }

  /// Add [arg] to [this].
  Vector2 add(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] + argStorage[0];
    _v2storage[1] = _v2storage[1] + argStorage[1];
    return this;
  }

  /// Add [arg] scaled by [factor] to [this].
  Vector2 addScaled(Vector2 arg, double factor) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] + argStorage[0] * factor;
    _v2storage[1] = _v2storage[1] + argStorage[1] * factor;
    return this;
  }

  /// Subtract [arg] from [this].
  Vector2 sub(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] - argStorage[0];
    _v2storage[1] = _v2storage[1] - argStorage[1];
    return this;
  }

  /// Multiply entries in [this] with entries in [arg].
  Vector2 multiply(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] * argStorage[0];
    _v2storage[1] = _v2storage[1] * argStorage[1];
    return this;
  }

  /// Divide entries in [this] with entries in [arg].
  Vector2 divide(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] / argStorage[0];
    _v2storage[1] = _v2storage[1] / argStorage[1];
    return this;
  }

  /// Scale [this] by [arg].
  Vector2 scale(double arg) {
    _v2storage[1] = _v2storage[1] * arg;
    _v2storage[0] = _v2storage[0] * arg;
    return this;
  }

  /// Return a copy of [this] scaled by [arg].
  Vector2 scaled(double arg) => clone()..scale(arg);

  /// Negate.
  Vector2 negate() {
    _v2storage[1] = -_v2storage[1];
    _v2storage[0] = -_v2storage[0];
    return this;
  }

  /// Absolute value.
  Vector2 absolute() {
    _v2storage[1] = _v2storage[1].abs();
    _v2storage[0] = _v2storage[0].abs();
    return this;
  }

  /// Clamp each entry n in [this] in the range [min[n]]-[max[n]].
  Vector2 clamp(Vector2 min, Vector2 max) {
    var minStorage = min.storage;
    var maxStorage = max.storage;
    _v2storage[0] = _v2storage[0].clamp(minStorage[0], maxStorage[0]);
    _v2storage[1] = _v2storage[1].clamp(minStorage[1], maxStorage[1]);
    return this;
  }

  /// Clamp entries [this] in the range [min]-[max].
  Vector2 clampScalar(double min, double max) {
    _v2storage[0] = _v2storage[0].clamp(min, max);
    _v2storage[1] = _v2storage[1].clamp(min, max);
    return this;
  }

  /// Floor entries in [this].
  Vector2 floor() {
    _v2storage[0] = _v2storage[0].floorToDouble();
    _v2storage[1] = _v2storage[1].floorToDouble();
    return this;
  }

  /// Ceil entries in [this].
  Vector2 ceil() {
    _v2storage[0] = _v2storage[0].ceilToDouble();
    _v2storage[1] = _v2storage[1].ceilToDouble();
    return this;
  }

  /// Round entries in [this].
  Vector2 round() {
    _v2storage[0] = _v2storage[0].roundToDouble();
    _v2storage[1] = _v2storage[1].roundToDouble();
    return this;
  }

  /// Round entries in [this] towards zero.
  Vector2 roundToZero() {
    _v2storage[0] = _v2storage[0] < 0.0
        ? _v2storage[0].ceilToDouble()
        : _v2storage[0].floorToDouble();
    _v2storage[1] = _v2storage[1] < 0.0
        ? _v2storage[1].ceilToDouble()
        : _v2storage[1].floorToDouble();
    return this;
  }

  /// Clone of [this].
  Vector2 clone() => new Vector2.copy(this);

  /// Copy [this] into [arg]. Returns [arg].
  Vector2 copyInto(Vector2 arg) {
    final argStorage = arg._v2storage;
    argStorage[1] = _v2storage[1];
    argStorage[0] = _v2storage[0];
    return arg;
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset = 0]) {
    array[offset + 1] = _v2storage[1];
    array[offset + 0] = _v2storage[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    _v2storage[1] = array[offset + 1];
    _v2storage[0] = array[offset + 0];
  }

  set xy(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = argStorage[0];
    _v2storage[1] = argStorage[1];
  }

  set yx(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[1] = argStorage[0];
    _v2storage[0] = argStorage[1];
  }

  set r(double arg) => x = arg;
  set g(double arg) => y = arg;
  set s(double arg) => x = arg;
  set t(double arg) => y = arg;
  set x(double arg) => _v2storage[0] = arg;
  set y(double arg) => _v2storage[1] = arg;
  set rg(Vector2 arg) => xy = arg;
  set gr(Vector2 arg) => yx = arg;
  set st(Vector2 arg) => xy = arg;
  set ts(Vector2 arg) => yx = arg;
  Vector2 get xx => new Vector2(_v2storage[0], _v2storage[0]);
  Vector2 get xy => new Vector2(_v2storage[0], _v2storage[1]);
  Vector2 get yx => new Vector2(_v2storage[1], _v2storage[0]);
  Vector2 get yy => new Vector2(_v2storage[1], _v2storage[1]);
  Vector3 get xxx => new Vector3(_v2storage[0], _v2storage[0], _v2storage[0]);
  Vector3 get xxy => new Vector3(_v2storage[0], _v2storage[0], _v2storage[1]);
  Vector3 get xyx => new Vector3(_v2storage[0], _v2storage[1], _v2storage[0]);
  Vector3 get xyy => new Vector3(_v2storage[0], _v2storage[1], _v2storage[1]);
  Vector3 get yxx => new Vector3(_v2storage[1], _v2storage[0], _v2storage[0]);
  Vector3 get yxy => new Vector3(_v2storage[1], _v2storage[0], _v2storage[1]);
  Vector3 get yyx => new Vector3(_v2storage[1], _v2storage[1], _v2storage[0]);
  Vector3 get yyy => new Vector3(_v2storage[1], _v2storage[1], _v2storage[1]);
  Vector4 get xxxx =>
      new Vector4(_v2storage[0], _v2storage[0], _v2storage[0], _v2storage[0]);
  Vector4 get xxxy =>
      new Vector4(_v2storage[0], _v2storage[0], _v2storage[0], _v2storage[1]);
  Vector4 get xxyx =>
      new Vector4(_v2storage[0], _v2storage[0], _v2storage[1], _v2storage[0]);
  Vector4 get xxyy =>
      new Vector4(_v2storage[0], _v2storage[0], _v2storage[1], _v2storage[1]);
  Vector4 get xyxx =>
      new Vector4(_v2storage[0], _v2storage[1], _v2storage[0], _v2storage[0]);
  Vector4 get xyxy =>
      new Vector4(_v2storage[0], _v2storage[1], _v2storage[0], _v2storage[1]);
  Vector4 get xyyx =>
      new Vector4(_v2storage[0], _v2storage[1], _v2storage[1], _v2storage[0]);
  Vector4 get xyyy =>
      new Vector4(_v2storage[0], _v2storage[1], _v2storage[1], _v2storage[1]);
  Vector4 get yxxx =>
      new Vector4(_v2storage[1], _v2storage[0], _v2storage[0], _v2storage[0]);
  Vector4 get yxxy =>
      new Vector4(_v2storage[1], _v2storage[0], _v2storage[0], _v2storage[1]);
  Vector4 get yxyx =>
      new Vector4(_v2storage[1], _v2storage[0], _v2storage[1], _v2storage[0]);
  Vector4 get yxyy =>
      new Vector4(_v2storage[1], _v2storage[0], _v2storage[1], _v2storage[1]);
  Vector4 get yyxx =>
      new Vector4(_v2storage[1], _v2storage[1], _v2storage[0], _v2storage[0]);
  Vector4 get yyxy =>
      new Vector4(_v2storage[1], _v2storage[1], _v2storage[0], _v2storage[1]);
  Vector4 get yyyx =>
      new Vector4(_v2storage[1], _v2storage[1], _v2storage[1], _v2storage[0]);
  Vector4 get yyyy =>
      new Vector4(_v2storage[1], _v2storage[1], _v2storage[1], _v2storage[1]);
  double get r => x;
  double get g => y;
  double get s => x;
  double get t => y;
  double get x => _v2storage[0];
  double get y => _v2storage[1];
  Vector2 get rr => xx;
  Vector2 get rg => xy;
  Vector2 get gr => yx;
  Vector2 get gg => yy;
  Vector3 get rrr => xxx;
  Vector3 get rrg => xxy;
  Vector3 get rgr => xyx;
  Vector3 get rgg => xyy;
  Vector3 get grr => yxx;
  Vector3 get grg => yxy;
  Vector3 get ggr => yyx;
  Vector3 get ggg => yyy;
  Vector4 get rrrr => xxxx;
  Vector4 get rrrg => xxxy;
  Vector4 get rrgr => xxyx;
  Vector4 get rrgg => xxyy;
  Vector4 get rgrr => xyxx;
  Vector4 get rgrg => xyxy;
  Vector4 get rggr => xyyx;
  Vector4 get rggg => xyyy;
  Vector4 get grrr => yxxx;
  Vector4 get grrg => yxxy;
  Vector4 get grgr => yxyx;
  Vector4 get grgg => yxyy;
  Vector4 get ggrr => yyxx;
  Vector4 get ggrg => yyxy;
  Vector4 get gggr => yyyx;
  Vector4 get gggg => yyyy;
  Vector2 get ss => xx;
  Vector2 get st => xy;
  Vector2 get ts => yx;
  Vector2 get tt => yy;
  Vector3 get sss => xxx;
  Vector3 get sst => xxy;
  Vector3 get sts => xyx;
  Vector3 get stt => xyy;
  Vector3 get tss => yxx;
  Vector3 get tst => yxy;
  Vector3 get tts => yyx;
  Vector3 get ttt => yyy;
  Vector4 get ssss => xxxx;
  Vector4 get ssst => xxxy;
  Vector4 get ssts => xxyx;
  Vector4 get sstt => xxyy;
  Vector4 get stss => xyxx;
  Vector4 get stst => xyxy;
  Vector4 get stts => xyyx;
  Vector4 get sttt => xyyy;
  Vector4 get tsss => yxxx;
  Vector4 get tsst => yxxy;
  Vector4 get tsts => yxyx;
  Vector4 get tstt => yxyy;
  Vector4 get ttss => yyxx;
  Vector4 get ttst => yyxy;
  Vector4 get ttts => yyyx;
  Vector4 get tttt => yyyy;
}
