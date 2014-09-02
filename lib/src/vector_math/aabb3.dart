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

/// Defines a result of an intersection test
class IntersectionResult {
  double _depth;
  /// The depth of the intersection
  double get depth => _depth;
  Vector3 _axis = new Vector3.zero();
  /// The axis of the intersection
  Vector3 get axis => _axis;

  IntersectionResult();
}

/// Defines a 3-dimensional axis-aligned bounding box between a [min] and a
/// [max] position.
class Aabb3 {
  final Vector3 _min3;
  final Vector3 _max3;

  /// The minimum point defining the AABB.
  Vector3 get min => _min3;
  /// The maximum point defining the AABB.
  Vector3 get max => _max3;

  /// The center of the AABB.
  Vector3 get center => _min3.clone()
      ..add(_max3)
      ..scale(0.5);

  /// Create a new AABB with [min] and [max] set to the origin.
  Aabb3()
      : _min3 = new Vector3.zero(),
        _max3 = new Vector3.zero();

  /// Create a new AABB as a copy of [other].
  Aabb3.copy(Aabb3 other)
      : _min3 = new Vector3.copy(other._min3),
        _max3 = new Vector3.copy(other._max3);

  /// DEPRECATED: Use [minMax] instead
  @deprecated
  Aabb3.minmax(Vector3 min, Vector3 max)
      : _min3 = new Vector3.copy(min),
        _max3 = new Vector3.copy(max);

  /// Create a new AABB with a [min] and [max].
  Aabb3.minMax(Vector3 min, Vector3 max)
      : _min3 = new Vector3.copy(min),
        _max3 = new Vector3.copy(max);

  /// Create a new AABB that encloses a [sphere].
  factory Aabb3.fromSphere(Sphere sphere) => new Aabb3()..setSphere(sphere);

  /// Create a new AABB that encloses a [triangle].
  factory Aabb3.fromTriangle(Triangle triangle) =>
      new Aabb3()..setTriangle(triangle);

  /// Create a new AABB that encloses a [quad].
  factory Aabb3.fromQuad(Quad quad) => new Aabb3()..setQuad(quad);

  /// Create a new AABB that encloses a [obb].
  factory Aabb3.fromObb3(Obb3 obb) => new Aabb3()..setObb3(obb);

  /// Create a new AABB that encloses a limited [ray] (or line segment) that has
  /// a minLimit and maxLimit.
  factory Aabb3.fromRay(Ray ray, double limitMin, double limitMax) =>
      new Aabb3()..setRay(ray, limitMin, limitMax);

  /// Create a new AABB with a [center] and [halfExtents].
  factory Aabb3.centerAndHalfExtents(Vector3 center, Vector3 halfExtents)
      => new Aabb3()..setCenterAndHalfExtents(center, halfExtents);

  /// Constructs [Aabb3] with a min/max [storage] that views given [buffer]
  /// starting at [offset]. [offset] has to be multiple of
  /// [Float32List.BYTES_PER_ELEMENT].
  Aabb3.fromBuffer(ByteBuffer buffer, int offset)
      : _min3 = new Vector3.fromBuffer(buffer, offset),
        _max3 = new Vector3.fromBuffer(buffer, offset +
          Float32List.BYTES_PER_ELEMENT * 3);

  /// Set the AABB by a [center] and [halfExtents].
  void setCenterAndHalfExtents(Vector3 center, Vector3 halfExtents) {
    _min3
        ..setFrom(center)
        ..sub(halfExtents);
    _max3
        ..setFrom(center)
        ..add(halfExtents);
  }

  /// Set the AABB to enclose a [sphere].
  void setSphere(Sphere sphere) {
    _min3
        ..splat(-sphere._radius)
        ..add(sphere._center);
    _max3
        ..splat(sphere._radius)
        ..add(sphere._center);
  }

  /// Set the AABB to enclose a [triangle].
  void setTriangle(Triangle triangle) {
    _min3.setValues(
      Math.min(triangle._point0.x,
      Math.min(triangle._point1.x, triangle._point2.x)),
      Math.min(triangle._point0.y,
      Math.min(triangle._point1.y, triangle._point2.y)),
      Math.min(triangle._point0.z,
      Math.min(triangle._point1.z, triangle._point2.z)));
    _max3.setValues(
      Math.max(triangle._point0.x,
      Math.max(triangle._point1.x, triangle._point2.x)),
      Math.max(triangle._point0.y,
      Math.max(triangle._point1.y, triangle._point2.y)),
      Math.max(triangle._point0.z,
      Math.max(triangle._point1.z, triangle._point2.z)));
  }

