// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

//TODO (fox32): Add setObb, fromObb
//TODO (fox32): Add intersectsWithTriangle, intersectsWithPlane,
// intersectsWithQuad and IntersectionResult

/// Defines a 3-dimensional axis-aligned bounding box between a [min] and a
/// [max] position.
class Aabb3 {
  final Vector3 _min;
  final Vector3 _max;

  Vector3 get min => _min;
  Vector3 get max => _max;

  /// The center of the AABB.
  Vector3 get center => _min.clone()
    ..add(_max)
    ..scale(0.5);

  /// Create a new AABB with [min] and [max] set to the origin.
  Aabb3()
      : _min = new Vector3.zero(),
        _max = new Vector3.zero();

  /// Create a new AABB as a copy of [other].
  Aabb3.copy(Aabb3 other)
      : _min = new Vector3.copy(other._min),
        _max = new Vector3.copy(other._max);

  /// Create a new AABB with a [min] and [max].
  Aabb3.minMax(Vector3 min, Vector3 max)
      : _min = new Vector3.copy(min),
        _max = new Vector3.copy(max);

  /// Create a new AABB that encloses a [sphere].
  factory Aabb3.fromSphere(Sphere sphere) => new Aabb3()..setSphere(sphere);

  /// Create a new AABB that encloses a [triangle].
  factory Aabb3.fromTriangle(Triangle triangle) =>
      new Aabb3()..setTriangle(triangle);

  /// Create a new AABB that encloses a [quad].
  factory Aabb3.fromQuad(Quad quad) => new Aabb3()..setQuad(quad);

  /// Create a new AABB that encloses a limited [ray] (or line segment) that has
  /// a minLimit and maxLimit.
  factory Aabb3.fromRay(Ray ray, double limitMin, double limitMax) =>
      new Aabb3()..setRay(ray, limitMin, limitMax);

  /// Create a new AABB with a [center] and [halfExtents].
  factory Aabb3.centerAndHalfExtents(Vector3 center, Vector3 halfExtents) =>
      new Aabb3()..setCenterAndHalfExtents(center, halfExtents);

  /// Constructs [Aabb3] with a min/max [storage] that views given [buffer]
  /// starting at [offset]. [offset] has to be multiple of
  /// [Float32List.BYTES_PER_ELEMENT].
  Aabb3.fromBuffer(ByteBuffer buffer, int offset)
      : _min = new Vector3.fromBuffer(buffer, offset),
        _max = new Vector3.fromBuffer(
            buffer, offset + Float32List.BYTES_PER_ELEMENT * 3);

  /// Set the AABB by a [center] and [halfExtents].
  void setCenterAndHalfExtents(Vector3 center, Vector3 halfExtents) {
    _min
      ..setFrom(center)
      ..sub(halfExtents);
    _max
      ..setFrom(center)
      ..add(halfExtents);
  }

  /// Set the AABB to enclose a [sphere].
  void setSphere(Sphere sphere) {
    _min
      ..splat(-sphere._radius)
      ..add(sphere._center);
    _max
      ..splat(sphere._radius)
      ..add(sphere._center);
  }

  /// Set the AABB to enclose a [triangle].
  void setTriangle(Triangle triangle) {
    _min.setValues(Math.min(triangle._point0.x,
        Math.min(triangle._point1.x, triangle._point2.x)), Math.min(
        triangle._point0.y,
        Math.min(triangle._point1.y, triangle._point2.y)), Math.min(
        triangle._point0.z, Math.min(triangle._point1.z, triangle._point2.z)));
    _max.setValues(Math.max(triangle._point0.x,
        Math.max(triangle._point1.x, triangle._point2.x)), Math.max(
        triangle._point0.y,
        Math.max(triangle._point1.y, triangle._point2.y)), Math.max(
        triangle._point0.z, Math.max(triangle._point1.z, triangle._point2.z)));
  }

  /// Set the AABB to enclose a [quad].
  void setQuad(Quad quad) {
    _min.setValues(Math.min(quad._point0.x,
            Math.min(quad._point1.x, Math.min(quad._point2.x, quad._point3.x))),
        Math.min(quad._point0.y,
            Math.min(quad._point1.y, Math.min(quad._point2.y, quad._point3.y))),
        Math.min(quad._point0.z, Math.min(
            quad._point1.z, Math.min(quad._point2.z, quad._point3.z))));
    _max.setValues(Math.max(quad._point0.x,
            Math.max(quad._point1.x, Math.max(quad._point2.x, quad._point3.x))),
        Math.max(quad._point0.y,
            Math.max(quad._point1.y, Math.max(quad._point2.y, quad._point3.y))),
        Math.max(quad._point0.z, Math.max(
            quad._point1.z, Math.max(quad._point2.z, quad._point3.z))));
  }

  /// Set the AABB to enclose a limited [ray] (or line segment) that is limited
  /// by [limitMin] and [limitMax].
  void setRay(Ray ray, double limitMin, double limitMax) {
    ray.copyAt(_min, limitMin);
    ray.copyAt(_max, limitMax);

    if (_max.x < _min.x) {
      final temp = _max.x;
      _max.x = _min.x;
      _min.x = temp;
    }

    if (_max.y < _min.y) {
      final temp = _max.y;
      _max.y = _min.y;
      _min.y = temp;
    }

    if (_max.z < _min.z) {
      final temp = _max.z;
      _max.z = _min.z;
      _min.z = temp;
    }
  }

