library test_aabb2;

import 'dart:math' as Math;
import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';
import 'test_helpers.dart';

void testCenter() {
  final Aabb2 aabb = new Aabb2.minMax(_v(1.0, 2.0), _v(8.0, 16.0));
  final Vector2 center = aabb.center;

  expect(center.x, equals(4.5));
  expect(center.y, equals(9.0));
}

void testContainsAabb2() {
  final Aabb2 parent = new Aabb2.minMax(_v(1.0, 1.0), _v(8.0, 8.0));
  final Aabb2 child = new Aabb2.minMax(_v(2.0, 2.0), _v(7.0, 7.0));
  final Aabb2 cutting = new Aabb2.minMax(_v(0.0, 0.0), _v(5.0, 5.0));
  final Aabb2 outside = new Aabb2.minMax(_v(10.0, 10.0), _v(20.0, 20.0));
  final Aabb2 grandParent = new Aabb2.minMax(_v(0.0, 0.0), _v(10.0, 10.0));

  expect(parent.containsAabb2(child), isTrue);
  expect(parent.containsAabb2(parent), isFalse);
  expect(parent.containsAabb2(cutting), isFalse);
  expect(parent.containsAabb2(outside), isFalse);
  expect(parent.containsAabb2(grandParent), isFalse);
}

void testContainsVector2() {
  final Aabb2 parent = new Aabb2.minMax(_v(1.0,1.0), _v(8.0,8.0));
  final Vector2 child = _v(2.0,2.0);
  final Vector2 cutting = _v(1.0,8.0);
  final Vector2 outside = _v(-1.0,0.0);

  expect(parent.containsVector2(child), isTrue);
  expect(parent.containsVector2(cutting), isFalse);
  expect(parent.containsVector2(outside), isFalse);
}

void testIntersectionAabb2() {
  final Aabb2 parent = new Aabb2.minMax(_v(1.0,1.0), _v(8.0,8.0));
  final Aabb2 child = new Aabb2.minMax(_v(2.0,2.0), _v(7.0,7.0));
  final Aabb2 cutting = new Aabb2.minMax(_v(0.0,0.0), _v(5.0,5.0));
  final Aabb2 outside = new Aabb2.minMax(_v(10.0,10.0), _v(20.0,20.0));
  final Aabb2 grandParent = new Aabb2.minMax(_v(0.0,0.0), _v(10.0,10.0));

  final Aabb2 siblingOne = new Aabb2.minMax(_v(0.0,0.0), _v(3.0,3.0));
  final Aabb2 siblingTwo = new Aabb2.minMax(_v(3.0,0.0), _v(6.0,3.0));
  final Aabb2 siblingThree = new Aabb2.minMax(_v(3.0,3.0), _v(6.0,6.0));


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

void testIntersectionVector2() {
  final Aabb2 parent = new Aabb2.minMax(_v(1.0,1.0), _v(8.0,8.0));
  final Vector2 child = _v(2.0,2.0);
  final Vector2 cutting = _v(1.0,8.0);
  final Vector2 outside = _v(-1.0,0.0);

  expect(parent.intersectsWithVector2(child), isTrue);
  expect(parent.intersectsWithVector2(cutting), isTrue);
  expect(parent.intersectsWithVector2(outside), isFalse);
}

void testHull() {
  final Aabb2 a = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,4.0));
  final Aabb2 b = new Aabb2.minMax(_v(3.0,2.0), _v(6.0,2.0));

  a.hull(b);

  expect(a.min.x, equals(1.0));
  expect(a.min.y, equals(1.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));
}

void testHullPoint() {
  final Aabb2 a = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,4.0));
  final Vector2 b = _v(6.0,2.0);

  a.hullPoint(b);

  expect(a.min.x, equals(1.0));
  expect(a.min.y, equals(1.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));

  final Vector2 c = _v(0.0,1.0);

  a.hullPoint(c);

  expect(a.min.x, equals(0.0));
  expect(a.min.y, equals(1.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));
}

void testRotate() {
  final Matrix3 rotation = new Matrix3.rotationZ(Math.PI/4);
  final Aabb2 input = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,3.0));

  final Aabb2 result = input..rotate(rotation);

  expect(result.min.x, relativeEquals(2 - Math.sqrt(2)));
  expect(result.min.y, relativeEquals(2 - Math.sqrt(2)));
  expect(result.max.x, relativeEquals(2 + Math.sqrt(2)));
  expect(result.max.y, relativeEquals(2 + Math.sqrt(2)));
  expect(result.center.x, relativeEquals(2.0));
  expect(result.center.y, relativeEquals(2.0));
}

void testTransform() {
  final Matrix3 rotation = new Matrix3.rotationZ(Math.PI/4);
  final Aabb2 input = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,3.0));

  final Aabb2 result = input..transform(rotation);
  final double newCenterY = Math.sqrt(8);

  expect(result.min.x, relativeEquals(-Math.sqrt(2)));
  expect(result.min.y, relativeEquals(newCenterY-Math.sqrt(2)));
  expect(result.max.x, relativeEquals(Math.sqrt(2)));
  expect(result.max.y, relativeEquals(newCenterY+Math.sqrt(2)));
  expect(result.center.x, absoluteEquals(0.0));
  expect(result.center.y, relativeEquals(newCenterY));
}

Vector2 _v(double x, double y) {
  return new Vector2(x,y);
}

void main() {
  group('Aabb2', () {
    test('Center', testCenter);
    test('Contains Aabb2', testContainsAabb2);
    test('Contains Vector2', testContainsVector2);
    test('Intersection Aabb2', testIntersectionAabb2);
    test('Intersection Vector2', testIntersectionVector2);
    test('Hull', testHull);
    test('Hull Point', testHullPoint);
    test('Rotate', testRotate);
    test('Transform', testTransform);
  });
}
