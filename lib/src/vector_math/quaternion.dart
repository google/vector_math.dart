// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

/// Defines a [Quaternion] (a four-dimensional vector) for efficient rotation
/// calculations.
///
/// Quaternion are better for interpolating between rotations and avoid the
/// [gimbal lock](http://de.wikipedia.org/wiki/Gimbal_Lock) problem compared to
/// euler rotations.
class Quaternion {
  final Float32List _qStorage;

  /// Access the internal [storage] of the quaternions components.
  Float32List get storage => _qStorage;

  /// Access the [x] component of the quaternion.
  double get x => _qStorage[0];
  set x(double x) {
    _qStorage[0] = x;
  }

  /// Access the [y] component of the quaternion.
  double get y => _qStorage[1];
  set y(double y) {
    _qStorage[1] = y;
  }

  /// Access the [z] component of the quaternion.
  double get z => _qStorage[2];
  set z(double z) {
    _qStorage[2] = z;
  }

  /// Access the [w] component of the quaternion.
  double get w => _qStorage[3];
  set w(double w) {
    _qStorage[3] = w;
  }

  Quaternion._() : _qStorage = new Float32List(4);

  /// Constructs a quaternion using the raw values [x], [y], [z], and [w].
  factory Quaternion(double x, double y, double z, double w) =>
      new Quaternion._()..setValues(x, y, z, w);

  /// Constructs a quaternion from a rotation matrix [rotationMatrix].
  factory Quaternion.fromRotation(Matrix3 rotationMatrix) =>
      new Quaternion._()..setFromRotation(rotationMatrix);

  /// Constructs a quaternion from a rotation of [angle] around [axis].
  factory Quaternion.axisAngle(Vector3 axis, double angle) =>
      new Quaternion._()..setAxisAngle(axis, angle);

  /// Constructs a quaternion to be the rotation that rotates vector [a] to [b].
  factory Quaternion.fromTwoVectors(Vector3 a, Vector3 b) =>
      new Quaternion._()..setFromTwoVectors(a, b);

  /// Constructs a quaternion as a copy of [original].
  factory Quaternion.copy(Quaternion original) =>
      new Quaternion._()..setFrom(original);

  /// Constructs a quaternion with a random rotation. The random number
  /// generator [rn] is used to generate the random numbers for the rotation.
  factory Quaternion.random(math.Random rn) =>
      new Quaternion._()..setRandom(rn);

  /// Constructs a quaternion set to the identity quaternion.
  factory Quaternion.identity() => new Quaternion._().._qStorage[3] = 1.0;

  /// Constructs a quaternion from time derivative of [q] with angular
  /// velocity [omega].
  factory Quaternion.dq(Quaternion q, Vector3 omega) =>
      new Quaternion._()..setDQ(q, omega);

  /// Constructs a quaternion from [yaw], [pitch] and [roll].
  factory Quaternion.euler(double yaw, double pitch, double roll) =>
      new Quaternion._()..setEuler(yaw, pitch, roll);

  /// Constructs a quaternion with given Float32List as [storage].
  Quaternion.fromFloat32List(this._qStorage);

  /// Constructs a quaternion with a [storage] that views given [buffer]
  /// starting at [offset]. [offset] has to be multiple of
  /// [Float32List.bytesPerElement].
  Quaternion.fromBuffer(ByteBuffer buffer, int offset)
      : _qStorage = new Float32List.view(buffer, offset, 4);

  /// Returns a new copy of [this].
  Quaternion clone() => new Quaternion.copy(this);

  /// Copy [source] into [this].
  void setFrom(Quaternion source) {
    final Float32List sourceStorage = source._qStorage;
    _qStorage[0] = sourceStorage[0];
    _qStorage[1] = sourceStorage[1];
    _qStorage[2] = sourceStorage[2];
    _qStorage[3] = sourceStorage[3];
  }

  /// Set the quaternion to the raw values [x], [y], [z], and [w].
  void setValues(double x, double y, double z, double w) {
    _qStorage[0] = x;
    _qStorage[1] = y;
    _qStorage[2] = z;
    _qStorage[3] = w;
  }

  /// Set the quaternion with rotation of [radians] around [axis].
  void setAxisAngle(Vector3 axis, double radians) {
    final double len = axis.length;
    if (len == 0.0) {
      return;
    }
    final double halfSin = math.sin(radians * 0.5) / len;
    final Float32List axisStorage = axis.storage;
    _qStorage[0] = axisStorage[0] * halfSin;
    _qStorage[1] = axisStorage[1] * halfSin;
    _qStorage[2] = axisStorage[2] * halfSin;
    _qStorage[3] = math.cos(radians * 0.5);
  }

