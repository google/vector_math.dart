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

class Quaternion {
  final Float32List storage;

  double get x => storage[0];
  double get y => storage[1];
  double get z => storage[2];
  double get w => storage[3];
  set x(double x) { storage[0] = x; }
  set y(double y) { storage[1] = y; }
  set z(double z) { storage[2] = z; }
  set w(double w) { storage[3] = w; }

  /// Constructs a quaternion using the raw values [x], [y], [z], and [w]
  Quaternion(double x, double y, double z, double w) : storage = new Float32List(4) {
    storage[0] = x;
    storage[1] = y;
    storage[2] = z;
    storage[3] = w;
  }

  /// From a rotation matrix [rotationMatrix].
  Quaternion.fromRotation(Matrix3 rotationMatrix) : storage = new Float32List(4) {
    double trace = rotationMatrix.trace();
    if (trace > 0.0) {
      double s = Math.sqrt(trace + 1.0);
      storage[3] = s * 0.5;
      s = 0.5 / s;
      storage[0] = (rotationMatrix.storage[5] -
                     rotationMatrix.storage[7]) * s;
      storage[1] = (rotationMatrix.storage[6] -
                     rotationMatrix.storage[2]) * s;
      storage[2] = (rotationMatrix.storage[1] -
                     rotationMatrix.storage[3]) * s;
    } else {
      int i = rotationMatrix.storage[0] < rotationMatrix.storage[4] ?
              (rotationMatrix.storage[4] < rotationMatrix.storage[8] ? 2 : 1)
              :
              (rotationMatrix.storage[0] < rotationMatrix.storage[8] ? 2 : 0);
      int j = (i + 1) % 3;
      int k = (i + 2) % 3;
      double s = Math.sqrt(rotationMatrix.entry(i,i) -
                           rotationMatrix.entry(j,j) -
                           rotationMatrix.entry(k,k) + 1.0);
      storage[i] = s * 0.5;
      s = 0.5 / s;
      storage[3] = (rotationMatrix.entry(k,j) - rotationMatrix.entry(j,k)) * s;
      storage[j] = (rotationMatrix.entry(j,i) + rotationMatrix.entry(i,j)) * s;
      storage[k] = (rotationMatrix.entry(k,i) + rotationMatrix.entry(i,k)) * s;
    }
  }

  /// Rotation of [angle] around [axis].
  Quaternion.axisAngle(Vector3 axis, double angle) : storage = new Float32List(4) {
    setAxisAngle(axis, angle);
  }

  /// Copies [original].
  Quaternion.copy(Quaternion original) : storage = new Float32List(4) {
    storage[0] = original.storage[0];
    storage[1] = original.storage[1];
    storage[2] = original.storage[2];
    storage[3] = original.storage[3];
  }

  /// Random rotation.
  Quaternion.random(Math.Random rn) : storage = new Float32List(4) {
    // From: "Uniform Random Rotations", Ken Shoemake, Graphics Gems III,
    // pg. 124-132.
    double x0 = rn.nextDouble();
    double r1 = Math.sqrt(1.0 - x0);
    double r2 = Math.sqrt(x0);
    double t1 = Math.PI*2.0 * rn.nextDouble();
    double t2 = Math.PI*2.0 * rn.nextDouble();
    double c1 = Math.cos(t1);
    double s1 = Math.sin(t1);
    double c2 = Math.cos(t2);
    double s2 = Math.sin(t2);
    storage[0] = s1 * r1;
    storage[1] = c1 * r1;
    storage[2] = s2 * r2;
    storage[3] = c2 * r2;
  }

  /// Constructs the identity quaternion
  Quaternion.identity() : storage = new Float32List(4) {
    storage[3] = 1.0;
  }

  /// Time derivative of [q] with angular velocity [omega].
  Quaternion.dq(Quaternion q, Vector3 omega) : storage = new Float32List(4) {
    double qx = q.storage[0];
    double qy = q.storage[1];
    double qz = q.storage[2];
    double qw = q.storage[3];
    double ox = omega.storage[0];
    double oy = omega.storage[1];
    double oz = omega.storage[2];
    double _x = ox * qw + oy * qz - oz * qy;
    double _y = oy * qw + oz * qx - ox * qz;
    double _z = oz * qw + ox * qy - oy * qx;
    double _w = -ox * qx - oy * qy - oz * qz;
    storage[0] = _x * 0.5;
    storage[1] = _y * 0.5;
    storage[2] = _z * 0.5;
    storage[3] = _w * 0.5;
  }


