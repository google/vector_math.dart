library test_vector4;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';
import '../test_helpers.dart';

void testAdd() {
  final Vector4 a = new Vector4(5.0, 7.0, 3.0, 10.0);
  final Vector4 b = new Vector4(3.0, 8.0, 2.0, 2.0);

  a.add(b);
  expect(a.x, equals(8.0));
  expect(a.y, equals(15.0));
  expect(a.z, equals(5.0));
  expect(a.w, equals(12.0));

  b.addScaled(a, 0.5);
  expect(b.x, equals(7.0));
  expect(b.y, equals(15.5));
  expect(b.z, equals(4.5));
  expect(b.w, equals(8.0));
}

void testLength() {
  final Vector4 a = new Vector4(5.0, 7.0, 3.0, 10.0);

  expect(a.length, relativeEquals(13.5277));
  expect(a.length2, relativeEquals(183.0));

  expect(a.normalize(), relativeEquals(13.5277));
  expect(a.x, relativeEquals(0.3696));
  expect(a.y, relativeEquals(0.5174));
  expect(a.z, relativeEquals(0.2217));
  expect(a.w, relativeEquals(0.7392));
}

void testMinMax() {
  final Vector4 a = new Vector4(5.0, 7.0, -3.0, 10.0);
  final Vector4 b = new Vector4(3.0, 8.0, 2.0, 2.0);

  Vector4 result = new Vector4.zero();

  Vector4.min(a, b, result);
  expect(result.x, equals(3.0));
  expect(result.y, equals(7.0));
  expect(result.z, equals(-3.0));
  expect(result.w, equals(2.0));

  Vector4.max(a, b, result);
  expect(result.x, equals(5.0));
  expect(result.y, equals(8.0));
  expect(result.z, equals(2.0));
  expect(result.w, equals(10.0));
}

void testMix() {
  final Vector4 a = new Vector4(5.0, 7.0, 3.0, 10.0);
  final Vector4 b = new Vector4(3.0, 8.0, 2.0, 2.0);

  Vector4 result = new Vector4.zero();

  Vector4.mix(a, b, 0.5, result);
  expect(result.x, equals(4.0));
  expect(result.y, equals(7.5));
  expect(result.z, equals(2.5));
  expect(result.w, equals(6.0));

  Vector4.mix(a, b, 0.0, result);
  expect(result.x, equals(5.0));
  expect(result.y, equals(7.0));
  expect(result.z, equals(3.0));
  expect(result.w, equals(10.0));

  Vector4.mix(a, b, 1.0, result);
  expect(result.x, equals(3.0));
  expect(result.y, equals(8.0));
  expect(result.z, equals(2.0));
  expect(result.w, equals(2.0));
}

void testConstructor() {
  var v1 = new Vector4(2.0, 4.0, -1.5, 10.0);
  expect(v1.x, equals(2.0));
  expect(v1.y, equals(4.0));
  expect(v1.z, equals(-1.5));
  expect(v1.w, equals(10.0));

  var v2 = new Vector4.all(2.0);
  expect(v2.x, equals(2.0));
  expect(v2.y, equals(2.0));
  expect(v2.z, equals(2.0));
  expect(v2.w, equals(2.0));
}

void testNegate() {
  var vec3 = new Vector4(1.0, 2.0, 3.0, 4.0);
  vec3.negate();
  expect(vec3.x, equals(-1.0));
  expect(vec3.y, equals(-2.0));
  expect(vec3.z, equals(-3.0));
  expect(vec3.w, equals(-4.0));
}

void testDistanceTo() {
  var a = new Vector4(1.0, 1.0, 1.0, 0.0);
  var b = new Vector4(1.0, 3.0, 1.0, 0.0);
  var c = new Vector4(1.0, 1.0, -1.0, 0.0);

  expect(a.distanceTo(b), equals(2.0));
  expect(a.distanceTo(c), equals(2.0));
}

void testDistanceToSquared() {
  var a = new Vector4(1.0, 1.0, 1.0, 0.0);
  var b = new Vector4(1.0, 3.0, 1.0, 0.0);
  var c = new Vector4(1.0, 1.0, -1.0, 0.0);

  expect(a.distanceToSquared(b), equals(4.0));
  expect(a.distanceToSquared(c), equals(4.0));
}

void main() {
  group('Vector4', () {
    test('Negate', testNegate);
    test('Constructor', testConstructor);
    test('add', testAdd);
    test('length', testLength);
    test('min/max', testMinMax);
    test('mix', testMix);
    test('distanceTo', testDistanceTo);
    test('distanceToSquared', testDistanceToSquared);
  });
}
