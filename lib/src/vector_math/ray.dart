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

  /// Copy the [origin] and [direction] from [this] into [other].
  void copyInto(Ray other) {
    other._origin.setFrom(_origin);
    other._direction.setFrom(_direction);
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

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithTriangle(Triangle other) {
    const double EPSILON = 10e-6;

    final point0 = other._point0;
    final point1 = other._point1;
    final point2 = other._point2;

    final e1 = point1.clone()..sub(point0);
    final e2 = point2.clone()..sub(point0);

    final q = _direction.cross(e2);
    final a = e1.dot(q);

    if (a > -EPSILON && a < EPSILON) {
      return null;
    }

    final f = 1 / a;
    final s = _origin.clone()..sub(point0);
    final u = f * (s.dot(q));

    if (u < 0.0) {
      return null;
    }

    final r = s.cross(e1);
    final v = f * (_direction.dot(r));

    if (v < -EPSILON || u + v > 1.0 + EPSILON) {
      return null;
    }

    final t = f * (e2.dot(r));

    return t;
  }

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithAabb3(Aabb3 other) {
    final otherMin = other._min3;
    final otherMax = other._max3;

    var t1 = new Vector3.zero();
    var t2 = new Vector3.zero();
    var tNear = -double.MAX_FINITE;
    var tFar = double.MAX_FINITE;

    for (var i = 0; i < 3; ++i) {
      if (_direction[i] == 0.0) {
        if (_origin[i] < otherMin[i] || _origin[i] > otherMax[i]) {
          return null;
        }
      } else {
        t1[i] = (otherMin[i] - _origin[i]) / _direction[i];
        t2[i] = (otherMax[i] - _origin[i]) / _direction[i];

        if (t1[i] > t2[i]) {
          final temp = t1;
          t1 = t2;
          t2 = temp;
        }

        if (t1[i] > tNear) {
          tNear = t1[i];
        }

        if (t2[i] < tFar) {
          tFar = t2[i];
        }

        if (tNear > tFar || tFar < 0) {
          return null;
        }
      }
    }

    return tNear;
  }
}