  /// Constructs Quaternion with given Float32List as [storage].
  Quaternion.fromFloat32List(Float32List this.storage);

  /// Constructs Quaternion with a [storage] that views given [buffer] starting at [offset].
  /// [offset] has to be multiple of [Float32List.BYTES_PER_ELEMENT].
  Quaternion.fromBuffer(ByteBuffer buffer, int offset) : storage = new Float32List.view(buffer, offset, 4);

  /// Returns a new copy of this
  Quaternion clone() {
    return new Quaternion.copy(this);
  }

  /// Copy [source] into [this]
  void copyFrom(Quaternion source) {
    storage[0] = source.storage[0];
    storage[1] = source.storage[1];
    storage[2] = source.storage[2];
    storage[3] = source.storage[3];
  }

  /// Copy [this] into [target].
  void copyTo(Quaternion target) {
    target.storage[0] = storage[0];
    target.storage[1] = storage[1];
    target.storage[2] = storage[2];
    target.storage[3] = storage[3];
  }

  /// Set quaternion with rotation of [radians] around [axis].
  void setAxisAngle(Vector3 axis, double radians) {
    double len = axis.length;
    if (len == 0.0) {
      return;
    }
    double halfSin = Math.sin(radians * 0.5) / len;
    storage[0] = axis.storage[0] * halfSin;
    storage[1] = axis.storage[1] * halfSin;
    storage[2] = axis.storage[2] * halfSin;
    storage[3] = Math.cos(radians * 0.5);
  }

  /// Set quaternion with rotation of [yaw], [pitch] and [roll].
  void setEuler(double yaw, double pitch, double roll) {
    double halfYaw = yaw * 0.5;
    double halfPitch = pitch * 0.5;
    double halfRoll = roll * 0.5;
    double cosYaw = Math.cos(halfYaw);
    double sinYaw = Math.sin(halfYaw);
    double cosPitch = Math.cos(halfPitch);
    double sinPitch = Math.sin(halfPitch);
    double cosRoll = Math.cos(halfRoll);
    double sinRoll = Math.sin(halfRoll);
    storage[0] = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
    storage[1] = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
    storage[2] = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw;
    storage[3] = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw;
  }

