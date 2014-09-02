library test_aabb3;

import 'dart:typed_data';
import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';

void testByteBufferInstanciation() {
  final ByteBuffer buffer = new Float32List.fromList([1.0,2.0,3.0,4.0,5.0,6.0,7.0]).buffer;
  final Aabb3 aabb = new Aabb3.fromBuffer( buffer, 0);
  final Aabb3 aabbOffest = new Aabb3.fromBuffer( buffer, Float32List.BYTES_PER_ELEMENT);
  final Vector3 center = aabb.center;

  expect(aabb.min.x, equals(1.0));
  expect(aabb.min.y, equals(2.0));
  expect(aabb.min.z, equals(3.0));
  expect(aabb.max.x, equals(4.0));
  expect(aabb.max.y, equals(5.0));
  expect(aabb.max.z, equals(6.0));

  expect(aabbOffest.min.x, equals(2.0));
  expect(aabbOffest.min.y, equals(3.0));
  expect(aabbOffest.min.z, equals(4.0));
  expect(aabbOffest.max.x, equals(5.0));
  expect(aabbOffest.max.y, equals(6.0));
  expect(aabbOffest.max.z, equals(7.0));
}

void testCenter() {
  final Aabb3 aabb = new Aabb3.minMax(_v(1.0,2.0, 4.0), _v(8.0,16.0, 32.0));
  final Vector3 center = aabb.center;

  expect(center.x, equals(4.5));
  expect(center.y, equals(9.0));
  expect(center.z, equals(18.0));
}

void testContainsAabb3() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Aabb3 child = new Aabb3.minMax(_v(2.0,2.0,2.0), _v(7.0,7.0,7.0));
  final Aabb3 cutting = new Aabb3.minMax(_v(0.0,0.0,0.0), _v(5.0,5.0,5.0));
  final Aabb3 outside = new Aabb3.minMax(_v(10.0,10.0,10.0), _v(20.0,20.0,20.0));
  final Aabb3 grandParent = new Aabb3.minMax(_v(0.0,0.0,0.0), _v(10.0,10.0,10.0));

  expect(parent.containsAabb3(child), isTrue);
  expect(parent.containsAabb3(parent), isFalse);
  expect(parent.containsAabb3(cutting), isFalse);
  expect(parent.containsAabb3(outside), isFalse);
  expect(parent.containsAabb3(grandParent), isFalse);
}

void testContainsSphere() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Sphere child = new Sphere.centerRadius(_v(3.0, 3.0, 3.0), 1.5);
  final Sphere cutting = new Sphere.centerRadius(_v(0.0,0.0,0.0), 6.0);
  final Sphere outside = new Sphere.centerRadius(_v(-10.0,-10.0,-10.0), 5.0);

  expect(parent.containsSphere(child), isTrue);
  expect(parent.containsSphere(cutting), isFalse);
  expect(parent.containsSphere(outside), isFalse);
}

void testContainsVector3() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Vector3 child = _v(7.0,7.0,7.0);
  final Vector3 cutting = _v(1.0,2.0,1.0);
  final Vector3 outside = _v(-10.0,10.0,10.0);

  expect(parent.containsVector3(child), isTrue);
  expect(parent.containsVector3(cutting), isFalse);
  expect(parent.containsVector3(outside), isFalse);
}

void testContainsTriangle() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Triangle child = new Triangle.points(_v(2.0,2.0,2.0), _v(3.0,3.0,3.0), _v(4.0,4.0,4.0));
  final Triangle edge = new Triangle.points(_v(1.0,1.0,1.0), _v(3.0,3.0,3.0), _v(4.0,4.0,4.0));
  final Triangle cutting = new Triangle.points(_v(2.0,2.0,2.0), _v(3.0,3.0,3.0), _v(14.0,14.0,14.0));
  final Triangle outside = new Triangle.points(_v(0.0,0.0,0.0), _v(-3.0,-3.0,-3.0), _v(-4.0,-4.0,-4.0));

  expect(parent.containsTriangle(child), isTrue);
  expect(parent.containsTriangle(edge), isFalse);
  expect(parent.containsTriangle(cutting), isFalse);
  expect(parent.containsTriangle(outside), isFalse);
}