  /// Set the AABB to enclose a [quad].
  void setQuad(Quad quad) {
    _min3.setValues(
      Math.min(quad._point0.x,
      Math.min(quad._point1.x,
      Math.min(quad._point2.x, quad._point3.x))),
      Math.min(quad._point0.y,
      Math.min(quad._point1.y,
      Math.min(quad._point2.y, quad._point3.y))),
      Math.min(quad._point0.z,
      Math.min(quad._point1.z,
      Math.min(quad._point2.z, quad._point3.z))));
    _max3.setValues(
      Math.max(quad._point0.x,
      Math.max(quad._point1.x,
      Math.max(quad._point2.x, quad._point3.x))),
      Math.max(quad._point0.y,
      Math.max(quad._point1.y,
      Math.max(quad._point2.y, quad._point3.y))),
      Math.max(quad._point0.z,
      Math.max(quad._point1.z,
      Math.max(quad._point2.z, quad._point3.z))));
  }

  /// Set the AABB to enclose a [obb].
  void setObb3(Obb3 obb) {
    final corner = new Vector3.zero();

    obb.copyCorner(0, corner);
    _min3.setFrom(corner);
    _max3.setFrom(corner);

    obb.copyCorner(1, corner);
    hullPoint(corner);

    obb.copyCorner(2, corner);
    hullPoint(corner);

    obb.copyCorner(3, corner);
    hullPoint(corner);

    obb.copyCorner(4, corner);
    hullPoint(corner);

    obb.copyCorner(5, corner);
    hullPoint(corner);

    obb.copyCorner(6, corner);
    hullPoint(corner);

    obb.copyCorner(7, corner);
    hullPoint(corner);

  }

  /// Set the AABB to enclose a limited [ray] (or line segment) that has
  /// a minLimit and maxLimit.
  void setRay(Ray ray, double limitMin, double limitMax) {
    ray.copyAt(_min3, limitMin);
    ray.copyAt(_max3, limitMax);

    if (_max3.x < _min3.x) {
      var temp = _max3.x;
      _max3.x = _min3.x;
      _min3.x = temp;
    }

    if (_max3.y < _min3.y) {
      var temp = _max3.y;
      _max3.y = _min3.y;
      _min3.y = temp;
    }

    if (_max3.z < _min3.z) {
      var temp = _max3.z;
      _max3.z = _min3.z;
      _min3.z = temp;
    }
  }

  /// DEPREACTED: Removed, copy min and max yourself
  @deprecated
  void copyMinMax(Vector3 min_, Vector3 max_) {
    max_.setFrom(_max3);
    min_.setFrom(_min3);
  }

  /// Copy the [center] and the [halfExtends] of [this].
  void copyCenterAndHalfExtents(Vector3 center, Vector3 halfExtents) {
    center
        ..setFrom(_min3)
        ..add(_max3)
        ..scale(0.5);
    halfExtents
        ..setFrom(_max3)
        ..sub(_min3)
        ..scale(0.5);
  }

  /// Copy the [center] of [this].
  void copyCenter(Vector3 center) {
    center
        ..setFrom(_min3)
        ..add(_max3)
        ..scale(0.5);
  }

  /// Copy the [min] and [max] from [other] into [this].
  void copyFrom(Aabb3 other) {
    _min3.setFrom(other._min3);
    _max3.setFrom(other._max3);
  }

  /// Copy the [min] and [max] from [this] into [other].
  void copyInto(Aabb3 other) {
    other._min3.setFrom(_min3);
    other._max3.setFrom(_max3);
  }

  /// Transform [this] by the transform [t].
  void transform(Matrix4 t) {
    final center = new Vector3.zero();
    final halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t
        ..transform3(center)
        ..absoluteRotate(halfExtents);
    _min3
        ..setFrom(center)
        ..sub(halfExtents);
    _max3
        ..setFrom(center)
        ..add(halfExtents);
  }

