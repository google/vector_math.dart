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

/// Defines a 3-dimensional oriented bounding box defined with a [center],
/// [extents] and axes.
class Obb3 {
  final Vector3 _center;
  final Vector3 _extents;
  final Vector3 _axis0;
  final Vector3 _axis1;
  final Vector3 _axis2;

  /// The center of the OBB.
  Vector3 get center => _center;
  /// The extends of the OBB.
  Vector3 get extents => _extents;
  /// The first axis of the OBB.
  Vector3 get axis0 => _axis0;
  /// The second axis of the OBB.
  Vector3 get axis1 => _axis1;
  /// The third axis of the OBB.
  Vector3 get axis2 => _axis2;

  /// Create a new OBB with erverything set to zero.
  Obb3()
      : _center = new Vector3.zero(),
        _extents = new Vector3.zero(),
        _axis0 = new Vector3(1.0, 0.0, 0.0),
        _axis1 = new Vector3(0.0, 1.0, 0.0),
        _axis2 = new Vector3(0.0, 0.0, 1.0);

  /// Create a new OBB as a copy of [other].
  Obb3.copy(Obb3 other)
      : _center = new Vector3.copy(other._center),
        _extents = new Vector3.copy(other._extents),
        _axis0 = new Vector3.copy(other._axis0),
        _axis1 = new Vector3.copy(other._axis1),
        _axis2 = new Vector3.copy(other._axis2);

  /// Create a new OBB using [center], [extents] and axis.
  Obb3.centerExtentsAxes(Vector3 center, Vector3 extents, Vector3 axis0,
      Vector3 axis1, Vector3 axis2)
      : _center = new Vector3.copy(center),
        _extents = new Vector3.copy(extents),
        _axis0 = new Vector3.copy(axis0),
        _axis1 = new Vector3.copy(axis1),
        _axis2 = new Vector3.copy(axis2);

  /// Copy from [other] into [this].
  void copyFrom(Obb3 other) {
    _center.setFrom(other._center);
    _extents.setFrom(other._extents);
    _axis0.setFrom(other._axis0);
    _axis1.setFrom(other._axis1);
    _axis2.setFrom(other._axis2);
  }

  /// Copy from [this] into [other].
  void copyInto(Obb3 other) {
    other._center.setFrom(_center);
    other._extents.setFrom(_extents);
    other._axis0.setFrom(_axis0);
    other._axis1.setFrom(_axis1);
    other._axis2.setFrom(_axis2);
  }

  /// Translate [this] by [offset].
  void translate(Vector3 offset) {
    _center.add(offset);
  }

  /// Rotate [this] by the rotation matrix [t].
  void rotate(Matrix3 t) {
    t.transform(_axis0..scale(_extents.x));
    t.transform(_axis1..scale(_extents.y));
    t.transform(_axis2..scale(_extents.z));
    _extents.x = _axis0.normalizeLength();
    _extents.y = _axis1.normalizeLength();
    _extents.z = _axis2.normalizeLength();
  }

  /// Transform [this] by the transform [t].
  void transform(Matrix4 t) {
    t.transform3(_center);
    t.rotate3(_axis0..scale(_extents.x));
    t.rotate3(_axis1..scale(_extents.y));
    t.rotate3(_axis2..scale(_extents.z));
    _extents.x = _axis0.normalizeLength();
    _extents.y = _axis1.normalizeLength();
    _extents.z = _axis2.normalizeLength();
  }

  void copyCorner(int cornerIndex, Vector3 corner) {
    assert(cornerIndex >= 0 || cornerIndex < 8);

    corner.setFrom(_center);

    switch(cornerIndex)
    {
      case 0:
        corner
            ..addScaled(_axis0, -_extents.x)
            ..addScaled(_axis1, -_extents.y)
            ..addScaled(_axis2, -_extents.z);
        break;
      case 1:
        corner
            ..addScaled(_axis0, -_extents.x)
            ..addScaled(_axis1, -_extents.y)
            ..addScaled(_axis2, _extents.z);
        break;
      case 2:
        corner
            ..addScaled(_axis0, -_extents.x)
            ..addScaled(_axis1, _extents.y)
            ..addScaled(_axis2, -_extents.z);
        break;
      case 3:
        corner
            ..addScaled(_axis0, -_extents.x)
            ..addScaled(_axis1, _extents.y)
            ..addScaled(_axis2, _extents.z);
        break;
      case 4:
        corner
            ..addScaled(_axis0, _extents.x)
            ..addScaled(_axis1, -_extents.y)
            ..addScaled(_axis2, -_extents.z);
        break;
      case 5:
        corner
            ..addScaled(_axis0, _extents.x)
            ..addScaled(_axis1, -_extents.y)
            ..addScaled(_axis2, _extents.z);
        break;
      case 6:
        corner
            ..addScaled(_axis0, _extents.x)
            ..addScaled(_axis1, _extents.y)
            ..addScaled(_axis2, -_extents.z);
        break;
      case 7:
        corner
            ..addScaled(_axis0, _extents.x)
            ..addScaled(_axis1, _extents.y)
            ..addScaled(_axis2, _extents.z);
        break;
    }
  }

  final _r = new Matrix3.zero();
  final _absR = new Matrix3.zero();
  final _t = new Vector3.zero();