  /// Set the quaternion with rotation from a rotation matrix [rotationMatrix].
  void setFromRotation(Matrix3 rotationMatrix) {
    final Float32List rotationMatrixStorage = rotationMatrix.storage;
    final double trace = rotationMatrix.trace();
    if (trace > 0.0) {
      double s = math.sqrt(trace + 1.0);
      _qStorage[3] = s * 0.5;
      s = 0.5 / s;
      _qStorage[0] = (rotationMatrixStorage[5] - rotationMatrixStorage[7]) * s;
      _qStorage[1] = (rotationMatrixStorage[6] - rotationMatrixStorage[2]) * s;
      _qStorage[2] = (rotationMatrixStorage[1] - rotationMatrixStorage[3]) * s;
    } else {
      final int i = rotationMatrixStorage[0] < rotationMatrixStorage[4]
          ? (rotationMatrixStorage[4] < rotationMatrixStorage[8] ? 2 : 1)
          : (rotationMatrixStorage[0] < rotationMatrixStorage[8] ? 2 : 0);
      final int j = (i + 1) % 3;
      final int k = (i + 2) % 3;
      double s = math.sqrt(rotationMatrixStorage[rotationMatrix.index(i, i)] -
          rotationMatrixStorage[rotationMatrix.index(j, j)] -
          rotationMatrixStorage[rotationMatrix.index(k, k)] +
          1.0);
      _qStorage[i] = s * 0.5;
      s = 0.5 / s;
      _qStorage[3] = (rotationMatrixStorage[rotationMatrix.index(k, j)] -
              rotationMatrixStorage[rotationMatrix.index(j, k)]) *
          s;
      _qStorage[j] = (rotationMatrixStorage[rotationMatrix.index(j, i)] +
              rotationMatrixStorage[rotationMatrix.index(i, j)]) *
          s;
      _qStorage[k] = (rotationMatrixStorage[rotationMatrix.index(k, i)] +
              rotationMatrixStorage[rotationMatrix.index(i, k)]) *
          s;
    }
  }

  void setFromTwoVectors(Vector3 a, Vector3 b) {
    final Vector3 v1 = a.normalized();
    final Vector3 v2 = b.normalized();

    final double c = v1.dot(v2);
    double angle = math.acos(c);
    Vector3 axis = v1.cross(v2);

    if ((1.0 + c).abs() < 0.0005) {
      // c \approx -1 indicates 180 degree rotation
      angle = math.pi;

      // a and b are parallel in opposite directions. We need any
      // vector as our rotation axis that is perpendicular.
      // Find one by taking the cross product of v1 with an appropriate unit axis
      if (v1.x > v1.y && v1.x > v1.z) {
        // v1 points in a dominantly x direction, so don't cross with that axis
        axis = v1.cross(new Vector3(0.0, 1.0, 0.0));
      } else {
        // Predominantly points in some other direction, so x-axis should be safe
        axis = v1.cross(new Vector3(1.0, 0.0, 0.0));
      }
    } else if ((1.0 - c).abs() < 0.0005) {
      // c \approx 1 is 0-degree rotation, axis is arbitrary
      angle = 0.0;
      axis = new Vector3(1.0, 0.0, 0.0);
    }

    setAxisAngle(axis.normalized(), angle);
  }

  /// Set the quaternion to a random rotation. The random number generator [rn]
  /// is used to generate the random numbers for the rotation.
  void setRandom(math.Random rn) {
    // From: "Uniform Random Rotations", Ken Shoemake, Graphics Gems III,
    // pg. 124-132.
    final double x0 = rn.nextDouble();
    final double r1 = math.sqrt(1.0 - x0);
    final double r2 = math.sqrt(x0);
    final double t1 = math.pi * 2.0 * rn.nextDouble();
    final double t2 = math.pi * 2.0 * rn.nextDouble();
    final double c1 = math.cos(t1);
    final double s1 = math.sin(t1);
    final double c2 = math.cos(t2);
    final double s2 = math.sin(t2);
    _qStorage[0] = s1 * r1;
    _qStorage[1] = c1 * r1;
    _qStorage[2] = s2 * r2;
    _qStorage[3] = c2 * r2;
  }

  /// Set the quaternion to the time derivative of [q] with angular velocity
  /// [omega].
  void setDQ(Quaternion q, Vector3 omega) {
    final Float32List qStorage = q._qStorage;
    final Float32List omegaStorage = omega.storage;
    final double qx = qStorage[0];
    final double qy = qStorage[1];
    final double qz = qStorage[2];
    final double qw = qStorage[3];
    final double ox = omegaStorage[0];
    final double oy = omegaStorage[1];
    final double oz = omegaStorage[2];
    final double _x = ox * qw + oy * qz - oz * qy;
    final double _y = oy * qw + oz * qx - ox * qz;
    final double _z = oz * qw + ox * qy - oy * qx;
    final double _w = -ox * qx - oy * qy - oz * qz;
    _qStorage[0] = _x * 0.5;
    _qStorage[1] = _y * 0.5;
    _qStorage[2] = _z * 0.5;
    _qStorage[3] = _w * 0.5;
  }

