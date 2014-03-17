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

/// Defines a plane with a [normal] and a [constant] describing the signed
/// distance from the origin to the plane.
class Plane {
  final Vector3 _normal;
  double _constant;

  /// Find the intersection point between the three planes [a], [b] and [c] and
  /// copy it into [result].
  static void intersection(Plane a, Plane b, Plane c, Vector3 result) {
    final cross = new Vector3.zero();

    b._normal.crossInto(c._normal, cross);

    final f = -a._normal.dot(cross);

    final v1 = cross.scaled(a._constant);

    c._normal.crossInto(a._normal, cross);

    final v2 = cross.scaled(b._constant);

    a._normal.crossInto(b._normal, cross);

    final v3 = cross.scaled(c._constant);

    result.x = (v1.x + v2.x + v3.x) / f;
    result.y = (v1.y + v2.y + v3.y) / f;
    result.z = (v1.z + v2.z + v3.z) / f;
  }

  /// The [normal] of the plane.
  Vector3 get normal => _normal;
  /// The signed distance from the origin to the plane.
  double get constant => _constant;
  set constant(double value) => _constant = value;

  /// Create a new, uninitialized plane.
  Plane()
      : _normal = new Vector3.zero(),
        _constant = 0.0;

  /// Create a plane as a copy of [other].
  Plane.copy(Plane other)
      : _normal = new Vector3.copy(other._normal),
        _constant = other._constant;

  /// Create a plane with its components.
  Plane.components(double x, double y, double z, double w)
      : _normal = new Vector3(x, y, z),
        _constant = w;

  /// DEPREACTED: Use [normalConstant] instead
  @deprecated
  Plane.normalconstant(Vector3 normal, double constant)
      : _normal = new Vector3.copy(normal),
        _constant = constant;

  /// Create a plane with a [normal] and a [constant].
  Plane.normalConstant(Vector3 normal, double constant)
      : _normal = new Vector3.copy(normal),
        _constant = constant;

  /// Copy [other] into [this].
  void copyFrom(Plane other) {
    _normal.setFrom(other._normal);
    _constant = other._constant;
  }

  /// Set [this] by components.
  void setFromComponents(double x, double y, double z, double w) {
    _normal.setValues(x, y, z);
    _constant = w;
  }

  /// Normalize [this].
  void normalize() {
    final inverseLength = 1.0 / _normal.length;
    _normal.scale(inverseLength);
    _constant *= inverseLength;
  }

  /// Get the distance from [this] to [point].
  double distanceToVector3(Vector3 point) => _normal.dot(point) + _constant;
}
