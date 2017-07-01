// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

/// Defines a sphere with a [center] and a [radius].
class Sphere {
  final Vector3 _center;
  double _radius;

  /// The [center] of the sphere.
  Vector3 get center => _center;

  /// The [radius] of the sphere.
  double get radius => _radius;
  set radius(double value) => _radius = value;

  /// Create a new, uninitialized sphere.
  Sphere()
      : _center = new Vector3.zero(),
        _radius = 0.0;

  /// Create a sphere as a copy of [other].
  Sphere.copy(Sphere other)
      : _center = new Vector3.copy(other._center),
        _radius = other._radius;

  /// Create a sphere from a [center] and a [radius].
  Sphere.centerRadius(Vector3 center, double radius)
      : _center = new Vector3.copy(center),
        _radius = radius;

  /// Copy the sphere from [other] into [this].
  void copyFrom(Sphere other) {
    _center.setFrom(other._center);
    _radius = other._radius;
  }

  /// Return if [this] contains [other].
  bool containsVector3(Vector3 other) =>
      other.distanceToSquared(center) < radius * radius;

  /// Return if [this] intersects with [other].
  bool intersectsWithVector3(Vector3 other) =>
      other.distanceToSquared(center) <= radius * radius;

  /// Return if [this] intersects with [other].
  bool intersectsWithSphere(Sphere other) {
    final double radiusSum = radius + other.radius;

    return other.center.distanceToSquared(center) <= (radiusSum * radiusSum);
  }
}
