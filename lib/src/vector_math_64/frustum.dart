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

/// Defines a frustum constructed out of six [planes].
class Frustum {
  final List<Plane> _planes;

  /// A list of six planes that define the bounce of the frustum.
  List<Plane> get planes => _planes;

  /// Create a new frustum without initializing its bounds.
  Frustum()
      : _planes = <Plane>[new Plane(), new Plane(), new Plane(), new Plane(),
                          new Plane(), new Plane()].toList(growable: false);

  /// Create a new frustum as a copy of [other].
  factory Frustum.copy(Frustum other) => new Frustum()..copyFrom(other);

  /// Create a new furstum from a [matrix].
  factory Frustum.matrix(Matrix4 matrix) => new Frustum()..setFromMatrix(matrix);

  /// Copy the [other] frustum into [this].
  void copyFrom(Frustum other) {
    final otherPlanes = other._planes;

    for (var i = 0; i < 6; ++i) {
      _planes[i].copyFrom(otherPlanes[i]);
    }
  }

  /// Set [this] from [matrix].
  void setFromMatrix(Matrix4 matrix) {
    var me = matrix._storage44;
    var me0 = me[0],
        me1 = me[1],
        me2 = me[2],
        me3 = me[3];
    var me4 = me[4],
        me5 = me[5],
        me6 = me[6],
        me7 = me[7];
    var me8 = me[8],
        me9 = me[9],
        me10 = me[10],
        me11 = me[11];
    var me12 = me[12],
        me13 = me[13],
        me14 = me[14],
        me15 = me[15];

    _planes[0]
        ..setFromComponents(me3 - me0, me7 - me4, me11 - me8, me15 - me12)
        ..normalize();
    _planes[1]
        ..setFromComponents(me3 + me0, me7 + me4, me11 + me8, me15 + me12)
        ..normalize();
    _planes[2]
        ..setFromComponents(me3 + me1, me7 + me5, me11 + me9, me15 + me13)
        ..normalize();
    _planes[3]
        ..setFromComponents(me3 - me1, me7 - me5, me11 - me9, me15 - me13)
        ..normalize();
    _planes[4]
        ..setFromComponents(me3 - me2, me7 - me6, me11 - me10, me15 - me14)
        ..normalize();
    _planes[5]
        ..setFromComponents(me3 + me2, me7 + me6, me11 + me10, me15 + me14)
        ..normalize();
  }

  /// Check if [this] contains a [point].
  bool containsVector3(Vector3 point) {
    for (var i = 0; i < 6; ++i) {
      if (_planes[i].distanceToVector3(point) < 0.0) {
        return false;
      }
    }

    return true;
  }

  /// Check if [this] intersects with [aabb].
  bool intersectsWithAabb3(Aabb3 aabb) {
    for (var i = 0; i < 6; ++i) {
      final plane = _planes[i];
      var outPx, outPy, outPz, outNx, outNy, outNz;

      if (plane._normal.x < 0.0) {
        outPx = aabb._min3.x;
        outNx = aabb._max3.x;
      } else {
        outPx = aabb._max3.x;
        outNx = aabb._min3.x;
      }

      if (plane._normal.y < 0.0) {
        outPy = aabb._min3.y;
        outNy = aabb._max3.y;
      } else {
        outPy = aabb._max3.y;
        outNy = aabb._min3.y;
      }

      if (plane._normal.z < 0.0) {
        outPz = aabb._min3.z;
        outNz = aabb._max3.z;
      } else {
        outPz = aabb._max3.z;
        outNz = aabb._min3.z;
      }

      final d1 =
          plane._normal.x * outPx +
          plane._normal.y * outPy +
          plane._normal.z * outPz +
          plane._constant;
      final d2 =
          plane._normal.x * outNx +
          plane._normal.y * outNy +
          plane._normal.z * outNz +
          plane._constant;

      if (d1 < 0 && d2 < 0) {
        return false;
      }
    }

    return true;
  }

  /// Check if [this] intersects with [sphere].
  bool intersectsWithSphere(Sphere sphere) {
    final negativeRadius = -sphere._radius;
    final center = sphere._center;

    for (var i = 0; i < 6; ++i) {
      final distance = _planes[i].distanceToVector3(center);

      if (distance < negativeRadius) {
        return false;
      }
    }

    return true;
  }

  /// Calculate the corners of a [frustum] at write them into [corner0] to
  // [corner7].
  void calculateCorners(Vector3 corner0, Vector3 corner1, Vector3 corner2,
      Vector3 corner3, Vector3 corner4, Vector3 corner5, Vector3 corner6,
      Vector3 corner7) {
    Plane.intersection(_planes[0], _planes[2], _planes[4], corner0);
    Plane.intersection(_planes[0], _planes[3], _planes[4], corner1);
    Plane.intersection(_planes[0], _planes[3], _planes[5], corner2);
    Plane.intersection(_planes[0], _planes[2], _planes[5], corner3);
    Plane.intersection(_planes[1], _planes[2], _planes[4], corner4);
    Plane.intersection(_planes[1], _planes[3], _planes[4], corner5);
    Plane.intersection(_planes[1], _planes[3], _planes[5], corner6);
    Plane.intersection(_planes[1], _planes[2], _planes[5], corner7);
  }
}
