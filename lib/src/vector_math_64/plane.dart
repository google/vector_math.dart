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

class Plane {
  final Vector3 _normal;
  double _constant;

  /// Find the intersection point between the three planes [a], [b] and [c] and
  /// copy it into [result].
  static void intersection(Plane a, Plane b, Plane c, Vector3 result)
  {
    final cross = new Vector3.zero();

    b.normal.crossInto(c.normal, cross);

    final f = -a.normal.dot(cross);

    final v1 = cross.scaled(a.constant);

    c.normal.crossInto(a.normal, cross);

    final v2 = cross.scaled(b.constant);

    a.normal.crossInto(b.normal, cross);

    final v3 = cross.scaled(c.constant);

    result.x = (v1.x + v2.x + v3.x) / f;
    result.y = (v1.y + v2.y + v3.y) / f;
    result.z = (v1.z + v2.z + v3.z) / f;
  }

  Vector3 get normal => _normal;
  double get constant => _constant;
         set constant(double value) => _constant = value;

  Plane() :
    _normal = new Vector3.zero(),
    _constant = 0.0 {}

  Plane.copy(Plane other) :
    _normal = new Vector3.copy(other._normal),
    _constant = other._constant {}

  Plane.components(double x, double y, double z, double w) :
    _normal = new Vector3(x, y, z),
    _constant = w {}

  Plane.normalconstant(Vector3 normal_, double constant_) :
    _normal = new Vector3.copy(normal_),
    _constant = constant_ {}

  void copyFrom(Plane o) {
    _normal.setFrom(o._normal);
    _constant = o._constant;
  }

  void setFromComponents(double x, double y, double z, double w) {
    _normal.setValues(x, y, z);
    _constant = w;
  }

  void normalize() {
    var inverseLength = 1.0 / normal.length;
    _normal.scale(inverseLength);
    _constant *= inverseLength;
  }

  double distanceToVector3(Vector3 point) {
    return _normal.dot(point) + _constant;
  }
}
