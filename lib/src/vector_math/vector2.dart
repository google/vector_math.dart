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

//TODO (fox32): Update documentation comments!

/// 2D column vector.
class Vector2 {
  final Float32List _storage;

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
  /// interpolation and set the values to [result].
  static void mix(Vector2 min, Vector2 max, double a, Vector2 result) {
    result.x = min.x + a * (max.x - min.x);
    result.y = min.y + a * (max.y - min.y);
  }

  /// The components of the vector.
  Float32List get storage => _storage;

  /// Construct a new vector with the specified values.
  Vector2(double x, double y)
      : _storage = new Float32List(2) {
    setValues(x, y);
  }

  /// Initialized with values from [array] starting at [offset].
  Vector2.array(List<double> array, [int offset = 0])
      : _storage = new Float32List(2) {
    int i = offset;
    storage[1] = array[i + 1];
    storage[0] = array[i + 0];
  }

  /// Zero vector.
  Vector2.zero()
      : _storage = new Float32List(2);

  /// Splat [value] into all lanes of the vector.
  Vector2.all(double value)
      : this(value, value);

  /// Copy of [other].
  Vector2.copy(Vector2 other)
      : _storage = new Float32List(2) {
    setFrom(other);
  }

  /// Constructs Vector2 with given Float32List as [storage].
  Vector2.fromFloat32List(this._storage);

  /// Constructs Vector2 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float32List.BYTES_PER_ELEMENT].
  Vector2.fromBuffer(ByteBuffer buffer, int offset)
      : _storage = new Float32List.view(buffer, offset, 2);

  /// Set the values of the vector.
  void setValues(double x, double y) {
    _storage[0] = x;
    _storage[1] = y;
  }

