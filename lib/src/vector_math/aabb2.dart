// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

/// Defines a 2-dimensional axis-aligned bounding box between a [min] and a
/// [max] position.
class Aabb2 {
  final Vector2 _center;
  final Vector2 _half;

  /// The minimum point defining the AABB.
  Vector2 get min => _center.clone()..sub(_half);
  /// The maximum point defining the AABB.
  Vector2 get max => _center.clone()..add(_half);

  /// The center of the AABB.
  Vector2 get center => _center;
  /// The radius of the AABB.
  Vector2 get half => _half;

  /// Create a new AABB with [min] and [max] set to the origin.
  Aabb2()
      : _center = new Vector2.zero(),
        _half = new Vector2.zero();

  /// Create a new AABB as a copy of [other].
  Aabb2.copy(Aabb2 other)
      : _center = new Vector2.copy(other._center),
        _half = new Vector2.copy(other._half);

  /// Create a new AABB with a [min] and [max].
  Aabb2.minMax(Vector2 min, Vector2 max)
      : _center = new Vector2.copy(min)..add(max)..scale(0.5),
        _half = new Vector2.copy(max)..sub(min)..scale(0.5);

  /// Create a new AABB with a [center] and [halfExtents].
  Aabb2.centerAndHalfExtents(Vector2 center, Vector2 halfExtents)
      : _center = new Vector2.copy(center),
        _half = new Vector2.copy(halfExtents);

  /// Constructs [Aabb2] with a min/max [storage] that views given [buffer]
  /// starting at [offset]. [offset] has to be multiple of
  /// [Float32List.BYTES_PER_ELEMENT].
  factory Aabb2.fromBuffer(ByteBuffer buffer, int offset) {
    final min = new Vector2.fromBuffer(buffer, offset);
    final max = new Vector2.fromBuffer(
        buffer, offset + Float32List.BYTES_PER_ELEMENT * 2);
    return new Aabb2.minMax(min, max);
  }

  /// Set the AABB by a [center] and [halfExtents].
  void setCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    _center.setFrom(center);
    _half.setFrom(halfExtents);
  }

  /// Copy the [center] and the [halfExtends] of [this].
  void copyCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    center.setFrom(_center);
    halfExtents.setFrom(_half);
  }

  void setMinMax(Vector2 min, Vector2 max) {
    _center.setFrom(min)..add(max)..scale(0.5);
    _half.setFrom(max)..sub(min)..scale(0.5);
  }

  void copyMinMax(Vector2 min, Vector2 max) {
    min.setFrom(_center)..sub(_half);
    max.setFrom(_center)..add(_half);
  }

  /// Copy the [min] and [max] from [other] into [this].
  void copyFrom(Aabb2 other) {
    _center.setFrom(other._center);
    _half.setFrom(other._half);
  }

  /// Transform [this] by the transform [t].
  Aabb2 transform(Matrix3 t) {
    t
      ..transform2(_center)
      ..absoluteRotate2(_half);
    return this;
  }

  /// Rotate [this] by the rotation matrix [t].
  Aabb2 rotate(Matrix3 t) {
    t.absoluteRotate2(_half);
    return this;
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
    var thisMin = this.min;
    var thisMax = this.max;
    Vector2.min(thisMin, other.min, thisMin);
    Vector2.max(thisMax, other.max, thisMax);
    setMinMax(thisMin, thisMax);
  }

  /// Set the min and max of [this] so that [this] contains [point].
  void hullPoint(Vector2 point) {
    var thisMin = this.min;
    var max = this.max;
    Vector2.min(thisMin, point, thisMin);
    Vector2.max(max, point, max);
    setMinMax(thisMin, max);
  }

  /// Return if [this] contains [other].
  bool containsAabb2(Aabb2 other) {
    final dx = (_center.x - other._center.x).abs();
    if ((dx + other._half.x) >= _half.x) return false;

    final dy = (_center.y - other._center.y).abs();
    if ((dy + other._half.y) >= _half.y) return false;

    return true;
  }

  /// Return if [this] contains [other].
  bool containsVector2(Vector2 other) {
    final dx = (_center.x - other.x).abs();
    if (dx >= _half.x) return false;

    final dy = (_center.y - other.y).abs();
    if (dy >= _half.y) return false;

    return true;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithAabb2(Aabb2 other) {
    final dx = (_center.x - other._center.x).abs();
    if (dx > (_half.x + other._half.x)) return false;

    final dy = (_center.y - other._center.y).abs();
    if (dy > (_half.y + other._half.y)) return false;

    return true;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithVector2(Vector2 other) {
    final dx = (_center.x - other.x).abs();
    if (dx > _half.x) return false;

    final dy = (_center.y - other.y).abs();
    if (dy > _half.y) return false;

    return true;
  }
}