  /// Normalize [this].
  Quaternion normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    storage[3] = storage[3] * l;
    storage[2] = storage[2] * l;
    storage[1] = storage[1] * l;
    storage[0] = storage[0] * l;
    return this;
  }

  /// Conjugate [this].
  Quaternion conjugate() {
    storage[2] = -storage[2];
    storage[1] = -storage[1];
    storage[0] = -storage[0];
    return this;
  }

  /// Invert [this].
  Quaternion inverse() {
    double l = 1.0 / length2;
    storage[3] = storage[3] * l;
    storage[2] = -storage[2] * l;
    storage[1] = -storage[1] * l;
    storage[0] = -storage[0] * l;
    return this;
  }

  /// Normalized copy of [this].
  Quaternion normalized() {
    return new Quaternion.copy(this).normalize();
  }

  /// Conjugated copy of [this].
  Quaternion conjugated() {
    return new Quaternion.copy(this).conjugate();
  }

  /// Inverted copy of [this].
  Quaternion inverted() {
    return new Quaternion.copy(this).inverse();
  }

  /// Radians of rotation.
  double get radians => 2.0 * Math.acos(storage[3]);

  /// Axis of rotation.
  Vector3 get axis {
      double scale = 1.0 / (1.0 - (storage[3] * storage[3]));
      return new Vector3(storage[0] * scale,
                      storage[1] * scale,
                      storage[2] * scale);
  }

  /// Length squared.
  double get length2 {
    double _x = storage[0];
    double _y = storage[1];
    double _z = storage[2];
    double _w = storage[3];
    return (_x * _x) + (_y * _y) + (_z * _z) + (_w * _w);
  }

  /// Length.
  double get length {
    return Math.sqrt(length2);
  }

  /// Returns a copy of [v] rotated by quaternion.
  Vector3 rotated(Vector3 v) {
    Vector3 out = new Vector3.copy(v);
    return rotate(out);
  }

  /// Rotates [v] by [this].
  Vector3 rotate(Vector3 v) {
    // conjugate(this) * [v,0] * this
    double _w = storage[3];
    double _z = storage[2];
    double _y = storage[1];
    double _x = storage[0];
    double tiw = _w;
    double tiz = -_z;
    double tiy = -_y;
    double tix = -_x;
    double tx = tiw * v.x + tix * 0.0 + tiy * v.z - tiz * v.y;
    double ty = tiw * v.y + tiy * 0.0 + tiz * v.x - tix * v.z;
    double tz = tiw * v.z + tiz * 0.0 + tix * v.y - tiy * v.x;
    double tw = tiw * 0.0 - tix * v.x - tiy * v.y - tiz * v.z;
    double result_x = tw * _x + tx * _w + ty * _z - tz * _y;
    double result_y = tw * _y + ty * _w + tz * _x - tx * _z;
    double result_z = tw * _z + tz * _w + tx * _y - ty * _x;
    v.storage[2] = result_z;
    v.storage[1] = result_y;
    v.storage[0] = result_x;
    return v;
  }

  /// Scales [this] by [scale].
  Quaternion scale(double scale) {
    storage[3] = storage[3] * scale;
    storage[2] = storage[2] * scale;
    storage[1] = storage[1] * scale;
    storage[0] = storage[0] * scale;
    return this;
  }

  /// Scaled copy of [this].
  Quaternion scaled(double scale) {
    Quaternion q = new Quaternion.copy(this);
    return q.scale(scale);
  }

  /// [this] rotated by [other].
  Quaternion operator*(Quaternion other) {
    double _w = storage[3];
    double _z = storage[2];
    double _y = storage[1];
    double _x = storage[0];
    double ow = other.storage[3];
    double oz = other.storage[2];
    double oy = other.storage[1];
    double ox = other.storage[0];
    return new Quaternion(_w * ox + _x * ow + _y * oz - _z * oy,
                    _w * oy + _y * ow + _z * ox - _x * oz,
                    _w * oz + _z * ow + _x * oy - _y * ox,
                    _w * ow - _x * ox - _y * oy - _z * oz);
  }

  /// Returns copy of [this] + [other].
  Quaternion operator+(Quaternion other) {
    return new Quaternion(storage[0] + other.storage[0],
                    storage[1] + other.storage[1],
                    storage[2] + other.storage[2],
                    storage[3] + other.storage[3]);
  }

  /// Returns copy of [this] - [other].
  Quaternion operator-(Quaternion other) {
    return new Quaternion(storage[0] - other.storage[0],
                    storage[1] - other.storage[1],
                    storage[2] - other.storage[2],
                    storage[3] - other.storage[3]);
  }

  /// Returns negated copy of [this].
  Quaternion operator-() {
    return new Quaternion(-storage[0], -storage[1], -storage[2], -storage[3]);
  }

  double operator[](int i) => storage[i];

  void operator[]=(int i, double arg) {
    storage[i] = arg;
  }

  /// Returns a rotation matrix containing the same rotation as [this].
  Matrix3 asRotationMatrix() {
    double d = length2;
    assert(d != 0.0);
    double s = 2.0 / d;

    double _x = storage[0];
    double _y = storage[1];
    double _z = storage[2];
    double _w = storage[3];

    double xs = _x * s;
    double ys = _y * s;
    double zs = _z * s;

    double wx = _w * xs;
    double wy = _w * ys;
    double wz = _w * zs;

    double xx = _x * xs;
    double xy = _x * ys;
    double xz = _x * zs;

    double yy = _y * ys;
    double yz = _y * zs;
    double zz = _z * zs;

    return new Matrix3(1.0 - (yy + zz), xy + wz, xz - wy, // column 0
                    xy - wz, 1.0 - (xx + zz), yz + wx, // column 1
                    xz + wy, yz - wx, 1.0 - (xx + yy)); // column 2
  }

  /// Printable string.
  String toString() {
    return '${storage[0]}, ${storage[1]}, ${storage[2]} @ ${storage[3]}';
  }

  /// Relative error between [this] and [correct].
  double relativeError(Quaternion correct) {
    Quaternion diff = correct - this;
    double norm_diff = diff.length;
    double correct_norm = correct.length;
    return norm_diff/correct_norm;
  }

  /// Absolute error between [this] and [correct].
  double absoluteError(Quaternion correct) {
    double this_norm = length;
    double correct_norm = correct.length;
    double norm_diff = (this_norm - correct_norm).abs();
    return norm_diff;
  }
}
