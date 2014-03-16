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

part of vector_math_64;

/// Defines a 3-dimensional axis-aligned bounding box between a [min] and a
/// [max] position.
class Aabb3 {
  final Vector3 _min;
  final Vector3 _max;

  /// The minimum point defining the AABB.
  Vector3 get min => _min;
  /// The maximum point defining the AABB.
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

  /// DEPRECATED: Use [minMax] instead
  @deprecated
  Aabb3.minmax(Vector3 min, Vector3 max)
      : _min = new Vector3.copy(min),
        _max = new Vector3.copy(max);

  /// Create a new AABB with a [min] and [max].
  Aabb3.minMax(Vector3 min, Vector3 max)
      : _min = new Vector3.copy(min),
        _max = new Vector3.copy(max);

  /// Create a new AABB with a [center] and [max_].
  Aabb3.centerAndHalfExtents(Vector3 center, Vector3 halfExtents)
      : _min = new Vector3.copy(center)..sub(halfExtents),
        _max = new Vector3.copy(center)..add(halfExtents);

  /// Constructs [Aabb3] with a min/max [storage] that views given [buffer]
  /// starting at [offset]. [offset] has to be multiple of
  /// [Float64List.BYTES_PER_ELEMENT].
  Aabb3.fromBuffer(ByteBuffer buffer, int offset)
      : _min = new Vector3.fromBuffer(buffer, offset),
        _max = new Vector3.fromBuffer(buffer, offset +
          Float64List.BYTES_PER_ELEMENT * 3);

  /// DEPREACTED: Removed copy min and max yourself
  @deprecated
  void copyMinMax(Vector3 min_, Vector3 max_) {
    max_.setFrom(_max);
    min_.setFrom(_min);
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

  /// Copy the [min] and [max] from [other] into [this].
  void copyFrom(Aabb3 other) {
    _min.setFrom(other._min);
    _max.setFrom(other._max);
  }

  /// Copy the [min] and [max] from [this] into [other].
  void copyInto(Aabb3 other) {
    other._min.setFrom(_min);
    other._max.setFrom(_max);
  }

  /// Transform [this] by the transform [t].
  void transform(Matrix4 t) {
    final center = new Vector3.zero();
    final halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t
        ..transform3(center)
        ..absoluteRotate(halfExtents);
    min
        ..setFrom(center)
        ..sub(halfExtents);
    max
        ..setFrom(center)
        ..add(halfExtents);
  }

  /// Rotate [this] by the rotation matrix [t].
  void rotate(Matrix4 t) {
    final center = new Vector3.zero();
    final halfExtents = new Vector3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t.absoluteRotate(halfExtents);
    min
        ..setFrom(center)
        ..sub(halfExtents);
    max
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

  //TODO (fox32): Add a documentation comment
  void getPN(Vector3 planeNormal, Vector3 outP, Vector3 outN) {
    outP.x = planeNormal.x < 0.0 ? _min.x : _max.x;
    outP.y = planeNormal.y < 0.0 ? _min.y : _max.y;
    outP.z = planeNormal.z < 0.0 ? _min.z : _max.z;

    outN.x = planeNormal.x < 0.0 ? _max.x : _min.x;
    outN.y = planeNormal.y < 0.0 ? _max.y : _min.y;
    outN.z = planeNormal.z < 0.0 ? _max.z : _min.z;
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

    return _min.x < otherMin.x && _min.y < otherMin.y && _min.z < otherMin.z &&
        _max.x > otherMax.x && _max.y > otherMax.y && _max.z > otherMax.z;
  }

  /// Return if [this] contains [other].
  bool containsSphere(Sphere other) {
    final boxExtends = new Vector3.all(other.radius);
    final sphereBox = new Aabb3.centerAndHalfExtents(other.center, boxExtends);

    return containsAabb3(sphereBox);
  }

  /// Return if [this] contains [other].
  bool containsVector3(Vector3 other) {
    final otherX = other[0];
    final otherY = other[1];
    final otherZ = other[2];

    return _min.x < otherX && _min.y < otherY && _min.z < otherZ && _max.x >
        otherX && _max.y > otherY && _max.z > otherZ;
  }

  /// Return if [this] contains [other].
  bool containsTriangle(Triangle other) => containsVector3(other.point0) &&
      containsVector3(other.point1) && containsVector3(other.point2);

  /// Return if [this] intersects with [other].
  bool intersectsWithAabb3(Aabb3 other) {
    final otherMax = other._max;
    final otherMin = other._min;

    return _min.x <= otherMax.x && _min.y <= otherMax.y && _min.z <= otherMax.z
        && _max.x >= otherMin.x && _max.y >= otherMin.y && _max.z >= otherMin.z;
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
    final otherX = other[0];
    final otherY = other[1];
    final otherZ = other[2];

    return _min.x <= otherX && _min.y <= otherY && _min.z <= otherZ && _max.x >=
        otherX && _max.y >= otherY && _max.z >= otherZ;
  }
}