  /// Rotate [this] by the rotation matrix [t].
  void rotate(Matrix4 t) {
    final center = new Vector3.zero();
    final halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t.absoluteRotate(halfExtents);
    _min3
        ..setFrom(center)
        ..sub(halfExtents);
    _max3
        ..setFrom(center)
        ..add(halfExtents);
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
      outP.x = _min3.x;
      outN.x = _max3.x;
    } else {
      outP.x = _max3.x;
      outN.x = _min3.x;
    }

    if (planeNormal.y < 0.0) {
      outP.y = _min3.y;
      outN.y = _max3.y;
    } else {
      outP.y = _max3.y;
      outN.y = _min3.y;
    }

    if (planeNormal.z < 0.0) {
      outP.z = _min3.z;
      outN.z = _max3.z;
    } else {
      outP.z = _max3.z;
      outN.z = _min3.z;
    }
  }

  /// Set the min and max of [this] so that [this] is a hull of [this] and
  /// [other].
  void hull(Aabb3 other) {
    Vector3.min(_min3, other._min3, _min3);
    Vector3.max(_max3, other._max3, _max3);
  }

  /// Set the min and max of [this] so that [this] contains [point].
  void hullPoint(Vector3 point) {
    Vector3.min(_min3, point, _min3);
    Vector3.max(_max3, point, _max3);
  }

  /// Return if [this] contains [other].
  bool containsAabb3(Aabb3 other) {
    final otherMax = other._max3;
    final otherMin = other._min3;

    return _min3.x < otherMin.x &&
           _min3.y < otherMin.y &&
           _min3.z < otherMin.z &&
           _max3.x > otherMax.x &&
           _max3.y > otherMax.y &&
           _max3.z > otherMax.z;
  }

  /// Return if [this] contains [other].
  bool containsSphere(Sphere other) {
    final boxExtends = new Vector3.all(other._radius);
    final sphereBox = new Aabb3.centerAndHalfExtents(other._center, boxExtends);

    return containsAabb3(sphereBox);
  }

  /// Return if [this] contains [other].
  bool containsVector3(Vector3 other) {
    final otherX = other[0];
    final otherY = other[1];
    final otherZ = other[2];

    return _min3.x < otherX &&
           _min3.y < otherY &&
           _min3.z < otherZ &&
           _max3.x > otherX &&
           _max3.y > otherY &&
           _max3.z > otherZ;
  }

  /// Return if [this] contains [other].
  bool containsTriangle(Triangle other) => containsVector3(other._point0) &&
      containsVector3(other._point1) && containsVector3(other._point2);

  /// Return if [this] intersects with [other].
  bool intersectsWithAabb3(Aabb3 other) {
    final otherMax = other._max3;
    final otherMin = other._min3;

    return !(_min3.x > otherMax.x ||
           _min3.y > otherMax.y ||
           _min3.z > otherMax.z ||
           _max3.x < otherMin.x ||
           _max3.y < otherMin.y ||
           _max3.z < otherMin.z);
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithSphere(Sphere other) {
    final center = other._center;
    final radius = other._radius;
    var d = 0.0;
    var e = 0.0;

    for (var i = 0; i < 3; ++i) {
      if ((e = center[i] - _min3[i]) < 0.0) {
        if (e < -radius) {
          return false;
        }

        d = d + e * e;
      } else {
        if ((e = center[i] - _max3[i]) > 0.0) {
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
    final otherX = other[0];
    final otherY = other[1];
    final otherZ = other[2];

    return _min3.x <= otherX &&
           _min3.y <= otherY &&
           _min3.z <= otherZ &&
           _max3.x >= otherX &&
           _max3.y >= otherY &&
           _max3.z >= otherZ;
  }

  // Avoid allocating these instance on every call to intersectsWithTriangle
  static final _aabbCenter = new Vector3.zero();
  static final _aabbHalfExtents = new Vector3.zero();
  static final _v0 = new Vector3.zero();
  static final _v1 = new Vector3.zero();
  static final _v2 = new Vector3.zero();
  static final _f0 = new Vector3.zero();
  static final _f1 = new Vector3.zero();
  static final _f2 = new Vector3.zero();
  static final _trianglePlane = new Plane();

  static final _u0 = new Vector3(1.0, 0.0, 0.0);
  static final _u1 = new Vector3(0.0, 1.0, 0.0);
  static final _u2 = new Vector3(0.0, 0.0, 1.0);



  /// Return if [this] intersects with [other]
  bool intersectsWithTriangle(Triangle other, {double epsilon: 1e-3, IntersectionResult result}) {
    double p0, p1, p2, r, len;
    double a;

    copyCenterAndHalfExtents(_aabbCenter, _aabbHalfExtents);

    // Translate triangle as conceptually moving AABB to origin
    _v0..setFrom(other.point0)..sub(_aabbCenter);
    _v1..setFrom(other.point1)..sub(_aabbCenter);
    _v2..setFrom(other.point2)..sub(_aabbCenter);

    // Translate triangle as conceptually moving AABB to origin
    _f0..setFrom(_v1)..sub(_v0);
    _f1..setFrom(_v2)..sub(_v1);
    _f2..setFrom(_v0)..sub(_v2);

    // Test axes a00..a22 (category 3)
    // Test axis a00
    len = _f0.y * _f0.y + _f0.z * _f0.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.z * _f0.y - _v0.y * _f0.z;
      p2 = _v2.z * _f0.y - _v2.y * _f0.z;
      r = _aabbHalfExtents[1] * _f0.z.abs() + _aabbHalfExtents[2] * _f0.y.abs();
      if (Math.max(-Math.max(p0, p2), Math.min(p0, p2)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p2) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u0.crossInto(_f0, result._axis);
      }
    }

    // Test axis a01
    len = _f1.y * _f1.y + _f1.z * _f1.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.z * _f1.y - _v0.y * _f1.z;
      p1 = _v1.z * _f1.y - _v1.y * _f1.z;
      r = _aabbHalfExtents[1] * _f1.z.abs() + _aabbHalfExtents[2] * _f1.y.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p1) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u0.crossInto(_f1, result._axis);
      }
    }

    // Test axis a02
    len = _f2.y * _f2.y + _f2.z * _f2.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.z * _f2.y - _v0.y * _f2.z;
      p1 = _v1.z * _f2.y - _v1.y * _f2.z;
      r = _aabbHalfExtents[1] * _f2.z.abs() + _aabbHalfExtents[2] * _f2.y.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p1) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u0.crossInto(_f2, result._axis);
      }
    }

    // Test axis a10
    len = _f0.x * _f0.x + _f0.z * _f0.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.x * _f0.z - _v0.z * _f0.x;
      p2 = _v2.x * _f0.z - _v2.z * _f0.x;
      r = _aabbHalfExtents[0] * _f0.z.abs() + _aabbHalfExtents[2] * _f0.x.abs();
      if (Math.max(-Math.max(p0, p2), Math.min(p0, p2)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p2) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u1.crossInto(_f0, result._axis);
      }
    }

    // Test axis a11
    len = _f1.x * _f1.x + _f1.z * _f1.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.x * _f1.z - _v0.z * _f1.x;
      p1 = _v1.x * _f1.z - _v1.z * _f1.x;
      r = _aabbHalfExtents[0] * _f1.z.abs() + _aabbHalfExtents[2] * _f1.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p1) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u1.crossInto(_f1, result._axis);
      }
    }

    // Test axis a12
    len = _f2.x * _f2.x + _f2.z * _f2.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.x * _f2.z - _v0.z * _f2.x;
      p1 = _v1.x * _f2.z - _v1.z * _f2.x;
      r = _aabbHalfExtents[0] * _f2.z.abs() + _aabbHalfExtents[2] * _f2.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p1) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u1.crossInto(_f2, result._axis);
      }
    }

    // Test axis a20
    len = _f0.x * _f0.x + _f0.y * _f0.y;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.y * _f0.x - _v0.x * _f0.y;
      p2 = _v2.y * _f0.x - _v2.x * _f0.y;
      r = _aabbHalfExtents[0] * _f0.y.abs() + _aabbHalfExtents[1] * _f0.x.abs();
      if (Math.max(-Math.max(p0, p2), Math.min(p0, p2)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p2) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u2.crossInto(_f0, result._axis);
      }
    }

    // Test axis a21
    len = _f1.x * _f1.x + _f1.y * _f1.y;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.y * _f1.x - _v0.x * _f1.y;
      p1 = _v1.y * _f1.x - _v1.x * _f1.y;
      r = _aabbHalfExtents[0] * _f1.y.abs() + _aabbHalfExtents[1] * _f1.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p1) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u2.crossInto(_f1, result._axis);
      }
    }

    // Test axis a22
    len = _f2.x * _f2.x + _f2.y * _f2.y;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = _v0.y * _f2.x - _v0.x * _f2.y;
      p1 = _v1.y * _f2.x - _v1.x * _f2.y;
      r = _aabbHalfExtents[0] * _f2.y.abs() + _aabbHalfExtents[1] * _f2.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }

      a = Math.min(p0, p1) - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        _u2.crossInto(_f2, result._axis);
      }
    }

    // Test the three axes corresponding to the face normals of AABB b (category 1). // Exit if...
    // ... [-e0, e0] and [min(v0.x,v1.x,v2.x), max(v0.x,v1.x,v2.x)] do not overlap
    if (Math.max(_v0.x, Math.max(_v1.x, _v2.x)) < -_aabbHalfExtents[0] || Math.min(_v0.x, Math.min(_v1.x, _v2.x)) > _aabbHalfExtents[0]) {
      return false;
    }
    a = Math.min(_v0.x, Math.min(_v1.x, _v2.x)) - _aabbHalfExtents[0];
    if (result != null && (result._depth == null || result._depth < a)) {
      result._depth = a;
      result._axis.setFrom(_u0);
    }
    // ... [-e1, e1] and [min(v0.y,v1.y,v2.y), max(v0.y,v1.y,v2.y)] do not overlap
    if (Math.max(_v0.y, Math.max(_v1.y, _v2.y)) < -_aabbHalfExtents[1] || Math.min(_v0.y, Math.min(_v1.y, _v2.y)) > _aabbHalfExtents[1]) {
      return false;
    }
    a = Math.min(_v0.y, Math.min(_v1.y, _v2.y)) - _aabbHalfExtents[1];
    if (result != null && (result._depth == null || result._depth < a)) {
      result._depth = a;
      result._axis.setFrom(_u1);
    }
    // ... [-e2, e2] and [min(v0.z,v1.z,v2.z), max(v0.z,v1.z,v2.z)] do not overlap
    if (Math.max(_v0.z, Math.max(_v1.z, _v2.z)) < -_aabbHalfExtents[2] || Math.min(_v0.z, Math.min(_v1.z, _v2.z)) > _aabbHalfExtents[2]) {
      return false;
    }
    a = Math.min(_v0.z, Math.min(_v1.z, _v2.z)) - _aabbHalfExtents[2];
    if (result != null && (result._depth == null || result._depth < a)) {
      result._depth = a;
      result._axis.setFrom(_u2);
    }

    // It seems like that wee need to move the edges before creating the
    // plane
    _v0.add(_aabbCenter);

    // Test separating axis corresponding to triangle face normal (category 2)
    _f0.crossInto(_f1, _trianglePlane.normal);
    _trianglePlane.constant = _trianglePlane.normal.dot(_v0);
    return intersectsWithPlane(_trianglePlane, result: result);
  }

  /// Return if [this] intersects with [other]
  bool intersectsWithPlane(Plane other, {IntersectionResult result}) {
    // Thes line not necessary with a (center, extents) AABB representation
    copyCenterAndHalfExtents(_aabbCenter, _aabbHalfExtents);

    // Compute the projection interval radius of b onto L(t) = b.c + t * p.n
    double r = _aabbHalfExtents[0] * other.normal[0].abs() + _aabbHalfExtents[1] * other.normal[1].abs() + _aabbHalfExtents[2] * other.normal[2].abs();
    // Compute distance of box center from plane
    double s = other.normal.dot(_aabbCenter) - other.constant;
    // Intersection occurs when distance s falls within [-r,+r] interval
    if (s.abs() <= r) {
      final a = s - r;
      if (result != null && (result._depth == null || result._depth < a)) {
        result._depth = a;
        result._axis.setFrom(other.normal);
      }
      return true;
    }

    return false;
  }

  // Avoid allocating these instance on every call to intersectsWithTriangle
  static final _quadTriangle0 = new Triangle();
  static final _quadTriangle1 = new Triangle();

  /// Return if [this] intersects with [other]
  bool intersectsWithQuad(Quad other, {IntersectionResult result}) {
    other.copyTriangles(_quadTriangle0, _quadTriangle1);

    return intersectsWithTriangle(_quadTriangle0, result: result) || intersectsWithTriangle(_quadTriangle1, result: result);
  }
}
