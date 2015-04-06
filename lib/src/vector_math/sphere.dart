// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

class Sphere {
  final Vector3 _center;
  double _radius;

  Vector3 get center => _center;
  double get radius => _radius;
  set radius(double value) => _radius = value;

  Sphere()
      : _center = new Vector3.zero(),
        _radius = 0.0;

  Sphere.copy(Sphere other)
      : _center = new Vector3.copy(other._center),
        _radius = other._radius;

  Sphere.centerRadius(Vector3 center_, double radius_)
      : _center = new Vector3.copy(center_),
        _radius = radius_;

  void copyFrom(Sphere o) {
    _center.setFrom(o._center);
    _radius = _radius;
  }

  /// Return if [this] contains [other].
  bool containsVector3(Vector3 other) {
    return other.distanceToSquared(center) < radius * radius;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithVector3(Vector3 other) {
    return other.distanceToSquared(center) <= radius * radius;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithSphere(Sphere other) {
    var radiusSum = radius + other.radius;

    return other.center.distanceToSquared(center) <= (radiusSum * radiusSum);
  }
}
