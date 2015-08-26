// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

/// Defines a [Ray] by an [origin] and a [direction].
class Ray {
  final Vector3 _origin;
  final Vector3 _direction;

  /// The [origin] of the ray.
  Vector3 get origin => _origin;

  /// The [direction] of the ray.
  Vector3 get direction => _direction;

  /// Create a new, uninitialized ray.
  Ray()
      : _origin = new Vector3.zero(),
        _direction = new Vector3.zero();

  /// Create a ray as a copy of [other].
  Ray.copy(Ray other)
      : _origin = new Vector3.copy(other._origin),
        _direction = new Vector3.copy(other._direction);

  /// Create a ray with an [origin] and a [direction].
  Ray.originDirection(Vector3 origin, Vector3 direction)
      : _origin = new Vector3.copy(origin),
        _direction = new Vector3.copy(direction);

  /// Copy the [origin] and [direction] from [other] into [this].
  void copyFrom(Ray other) {
    _origin.setFrom(other._origin);
    _direction.setFrom(other._direction);
  }

  /// Returns the position on [this] with a distance of [t] from [origin].
  Vector3 at(double t) => _direction.scaled(t)..add(_origin);

  /// Copy the position on [this] with a distance of [t] from [origin] into
  /// [other].
  void copyAt(Vector3 other, double t) {
    other
      ..setFrom(_direction)
      ..scale(t)
      ..add(_origin);
  }

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithSphere(Sphere other) {
    final r = other._radius;
    final r2 = r * r;
    final l = other._center.clone()..sub(_origin);
    final s = l.dot(_direction);
    final l2 = l.dot(l);
    if (s < 0 && l2 > r2) {
      return null;
    }
    final m2 = l2 - s * s;
    if (m2 > r2) {
      return null;
    }
    final q = Math.sqrt(r2 - m2);

    return (l2 > r2) ? s - q : s + q;
  }

  // Some varaibles that are used for intersectsWithTriangle and
  // intersectsWithQuad. The performance is better in Dart and JS if we avoid
  // to create temporary instance over and over. Also reduce GC.
  static final _e1 = new Vector3.zero();
  static final _e2 = new Vector3.zero();
  static final _q = new Vector3.zero();
  static final _s = new Vector3.zero();
  static final _r = new Vector3.zero();

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithTriangle(Triangle other) {
    const double EPSILON = 10e-6;

    final point0 = other._point0;
    final point1 = other._point1;
    final point2 = other._point2;

    _e1
      ..setFrom(point1)
      ..sub(point0);
    _e2
      ..setFrom(point2)
      ..sub(point0);

    _direction.crossInto(_e2, _q);
    final a = _e1.dot(_q);

    if (a > -EPSILON && a < EPSILON) {
      return null;
    }

    final f = 1 / a;
    _s
      ..setFrom(_origin)
      ..sub(point0);
    final u = f * (_s.dot(_q));

    if (u < 0.0) {
      return null;
    }

    _s.crossInto(_e1, _r);
    final v = f * (_direction.dot(_r));

    if (v < -EPSILON || u + v > 1.0 + EPSILON) {
      return null;
    }

    final t = f * (_e2.dot(_r));

    return t;
  }

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithQuad(Quad other) {
    const double EPSILON = 10e-6;

    // First triangle
    var point0 = other._point0;
    var point1 = other._point1;
    var point2 = other._point2;

    _e1
      ..setFrom(point1)
      ..sub(point0);
    _e2
      ..setFrom(point2)
      ..sub(point0);

    _direction.crossInto(_e2, _q);
    final a0 = _e1.dot(_q);

    if (!(a0 > -EPSILON && a0 < EPSILON)) {
      final f = 1 / a0;
      _s
        ..setFrom(_origin)
        ..sub(point0);
      final u = f * (_s.dot(_q));

      if (u >= 0.0) {
        _s.crossInto(_e1, _r);
        final v = f * (_direction.dot(_r));

        if (!(v < -EPSILON || u + v > 1.0 + EPSILON)) {
          final t = f * (_e2.dot(_r));

          return t;
        }
      }
    }

    // Second triangle
    point0 = other._point3;
    point1 = other._point0;
    point2 = other._point2;

    _e1
      ..setFrom(point1)
      ..sub(point0);
    _e2
      ..setFrom(point2)
      ..sub(point0);

    _direction.crossInto(_e2, _q);
    final a1 = _e1.dot(_q);

    if (!(a1 > -EPSILON && a1 < EPSILON)) {
      final f = 1 / a1;
      _s
        ..setFrom(_origin)
        ..sub(point0);
      final u = f * (_s.dot(_q));

      if (u >= 0.0) {
        _s.crossInto(_e1, _r);
        final v = f * (_direction.dot(_r));

        if (!(v < -EPSILON || u + v > 1.0 + EPSILON)) {
          final t = f * (_e2.dot(_r));

          return t;
        }
      }
    }

    return null;
  }

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithAabb3(Aabb3 other) {
    final otherMin = other.min;
    final otherMax = other.max;

    var tNear = -double.MAX_FINITE;
    var tFar = double.MAX_FINITE;

    for (var i = 0; i < 3; ++i) {
      if (_direction[i] == 0.0) {
        if (_origin[i] < otherMin[i] || _origin[i] > otherMax[i]) {
          return null;
        }
      } else {
        var t1 = (otherMin[i] - _origin[i]) / _direction[i];
        var t2 = (otherMax[i] - _origin[i]) / _direction[i];

        if (t1 > t2) {
          final temp = t1;
          t1 = t2;
          t2 = temp;
        }

        if (t1 > tNear) {
          tNear = t1;
        }

        if (t2 < tFar) {
          tFar = t2;
        }

        if (tNear > tFar || tFar < 0) {
          return null;
        }
      }
    }

    return tNear;
  }
}
