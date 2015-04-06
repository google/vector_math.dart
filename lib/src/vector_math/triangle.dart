// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

class Triangle {
  final Vector3 _point0;
  final Vector3 _point1;
  final Vector3 _point2;

  Vector3 get point0 => _point0;
  Vector3 get point1 => _point1;
  Vector3 get point2 => _point2;

  Triangle()
      : _point0 = new Vector3.zero(),
        _point1 = new Vector3.zero(),
        _point2 = new Vector3.zero();

  Triangle.copy(Triangle other)
      : _point0 = new Vector3.copy(other._point0),
        _point1 = new Vector3.copy(other._point1),
        _point2 = new Vector3.copy(other._point2);

  Triangle.points(Vector3 point0_, Vector3 point1_, Vector3 point2_)
      : _point0 = new Vector3.copy(point0_),
        _point1 = new Vector3.copy(point1_),
        _point2 = new Vector3.copy(point2_);

  void copyOriginDirection(Vector3 point0_, Vector3 point1_, Vector3 point2_) {
    point0_.setFrom(_point0);
    point1_.setFrom(_point1);
    point2_.setFrom(_point2);
  }

  void copyFrom(Triangle o) {
    _point0.setFrom(o._point0);
    _point1.setFrom(o._point1);
    _point2.setFrom(o._point2);
  }

  void copyInto(Triangle o) {
    o._point0.setFrom(_point0);
    o._point1.setFrom(_point1);
    o._point2.setFrom(_point2);
  }
}
