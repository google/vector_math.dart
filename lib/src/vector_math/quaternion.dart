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
//TODO (fox32): Add a non operator interface? (add, sub, mul) but share one implementation!

class Quaternion {
  final Float32List _storage41;

  /// The components of the quaternion.
  Float32List get storage => _storage41;
  double get x => _storage41[0];
  double get y => _storage41[1];
  double get z => _storage41[2];
  double get w => _storage41[3];
  set x(double x) {
    _storage41[0] = x;
  }
  set y(double y) {
    _storage41[1] = y;
  }
  set z(double z) {
    _storage41[2] = z;
  }
  set w(double w) {
    _storage41[3] = w;
  }

  Quaternion._()
      : _storage41 = new Float32List(4);

  /// Constructs a quaternion using the raw values [x], [y], [z], and [w]
  factory Quaternion(double x, double y, double z, double w) =>
      new Quaternion._()..setValues(x, y, z, w);

  /// From a rotation matrix [rotationMatrix].
  factory Quaternion.fromRotation(Matrix3 rotationMatrix) => new Quaternion._(
      )..setFromRotation(rotationMatrix);

  /// Rotation of [angle] around [axis].
  factory Quaternion.axisAngle(Vector3 axis, double angle) => new Quaternion._(
      )..setAxisAngle(axis, angle);

  /// Copies [original].
  factory Quaternion.copy(Quaternion original) => new Quaternion._()..setFrom(
      original);

  /// Random rotation.
  factory Quaternion.random(Math.Random rn) => new Quaternion._()..setRandom(rn
      );

  /// Constructs the identity quaternion
  factory Quaternion.identity() => new Quaternion._().._storage41[3] = 1.0;

  /// Time derivative of [q] with angular velocity [omega].
  factory Quaternion.dq(Quaternion q, Vector3 omega) => new Quaternion._(
      )..setDQ(q, omega);

  factory Quaternion.euler(double yaw, double pitch, double roll) =>
      new Quaternion._()..setEuler(yaw, pitch, roll);

  /// Constructs Quaternion with given Float32List as [storage].
  Quaternion.fromFloat32List(this._storage41);

  /// Constructs Quaternion with a [storage] that views given [buffer] starting at [offset].
  /// [offset] has to be multiple of [Float32List.BYTES_PER_ELEMENT].
  Quaternion.fromBuffer(ByteBuffer buffer, int offset)
      : _storage41 = new Float32List.view(buffer, offset, 4);

  /// Returns a new copy of this
  Quaternion clone() => new Quaternion.copy(this);

  /// DEPRRECATED: Replaced by [setFrom]
  @deprecated
  void copyFrom(Quaternion source) => setFrom(source);

  /// Copy [source] into [this]
  void setFrom(Quaternion source) {
    final sourceStorage = source._storage41;
    _storage41[0] = sourceStorage[0];
    _storage41[1] = sourceStorage[1];
    _storage41[2] = sourceStorage[2];
    _storage41[3] = sourceStorage[3];
  }

  /// Copy [this] into [target].
  void copyTo(Quaternion target) {
    final targetStorage = target._storage41;
    targetStorage[0] = _storage41[0];
    targetStorage[1] = _storage41[1];
    targetStorage[2] = _storage41[2];
    targetStorage[3] = _storage41[3];
  }

  void setValues(double x, double y, double z, double w) {
    _storage41[0] = x;
    _storage41[1] = y;
    _storage41[2] = z;
    _storage41[3] = w;
  }

  /// Set quaternion with rotation of [radians] around [axis].
  void setAxisAngle(Vector3 axis, double radians) {
    final len = axis.length;
    if (len == 0.0) {
      return;
    }
    final halfSin = Math.sin(radians * 0.5) / len;
    final axisStorage = axis._storage3;
    _storage41[0] = axisStorage[0] * halfSin;
    _storage41[1] = axisStorage[1] * halfSin;
    _storage41[2] = axisStorage[2] * halfSin;
    _storage41[3] = Math.cos(radians * 0.5);
  }

  void setFromRotation(Matrix3 rotationMatrix) {
    final rotationMatrixStorage = rotationMatrix._storage33;
    final trace = rotationMatrix.trace();
    if (trace > 0.0) {
      var s = Math.sqrt(trace + 1.0);
      _storage41[3] = s * 0.5;
      s = 0.5 / s;
      _storage41[0] = (rotationMatrixStorage[5] - rotationMatrixStorage[7]) * s;
      _storage41[1] = (rotationMatrixStorage[6] - rotationMatrixStorage[2]) * s;
      _storage41[2] = (rotationMatrixStorage[1] - rotationMatrixStorage[3]) * s;
    } else {
      var i = rotationMatrixStorage[0] < rotationMatrixStorage[4] ?
          (rotationMatrixStorage[4] < rotationMatrixStorage[8] ? 2 : 1) :
          (rotationMatrixStorage[0] < rotationMatrixStorage[8] ? 2 : 0);
      var j = (i + 1) % 3;
      var k = (i + 2) % 3;
      var s = Math.sqrt(rotationMatrixStorage[rotationMatrix.index(i, i)] -
          rotationMatrixStorage[rotationMatrix.index(j, j)] -
          rotationMatrixStorage[rotationMatrix.index(k, k)] + 1.0);
      _storage41[i] = s * 0.5;
      s = 0.5 / s;
      _storage41[3] = (rotationMatrixStorage[rotationMatrix.index(k, j)] -
          rotationMatrixStorage[rotationMatrix.index(j, k)]) * s;
      _storage41[j] = (rotationMatrixStorage[rotationMatrix.index(j, i)] +
          rotationMatrixStorage[rotationMatrix.index(i, j)]) * s;
      _storage41[k] = (rotationMatrixStorage[rotationMatrix.index(k, i)] +
          rotationMatrixStorage[rotationMatrix.index(i, k)]) * s;
    }
  }