  /// Copy the [center] and the [halfExtends] of [this].
  void copyCenterAndHalfExtents(Vector3 center, Vector3 halfExtents) {
    center
      ..setFrom(_min)
      ..add(_max)
      ..scale(0.5);
    halfExtents
      ..setFrom(_max)
      ..sub(_min)
      ..scale(0.5);
  }

  /// Copy the [center] of [this].
  void copyCenter(Vector3 center) {
    center
      ..setFrom(_min)
      ..add(_max)
      ..scale(0.5);
  }

  /// Copy the [min] and [max] from [other] into [this].
  void copyFrom(Aabb3 other) {
    _min.setFrom(other._min);
    _max.setFrom(other._max);
  }

  /// Transform [this] by the transform [t].
  Aabb3 transform(Matrix4 t) {
    final center = new Vector3.zero();
    final halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t
      ..transform3(center)
      ..absoluteRotate(halfExtents);
    _min
      ..setFrom(center)
      ..sub(halfExtents);
    _max
      ..setFrom(center)
      ..add(halfExtents);
    return this;
  }

  /// Rotate [this] by the rotation matrix [t].
  Aabb3 rotate(Matrix4 t) {
    final center = new Vector3.zero();
    final halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t.absoluteRotate(halfExtents);
    _min
      ..setFrom(center)
      ..sub(halfExtents);
    _max
      ..setFrom(center)
      ..add(halfExtents);
    return this;
  }

  /// Create a copy of [this] that is transformed by the transform [t] and store
  /// it in [out].
  Aabb3 transformed(Matrix4 t, Aabb3 out) => out
    ..copyFrom(this)
    ..transform(t);

  /// Create a copy of [this] that is rotated by the rotation matrix [t] and
  /// store it in [out].
  Aabb3 rotated(Matrix4 t, Aabb3 out) => out
    ..copyFrom(this)
    ..rotate(t);

  void getPN(Vector3 planeNormal, Vector3 outP, Vector3 outN) {
    if (planeNormal.x < 0.0) {
      outP.x = _min.x;
      outN.x = _max.x;
    } else {
      outP.x = _max.x;
      outN.x = _min.x;
    }

    if (planeNormal.y < 0.0) {
      outP.y = _min.y;
      outN.y = _max.y;
    } else {
      outP.y = _max.y;
      outN.y = _min.y;
    }

    if (planeNormal.z < 0.0) {
      outP.z = _min.z;
      outN.z = _max.z;
    } else {
      outP.z = _max.z;
      outN.z = _min.z;
    }
  }

  /// Set the min and max of [this] so that [this] is a hull of [this] and
  /// [other].
  void hull(Aabb3 other) {
    Vector3.min(_min, other._min, _min);
    Vector3.max(_max, other._max, _max);
  }

  /// Set the min and max of [this] so that [this] contains [point].
  void hullPoint(Vector3 point) {
    Vector3.min(_min, point, _min);
    Vector3.max(_max, point, _max);
  }

  /// Return if [this] contains [other].
  bool containsAabb3(Aabb3 other) {
    final otherMax = other._max;
    final otherMin = other._min;

    return (_min.x < otherMin.x) &&
        (_min.y < otherMin.y) &&
        (_min.z < otherMin.z) &&
        (_max.x > otherMax.x) &&
        (_max.y > otherMax.y) &&
        (_max.z > otherMax.z);
  }

  /// Return if [this] contains [other].
  bool containsSphere(Sphere other) {
    final boxExtends = new Vector3.all(other._radius);
    final sphereBox = new Aabb3.centerAndHalfExtents(other._center, boxExtends);

    return containsAabb3(sphereBox);
  }

  /// Return if [this] contains [other].
  bool containsVector3(Vector3 other) {
    return (_min.x < other.x) &&
        (_min.y < other.y) &&
        (_min.z < other.z) &&
        (_max.x > other.x) &&
        (_max.y > other.y) &&
        (_max.z > other.z);
  }

  /// Return if [this] contains [other].
  bool containsTriangle(Triangle other) => containsVector3(other._point0) &&
      containsVector3(other._point1) &&
      containsVector3(other._point2);

  /// Return if [this] intersects with [other].
  bool intersectsWithAabb3(Aabb3 other) {
    final otherMax = other._max;
    final otherMin = other._min;

    return (_min.x <= otherMax.x) &&
        (_min.y <= otherMax.y) &&
        (_min.z <= otherMax.z) &&
        (_max.x >= otherMin.x) &&
        (_max.y >= otherMin.y) &&
        (_max.z >= otherMin.z);
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithSphere(Sphere other) {
    final center = other._center;
    final radius = other._radius;
    var d = 0.0;
    var e = 0.0;

    for (var i = 0; i < 3; ++i) {
      if ((e = center[i] - _min[i]) < 0.0) {
        if (e < -radius) {
          return false;
        }

        d = d + e * e;
      } else {
        if ((e = center[i] - _max[i]) > 0.0) {
          if (e > radius) {
            return false;
          }

          d = d + e * e;
        }
      }
    }

    return d <= radius * radius;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithVector3(Vector3 other) {
    return (_min.x <= other.x) &&
        (_min.y <= other.y) &&
        (_min.z <= other.z) &&
        (_max.x >= other.x) &&
        (_max.y >= other.y) &&
        (_max.z >= other.z);
  }
}
