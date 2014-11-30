library test_obb3;

import 'dart:math' as Math;
import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';
import 'test_helpers.dart';

void testCorners() {
  final a = new Obb3()
      ..center.setValues(0.0, 0.0, 0.0)
      ..halfExtents.setValues(5.0, 5.0, 5.0);
  final corner = new Vector3.zero();

  a.copyCorner(0, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0, -5.0, -5.0)));

  a.copyCorner(1, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0, -5.0,  5.0)));

  a.copyCorner(2, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0,  5.0, -5.0)));

  a.copyCorner(3, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0,  5.0,  5.0)));

  a.copyCorner(4, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0, -5.0, -5.0)));

  a.copyCorner(5, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0, -5.0,  5.0)));

  a.copyCorner(6, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0,  5.0, -5.0)));

  a.copyCorner(7, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0,  5.0,  5.0)));
}

void testTranslate() {
  final a = new Obb3()
      ..center.setValues(0.0, 0.0, 0.0)
      ..halfExtents.setValues(5.0, 5.0, 5.0);
  final corner = new Vector3.zero();

  a.translate(new Vector3(-1.0, 2.0, 3.0));

  a.copyCorner(0, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0 - 1.0, -5.0 + 2.0, -5.0 + 3.0)));

  a.copyCorner(1, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0 - 1.0, -5.0 + 2.0,  5.0 + 3.0)));

  a.copyCorner(2, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0 - 1.0,  5.0 + 2.0, -5.0 + 3.0)));

  a.copyCorner(3, corner);
  expect(corner, absoluteEquals(new Vector3(-5.0 - 1.0,  5.0 + 2.0,  5.0 + 3.0)));

  a.copyCorner(4, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0 - 1.0, -5.0 + 2.0, -5.0 + 3.0)));

  a.copyCorner(5, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0 - 1.0, -5.0 + 2.0,  5.0 + 3.0)));

  a.copyCorner(6, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0 - 1.0,  5.0 + 2.0, -5.0 + 3.0)));

  a.copyCorner(7, corner);
  expect(corner, absoluteEquals(new Vector3( 5.0 - 1.0,  5.0 + 2.0,  5.0 + 3.0)));
}

void testRotate() {
  final a = new Obb3()
      ..center.setValues(0.0, 0.0, 0.0)
      ..halfExtents.setValues(5.0, 5.0, 5.0);
  final corner = new Vector3.zero();
  final matrix = new Matrix3.rotationY(radians(45.0));

  a.rotate(matrix);

  a.copyCorner(0, corner);
  expect(corner, absoluteEquals(new Vector3(0.0, -5.0, -7.071067810058594)));

  a.copyCorner(1, corner);
  expect(corner, absoluteEquals(new Vector3(-7.071067810058594, -5.0, 0.0)));

  a.copyCorner(2, corner);
  expect(corner, absoluteEquals(new Vector3(0.0, 5.0, -7.071067810058594)));

  a.copyCorner(3, corner);
  expect(corner, absoluteEquals(new Vector3(-7.071067810058594, 5.0, 0.0)));

  a.copyCorner(4, corner);
  expect(corner, absoluteEquals(new Vector3(7.071067810058594, -5.0, 0.0)));

  a.copyCorner(5, corner);
  expect(corner, absoluteEquals(new Vector3(0.0, -5.0, 7.071067810058594)));

  a.copyCorner(6, corner);
  expect(corner, absoluteEquals(new Vector3(7.071067810058594, 5.0, 0.0)));

  a.copyCorner(7, corner);
  expect(corner, absoluteEquals(new Vector3(0.0, 5.0, 7.071067810058594)));
}