void testIntersectionAabb3() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Aabb3 child = new Aabb3.minMax(_v(2.0,2.0,2.0), _v(7.0,7.0,7.0));
  final Aabb3 cutting = new Aabb3.minMax(_v(0.0,0.0,0.0), _v(5.0,5.0,5.0));
  final Aabb3 outside = new Aabb3.minMax(_v(10.0,10.0,10.0), _v(20.0,20.0,10.0));
  final Aabb3 grandParent = new Aabb3.minMax(_v(0.0,0.0,0.0), _v(10.0,10.0,10.0));

  final Aabb3 siblingOne = new Aabb3.minMax(_v(0.0,0.0,0.0), _v(3.0,3.0,3.0));
  final Aabb3 siblingTwo = new Aabb3.minMax(_v(3.0,0.0,0.0), _v(6.0,3.0,3.0));
  final Aabb3 siblingThree = new Aabb3.minMax(_v(3.0,3.0,3.0), _v(6.0,6.0,6.0));

  expect(parent.intersectsWithAabb3(child), isTrue);
  expect(child.intersectsWithAabb3(parent), isTrue);

  expect(parent.intersectsWithAabb3(parent), isTrue);

  expect(parent.intersectsWithAabb3(cutting), isTrue);
  expect(cutting.intersectsWithAabb3(parent), isTrue);

  expect(parent.intersectsWithAabb3(outside), isFalse);
  expect(outside.intersectsWithAabb3(parent), isFalse);

  expect(parent.intersectsWithAabb3(grandParent), isTrue);
  expect(grandParent.intersectsWithAabb3(parent), isTrue);

  expect(siblingOne.intersectsWithAabb3(siblingTwo), isTrue,
      reason: 'Touching edges are counted as intersection.');
  expect(siblingOne.intersectsWithAabb3(siblingThree), isTrue,
      reason: 'Touching corners are counted as intersection.');
}

void testIntersectionSphere() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Sphere child = new Sphere.centerRadius(_v(3.0, 3.0, 3.0), 1.5);
  final Sphere cutting = new Sphere.centerRadius(_v(0.0,0.0,0.0), 6.0);
  final Sphere outside = new Sphere.centerRadius(_v(-10.0,-10.0,-10.0), 5.0);

  expect(parent.intersectsWithSphere(child), isTrue);
  expect(parent.intersectsWithSphere(cutting), isTrue);
  expect(parent.intersectsWithSphere(outside), isFalse);
}

void testIntersectionVector3() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Vector3 child = _v(7.0,7.0,7.0);
  final Vector3 cutting = _v(1.0,2.0,1.0);
  final Vector3 outside = _v(-10.0,10.0,10.0);

  expect(parent.intersectsWithVector3(child), isTrue);
  expect(parent.intersectsWithVector3(cutting), isTrue);
  expect(parent.intersectsWithVector3(outside), isFalse);
}

