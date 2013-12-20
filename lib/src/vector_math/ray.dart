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

class Ray {
  final Vector3 _origin;
  final Vector3 _direction;

  Vector3 get origin => _origin;
  Vector3 get direction => _direction;

  Ray() :
    _origin = new Vector3.zero(),
    _direction = new Vector3.zero() {}

  Ray.copy(Ray other) :
    _origin = new Vector3.copy(other._origin),
    _direction = new Vector3.copy(other._direction) {}

  Ray.originDirection(Vector3 origin_, Vector3 direction_) :
    _origin = new Vector3.copy(origin_),
    _direction = new Vector3.copy(direction_) {}

  void copyOriginDirection(Vector3 origin_, Vector3 direction_) {
    origin_.setFrom(_origin);
    direction_.setFrom(_direction);
  }

  void copyFrom(Ray o) {
    _origin.setFrom(o._origin);
    _direction.setFrom(o._direction);
  }

  void copyInto(Ray o) {
    o._origin.setFrom(_origin);
    o._direction.setFrom(_direction);
  }

  /// Returns the position on [this] with a distance of [t] from [origin].
  Vector3 at(double t) {
    return _direction.scaled(t).add(_origin);
  }

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithSphere(Sphere other) {
    final r2 = other.radius * other.radius;
    final l = other.center.clone().sub(origin);
    final s = l.dot(direction);
    final l2 = l.dot(l);
    if(s < 0 && l2 > r2) {
      return null;
    }
    final m2 = l2 - s * s;
    if(m2 > r2) {
      return null;
    }
    final q = Math.sqrt(r2 - m2);

    return (l2 > r2) ? s - q : s + q;
  }

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithTriangle(Triangle other) {
    const double EPSILON = 10e-6;

    final e1 = other.point1.clone().sub(other.point0);
    final e2 = other.point2.clone().sub(other.point0);

    final q = direction.cross(e2);
    final a = e1.dot(q);

    if(a > -EPSILON && a < EPSILON) {
      return null;
    }

    final f = 1 / a;
    final s = origin.clone().sub(other.point0);
    final u = f * (s.dot(q));

    if(u < 0.0) {
      return null;
    }

    final r = s.cross(e1);
    final v = f * (direction.dot(r));

    if(v < -EPSILON || u + v > 1.0+EPSILON) {
      return null;
    }

    final t = f * (e2.dot(r));

    return t;
  }

  /// Return the distance from the origin of [this] to the intersection with
  /// [other] if [this] intersects with [other], or null if the don't intersect.
  double intersectsWithAabb3(Aabb3 other) {
    Vector3 t1 = new Vector3.zero(), t2 = new Vector3.zero();
    double tNear = -double.MAX_FINITE;
    double tFar = double.MAX_FINITE;

    for(int i = 0; i < 3; ++i){
      if(direction[i] == 0.0){
        if((origin[i] < other.min[i]) || (origin[i] > other.max[i])) {
          return null;
        }
      }
      else {
        t1[i] = (other.min[i] - origin[i]) / direction[i];
        t2[i] = (other.max[i] - origin[i]) / direction[i];

        if(t1[i] > t2[i]){
          final temp = t1;
          t1 = t2;
          t2 = temp;
        }

        if(t1[i] > tNear){
          tNear = t1[i];
        }

        if(t2[i] < tFar){
          tFar = t2[i];
        }

        if((tNear > tFar) || (tFar < 0)){
          return null;
        }
      }
    }

    return tNear;
  }
}