  void setRandom(Math.Random rn) {
    // From: "Uniform Random Rotations", Ken Shoemake, Graphics Gems III,
    // pg. 124-132.
    final x0 = rn.nextDouble();
    final r1 = Math.sqrt(1.0 - x0);
    final r2 = Math.sqrt(x0);
    final t1 = Math.PI * 2.0 * rn.nextDouble();
    final t2 = Math.PI * 2.0 * rn.nextDouble();
    final c1 = Math.cos(t1);
    final s1 = Math.sin(t1);
    final c2 = Math.cos(t2);
    final s2 = Math.sin(t2);
    _storage41[0] = s1 * r1;
    _storage41[1] = c1 * r1;
    _storage41[2] = s2 * r2;
    _storage41[3] = c2 * r2;
  }

  void setDQ(Quaternion q, Vector3 omega) {
    final qStorage = q._storage41;
    final omegaStorage = omega._storage3;
    final qx = qStorage[0];
    final qy = qStorage[1];
    final qz = qStorage[2];
    final qw = qStorage[3];
    final ox = omegaStorage[0];
    final oy = omegaStorage[1];
    final oz = omegaStorage[2];
    final _x = ox * qw + oy * qz - oz * qy;
    final _y = oy * qw + oz * qx - ox * qz;
    final _z = oz * qw + ox * qy - oy * qx;
    final _w = -ox * qx - oy * qy - oz * qz;
    _storage41[0] = _x * 0.5;
    _storage41[1] = _y * 0.5;
    _storage41[2] = _z * 0.5;
    _storage41[3] = _w * 0.5;
  }

  /// Set quaternion with rotation of [yaw], [pitch] and [roll].
  void setEuler(double yaw, double pitch, double roll) {
    final halfYaw = yaw * 0.5;
    final halfPitch = pitch * 0.5;
    final halfRoll = roll * 0.5;
    final cosYaw = Math.cos(halfYaw);
    final sinYaw = Math.sin(halfYaw);
    final cosPitch = Math.cos(halfPitch);
    final sinPitch = Math.sin(halfPitch);
    final cosRoll = Math.cos(halfRoll);
    final sinRoll = Math.sin(halfRoll);
    _storage41[0] = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
    _storage41[1] = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
    _storage41[2] = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw;
    _storage41[3] = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw;
  }

  /// Normalize [this].
  void normalize() {
    var l = length;
    if (l == 0.0) {
      return;
    }
    l = 1.0 / l;
    _storage41[3] = _storage41[3] * l;
    _storage41[2] = _storage41[2] * l;
    _storage41[1] = _storage41[1] * l;
    _storage41[0] = _storage41[0] * l;
  }

  /// Conjugate [this].
  void conjugate() {
    _storage41[2] = -_storage41[2];
    _storage41[1] = -_storage41[1];
    _storage41[0] = -_storage41[0];
  }

  /// Invert [this].
  void inverse() {
    final l = 1.0 / length2;
    _storage41[3] = _storage41[3] * l;
    _storage41[2] = -_storage41[2] * l;
    _storage41[1] = -_storage41[1] * l;
    _storage41[0] = -_storage41[0] * l;
  }

  /// Normalized copy of [this].
  Quaternion normalized() => clone()..normalize();

  /// Conjugated copy of [this].
  Quaternion conjugated() => clone()..conjugate();

  /// Inverted copy of [this].
  Quaternion inverted() => clone()..inverse();

  /// Radians of rotation.
  double get radians => 2.0 * Math.acos(_storage41[3]);

  /// Axis of rotation.
  Vector3 get axis {
    final scale = 1.0 / (1.0 - (_storage41[3] * _storage41[3]));
    return new Vector3(_storage41[0] * scale, _storage41[1] * scale,
        _storage41[2] * scale);
  }

  /// Length squared.
  double get length2 {
    final _x = _storage41[0];
    final _y = _storage41[1];
    final _z = _storage41[2];
    final _w = _storage41[3];
    return (_x * _x) + (_y * _y) + (_z * _z) + (_w * _w);
  }

  /// Length.
  double get length => Math.sqrt(length2);

  /// Returns a copy of [v] rotated by quaternion.
  Vector3 rotated(Vector3 v) {
    final out = v.clone();
    rotate(out);
    return out;
  }

