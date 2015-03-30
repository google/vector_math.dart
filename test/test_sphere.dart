library vector_math.test.sphere_test;

import 'package:unittest/unittest.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testSphereContainsVector3() {
  final Sphere parent = new Sphere.centerRadius(v3(1.0, 1.0, 1.0), 2.0);
  final Vector3 child = v3(1.0, 1.0, 2.0);
  final Vector3 cutting = v3(1.0, 3.0, 1.0);
  final Vector3 outside = v3(-10.0, 10.0, 10.0);

  expect(parent.containsVector3(child), isTrue);
  expect(parent.containsVector3(cutting), isFalse);
  expect(parent.containsVector3(outside), isFalse);
}

void testSphereIntersectionVector3() {
  final Sphere parent = new Sphere.centerRadius(v3(1.0, 1.0, 1.0), 2.0);
  final Vector3 child = v3(1.0, 1.0, 2.0);
  final Vector3 cutting = v3(1.0, 3.0, 1.0);
  final Vector3 outside = v3(-10.0, 10.0, 10.0);

  expect(parent.intersectsWithVector3(child), isTrue);
  expect(parent.intersectsWithVector3(cutting), isTrue);
  expect(parent.intersectsWithVector3(outside), isFalse);
}

void testSphereIntersectionSphere() {
  final Sphere parent = new Sphere.centerRadius(v3(1.0, 1.0, 1.0), 2.0);
  final Sphere child = new Sphere.centerRadius(v3(1.0, 1.0, 2.0), 1.0);
  final Sphere cutting = new Sphere.centerRadius(v3(1.0, 6.0, 1.0), 3.0);
  final Sphere outside = new Sphere.centerRadius(v3(10.0, -1.0, 1.0), 1.0);

  expect(parent.intersectsWithSphere(child), isTrue);
  expect(parent.intersectsWithSphere(cutting), isTrue);
  expect(parent.intersectsWithSphere(outside), isFalse);
}

void main() {
  test('Sphere Contains Vector3', testSphereContainsVector3);
  test('Sphere Intersection Vector3', testSphereIntersectionVector3);
  test('Sphere Intersection Sphere', testSphereIntersectionSphere);
}
