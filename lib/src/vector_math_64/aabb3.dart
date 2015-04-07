// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_64;

class Aabb3 {
  final Vector3 _min;
  final Vector3 _max;

  Vector3 get min => _min;
  Vector3 get max => _max;

  Vector3 get center {
    Vector3 c = new Vector3.copy(_min);
    return c.add(_max).scale(.5);
  }

  Aabb3()
      : _min = new Vector3.zero(),
        _max = new Vector3.zero();

  Aabb3.copy(Aabb3 other)
      : _min = new Vector3.copy(other._min),
        _max = new Vector3.copy(other._max);

  @deprecated
  Aabb3.minmax(Vector3 min_, Vector3 max_)
      : _min = new Vector3.copy(min_),
        _max = new Vector3.copy(max_);

  Aabb3.minMax(Vector3 min_, Vector3 max_)
      : _min = new Vector3.copy(min_),
        _max = new Vector3.copy(max_);

  void copyMinMax(Vector3 min_, Vector3 max_) {
    max_.setFrom(_max);
    min_.setFrom(_min);
  }

  /// Constructs Aabb3 with a min/max [storage] that views given [buffer] starting at [offset].
  /// [offset] has to be multiple of [Float64List.BYTES_PER_ELEMENT].
  Aabb3.fromBuffer(ByteBuffer buffer, int offset)
      : _min = new Vector3.fromBuffer(buffer, offset),
        _max = new Vector3.fromBuffer(
            buffer, offset + Float64List.BYTES_PER_ELEMENT * 3);

  void copyCenterAndHalfExtents(Vector3 center, Vector3 halfExtents) {
    center.setFrom(_min);
    center.add(_max);
    center.scale(0.5);
    halfExtents.setFrom(_max);
    halfExtents.sub(_min);
    halfExtents.scale(0.5);
  }

  void copyFrom(Aabb3 o) {
    _min.setFrom(o._min);
    _max.setFrom(o._max);
  }

  void copyInto(Aabb3 o) {
    o._min.setFrom(_min);
    o._max.setFrom(_max);
  }

  Aabb3 transform(Matrix4 T) {
    Vector3 center = new Vector3.zero();
    Vector3 halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    T.transform3(center);
    T.absoluteRotate(halfExtents);
    _min.setFrom(center);
    _max.setFrom(center);

    _min.sub(halfExtents);
    _max.add(halfExtents);
    return this;
  }

  Aabb3 rotate(Matrix4 T) {
    Vector3 center = new Vector3.zero();
    Vector3 halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    T.absoluteRotate(halfExtents);
    _min.setFrom(center);
    _max.setFrom(center);

    _min.sub(halfExtents);
    _max.add(halfExtents);
    return this;
  }

  Aabb3 transformed(Matrix4 T, Aabb3 out) {
    out.copyFrom(this);
    return out.transform(T);
  }

  Aabb3 rotated(Matrix4 T, Aabb3 out) {
    out.copyFrom(this);
    return out.rotate(T);
  }

  void getPN(Vector3 planeNormal, Vector3 outP, Vector3 outN) {
    outP.x = planeNormal.x < 0.0 ? _min.x : _max.x;
    outP.y = planeNormal.y < 0.0 ? _min.y : _max.y;
    outP.z = planeNormal.z < 0.0 ? _min.z : _max.z;

    outN.x = planeNormal.x < 0.0 ? _max.x : _min.x;
    outN.y = planeNormal.y < 0.0 ? _max.y : _min.y;
    outN.z = planeNormal.z < 0.0 ? _max.z : _min.z;
  }

  /// Set the min and max of [this] so that [this] is a hull of [this] and [other].
  void hull(Aabb3 other) {
    min.x = Math.min(_min.x, other.min.x);
    min.y = Math.min(_min.y, other.min.y);
    min.z = Math.min(_min.z, other.min.z);
    max.x = Math.max(_max.x, other.max.x);
    max.y = Math.max(_max.y, other.max.y);
    max.z = Math.max(_max.z, other.max.y);
  }

  /// Set the min and max of [this] so that [this] contains [point].
  void hullPoint(Vector3 point) {
    Vector3.min(_min, point, _min);
    Vector3.max(_max, point, _max);
  }

  /// Return if [this] contains [other].
  bool containsAabb3(Aabb3 other) {
    return min.x < other.min.x &&
        min.y < other.min.y &&
        min.z < other.min.z &&
        max.x > other.max.x &&
        max.y > other.max.y &&
        max.z > other.max.z;
  }

  /// Return if [this] contains [other].
  bool containsSphere(Sphere other) {
    final sphereExtends = new Vector3.zero().splat(other.radius);
    final sphereBox = new Aabb3.minMax(other.center.clone().sub(sphereExtends),
        other.center.clone().add(sphereExtends));

    return containsAabb3(sphereBox);
  }

  /// Return if [this] contains [other].
  bool containsVector3(Vector3 other) {
    return min.x < other.x &&
        min.y < other.y &&
        min.z < other.z &&
        max.x > other.x &&
        max.y > other.y &&
        max.z > other.z;
  }

  /// Return if [this] contains [other].
  bool containsTriangle(Triangle other) {
    return containsVector3(other.point0) &&
        containsVector3(other.point1) &&
        containsVector3(other.point2);
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithAabb3(Aabb3 other) {
    return min.x <= other.max.x &&
        min.y <= other.max.y &&
        min.z <= other.max.z &&
        max.x >= other.min.x &&
        max.y >= other.min.y &&
        max.z >= other.min.z;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithSphere(Sphere other) {
    double d = 0.0;
    double e = 0.0;

    for (int i = 0; i < 3; ++i) {
      if ((e = other.center[i] - min[i]) < 0.0) {
        if (e < -other.radius) {
          return false;
        }

        d = d + e * e;
      } else if ((e = other.center[i] - max[i]) > 0.0) {
        if (e > other.radius) {
          return false;
        }

        d = d + e * e;
      }
    }

    return d <= other.radius * other.radius;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithVector3(Vector3 other) {
    return min.x <= other.x &&
        min.y <= other.y &&
        min.z <= other.z &&
        max.x >= other.x &&
        max.y >= other.y &&
        max.z >= other.z;
  }
}