  /// Rotates [v] by [this].
  Vector3 rotate(Vector3 v) {
    // conjugate(this) * [v,0] * this
    final _w = _storage41[3];
    final _z = _storage41[2];
    final _y = _storage41[1];
    final _x = _storage41[0];
    final tiw = _w;
    final tiz = -_z;
    final tiy = -_y;
    final tix = -_x;
    final tx = tiw * v.x + tix * 0.0 + tiy * v.z - tiz * v.y;
    final ty = tiw * v.y + tiy * 0.0 + tiz * v.x - tix * v.z;
    final tz = tiw * v.z + tiz * 0.0 + tix * v.y - tiy * v.x;
    final tw = tiw * 0.0 - tix * v.x - tiy * v.y - tiz * v.z;
    final result_x = tw * _x + tx * _w + ty * _z - tz * _y;
    final result_y = tw * _y + ty * _w + tz * _x - tx * _z;
    final result_z = tw * _z + tz * _w + tx * _y - ty * _x;
    final vStorage = v._storage3;
    vStorage[2] = result_z;
    vStorage[1] = result_y;
    vStorage[0] = result_x;
    return v; //TODO (fox32): Remove return value?
  }

  /// Scales [this] by [scale].
  void scale(double scale) {
    _storage41[3] = _storage41[3] * scale;
    _storage41[2] = _storage41[2] * scale;
    _storage41[1] = _storage41[1] * scale;
    _storage41[0] = _storage41[0] * scale;
  }

  /// Scaled copy of [this].
  Quaternion scaled(double scale) => clone()..scale(scale);

  /// [this] rotated by [other].
  Quaternion operator *(Quaternion other) {
    if (other is Quaternion) {
      double _w = _storage41[3];
      double _z = _storage41[2];
      double _y = _storage41[1];
      double _x = _storage41[0];
      final otherStorage = other._storage41;
      double ow = otherStorage[3];
      double oz = otherStorage[2];
      double oy = otherStorage[1];
      double ox = otherStorage[0];
      return new Quaternion(_w * ox + _x * ow + _y * oz - _z * oy, _w * oy + _y
          * ow + _z * ox - _x * oz, _w * oz + _z * ow + _x * oy - _y * ox, _w * ow - _x *
          ox - _y * oy - _z * oz);
    }
    throw new ArgumentError(other);
  }

  /// Returns copy of [this] + [other].
  Quaternion operator +(Quaternion other) {
    if (other is Quaternion) {
      final otherStorage = other._storage41;
      return new Quaternion(_storage41[0] + otherStorage[0], _storage41[1] +
          otherStorage[1], _storage41[2] + otherStorage[2], _storage41[3] +
          otherStorage[3]);
    }
    throw new ArgumentError(other);
  }

  /// Returns copy of [this] - [other].
  Quaternion operator -(Quaternion other) {
    if (other is Quaternion) {
      final otherStorage = other._storage41;
      return new Quaternion(_storage41[0] - otherStorage[0], _storage41[1] -
          otherStorage[1], _storage41[2] - otherStorage[2], _storage41[3] -
          otherStorage[3]);
    }
    throw new ArgumentError(other);
  }

  /// Returns negated copy of [this].
  Quaternion operator -() => conjugated();

  /// Access the component of the quaternion at the index [i].
  double operator [](int i) => _storage41[i];

  /// Set the component of the quaternion at the index [i].
  void operator []=(int i, double arg) {
    _storage41[i] = arg;
  }

  /// Returns a rotation matrix containing the same rotation as [this].
  Matrix3 asRotationMatrix() {
    final d = length2;
    assert(d != 0.0);
    final s = 2.0 / d;

    final _x = _storage41[0];
    final _y = _storage41[1];
    final _z = _storage41[2];
    final _w = _storage41[3];

    final xs = _x * s;
    final ys = _y * s;
    final zs = _z * s;

    final wx = _w * xs;
    final wy = _w * ys;
    final wz = _w * zs;

    final xx = _x * xs;
    final xy = _x * ys;
    final xz = _x * zs;

    final yy = _y * ys;
    final yz = _y * zs;
    final zz = _z * zs;

    return new Matrix3(1.0 - (yy + zz), xy + wz, xz - wy, // column 0
    xy - wz, 1.0 - (xx + zz), yz + wx, // column 1
    xz + wy, yz - wx, 1.0 - (xx + yy)); // column 2
  }

  /// Printable string.
  String toString() => '${_storage41[0]}, ${_storage41[1]},'
      ' ${_storage41[2]} @ ${_storage41[3]}';

  /// Relative error between [this] and [correct].
  double relativeError(Quaternion correct) {
    final diff = correct - this;
    final norm_diff = diff.length;
    final correct_norm = correct.length;
    return norm_diff / correct_norm;
  }

  /// Absolute error between [this] and [correct].
  double absoluteError(Quaternion correct) {
    final this_norm = length;
    final correct_norm = correct.length;
    final norm_diff = (this_norm - correct_norm).abs();
    return norm_diff;
  }
}
