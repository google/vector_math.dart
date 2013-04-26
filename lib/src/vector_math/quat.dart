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

class quat {
  final Float32List _storage = new Float32List(4);
  Float32List get storage => _storage;
  double get x => _storage[0];
  double get y => _storage[0];
  double get z => _storage[0];
  double get w => _storage[0];
  set x(double x) { _storage[0] = x; }
  set y(double y) { _storage[1] = y; }
  set z(double z) { _storage[2] = z; }
  set w(double w) { _storage[3] = w; }

  /// Constructs a quaternion using the raw values [x], [y], [z], and [w]
  quat(double x, double y, double z, double w) {
    _storage[0] = x;
    _storage[1] = y;
    _storage[2] = z;
    _storage[3] = w;
  }

  /// From a rotation matrix [rotationMatrix].
  quat.fromRotation(mat3 rotationMatrix) {
    double trace = rotationMatrix.trace();
    if (trace > 0.0) {
      double s = Math.sqrt(trace + 1.0);
      _storage[3] = s * 0.5;
      s = 0.5 / s;
      _storage[0] = (rotationMatrix._storage[5] -
                     rotationMatrix._storage[7]) * s;
      _storage[1] = (rotationMatrix._storage[6] -
                     rotationMatrix._storage[2]) * s;
      _storage[2] = (rotationMatrix._storage[1] -
                     rotationMatrix._storage[3]) * s;
    } else {
      int i = rotationMatrix._storage[0] < rotationMatrix._storage[4] ?
              (rotationMatrix._storage[4] < rotationMatrix._storage[8] ? 2 : 1)
              :
              (rotationMatrix._storage[0] < rotationMatrix._storage[8] ? 2 : 0);
      int j = (i + 1) % 3;
      int k = (i + 2) % 3;
      double s = Math.sqrt(rotationMatrix.entry(i,i) -
                           rotationMatrix.entry(j,j) -
                           rotationMatrix.entry(k,k) + 1.0);
      _storage[i] = s * 0.5;
      s = 0.5 / s;
      _storage[3] = (rotationMatrix.entry(k,j) - rotationMatrix.entry(j,k)) * s;
      _storage[j] = (rotationMatrix.entry(j,i) + rotationMatrix.entry(i,j)) * s;
      _storage[k] = (rotationMatrix.entry(k,i) + rotationMatrix.entry(i,k)) * s;
    }
  }

  /// Rotation of [angle] around [axis].
  quat.axisAngle(vec3 axis, double angle) {
    setAxisAngle(axis, angle);
  }

  /// Copies [original].
  quat.copy(quat original) {
    _storage[0] = original._storage[0];
    _storage[1] = original._storage[1];
    _storage[2] = original._storage[2];
    _storage[3] = original._storage[3];
  }

  /// Random rotation.
  quat.random(Math.Random rn) {
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
    _storage[0] = s1 * r1;
    _storage[1] = c1 * r1;
    _storage[2] = s2 * r2;
    _storage[3] = c2 * r2;
  }

  /// Constructs the identity quaternion
  quat.identity() {
    _storage[3] = 1.0;
  }

  /// Time derivative of [q] with angular velocity [omega].
  quat.dq(quat q, vec3 omega) {
    double qx = q._storage[0];
    double qy = q._storage[1];
    double qz = q._storage[2];
    double qw = q._storage[3];
    double ox = omega._storage[0];
    double oy = omega._storage[1];
    double oz = omega._storage[2];
    double _x = ox * qw + oy * qz - oz * qy;
    double _y = oy * qw + oz * qx - ox * qz;
    double _z = oz * qw + ox * qy - oy * qx;
    double _w = -ox * qx - oy * qy - oz * qz;
    _storage[0] = _x * 0.5;
    _storage[1] = _y * 0.5;
    _storage[2] = _z * 0.5;
    _storage[3] = _w * 0.5;
  }

  /// Returns a new copy of this
  quat clone() {
    return new quat.copy(this);
  }

  /// Copy [source] into [this]
  void copyFrom(quat source) {
    _storage[0] = source._storage[0];
    _storage[1] = source._storage[1];
    _storage[2] = source._storage[2];
    _storage[3] = source._storage[3];
  }

  /// Copy [this] into [target].
  void copyTo(quat target) {
    target._storage[0] = _storage[0];
    target._storage[1] = _storage[1];
    target._storage[2] = _storage[2];
    target._storage[3] = _storage[3];
  }

  /// Set quaternion with rotation of [radians] around [axis].
  void setAxisAngle(vec3 axis, double radians) {
    double len = axis.length;
    if (len == 0.0) {
      return;
    }
    double halfSin = sin(radians * 0.5) / len;
    _storage[0] = axis._storage[0] * halfSin;
    _storage[1] = axis._storage[1] * halfSin;
    _storage[2] = axis._storage[2] * halfSin;
    _storage[3] = cos(radians * 0.5);
  }

