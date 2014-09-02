library test_plane;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';

void testNormalize() {
  final Plane plane = new Plane.normalConstant(_v(2.0, 0.0, 0.0), 2.0);

  plane.normalize();

  expect(plane.normal.x, equals(1.0));
  expect(plane.normal.y, equals(0.0));
  expect(plane.normal.z, equals(0.0));
  expect(plane.normal.length, equals(1.0));
  expect(plane.constant, equals(1.0));
}

void testDistanceToVector3() {
  final Plane plane = new Plane.normalConstant(_v(2.0, 0.0, 0.0), -2.0);

  plane.normalize();

  expect(plane.distanceToVector3(_v(4.0, 0.0, 0.0)), equals(3.0));
  expect(plane.distanceToVector3(_v(1.0, 0.0, 0.0)), equals(0.0));
}

void testIntersection() {
  final Plane plane1 = new Plane.normalConstant(_v(1.0, 0.0, 0.0), -2.0);
  final Plane plane2 = new Plane.normalConstant(_v(0.0, 1.0, 0.0), -3.0);
  final Plane plane3 = new Plane.normalConstant(_v(0.0, 0.0, 1.0), -4.0);

  plane1.normalize();
  plane2.normalize();
  plane3.normalize();

  final point = new Vector3.zero();

  Plane.intersection(plane1, plane2, plane3, point);

  expect(point.x, equals(2.0));
  expect(point.y, equals(3.0));
  expect(point.z, equals(4.0));
}

Vector3 _v(double x, double y, double z) {
  return new Vector3(x, y, z);
}

void main() {
  group('Plane', () {
    test('Normalize', testNormalize);
    test('DistanceToVector3', testDistanceToVector3);
    test('Intersection', testIntersection);
  });
}
