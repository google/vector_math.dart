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

class Triangle {
  final Vector3 _point0;
  final Vector3 _point1;
  final Vector3 _point2;

  Vector3 get point0 => _point0;
  Vector3 get point1 => _point1;
  Vector3 get point2 => _point2;

  Triangle() :
    _point0 = new Vector3.zero(),
    _point1 = new Vector3.zero(),
    _point2 = new Vector3.zero() {}

  Triangle.copy(Triangle other) :
    _point0 = new Vector3.copy(other._point0),
    _point1 = new Vector3.copy(other._point1),
    _point2 = new Vector3.copy(other._point2) {}

  Triangle.points(Vector3 point0_, Vector3 point1_, Vector3 point2_) :
    _point0 = new Vector3.copy(point0_),
    _point1 = new Vector3.copy(point1_),
    _point2 = new Vector3.copy(point2_) {}

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
