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

/// Defines a quad by four points.
class Quad {
  final Vector3 _point0;
  final Vector3 _point1;
  final Vector3 _point2;
  final Vector3 _point3;

  /// The first point of the quad.
  Vector3 get point0 => _point0;
  /// The second point of the quad.
  Vector3 get point1 => _point1;
  /// The third point of the quad.
  Vector3 get point2 => _point2;
  /// The third point of the quad.
  Vector3 get point3 => _point3;

  /// Create a new, uninitialized quad.
  Quad()
      : _point0 = new Vector3.zero(),
        _point1 = new Vector3.zero(),
        _point2 = new Vector3.zero(),
        _point3 = new Vector3.zero();

  /// Create a quad as a copy of [other].
  Quad.copy(Quad other)
      : _point0 = new Vector3.copy(other._point0),
        _point1 = new Vector3.copy(other._point1),
        _point2 = new Vector3.copy(other._point2),
        _point3 = new Vector3.copy(other._point2);

  /// Create a quad by four points.
  Quad.points(Vector3 point0, Vector3 point1, Vector3 point2, Vector3 point3)
      : _point0 = new Vector3.copy(point0),
        _point1 = new Vector3.copy(point1),
        _point2 = new Vector3.copy(point2),
        _point3 = new Vector3.copy(point3);

  /// Copy the quad from [other] into [this].
  void copyFrom(Quad other) {
    _point0.setFrom(other._point0);
    _point1.setFrom(other._point1);
    _point2.setFrom(other._point2);
    _point3.setFrom(other._point3);
  }

  /// Copy the quad from [this] into [other].
  void copyInto(Quad other) {
    other._point0.setFrom(_point0);
    other._point1.setFrom(_point1);
    other._point2.setFrom(_point2);
    other._point3.setFrom(_point3);
  }

  /// Copy the normal of [this] into [normal].
  void copyNormalInto(Vector3 normal) {
    final v0 = _point0.clone()..sub(_point1);
    normal
        ..setFrom(_point2)
        ..sub(_point1)
        ..crossInto(v0, normal)
        ..normalize();
  }

  /// Transform [this] by the transform [t].
  void transform(Matrix4 t) {
    t.transform3(_point0);
    t.transform3(_point1);
    t.transform3(_point2);
    t.transform3(_point3);
  }

  /// Translate [this] by [value].
  void translate(Vector3 value) {
    _point0.add(value);
    _point1.add(value);
    _point2.add(value);
    _point3.add(value);
  }
}