  /// Set quaternion with rotation of [yaw], [pitch] and [roll].
  void setEuler(double yaw, double pitch, double roll) {
    final double halfYaw = yaw * 0.5;
    final double halfPitch = pitch * 0.5;
    final double halfRoll = roll * 0.5;
    final double cosYaw = math.cos(halfYaw);
    final double sinYaw = math.sin(halfYaw);
    final double cosPitch = math.cos(halfPitch);
    final double sinPitch = math.sin(halfPitch);
    final double cosRoll = math.cos(halfRoll);
    final double sinRoll = math.sin(halfRoll);
    _qStorage[0] = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
    _qStorage[1] = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
    _qStorage[2] = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw;
    _qStorage[3] = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw;
  }

  /// Normalize [this].
  double normalize() {
    final double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    final double d = 1.0 / l;
    _qStorage[0] *= d;
    _qStorage[1] *= d;
    _qStorage[2] *= d;
    _qStorage[3] *= d;
    return l;
  }

  /// Conjugate [this].
  void conjugate() {
    _qStorage[2] = -_qStorage[2];
    _qStorage[1] = -_qStorage[1];
    _qStorage[0] = -_qStorage[0];
  }

  /// Invert [this].
  void inverse() {
    final double l = 1.0 / length2;
    _qStorage[3] = _qStorage[3] * l;
    _qStorage[2] = -_qStorage[2] * l;
    _qStorage[1] = -_qStorage[1] * l;
    _qStorage[0] = -_qStorage[0] * l;
  }

  /// Normalized copy of [this].
  Quaternion normalized() => clone()..normalize();

  /// Conjugated copy of [this].
  Quaternion conjugated() => clone()..conjugate();

  /// Inverted copy of [this].
  Quaternion inverted() => clone()..inverse();

  /// [radians] of rotation around the [axis] of the rotation.
  double get radians => 2.0 * math.acos(_qStorage[3]);

  /// [axis] of rotation.
  Vector3 get axis {
    final double den = 1.0 - (_qStorage[3] * _qStorage[3]);
    if (den < 0.0005) {
      // 0-angle rotation, so axis does not matter
      return new Vector3.zero();
    }

    final double scale = 1.0 / math.sqrt(den);
    return new Vector3(
        _qStorage[0] * scale, _qStorage[1] * scale, _qStorage[2] * scale);
  }

  /// Length squared.
  double get length2 {
    final double x = _qStorage[0];
    final double y = _qStorage[1];
    final double z = _qStorage[2];
    final double w = _qStorage[3];
    return (x * x) + (y * y) + (z * z) + (w * w);
  }

  /// Length.
  double get length => math.sqrt(length2);

  /// Returns a copy of [v] rotated by quaternion.
  Vector3 rotated(Vector3 v) {
    final Vector3 out = v.clone();
    rotate(out);
    return out;
  }

  /// Rotates [v] by [this].
  Vector3 rotate(Vector3 v) {
    // conjugate(this) * [v,0] * this
    final double _w = _qStorage[3];
    final double _z = _qStorage[2];
    final double _y = _qStorage[1];
    final double _x = _qStorage[0];
    final double tiw = _w;
    final double tiz = -_z;
    final double tiy = -_y;
    final double tix = -_x;
    final double tx = tiw * v.x + tix * 0.0 + tiy * v.z - tiz * v.y;
    final double ty = tiw * v.y + tiy * 0.0 + tiz * v.x - tix * v.z;
    final double tz = tiw * v.z + tiz * 0.0 + tix * v.y - tiy * v.x;
    final double tw = tiw * 0.0 - tix * v.x - tiy * v.y - tiz * v.z;
    final double result_x = tw * _x + tx * _w + ty * _z - tz * _y;
    final double result_y = tw * _y + ty * _w + tz * _x - tx * _z;
    final double result_z = tw * _z + tz * _w + tx * _y - ty * _x;
    final Float32List vStorage = v.storage;
    vStorage[2] = result_z;
    vStorage[1] = result_y;
    vStorage[0] = result_x;
    return v;
  }

