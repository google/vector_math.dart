// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.aabb2_test;

import 'dart:math' as Math;

import 'package:unittest/unittest.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testAabb2Center() {
  final Aabb2 aabb = new Aabb2.minMax($v2(1.0, 2.0), $v2(8.0, 16.0));
  final Vector2 center = aabb.center;

  expect(center.x, equals(4.5));
  expect(center.y, equals(9.0));
}

void testAabb2ContainsAabb2() {
  final Aabb2 parent = new Aabb2.minMax($v2(1.0, 1.0), $v2(8.0, 8.0));
  final Aabb2 child = new Aabb2.minMax($v2(2.0, 2.0), $v2(7.0, 7.0));
  final Aabb2 cutting = new Aabb2.minMax($v2(0.0, 0.0), $v2(5.0, 5.0));
  final Aabb2 outside = new Aabb2.minMax($v2(10.0, 10.0), $v2(20.0, 20.0));
  final Aabb2 grandParent = new Aabb2.minMax($v2(0.0, 0.0), $v2(10.0, 10.0));

  expect(parent.containsAabb2(child), isTrue);
  expect(parent.containsAabb2(parent), isFalse);
  expect(parent.containsAabb2(cutting), isFalse);
  expect(parent.containsAabb2(outside), isFalse);
  expect(parent.containsAabb2(grandParent), isFalse);
}

void testAabb2ContainsVector2() {
  final Aabb2 parent = new Aabb2.minMax($v2(1.0, 1.0), $v2(8.0, 8.0));
  final Vector2 child = $v2(2.0, 2.0);
  final Vector2 cutting = $v2(1.0, 8.0);
  final Vector2 outside = $v2(-1.0, 0.0);

  expect(parent.containsVector2(child), isTrue);
  expect(parent.containsVector2(cutting), isFalse);
  expect(parent.containsVector2(outside), isFalse);
}

void testAabb2IntersectionAabb2() {
  final Aabb2 parent = new Aabb2.minMax($v2(1.0, 1.0), $v2(8.0, 8.0));
  final Aabb2 child = new Aabb2.minMax($v2(2.0, 2.0), $v2(7.0, 7.0));
  final Aabb2 cutting = new Aabb2.minMax($v2(0.0, 0.0), $v2(5.0, 5.0));
  final Aabb2 outside = new Aabb2.minMax($v2(10.0, 10.0), $v2(20.0, 20.0));
  final Aabb2 grandParent = new Aabb2.minMax($v2(0.0, 0.0), $v2(10.0, 10.0));

  final Aabb2 siblingOne = new Aabb2.minMax($v2(0.0, 0.0), $v2(3.0, 3.0));
  final Aabb2 siblingTwo = new Aabb2.minMax($v2(3.0, 0.0), $v2(6.0, 3.0));
  final Aabb2 siblingThree = new Aabb2.minMax($v2(3.0, 3.0), $v2(6.0, 6.0));

  expect(parent.intersectsWithAabb2(child), isTrue);
  expect(child.intersectsWithAabb2(parent), isTrue);

  expect(parent.intersectsWithAabb2(parent), isTrue);

  expect(parent.intersectsWithAabb2(cutting), isTrue);
  expect(cutting.intersectsWithAabb2(parent), isTrue);

  expect(parent.intersectsWithAabb2(outside), isFalse);
  expect(outside.intersectsWithAabb2(parent), isFalse);

  expect(parent.intersectsWithAabb2(grandParent), isTrue);
  expect(grandParent.intersectsWithAabb2(parent), isTrue);

  expect(siblingOne.intersectsWithAabb2(siblingTwo), isTrue,
      reason: 'Touching edges are counted as intersection.');
  expect(siblingOne.intersectsWithAabb2(siblingThree), isTrue,
      reason: 'Touching corners are counted as intersection.');
}

void testAabb2IntersectionVector2() {
  final Aabb2 parent = new Aabb2.minMax($v2(1.0, 1.0), $v2(8.0, 8.0));
  final Vector2 child = $v2(2.0, 2.0);
  final Vector2 cutting = $v2(1.0, 8.0);
  final Vector2 outside = $v2(-1.0, 0.0);

  expect(parent.intersectsWithVector2(child), isTrue);
  expect(parent.intersectsWithVector2(cutting), isTrue);
  expect(parent.intersectsWithVector2(outside), isFalse);
}

void testAabb2Hull() {
  final Aabb2 a = new Aabb2.minMax($v2(1.0, 1.0), $v2(3.0, 4.0));
  final Aabb2 b = new Aabb2.minMax($v2(3.0, 2.0), $v2(6.0, 2.0));

  a.hull(b);

  expect(a.min.x, equals(1.0));
  expect(a.min.y, equals(1.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));
}

void testAabb2HullPoint() {
  final Aabb2 a = new Aabb2.minMax($v2(1.0, 1.0), $v2(3.0, 4.0));
  final Vector2 b = $v2(6.0, 2.0);

  a.hullPoint(b);

  expect(a.min.x, equals(1.0));
  expect(a.min.y, equals(1.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));

  final Vector2 c = $v2(0.0, 1.0);

  a.hullPoint(c);

  expect(a.min.x, equals(0.0));
  expect(a.min.y, equals(1.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));
}

void testAabb2Rotate() {
  final Matrix3 rotation = new Matrix3.rotationZ(Math.PI / 4);
  final Aabb2 input = new Aabb2.minMax($v2(1.0, 1.0), $v2(3.0, 3.0));

  final Aabb2 result = input.rotate(rotation);

  relativeTest(result.min.x, 2 - Math.sqrt(2));
  relativeTest(result.min.y, 2 - Math.sqrt(2));
  relativeTest(result.max.x, 2 + Math.sqrt(2));
  relativeTest(result.max.y, 2 + Math.sqrt(2));
  relativeTest(result.center.x, 2.0);
  relativeTest(result.center.y, 2.0);
}

void testAabb2Transform() {
  final Matrix3 rotation = new Matrix3.rotationZ(Math.PI / 4);
  final Aabb2 input = new Aabb2.minMax($v2(1.0, 1.0), $v2(3.0, 3.0));

  final Aabb2 result = input.transform(rotation);
  final double newCenterY = Math.sqrt(8);

  relativeTest(result.min.x, -Math.sqrt(2));
  relativeTest(result.min.y, newCenterY - Math.sqrt(2));
  relativeTest(result.max.x, Math.sqrt(2));
  relativeTest(result.max.y, newCenterY + Math.sqrt(2));
  relativeTest(result.center.x, 0.0);
  relativeTest(result.center.y, newCenterY);
}

void main() {
  group('Aabb2', () {
    test('Center', testAabb2Center);
    test('Contains Aabb2', testAabb2ContainsAabb2);
    test('Contains Vector2', testAabb2ContainsVector2);
    test('Intersection Aabb2', testAabb2IntersectionAabb2);
    test('Intersection Vector2', testAabb2IntersectionVector2);
    test('Hull', testAabb2Hull);
    test('Hull Point', testAabb2HullPoint);
    test('Rotate', testAabb2Rotate);
    test('Transform', testAabb2Transform);
  });
}