void testTransform() {
  final a = new Obb3()
      ..center.setValues(0.0, 0.0, 0.0)
      ..halfExtents.setValues(5.0, 5.0, 5.0);
  final corner = new Vector3.zero();
  final matrix = new Matrix4.diagonal3Values(3.0, 3.0, 3.0);

  a.transform(matrix);

  a.copyCorner(0, corner);
  expect(corner, absoluteEquals(new Vector3(-15.0, -15.0, -15.0)));

  a.copyCorner(1, corner);
  expect(corner, absoluteEquals(new Vector3(-15.0, -15.0,  15.0)));

  a.copyCorner(2, corner);
  expect(corner, absoluteEquals(new Vector3(-15.0,  15.0, -15.0)));

  a.copyCorner(3, corner);
  expect(corner, absoluteEquals(new Vector3(-15.0,  15.0,  15.0)));

  a.copyCorner(4, corner);
  expect(corner, absoluteEquals(new Vector3( 15.0, -15.0, -15.0)));

  a.copyCorner(5, corner);
  expect(corner, absoluteEquals(new Vector3( 15.0, -15.0,  15.0)));

  a.copyCorner(6, corner);
  expect(corner, absoluteEquals(new Vector3( 15.0,  15.0, -15.0)));

  a.copyCorner(7, corner);
  expect(corner, absoluteEquals(new Vector3( 15.0,  15.0,  15.0)));
}

void testClosestPointTo() {
  final a = new Obb3()
      ..center.setValues(0.0, 0.0, 0.0)
      ..halfExtents.setValues(2.0, 2.0, 2.0);
  final b = new Vector3(3.0, 3.0, 3.0);
  final c = new Vector3(3.0, 3.0, -3.0);
  final closestPoint = new Vector3.zero();

  a.closestPointTo(b, closestPoint);

  expect(closestPoint, absoluteEquals(new Vector3( 2.0,  2.0,  2.0)));

  a.closestPointTo(c, closestPoint);

  expect(closestPoint, absoluteEquals(new Vector3( 2.0,  2.0,  -2.0)));

  a.rotate(new Matrix3.rotationZ(radians(45.0)));

  a.closestPointTo(b, closestPoint);

  expect(closestPoint, absoluteEquals(new Vector3(Math.SQRT2, Math.SQRT2, 2.0)));

  a.closestPointTo(c, closestPoint);

  expect(closestPoint, absoluteEquals(new Vector3(Math.SQRT2, Math.SQRT2, -2.0)));
}