  /// Zero the vector.
  void setZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
  }

  /// Set the values by copying them from [other].
  void setFrom(Vector2 other) {
    final otherStorage = other._storage;
    _storage[1] = otherStorage[1];
    _storage[0] = otherStorage[0];
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(double arg) {
    _storage[0] = arg;
    _storage[1] = arg;
  }

  /// Returns a printable string
  String toString() => '[${_storage[0]},${_storage[1]}]';

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
    return sum;
  }

  /// Normalize [this].
  void normalize() {
    var l = length;
    // TODO(johnmccutchan): Use an epsilon.
    if (l == 0.0) {
      return;
    }
    l = 1.0 / l;
    _storage[0] *= l;
    _storage[1] *= l;
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
    return l;
  }

  /// Normalized copy of [this].
  Vector2 normalized() => clone()..normalize();

  /// Normalize vector into [out].
  Vector2 normalizeInto(Vector2 out) {
    //TODO (fox32): Remove this method?
    out.setFrom(this);
    return out..normalize();
  }

  /// Distance from [this] to [arg]
  double distanceTo(Vector2 arg) => (clone()..sub(arg)).length;

  /// Squared distance from [this] to [arg]
  double distanceToSquared(Vector2 arg) => (clone()..sub(arg)).length2;

  /// Inner product.
  double dot(Vector2 other) {
    final otherStorage = other._storage;
    var sum;
    sum = _storage[0] * otherStorage[0];
    sum += _storage[1] * otherStorage[1];
    return sum;
  }

  /// Transforms [this] into the product of [this] as a row vector,
  /// postmultiplied by matrix, [arg].
  /// If [arg] is a rotation matrix, this is a computational shortcut for applying,
  /// the inverse of the transformation.
  void postmultiply(Matrix2 arg) {
    final argStorage = arg.storage;
    var v0 = _storage[0];
    var v1 = _storage[1];
    _storage[0] = v0 * argStorage[0] + v1 * argStorage[1];
    _storage[1] = v0 * argStorage[2] + v1 * argStorage[3];
  }

  /// Cross product.
  double cross(Vector2 other) {
    final otherStorage = other._storage;
    return storage[0] * otherStorage[1] - storage[1] * otherStorage[0];
  }

  /// Rotate [this] by 90 degrees then scale it. Store result in [out]. Return [out].
  Vector2 scaleOrthogonalInto(double scale, Vector2 out) {
    out.setValues(-scale * _storage[1], scale * _storage[0]);
    return out; //TODO (fox32): Remove return type?
  }

  /// Reflect [this].
  void reflect(Vector2 normal) {
    sub(normal.scaled(2.0 * normal.dot(this)));
  }

  /// Reflected copy of [this].
  Vector2 reflected(Vector2 normal) => clone()..reflect(normal);

  /// Relative error between [this] and [correct]
  double relativeError(Vector2 correct) {
    final correct_norm = correct.length;
    final diff_norm = (this - correct).length;
    return diff_norm / correct_norm;
  }

  /// Absolute error between [this] and [correct]
  double absoluteError(Vector2 correct) => (this - correct).length;

  /// True if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || _storage[0].isInfinite;
    is_infinite = is_infinite || _storage[1].isInfinite;
    return is_infinite;
  }

  /// True if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || _storage[0].isNaN;
    is_nan = is_nan || _storage[1].isNaN;
    return is_nan;
  }

  /// Add [arg] to [this].
  void add(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] + argStorage[0];
    _storage[1] = _storage[1] + argStorage[1];
  }

  /// Add [arg] scaled by [factor] to [this].
  void addScaled(Vector2 arg, double factor) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] + argStorage[0] * factor;
    _storage[1] = _storage[1] + argStorage[1] * factor;
  }

  /// Subtract [arg] from [this].
  void sub(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] - argStorage[0];
    _storage[1] = _storage[1] - argStorage[1];
  }

  /// Multiply entries in [this] with entries in [arg].
  void multiply(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] * argStorage[0];
    _storage[1] = _storage[1] * argStorage[1];
  }

  /// Divide entries in [this] with entries in [arg].
  void divide(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = _storage[0] / argStorage[0];
    _storage[1] = _storage[1] / argStorage[1];
  }

  /// Scale [this].
  void scale(double arg) {
    _storage[1] = _storage[1] * arg;
    _storage[0] = _storage[0] * arg;
  }

  Vector2 scaled(double arg) => clone()..scale(arg);

  /// Negate.
  void negate() {
    _storage[1] = -_storage[1];
    _storage[0] = -_storage[0];
  }

  /// Absolute value.
  void absolute() {
    _storage[1] = _storage[1].abs();
    _storage[0] = _storage[0].abs();
  }

  /// Clone of [this].
  Vector2 clone() => new Vector2.copy(this);

  /// Copy [this] into [arg]. Returns [arg].
  void copyInto(Vector2 arg) {
    final argStorage = arg._storage;
    argStorage[1] = _storage[1];
    argStorage[0] = _storage[0];
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset = 0]) {
    array[offset + 1] = _storage[1];
    array[offset + 0] = _storage[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    _storage[1] = array[offset + 1];
    _storage[0] = array[offset + 0];
  }

  set xy(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set yx(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set r(double arg) => _storage[0] = arg;
  set g(double arg) => _storage[1] = arg;
  set s(double arg) => _storage[0] = arg;
  set t(double arg) => _storage[1] = arg;
  set x(double arg) => _storage[0] = arg;
  set y(double arg) => _storage[1] = arg;
  set rg(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set gr(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  set st(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[0] = argStorage[0];
    _storage[1] = argStorage[1];
  }
  set ts(Vector2 arg) {
    final argStorage = arg._storage;
    _storage[1] = argStorage[0];
    _storage[0] = argStorage[1];
  }
  Vector2 get xx => new Vector2(storage[0], storage[0]);
  Vector2 get xy => new Vector2(storage[0], storage[1]);
  Vector2 get yx => new Vector2(storage[1], storage[0]);
  Vector2 get yy => new Vector2(storage[1], storage[1]);
  Vector3 get xxx => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get xxy => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get xyx => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get xyy => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get yxx => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get yxy => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get yyx => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get yyy => new Vector3(storage[1], storage[1], storage[1]);
  Vector4 get xxxx => new Vector4(storage[0], storage[0], storage[0], storage[0]
      );
  Vector4 get xxxy => new Vector4(storage[0], storage[0], storage[0], storage[1]
      );
  Vector4 get xxyx => new Vector4(storage[0], storage[0], storage[1], storage[0]
      );
  Vector4 get xxyy => new Vector4(storage[0], storage[0], storage[1], storage[1]
      );
  Vector4 get xyxx => new Vector4(storage[0], storage[1], storage[0], storage[0]
      );
  Vector4 get xyxy => new Vector4(storage[0], storage[1], storage[0], storage[1]
      );
  Vector4 get xyyx => new Vector4(storage[0], storage[1], storage[1], storage[0]
      );
  Vector4 get xyyy => new Vector4(storage[0], storage[1], storage[1], storage[1]
      );
  Vector4 get yxxx => new Vector4(storage[1], storage[0], storage[0], storage[0]
      );
  Vector4 get yxxy => new Vector4(storage[1], storage[0], storage[0], storage[1]
      );
  Vector4 get yxyx => new Vector4(storage[1], storage[0], storage[1], storage[0]
      );
  Vector4 get yxyy => new Vector4(storage[1], storage[0], storage[1], storage[1]
      );
  Vector4 get yyxx => new Vector4(storage[1], storage[1], storage[0], storage[0]
      );
  Vector4 get yyxy => new Vector4(storage[1], storage[1], storage[0], storage[1]
      );
  Vector4 get yyyx => new Vector4(storage[1], storage[1], storage[1], storage[0]
      );
  Vector4 get yyyy => new Vector4(storage[1], storage[1], storage[1], storage[1]
      );
  double get r => storage[0];
  double get g => storage[1];
  double get s => storage[0];
  double get t => storage[1];
  double get x => storage[0];
  double get y => storage[1];
  Vector2 get rr => new Vector2(storage[0], storage[0]);
  Vector2 get rg => new Vector2(storage[0], storage[1]);
  Vector2 get gr => new Vector2(storage[1], storage[0]);
  Vector2 get gg => new Vector2(storage[1], storage[1]);
  Vector3 get rrr => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get rrg => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get rgr => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get rgg => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get grr => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get grg => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get ggr => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get ggg => new Vector3(storage[1], storage[1], storage[1]);
  Vector4 get rrrr => new Vector4(storage[0], storage[0], storage[0], storage[0]
      );
  Vector4 get rrrg => new Vector4(storage[0], storage[0], storage[0], storage[1]
      );
  Vector4 get rrgr => new Vector4(storage[0], storage[0], storage[1], storage[0]
      );
  Vector4 get rrgg => new Vector4(storage[0], storage[0], storage[1], storage[1]
      );
  Vector4 get rgrr => new Vector4(storage[0], storage[1], storage[0], storage[0]
      );
  Vector4 get rgrg => new Vector4(storage[0], storage[1], storage[0], storage[1]
      );
  Vector4 get rggr => new Vector4(storage[0], storage[1], storage[1], storage[0]
      );
  Vector4 get rggg => new Vector4(storage[0], storage[1], storage[1], storage[1]
      );
  Vector4 get grrr => new Vector4(storage[1], storage[0], storage[0], storage[0]
      );
  Vector4 get grrg => new Vector4(storage[1], storage[0], storage[0], storage[1]
      );
  Vector4 get grgr => new Vector4(storage[1], storage[0], storage[1], storage[0]
      );
  Vector4 get grgg => new Vector4(storage[1], storage[0], storage[1], storage[1]
      );
  Vector4 get ggrr => new Vector4(storage[1], storage[1], storage[0], storage[0]
      );
  Vector4 get ggrg => new Vector4(storage[1], storage[1], storage[0], storage[1]
      );
  Vector4 get gggr => new Vector4(storage[1], storage[1], storage[1], storage[0]
      );
  Vector4 get gggg => new Vector4(storage[1], storage[1], storage[1], storage[1]
      );
  Vector2 get ss => new Vector2(storage[0], storage[0]);
  Vector2 get st => new Vector2(storage[0], storage[1]);
  Vector2 get ts => new Vector2(storage[1], storage[0]);
  Vector2 get tt => new Vector2(storage[1], storage[1]);
  Vector3 get sss => new Vector3(storage[0], storage[0], storage[0]);
  Vector3 get sst => new Vector3(storage[0], storage[0], storage[1]);
  Vector3 get sts => new Vector3(storage[0], storage[1], storage[0]);
  Vector3 get stt => new Vector3(storage[0], storage[1], storage[1]);
  Vector3 get tss => new Vector3(storage[1], storage[0], storage[0]);
  Vector3 get tst => new Vector3(storage[1], storage[0], storage[1]);
  Vector3 get tts => new Vector3(storage[1], storage[1], storage[0]);
  Vector3 get ttt => new Vector3(storage[1], storage[1], storage[1]);
  Vector4 get ssss => new Vector4(storage[0], storage[0], storage[0], storage[0]
      );
  Vector4 get ssst => new Vector4(storage[0], storage[0], storage[0], storage[1]
      );
  Vector4 get ssts => new Vector4(storage[0], storage[0], storage[1], storage[0]
      );
  Vector4 get sstt => new Vector4(storage[0], storage[0], storage[1], storage[1]
      );
  Vector4 get stss => new Vector4(storage[0], storage[1], storage[0], storage[0]
      );
  Vector4 get stst => new Vector4(storage[0], storage[1], storage[0], storage[1]
      );
  Vector4 get stts => new Vector4(storage[0], storage[1], storage[1], storage[0]
      );
  Vector4 get sttt => new Vector4(storage[0], storage[1], storage[1], storage[1]
      );
  Vector4 get tsss => new Vector4(storage[1], storage[0], storage[0], storage[0]
      );
  Vector4 get tsst => new Vector4(storage[1], storage[0], storage[0], storage[1]
      );
  Vector4 get tsts => new Vector4(storage[1], storage[0], storage[1], storage[0]
      );
  Vector4 get tstt => new Vector4(storage[1], storage[0], storage[1], storage[1]
      );
  Vector4 get ttss => new Vector4(storage[1], storage[1], storage[0], storage[0]
      );
  Vector4 get ttst => new Vector4(storage[1], storage[1], storage[0], storage[1]
      );
  Vector4 get ttts => new Vector4(storage[1], storage[1], storage[1], storage[0]
      );
  Vector4 get tttt => new Vector4(storage[1], storage[1], storage[1], storage[1]
      );
}
