library test_sphere;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';

void testContainsVector3() {
  final Sphere parent = new Sphere.centerRadius(_v(1.0, 1.0, 1.0), 2.0);
  final Vector3 child = _v(1.0, 1.0, 2.0);
  final Vector3 cutting = _v(1.0, 3.0, 1.0);
  final Vector3 outside = _v(-10.0, 10.0, 10.0);

  expect(parent.containsVector3(child), isTrue);
  expect(parent.containsVector3(cutting), isFalse);
  expect(parent.containsVector3(outside), isFalse);
}

void testIntersectionVector3() {
  final Sphere parent = new Sphere.centerRadius(_v(1.0, 1.0, 1.0), 2.0);
  final Vector3 child = _v(1.0, 1.0, 2.0);
  final Vector3 cutting = _v(1.0, 3.0, 1.0);
  final Vector3 outside = _v(-10.0, 10.0, 10.0);

  expect(parent.intersectsWithVector3(child), isTrue);
  expect(parent.intersectsWithVector3(cutting), isTrue);
  expect(parent.intersectsWithVector3(outside), isFalse);
}

void testIntersectionSphere() {
  final Sphere parent = new Sphere.centerRadius(_v(1.0, 1.0, 1.0), 2.0);
  final Sphere child = new Sphere.centerRadius(_v(1.0, 1.0, 2.0), 1.0);
  final Sphere cutting = new Sphere.centerRadius(_v(1.0, 6.0, 1.0), 3.0);
  final Sphere outside = new Sphere.centerRadius(_v(10.0, -1.0, 1.0), 1.0);

  expect(parent.intersectsWithSphere(child), isTrue);
  expect(parent.intersectsWithSphere(cutting), isTrue);
  expect(parent.intersectsWithSphere(outside), isFalse);
}

Vector3 _v(double x, double y, double z) {
  return new Vector3(x, y, z);
}

void main() {
  group('Sphere', () {
    test('Contains Vector3', testContainsVector3);
    test('Intersection Vector3', testIntersectionVector3);
    test('Intersection Sphere', testIntersectionSphere);
  });
}