  /// Check for intersection between [this] and [other].
  bool intersectsWithObb3(Obb3 other, [double epsilon = 1e-3]) {
    // Compute rotation matrix expressing other in this's coordinate frame
    _r.setEntry(0, 0, _axis0.dot(other._axis0));
    _r.setEntry(1, 0, _axis1.dot(other._axis0));
    _r.setEntry(2, 0, _axis2.dot(other._axis0));
    _r.setEntry(0, 1, _axis0.dot(other._axis1));
    _r.setEntry(2, 1, _axis1.dot(other._axis1));
    _r.setEntry(3, 1, _axis2.dot(other._axis1));
    _r.setEntry(0, 2, _axis0.dot(other._axis2));
    _r.setEntry(1, 2, _axis1.dot(other._axis2));
    _r.setEntry(2, 2, _axis2.dot(other._axis2));

    // Compute translation vector t
    _t
        ..setFrom(other._center)
        ..sub(_center);

    // Bring translation into this's coordinate frame
    _t.setValues(_t.dot(_axis0), _t.dot(_axis1), _t.dot(_axis2));

    // Compute common subexpressions. Add in an epsilon term to
    // counteract arithmetic errors when two edges are parallel and
    // their cross product is (near) null.
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++){
        _absR.setEntry(i, j, _r.entry(i, j).abs() + epsilon);
      }
    }

    double ra;
    double rb;

    // Test axes L = A0, L = A1, L = A2
    for (var i = 0; i < 3; i++) {
      ra = _extents[i];
      rb = other._extents[0] * _absR.entry(i, 0) +
          other._extents[1] * _absR.entry(i, 1) +
          other._extents[2] * _absR.entry(i, 2);

      if (_t[i].abs() > ra + rb) {
        return false;
      }
    }

    // Test axes L = B0, L = B1, L = B2
    for (var i = 0; i < 3; i++) {
      ra = _extents[0] * _absR.entry(0, i) +
          _extents[1] * _absR.entry(1, i) +
          _extents[2] * _absR.entry(2, i);
      rb = other._extents[i];

      if ((_t[0] * _r.entry(0, i) +
           _t[1] * _r.entry(1, i) +
           _t[2] * _r.entry(2, i)).abs() > ra + rb) {
        return false;
      }
    }

    // Test axis L = A0 x B0
    ra = _extents[1] * _absR.entry(2, 0) + _extents[2] * _absR.entry(1, 0);
    rb = other._extents[1] * _absR.entry(0, 2) +
        other._extents[2] * _absR.entry(0, 1);
    if ((_t[2] * _r.entry(1, 0) - _t[1] * _r.entry(2, 0)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A0 x B1
    ra = _extents[1] * _absR.entry(2, 1) + _extents[2] * _absR.entry(1, 1);
    rb = other._extents[0] * _absR.entry(0, 2) +
        other._extents[2] * _absR.entry(0, 0);
    if ((_t[2] * _r.entry(1, 1) - _t[1] * _r.entry(2, 1)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A0 x B2
    ra = _extents[1] * _absR.entry(2, 2) + _extents[2] * _absR.entry(1, 2);
    rb = other._extents[0] * _absR.entry(0, 1) +
        other._extents[1] * _absR.entry(0, 0);
    if ((_t[2] * _r.entry(1, 2) - _t[1] * _r.entry(2, 2)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A1 x B0
    ra = _extents[0] * _absR.entry(2, 0) + _extents[2] * _absR.entry(0, 0);
    rb = other._extents[1] * _absR.entry(1, 2) +
        other._extents[2] * _absR.entry(1, 1);
    if ((_t[0] * _r.entry(2, 0) - _t[2] * _r.entry(0, 0)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A1 x B1
    ra = _extents[0] * _absR.entry(2, 1) + _extents[2] * _absR.entry(0, 1);
    rb = other._extents[0] * _absR.entry(1, 2) +
        other._extents[2] * _absR.entry(1, 0);
    if ((_t[0] * _r.entry(2, 1) - _t[2] * _r.entry(0, 1)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A1 x B2
    ra = _extents[0] * _absR.entry(2, 2) + _extents[2] * _absR.entry(0, 2);
    rb = other._extents[0] * _absR.entry(1, 1) +
        other._extents[1] * _absR.entry(1, 0);
    if ((_t[0] * _r.entry(2, 2) - _t[2] * _r.entry(0, 2)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A2 x B0
    ra = _extents[0] * _absR.entry(1, 0) + _extents[1] * _absR.entry(0, 0);
    rb = other._extents[1] * _absR.entry(2, 2) +
        other._extents[2] * _absR.entry(2, 1);
    if ((_t[1] * _r.entry(0, 0) - _t[0] * _r.entry(1, 0)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A2 x B1
    ra = _extents[0] * _absR.entry(1, 1) + _extents[1] * _absR.entry(0, 1);
    rb = other._extents[0] * _absR.entry(2, 2) +
        other._extents[2] * _absR.entry(2, 0);
    if ((_t[1] * _r.entry(0, 1) - _t[0] * _r.entry(1, 1)).abs() > ra + rb) {
      return false;
    }

    // Test axis L = A2 x B2
    ra = _extents[0] * _absR.entry(1, 2) + _extents[1] * _absR.entry(0, 2);
    rb = other._extents[0] * _absR.entry(2, 1) +
        other._extents[1] * _absR.entry(2, 0);
    if ((_t[1] * _r.entry(0, 2) - _t[0] * _r.entry(1, 2)).abs() > ra + rb) {
      return false;
    }

    // Since no separating axis is found, the OBBs must be intersecting
    return false;
  }

  //TODO: IntersectsWithQuad
  //TODO: IntersectsWithTriangle
}