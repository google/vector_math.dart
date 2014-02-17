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

class Aabb2 {
  final Vector2 _min;
  final Vector2 _max;

  Vector2 get min => _min;
  Vector2 get max => _max;

  Vector2 get center {
    Vector2 c = new Vector2.copy(_min);
    return c.add(_max).scale(.5);
  }

  Aabb2() :
    _min = new Vector2.zero(),
    _max = new Vector2.zero() {}

  Aabb2.copy(Aabb2 other) :
    _min = new Vector2.copy(other._min),
    _max = new Vector2.copy(other._max) {}

  @deprecated
  Aabb2.minmax(Vector2 min_, Vector2 max_) :
    _min = new Vector2.copy(min_),
    _max = new Vector2.copy(max_) {}

  Aabb2.minMax(Vector2 min_, Vector2 max_) :
    _min = new Vector2.copy(min_),
    _max = new Vector2.copy(max_) {}

  void copyMinMax(Vector2 min_, Vector2 max_) {
    max_.setFrom(_max);
    min_.setFrom(_min);
  }

  void copyCenterAndHalfExtents(Vector2 center, Vector2 halfExtents) {
    center.setFrom(_min);
    center.add(_max);
    center.scale(0.5);
    halfExtents.setFrom(_max);
    halfExtents.sub(_min);
    halfExtents.scale(0.5);
  }

  void copyFrom(Aabb2 o) {
    _min.setFrom(o._min);
    _max.setFrom(o._max);
  }

  void copyInto(Aabb2 o) {
    o._min.setFrom(_min);
    o._max.setFrom(_max);
  }

  Aabb2 transform(Matrix3 T) {
    Vector2 center = new Vector2.zero();
    Vector2 halfExtents = new Vector2.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    T.transform2(center);
    T.absoluteRotate2(halfExtents);
    _min.setFrom(center);
    _max.setFrom(center);

    _min.sub(halfExtents);
    _max.add(halfExtents);
    return this;
  }

  Aabb2 rotate(Matrix3 T) {
    Vector2 center = new Vector2.zero();
    Vector2 halfExtents = new Vector2.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    T.absoluteRotate2(halfExtents);
    _min.setFrom(center);
    _max.setFrom(center);

    _min.sub(halfExtents);
    _max.add(halfExtents);
    return this;
  }

  Aabb2 transformed(Matrix3 T, Aabb2 out) {
    out.copyFrom(this);
    return out.transform(T);
  }

  Aabb2 rotated(Matrix3 T, Aabb2 out) {
    out.copyFrom(this);
    return out.rotate(T);
  }

  /// Set the min and max of [this] so that [this] is a hull of [this] and [other].
  void hull(Aabb2 other) {
    min.x = Math.min(_min.x, other.min.x);
    min.y = Math.min(_min.y, other.min.y);
    max.x = Math.max(_max.x, other.max.x);
    max.y = Math.max(_max.y, other.max.y);
  }

  /// Set the min and max of [this] so that [this] contains [point].
  void hullPoint(Vector2 point) {
    Vector2.min(_min, point, _min);
    Vector2.max(_max, point, _max);
  }

  /// Return if [this] contains [other].
  bool containsAabb2(Aabb2 other) {
    return min.x < other.min.x &&
           min.y < other.min.y &&
           max.y > other.max.y &&
           max.x > other.max.x;
  }

  /// Return if [this] contains [other].
  bool containsVector2(Vector2 other) {
    return min.x < other.x &&
           min.y < other.y &&
           max.x > other.x &&
           max.y > other.y;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithAabb2(Aabb2 other) {
    return min.x <= other.max.x &&
           min.y <= other.max.y &&
           max.x >= other.min.x &&
           max.y >= other.min.y;
  }

  /// Return if [this] intersects with [other].
  bool intersectsWithVector2(Vector2 other) {
    return min.x <= other.x &&
           min.y <= other.y &&
           max.x >= other.x &&
           max.y >= other.y;
  }
}
