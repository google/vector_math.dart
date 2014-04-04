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

/// Defines a 2-dimensional axis-aligned bounding box between a [min] and a
/// [max] position.
class Aabb2 {
  final Vector2 _min2;
  final Vector2 _max2;

  /// The minimum point defining the AABB.
  Vector2 get min => _min2;
  /// The maximum point defining the AABB.
  Vector2 get max => _max2;

  /// The center of the AABB.
  Vector2 get center => _min2.clone()
      ..add(_max2)
      ..scale(0.5);

  /// Create a new AABB with [min] and [max] set to the origin.
  Aabb2()
      : _min2 = new Vector2.zero(),
        _max2 = new Vector2.zero();

  /// Create a new AABB as a copy of [other].
  Aabb2.copy(Aabb2 other)
      : _min2 = new Vector2.copy(other._min2),
        _max2 = new Vector2.copy(other._max2);

  /// DEPREACTED: Use [minMax] instead.
  @deprecated
  Aabb2.minmax(Vector2 min, Vector2 max)
      : _min2 = new Vector2.copy(min),
        _max2 = new Vector2.copy(max);

  /// Create a new AABB with a [min] and [max].
  Aabb2.minMax(Vector2 min, Vector2 max)
      : _min2 = new Vector2.copy(min),
        _max2 = new Vector2.copy(max);

  /// Create a new AABB with a [center] and [halfExtents].
  factory Aabb2.centerAndHalfExtents(Vector2 center, Vector2 halfExtents)
      => new Aabb2()..setCenterAndHalfExtents(center, halfExtents);

  /// Constructs [Aabb2] with a min/max [storage] that views given [buffer]
  /// starting at [offset]. [offset] has to be multiple of
  /// [Float64List.BYTES_PER_ELEMENT].
  Aabb2.fromBuffer(ByteBuffer buffer, int offset)
      : _min2 = new Vector2.fromBuffer(buffer, offset),
        _max2 = new Vector2.fromBuffer(buffer, offset +
          Float64List.BYTES_PER_ELEMENT * 2);

  /// Set the AABB by a [center] and [halfExtents].
  void setCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    _min2
        ..setFrom(center)
        ..sub(halfExtents);
    _max2
        ..setFrom(center)
        ..add(halfExtents);
  }

  /// DEPREACTED: Removed, copy min and max yourself
  @deprecated
  void copyMinMax(Vector2 min, Vector2 max) {
    max.setFrom(_max2);
    min.setFrom(_min2);
  }

  /// Copy the [center] and the [halfExtends] of [this].
  void copyCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    center
        ..setFrom(_min2)
        ..add(_max2)
        ..scale(0.5);
    halfExtents
        ..setFrom(_max2)
        ..sub(_min2)
        ..scale(0.5);
  }

  /// Copy the [min] and [max] from [other] into [this].
  void copyFrom(Aabb2 other) {
    _min2.setFrom(other._min2);
    _max2.setFrom(other._max2);
  }

  /// Copy the [min] and [max] from [this] into [other].
  void copyInto(Aabb2 other) {
    other._min2.setFrom(_min2);
    other._max2.setFrom(_max2);
  }

  /// Transform [this] by the transform [t].
  void transform(Matrix3 t) {
    final center = new Vector2.zero();
    final halfExtents = new Vector2.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t
        ..transform2(center)
        ..absoluteRotate2(halfExtents);
    _min2
        ..setFrom(center)
        ..sub(halfExtents);
    _max2
        ..setFrom(center)
        ..add(halfExtents);
  }

  /// Rotate [this] by the rotation matrix [t].
  void rotate(Matrix3 t) {
    final center = new Vector2.zero();
    final halfExtents = new Vector2.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    t.absoluteRotate2(halfExtents);
    _min2
        ..setFrom(center)
        ..sub(halfExtents);
    _max2
        ..setFrom(center)
        ..add(halfExtents);
  }

  /// Create a copy of [this] that is transformed by the transform [t] and store
  /// it in [out].
  Aabb2 transformed(Matrix3 t, Aabb2 out) => out
      ..copyFrom(this)
      ..transform(t);

  /// Create a copy of [this] that is rotated by the rotation matrix [t] and
  /// store it in [out].
  Aabb2 rotated(Matrix3 t, Aabb2 out) => out
      ..copyFrom(this)
      ..rotate(t);

  /// Set the min and max of [this] so that [this] is a hull of [this] and
  /// [other].
  void hull(Aabb2 other) {
    Vector2.min(_min2, other._min2, _min2);
    Vector2.max(_max2, other._max2, _max2);
  }

  /// Set the min and max of [this] so that [this] contains [point].
  void hullPoint(Vector2 point) {
    Vector2.min(_min2, point, _min2);
    Vector2.max(_max2, point, _max2);
  }

  /// Return if [this] contains [other].
  bool containsAabb2(Aabb2 other) {
    final otherMax = other._max2;
    final otherMin = other._min2;

    return _min2.x < otherMin.x &&
           _min2.y < otherMin.y &&
           _max2.y > otherMax.y &&
           _max2.x > otherMax.x;
  }

  /// Return if [this] contains [other].
  bool containsVector2(Vector2 other) {
    final otherX = other[0];
    final otherY = other[1];

    return _min2.x < otherX &&
           _min2.y < otherY &&
           _max2.x > otherX &&
           _max2.y > otherY;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithAabb2(Aabb2 other) {
    final otherMax = other._max2;
    final otherMin = other._min2;

    return _min2.x <= otherMax.x &&
           _min2.y <= otherMax.y &&
           _max2.x >= otherMin.x &&
           _max2.y >= otherMin.y;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithVector2(Vector2 other) {
    final otherX = other[0];
    final otherY = other[1];

    return _min2.x <= otherX &&
           _min2.y <= otherY &&
           _max2.x >= otherX &&
           _max2.y >= otherY;
  }
}