  /// Add [arg] to [this].
  void add(Quaternion arg) {
    final Float32List argStorage = arg._qStorage;
    _qStorage[0] = _qStorage[0] + argStorage[0];
    _qStorage[1] = _qStorage[1] + argStorage[1];
    _qStorage[2] = _qStorage[2] + argStorage[2];
    _qStorage[3] = _qStorage[3] + argStorage[3];
  }

  /// Subtracts [arg] from [this].
  void sub(Quaternion arg) {
    final Float32List argStorage = arg._qStorage;
    _qStorage[0] = _qStorage[0] - argStorage[0];
    _qStorage[1] = _qStorage[1] - argStorage[1];
    _qStorage[2] = _qStorage[2] - argStorage[2];
    _qStorage[3] = _qStorage[3] - argStorage[3];
  }

  /// Scales [this] by [scale].
  void scale(double scale) {
    _qStorage[3] = _qStorage[3] * scale;
    _qStorage[2] = _qStorage[2] * scale;
    _qStorage[1] = _qStorage[1] * scale;
    _qStorage[0] = _qStorage[0] * scale;
  }

  /// Scaled copy of [this].
  Quaternion scaled(double scale) => clone()..scale(scale);

  /// [this] rotated by [other].
  Quaternion operator *(Quaternion other) {
    final double _w = _qStorage[3];
    final double _z = _qStorage[2];
    final double _y = _qStorage[1];
    final double _x = _qStorage[0];
    final Float32List otherStorage = other._qStorage;
    final double ow = otherStorage[3];
    final double oz = otherStorage[2];
    final double oy = otherStorage[1];
    final double ox = otherStorage[0];
    return new Quaternion(
        _w * ox + _x * ow + _y * oz - _z * oy,
        _w * oy + _y * ow + _z * ox - _x * oz,
        _w * oz + _z * ow + _x * oy - _y * ox,
        _w * ow - _x * ox - _y * oy - _z * oz);
  }

  /// Returns copy of [this] + [other].
  Quaternion operator +(Quaternion other) => clone()..add(other);

  /// Returns copy of [this] - [other].
  Quaternion operator -(Quaternion other) => clone()..sub(other);

  /// Returns negated copy of [this].
  Quaternion operator -() => conjugated();

  /// Access the component of the quaternion at the index [i].
  double operator [](int i) => _qStorage[i];

  /// Set the component of the quaternion at the index [i].
  void operator []=(int i, double arg) {
    _qStorage[i] = arg;
  }

  /// Returns a rotation matrix containing the same rotation as [this].
  Matrix3 asRotationMatrix() => copyRotationInto(new Matrix3.zero());

  /// Set [rotationMatrix] to a rotation matrix containing the same rotation as
  /// [this].
  Matrix3 copyRotationInto(Matrix3 rotationMatrix) {
    final double d = length2;
    assert(d != 0.0);
    final double s = 2.0 / d;

    final double _x = _qStorage[0];
    final double _y = _qStorage[1];
    final double _z = _qStorage[2];
    final double _w = _qStorage[3];

    final double xs = _x * s;
    final double ys = _y * s;
    final double zs = _z * s;

    final double wx = _w * xs;
    final double wy = _w * ys;
    final double wz = _w * zs;

    final double xx = _x * xs;
    final double xy = _x * ys;
    final double xz = _x * zs;

    final double yy = _y * ys;
    final double yz = _y * zs;
    final double zz = _z * zs;

    final Float32List rotationMatrixStorage = rotationMatrix.storage;
    rotationMatrixStorage[0] = 1.0 - (yy + zz); // column 0
    rotationMatrixStorage[1] = xy + wz;
    rotationMatrixStorage[2] = xz - wy;
    rotationMatrixStorage[3] = xy - wz; // column 1
    rotationMatrixStorage[4] = 1.0 - (xx + zz);
    rotationMatrixStorage[5] = yz + wx;
    rotationMatrixStorage[6] = xz + wy; // column 2
    rotationMatrixStorage[7] = yz - wx;
    rotationMatrixStorage[8] = 1.0 - (xx + yy);
    return rotationMatrix;
  }

  /// Printable string.
  @override
  String toString() => '${_qStorage[0]}, ${_qStorage[1]},'
      ' ${_qStorage[2]} @ ${_qStorage[3]}';

  /// Relative error between [this] and [correct].
  double relativeError(Quaternion correct) {
    final Quaternion diff = correct - this;
    final double norm_diff = diff.length;
    final double correct_norm = correct.length;
    return norm_diff / correct_norm;
  }

  /// Absolute error between [this] and [correct].
  double absoluteError(Quaternion correct) {
    final double this_norm = length;
    final double correct_norm = correct.length;
    final double norm_diff = (this_norm - correct_norm).abs();
    return norm_diff;
  }
}