void testIntersectionObb3() {
  final a = new Obb3()
      ..center.setValues(0.0, 0.0, 0.0)
      ..halfExtents.setValues(2.0, 2.0, 2.0);

  final b = new Obb3()
      ..center.setValues(3.0, 0.0, 0.0)
      ..halfExtents.setValues(0.5, 0.5, 0.5);

  final c = new Obb3()
      ..center.setValues(0.0, 3.0, 0.0)
      ..halfExtents.setValues(0.5, 0.5, 0.5);

  final d = new Obb3()
      ..center.setValues(0.0, 0.0, 3.0)
      ..halfExtents.setValues(0.5, 0.5, 0.5);

  final e = new Obb3()
      ..center.setValues(-3.0, 0.0, 0.0)
      ..halfExtents.setValues(0.5, 0.5, 0.5);

  final f = new Obb3()
      ..center.setValues(0.0, -3.0, 0.0)
      ..halfExtents.setValues(0.5, 0.5, 0.5);

  final g = new Obb3()
      ..center.setValues(0.0, 0.0, -3.0)
      ..halfExtents.setValues(0.5, 0.5, 0.5);

  final u = new Obb3()
      ..center.setValues(1.0, 1.0, 1.0)
      ..halfExtents.setValues(0.5, 0.5, 0.5);

  final v = new Obb3()
      ..center.setValues(10.0, 10.0, -10.0)
      ..halfExtents.setValues(2.0, 2.0, 2.0);

  final w = new Obb3()
      ..center.setValues(10.0, 0.0, 0.0)
      ..halfExtents.setValues(1.0, 1.0, 1.0);

  // a - b
  expect(a.intersectsWithObb3(b), isFalse);

  b.halfExtents.scale(2.0);

  expect(a.intersectsWithObb3(b), isTrue);

  b.rotate(new Matrix3.rotationZ(radians(45.0)));

  expect(a.intersectsWithObb3(b), isTrue);

  // a - c
  expect(a.intersectsWithObb3(c), isFalse);

  c.halfExtents.scale(2.0);

  expect(a.intersectsWithObb3(c), isTrue);

  c.rotate(new Matrix3.rotationZ(radians(45.0)));

  expect(a.intersectsWithObb3(c), isTrue);

  // a - d
  expect(a.intersectsWithObb3(d), isFalse);

  d.halfExtents.scale(2.0);

  expect(a.intersectsWithObb3(d), isTrue);

  d.rotate(new Matrix3.rotationZ(radians(45.0)));

  expect(a.intersectsWithObb3(d), isTrue);

  // a - e
  expect(a.intersectsWithObb3(e), isFalse);

  e.halfExtents.scale(2.0);

  expect(a.intersectsWithObb3(e), isTrue);

  e.rotate(new Matrix3.rotationZ(radians(45.0)));

  expect(a.intersectsWithObb3(e), isTrue);

  // a - f
  expect(a.intersectsWithObb3(f), isFalse);

  f.halfExtents.scale(2.0);

  expect(a.intersectsWithObb3(f), isTrue);

  f.rotate(new Matrix3.rotationZ(radians(45.0)));

  expect(a.intersectsWithObb3(f), isTrue);

  // a - g
  expect(a.intersectsWithObb3(g), isFalse);

  g.halfExtents.scale(2.0);

  expect(a.intersectsWithObb3(g), isTrue);

  g.rotate(new Matrix3.rotationZ(radians(45.0)));

  expect(a.intersectsWithObb3(g), isTrue);

  // u
  expect(a.intersectsWithObb3(u), isTrue);

  expect(b.intersectsWithObb3(u), isFalse);

  u.halfExtents.scale(10.0);

  expect(b.intersectsWithObb3(u), isTrue);

  // v
  expect(a.intersectsWithObb3(v), isFalse);

  expect(b.intersectsWithObb3(v), isFalse);

  // w
  expect(a.intersectsWithObb3(w), isFalse);

  w.rotate(new Matrix3.rotationZ(radians(22.0)));

  expect(a.intersectsWithObb3(w), isFalse);

  expect(b.intersectsWithObb3(w), isFalse);
}

void testIntersectionVector3() {
  //final Aabb3 parent = new Aabb3.minMax(_v(1.0,1.0,1.0), _v(8.0,8.0,8.0));
  final Obb3 parent = new Obb3()
      ..center.setValues(4.5, 4.5, 4.5)
      ..halfExtents.setValues(3.5, 3.5, 3.5);
  final Vector3 child = _v(7.0,7.0,7.0);
  final Vector3 cutting = _v(1.0,2.0,1.0);
  final Vector3 outside1 = _v(-10.0,10.0,10.0);
  final Vector3 outside2 = _v(4.5,4.5,9.0);

  expect(parent.intersectsWithVector3(child), isTrue);
  expect(parent.intersectsWithVector3(cutting), isTrue);
  expect(parent.intersectsWithVector3(outside1), isFalse);
  expect(parent.intersectsWithVector3(outside2), isFalse);

  final rotationX = new Matrix3.rotationX(radians(45.0));
  parent.rotate(rotationX);

  expect(parent.intersectsWithVector3(child), isFalse);
  expect(parent.intersectsWithVector3(cutting), isFalse);
  expect(parent.intersectsWithVector3(outside1), isFalse);
  expect(parent.intersectsWithVector3(outside2), isTrue);
}

