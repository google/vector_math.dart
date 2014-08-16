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
  Aabb3.fromSphere(Sphere sphere)
      : _min3 = new Vector3.all(-sphere._radius)..add(sphere._center),
        _max3 = new Vector3.all(sphere._radius)..add(sphere._center);

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
}
