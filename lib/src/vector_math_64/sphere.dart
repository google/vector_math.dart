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

class Sphere {
  final Vector3 _center;
  double _radius;

  Vector3 get center => _center;
  double get radius => _radius;
         set radius(double value) => _radius = value;

  Sphere() :
    _center = new Vector3.zero(),
    _radius = 0.0 {}

  Sphere.copy(Sphere other) :
    _center = new Vector3.copy(other._center),
    _radius = other._radius {}

  Sphere.centerRadius(Vector3 center_, double radius_) :
    _center = new Vector3.copy(center_),
    _radius = radius_ {}


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