void testIntersectionTriangle() {
  final Obb3 parent = new Obb3();
  parent.center.setValues(4.5, 4.5, 4.5);
  parent.halfExtents.setValues(3.5, 3.5, 3.5);
  final Triangle child = new Triangle.points(_v(2.0,2.0,2.0), _v(3.0,3.0,3.0), _v(4.0,4.0,4.0));
  final Triangle edge = new Triangle.points(_v(1.0,1.0,1.0), _v(3.0,3.0,3.0), _v(4.0,4.0,4.0));
  final Triangle cutting = new Triangle.points(_v(2.0,2.0,2.0), _v(3.0,3.0,3.0), _v(14.0,14.0,14.0));
  final Triangle outside = new Triangle.points(_v(0.0,0.0,0.0), _v(-3.0,-3.0,-3.0), _v(-4.0,-4.0,-4.0));
  final Triangle parallel0 = new Triangle.points(_v(1.0, 0.0, 1.0), _v(1.0, 10.0, 1.0), _v(1.0, 0.0, 10.0));
  final Triangle parallel1 = new Triangle.points(_v(1.0, 4.5, 0.0), _v(1.0, -1.0, 9.0), _v(1.0, 10.0, 9.0));
  final Triangle parallel2 = new Triangle.points(_v(1.0, 10.0, 9.0), _v(1.0, -1.0, 9.0), _v(1.0, 4.5, 0.0));

  expect(parent.intersectsWithTriangle(child), isTrue);
  expect(parent.intersectsWithTriangle(edge), isTrue);
  expect(parent.intersectsWithTriangle(cutting), isTrue);
  expect(parent.intersectsWithTriangle(outside), isFalse);
  expect(parent.intersectsWithTriangle(parallel0), isTrue);
  expect(parent.intersectsWithTriangle(parallel1), isTrue);
  expect(parent.intersectsWithTriangle(parallel2), isTrue);

  final rotationX = new Matrix3.rotationX(radians(0.01));
  parent.rotate(rotationX);

  expect(parent.intersectsWithTriangle(child), isTrue);
  expect(parent.intersectsWithTriangle(edge), isTrue);
  expect(parent.intersectsWithTriangle(cutting), isTrue);
  expect(parent.intersectsWithTriangle(outside), isFalse);
  expect(parent.intersectsWithTriangle(parallel0), isTrue);
  expect(parent.intersectsWithTriangle(parallel1), isTrue);
  expect(parent.intersectsWithTriangle(parallel2), isTrue);

  final rotationY = new Matrix3.rotationY(radians(45.0));
  parent.rotate(rotationY);

  expect(parent.intersectsWithTriangle(child), isTrue);
  expect(parent.intersectsWithTriangle(edge), isTrue);
  expect(parent.intersectsWithTriangle(cutting), isTrue);
  expect(parent.intersectsWithTriangle(outside), isFalse);
  expect(parent.intersectsWithTriangle(parallel0), isTrue);
  expect(parent.intersectsWithTriangle(parallel1), isTrue);
  expect(parent.intersectsWithTriangle(parallel2), isTrue);

  final rotationZ = new Matrix3.rotationZ(radians(45.0));
  parent.rotate(rotationZ);

  expect(parent.intersectsWithTriangle(child), isTrue);
  expect(parent.intersectsWithTriangle(edge), isTrue);
  expect(parent.intersectsWithTriangle(cutting), isTrue);
  expect(parent.intersectsWithTriangle(outside), isFalse);
  expect(parent.intersectsWithTriangle(parallel0), isTrue);
  expect(parent.intersectsWithTriangle(parallel1), isTrue);
  expect(parent.intersectsWithTriangle(parallel2), isTrue);

  final Obb3 obb = new Obb3.centerExtentsAxes(_v(21.0,-36.400001525878906,2.799999952316284), _v(0.25,0.15000000596046448,0.25), _v(0.0,1.0,0.0), _v(-1.0,0.0,0.0), _v(0.0,0.0,1.0));
  final Triangle triangle = new Triangle.points(_v(20.5,-36.5,3.5), _v(21.5,-36.5,2.5), _v(20.5,-36.5,2.5));

  expect(obb.intersectsWithTriangle(triangle), isTrue);

  final Obb3 obb2 = new Obb3.centerExtentsAxes(_v(25.15829086303711,-36.27009201049805,3.0299079418182373), _v(0.25,0.15000000596046448,0.25), _v(-0.7071067690849304,0.7071067690849304,0.0), _v(-0.7071067690849304,-0.7071067690849304,0.0), _v(0.0,0.0,1.0));
  final Triangle triangle2 = new Triangle.points(_v(25.5,-36.5,2.5), _v(25.5,-35.5,3.5), _v(24.5,-36.5,2.5));
  final Triangle triangle2_1 = new Triangle.points(_v(24.5,-36.5,2.5), _v(25.5,-35.5,3.5), _v(25.5,-36.5,2.5)); // reverse normal direction

  expect(obb2.intersectsWithTriangle(triangle2), isTrue);
  expect(obb2.intersectsWithTriangle(triangle2_1), isTrue);

  final Obb3 obb3 = new Obb3.centerExtentsAxes(_v(20.937196731567383,-37.599998474121094,2.799999952316284), _v(0.25,0.15000000596046448,0.25), _v(0.0,-1.0,0.0), _v(1.0,0.0,0.0), _v(0.0,0.0,1.0));
  final Triangle triangle3 = new Triangle.points(_v(20.5,-37.5,3.5), _v(20.5,-37.5,2.5), _v(21.5,-37.5,2.5));
  final Triangle triangle3_1 = new Triangle.points(_v(21.5,-37.5,2.5), _v(20.5,-37.5,2.5), _v(20.5,-37.5,3.5)); // reverse normal direction

  expect(obb3.intersectsWithTriangle(triangle3), isTrue);
  expect(obb3.intersectsWithTriangle(triangle3_1), isTrue);

  final Obb3 obb4 = new Obb3.centerExtentsAxes(_v(19.242143630981445,-39.20925521850586,2.549999952316284), _v(0.25,0.15000000596046448,0.25), _v(0.0,1.0,0.0), _v(-1.0,0.0,0.0), _v(0.0,0.0,1.0));
  final Triangle triangle4 = new Triangle.points(_v(18.5,-39.5,2.5), _v(19.5,-39.5,2.5), _v(19.5,-38.5,2.5));
  final Triangle triangle4_1 = new Triangle.points(_v(19.5,-38.5,2.5), _v(19.5,-39.5,2.5), _v(18.5,-39.5,2.5)); // reverse normal direction
  final Triangle triangle4_2 = new Triangle.points(_v(18.5,-39.5,2.5), _v(19.5,-38.5,2.5), _v(18.5,-38.5,2.5));
  final Triangle triangle4_3 = new Triangle.points(_v(18.5,-38.5,2.5), _v(19.5,-38.5,2.5), _v(18.5,-39.5,2.5)); // reverse normal direction

  expect(obb4.intersectsWithTriangle(triangle4), isTrue);
  expect(obb4.intersectsWithTriangle(triangle4_1), isTrue);
  expect(obb4.intersectsWithTriangle(triangle4_2), isFalse);
  expect(obb4.intersectsWithTriangle(triangle4_3), isFalse);
}

Vector3 _v(double x, double y, double z) {
  return new Vector3(x,y,z);
}

void main() {
  group('Obb3', () {
    test('Corners', testCorners);
    test('Translate', testTranslate);
    test('Rotate', testRotate);
    test('Transforn', testTransform);
    test('Closest Point To', testClosestPointTo);
    test('Intersection Obb3', testIntersectionObb3);
    test('Intersection Triangle', testIntersectionTriangle);
    test('Intersection Vector3', testIntersectionVector3);
  });
}
