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

  bool intersectsWithTriangle(Triangle other, [double epsilon = 1e-3]) {
    double p0, p1, p2, r, len;
    Vector3 axis;

    final u0 = new Vector3(1.0, 0.0, 0.0);
    final u1 = new Vector3(0.0, 1.0, 0.0);
    final u2 = new Vector3(0.0, 0.0, 1.0);

    final center = new Vector3.zero();
    final extents = new Vector3.zero();
    copyCenterAndHalfExtents(center, extents);

    final triangle = new Triangle.copy(other);

    // Translate triangle as conceptually moving AABB to origin
    Vector3 v0 = triangle.point0..sub(center);
    Vector3 v1 = triangle.point1..sub(center);
    Vector3 v2 = triangle.point2..sub(center);

    // Translate triangle as conceptually moving AABB to origin
    Vector3 f0 = new Vector3.copy(v1)..sub(v0);
    Vector3 f1 = new Vector3.copy(v2)..sub(v1);
    Vector3 f2 = new Vector3.copy(v0)..sub(v2);

    // Test axes a00..a22 (category 3)
    // Test axis a00
    len = f0.y * f0.y + f0.z * f0.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.z * f0.y - v0.y * f0.z;
      p2 = v2.z * f0.y - v2.y * f0.z;
      r = extents[1] * f0.z.abs() + extents[2] * f0.y.abs();
      if (Math.max(-Math.max(p0, p2), Math.min(p0, p2)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a01
    len = f1.y * f1.y + f1.z * f1.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.z * f1.y - v0.y * f1.z;
      p1 = v1.z * f1.y - v1.y * f1.z;
      r = extents[1] * f1.z.abs() + extents[2] * f1.y.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a02
    len = f2.y * f2.y + f2.z * f2.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.z * f2.y - v0.y * f2.z;
      p1 = v1.z * f2.y - v1.y * f2.z;
      r = extents[1] * f2.z.abs() + extents[2] * f2.y.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a10
    len = f0.x * f0.x + f0.z * f0.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.x * f0.z - v0.z * f0.x;
      p2 = v2.x * f0.z - v2.z * f0.x;
      r = extents[0] * f0.z.abs() + extents[2] * f0.x.abs();
      if (Math.max(-Math.max(p0, p2), Math.min(p0, p2)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a11
    len = f1.x * f1.x + f1.z * f1.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.x * f1.z - v0.z * f1.x;
      p1 = v1.x * f1.z - v1.z * f1.x;
      r = extents[0] * f1.z.abs() + extents[2] * f1.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a12
    len = f2.x * f2.x + f2.z * f2.z;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.x * f2.z - v0.z * f2.x;
      p1 = v1.x * f2.z - v1.z * f2.x;
      r = extents[0] * f2.z.abs() + extents[2] * f2.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a20
    len = f0.x * f0.x + f0.y * f0.y;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.y * f0.x - v0.x * f0.y;
      p2 = v2.y * f0.x - v2.x * f0.y;
      r = extents[0] * f0.y.abs() + extents[1] * f0.x.abs();
      if (Math.max(-Math.max(p0, p2), Math.min(p0, p2)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a21
    len = f1.x * f1.x + f1.y * f1.y;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.y * f1.x - v0.x * f1.y;
      p1 = v1.y * f1.x - v1.x * f1.y;
      r = extents[0] * f1.y.abs() + extents[1] * f1.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test axis a22
    len = f2.x * f2.x + f2.y * f2.y;
    if (len > epsilon) { // Ignore tests on degenerate axes.
      p0 = v0.y * f2.x - v0.x * f2.y;
      p1 = v1.y * f2.x - v1.x * f2.y;
      r = extents[0] * f2.y.abs() + extents[1] * f2.x.abs();
      if (Math.max(-Math.max(p0, p1), Math.min(p0, p1)) > r + epsilon) {
        return false; // Axis is a separating axis
      }
    }

    // Test the three axes corresponding to the face normals of AABB b (category 1). // Exit if...
    // ... [-e0, e0] and [min(v0.x,v1.x,v2.x), max(v0.x,v1.x,v2.x)] do not overlap
    if (Math.max(v0.x, Math.max(v1.x, v2.x)) < -extents[0] || Math.min(v0.x, Math.min(v1.x, v2.x)) > extents[0]) {
      return false;
    }
    // ... [-e1, e1] and [min(v0.y,v1.y,v2.y), max(v0.y,v1.y,v2.y)] do not overlap
    if (Math.max(v0.y, Math.max(v1.y, v2.y)) < -extents[1] || Math.min(v0.y, Math.min(v1.y, v2.y)) > extents[1]) {
      return false;
    }
    // ... [-e2, e2] and [min(v0.z,v1.z,v2.z), max(v0.z,v1.z,v2.z)] do not overlap
    if (Math.max(v0.z, Math.max(v1.z, v2.z)) < -extents[2] || Math.min(v0.z, Math.min(v1.z, v2.z)) > extents[2]) {
      return false;
    }

    // It seems like that wee need to move the edges before creating the
    // plane
    v0.add(center);

    // Test separating axis corresponding to triangle face normal (category 2)
    final normal = f0.cross(f1);
    Plane p = new Plane.normalConstant(normal, normal.dot(v0));
    return intersectsWithPlane(p);
  }

  bool intersectsWithPlane(Plane other) {
    // These two lines not necessary with a (center, extents) AABB representation
    Vector3 c = new Vector3.zero();
    Vector3 e = new Vector3.zero();
    copyCenterAndHalfExtents(c, e);

    // Compute the projection interval radius of b onto L(t) = b.c + t * p.n
    double r = e[0]*other.normal[0].abs() + e[1]*other.normal[1].abs() + e[2]*other.normal[2].abs();
    // Compute distance of box center from plane
    double s = other.normal.dot(c) - other.constant;
    // Intersection occurs when distance s falls within [-r,+r] interval
    return s.abs() <= r;
  }

  final _quadTriangle0 = new Triangle();
  final _quadTriangle1 = new Triangle();
  bool intersectsWithQuad(Quad quad) {
    quad.copyTriangles(_quadTriangle0, _quadTriangle1);

    return intersectsWithTriangle(_quadTriangle0) || intersectsWithTriangle(_quadTriangle0);
  }
}
