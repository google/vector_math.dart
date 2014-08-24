library test_obb3;

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

void main() {
  group('Obb3', () {
    test('Corners', testCorners);
    test('Translate', testTranslate);
    test('Rotate', testRotate);
    test('Transforn', testTransform);
    test('Intersection Obb3', testIntersectionObb3);
  });
}