  /** Set quaternion with rotation of [yaw], [pitch] and [roll] */
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
    _storage[0] = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
    _storage[1] = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
    _storage[2] = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw;
    _storage[3] = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw;
  }

  /** Normalize [this] */
  quat normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    l = 1.0 / l;
    _storage[3] = _storage[3] * l;
    _storage[2] = _storage[2] * l;
    _storage[1] = _storage[1] * l;
    _storage[0] = _storage[0] * l;
    return this;
  }

  /** Conjugate [this] */
  quat conjugate() {
    _storage[2] = -_storage[2];
    _storage[1] = -_storage[1];
    _storage[0] = -_storage[0];
    return this;
  }

  /** Invert [this]  */
  quat inverse() {
    double l = 1.0 / length2;
    _storage[3] = _storage[3] * l;
    _storage[2] = -_storage[2] * l;
    _storage[1] = -_storage[1] * l;
    _storage[0] = -_storage[0] * l;
    return this;
  }

  /** Normalized copy of [this]. Optionally stored in [out]*/
  quat normalized([quat out=null]) {
    if (out == null) {
      out = new quat.copy(this);
    }
    return out.normalize();
  }

  /** Conjugated copy of [this]. Optionally stored in [out] */
  quat conjugated([quat out=null]) {
    if (out == null) {
      out = new quat.copy(this);
    }
    return out.conjugate();
  }

  /** Inverted copy of [this]. Optionally stored in [out] */
  quat inverted([quat out=null]) {
    if (out == null) {
      out = new quat.copy(this);
    }
    return out.inverse();
  }

  /** Radians of rotation */
  double get radians => 2.0 * acos(_storage[3]);

  /** Axis of rotation */
  vec3 get axis {
      double scale = 1.0 / (1.0 - (_storage[3] * _storage[3]));
      return new vec3(_storage[0] * scale,
                      _storage[1] * scale,
                      _storage[2] * scale);
  }

  /** Squared length */
  double get length2 {
    double _x = _storage[0];
    double _y = _storage[1];
    double _z = _storage[2];
    double _w = _storage[3];
    return (_x * _x) + (_y * _y) + (_z * _z) + (_w * _w);
  }

  /** Length */
  double get length {
    return Math.sqrt(length2);
  }

  /** Returns a copy of [v] rotated by quaternion. Copy optionally stored in [out] */
  vec3 rotated(vec3 v, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.copy(v);
    } else {
      out.setFrom(v);
    }
    return rotate(out);
  }

  /** Rotates [v] by [this]. Returns [v]. */
  vec3 rotate(vec3 v) {
    // conjugate(this) * [v,0] * this
    double _w = _storage[3];
    double _z = _storage[2];
    double _y = _storage[1];
    double _x = _storage[0];
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
    v._storage[2] = result_z;
    v._storage[1] = result_y;
    v._storage[0] = result_x;
    return v;
  }

  /// Scales [this] by [scale].
  quat scaled(double scale) {
    _storage[3] = _storage[3] * scale;
    _storage[2] = _storage[2] * scale;
    _storage[1] = _storage[1] * scale;
    _storage[0] = _storage[0] * scale;
    return this;
  }

  quat scale(double scale) {
    quat q = new quat.copy(this);
    return q.scaled(scale);
  }

  /// [this] rotated by [other].
  quat operator*(quat other) {
    double _w = _storage[3];
    double _z = _storage[2];
    double _y = _storage[1];
    double _x = _storage[0];
    double ow = other._storage[3];
    double oz = other._storage[2];
    double oy = other._storage[1];
    double ox = other._storage[0];
    return new quat(_w * ox + _x * ow + _y * oz - _z * oy,
                    _w * oy + _y * ow + _z * ox - _x * oz,
                    _w * oz + _z * ow + _x * oy - _y * ox,
                    _w * ow - _x * ox - _y * oy - _z * oz);
  }

  /** Returns copy of [this] - [other] */
  quat operator+(quat other) {
    return new quat(_storage[0] + other._storage[0],
                    _storage[1] + other._storage[1],
                    _storage[2] + other._storage[2],
                    _storage[3] + other._storage[3]);
  }

  /** Returns copy of [this] + [other] */
  quat operator-(quat other) {
    return new quat(_storage[0] - other._storage[0],
                    _storage[1] - other._storage[1],
                    _storage[2] - other._storage[2],
                    _storage[3] - other._storage[3]);
  }

  /** Returns negated copy of [this] */
  quat operator-() {
    return new quat(-_storage[0], -_storage[1], -_storage[2], -_storage[3]);
  }

  double operator[](int i) => _storage[i];

  void operator[]=(int i, double arg) {
    _storage[i] = arg;
  }

  /** Returns a rotation matrix containing the same rotation as [this] */
  mat3 asRotationMatrix() {
    double d = length2;
    assert(d != 0.0);
    double s = 2.0 / d;

    double _x = _storage[0];
    double _y = _storage[1];
    double _z = _storage[2];
    double _w = _storage[3];

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

    return new mat3(1.0 - (yy + zz), xy + wz, xz - wy, // column 0
                    xy - wz, 1.0 - (xx + zz), yz + wx, // column 1
                    xz + wy, yz - wx, 1.0 - (xx + yy)); // column 2
  }

  /** Returns a printable string */
  String toString() {
    return '${_storage[0]}, ${_storage[1]}, ${_storage[2]} @ ${_storage[3]}';
  }

  /** Returns relative error between [this]  and [correct] */
  double relativeError(quat correct) {
    quat diff = correct - this;
    double norm_diff = diff.length;
    double correct_norm = correct.length;
    return norm_diff/correct_norm;
  }

  /** Returns absolute error between [this] and [correct] */
  double absoluteError(quat correct) {
    double this_norm = length;
    double correct_norm = correct.length;
    double norm_diff = (this_norm - correct_norm).abs();
    return norm_diff;
  }
}