void testIntersectionTriangle() {
  final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Triangle child = new Triangle.points(_v(2.0,2.0,2.0), _v(3.0,3.0,3.0), _v(4.0,4.0,4.0));
  final Triangle edge = new Triangle.points(_v(1.0,1.0,1.0), _v(3.0,3.0,3.0), _v(4.0,4.0,4.0));
  final Triangle cutting = new Triangle.points(_v(2.0,2.0,2.0), _v(3.0,3.0,3.0), _v(14.0,14.0,14.0));
  final Triangle outside = new Triangle.points(_v(0.0,0.0,0.0), _v(-3.0,-3.0,-3.0), _v(-4.0,-4.0,-4.0));

  expect(parent.intersectsWithTriangle(child), isTrue);
  expect(parent.intersectsWithTriangle(edge), isTrue);
  expect(parent.intersectsWithTriangle(cutting), isTrue);
  expect(parent.intersectsWithTriangle(outside), isFalse);

  // Special tests
  final Aabb3 testAabb = new Aabb3.minMax(_v(20.458911895751953,-36.607460021972656,2.549999952316284), _v(21.017810821533203,-36.192543029785156,3.049999952316284));
  final Triangle testTriangle = new Triangle.points(_v(20.5,-36.5,3.5), _v(21.5,-36.5,2.5), _v(20.5,-36.5,2.5));
  expect(testAabb.intersectsWithTriangle(testTriangle), isTrue);

  final Aabb3 aabb = new Aabb3.minMax(_v(19.07674217224121,-39.46818161010742,2.299999952316284), _v(19.40754508972168,-38.9503288269043,2.799999952316284));
  final Triangle triangle4 = new Triangle.points(_v(18.5,-39.5,2.5), _v(19.5,-39.5,2.5), _v(19.5,-38.5,2.5));
  final Triangle triangle4_1 = new Triangle.points(_v(19.5,-38.5,2.5), _v(19.5,-39.5,2.5), _v(18.5,-39.5,2.5));
  final Triangle triangle4_2 = new Triangle.points(_v(18.5,-39.5,2.5), _v(19.5,-38.5,2.5), _v(18.5,-38.5,2.5));
  final Triangle triangle4_3 = new Triangle.points(_v(18.5,-38.5,2.5), _v(19.5,-38.5,2.5), _v(18.5,-39.5,2.5));

  expect(aabb.intersectsWithTriangle(triangle4), isTrue);
  expect(aabb.intersectsWithTriangle(triangle4_1), isTrue);
  expect(aabb.intersectsWithTriangle(triangle4_2), isFalse);
  expect(aabb.intersectsWithTriangle(triangle4_3), isFalse);
}

void testHull() {
  final Aabb3 a = new Aabb3.minMax(_v(1.0,1.0,4.0), _v(3.0,4.0,10.0));
  final Aabb3 b = new Aabb3.minMax(_v(3.0,2.0,3.0), _v(6.0,2.0,8.0));

  a.hull(b);

  expect(a.min.x, equals(1.0));
  expect(a.min.y, equals(1.0));
  expect(a.min.z, equals(3.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));
  expect(a.max.z, equals(10.0));
}

void testHullPoint() {
  final Aabb3 a = new Aabb3.minMax(_v(1.0,1.0,4.0), _v(3.0,4.0,10.0));
  final Vector3 b = _v(6.0,2.0,8.0);

  a.hullPoint(b);

  expect(a.min.x, equals(1.0));
  expect(a.min.y, equals(1.0));
  expect(a.min.z, equals(4.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));
  expect(a.max.z, equals(10.0));

  final Vector3 c = _v(6.0,0.0,2.0);

  a.hullPoint(c);

  expect(a.min.x, equals(1.0));
  expect(a.min.y, equals(0.0));
  expect(a.min.z, equals(2.0));
  expect(a.max.x, equals(6.0));
  expect(a.max.y, equals(4.0));
  expect(a.max.z, equals(10.0));
}

Vector3 _v(double x, double y, double z) {
  return new Vector3(x,y,z);
}

void main() {
  group('Aabb3', () {
    test('ByteBuffer instanciation', testByteBufferInstanciation);
    test('Center', testCenter);
    test('Contains Aabb3', testContainsAabb3);
    test('Contains Vector3', testContainsVector3);
    test('Contains Triangle', testContainsTriangle);
    test('Contains Sphere', testContainsSphere);
    test('Intersection Aabb3', testIntersectionAabb3);
    test('Intersection Vector3', testIntersectionVector3);
    test('Intersection Sphere', testIntersectionSphere);
    test('Intersection Triangle', testIntersectionTriangle);
    test('Hull', testHull);
    test('Hull Point', testHullPoint);
  });
}
