library test_vector2;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';
import '../test_helpers.dart';

void testAdd() {
  final Vector2 a = new Vector2(5.0, 7.0);
  final Vector2 b = new Vector2(3.0, 8.0);

  a.add(b);
  expect(a.x, equals(8.0));
  expect(a.y, equals(15.0));

  b.addScaled(a, 0.5);
  expect(b.x, equals(7.0));
  expect(b.y, equals(15.5));
}

void testLength() {
  final Vector2 a = new Vector2(5.0, 7.0);

  expect(a.length, relativeEquals(8.6));
  expect(a.length2, relativeEquals(74.0));

  expect(a.normalize(), relativeEquals(8.6));
  expect(a.x, relativeEquals(0.5812));
  expect(a.y, relativeEquals(0.8137));
}

void testMinMax() {
  final Vector2 a = new Vector2(5.0, 7.0);
  final Vector2 b = new Vector2(3.0, 8.0);

  Vector2 result = new Vector2.zero();

  Vector2.min(a, b, result);
  expect(result.x, equals(3.0));
  expect(result.y, equals(7.0));

  Vector2.max(a, b, result);
  expect(result.x, equals(5.0));
  expect(result.y, equals(8.0));
}

void testMix() {
  final Vector2 a = new Vector2(5.0, 7.0);
  final Vector2 b = new Vector2(3.0, 8.0);

  Vector2 result = new Vector2.zero();

  Vector2.mix(a, b, 0.5, result);
  expect(result.x, equals(4.0));
  expect(result.y, equals(7.5));

  Vector2.mix(a, b, 0.0, result);
  expect(result.x, equals(5.0));
  expect(result.y, equals(7.0));

  Vector2.mix(a, b, 1.0, result);
  expect(result.x, equals(3.0));
  expect(result.y, equals(8.0));
}

void testDotProduct() {
  final Vector2 inputA = new Vector2(0.417267069084370, 0.049654430325742);
  final Vector2 inputB = new Vector2(0.944787189721646, 0.490864092468080);
  final double expectedOutput = 0.418602158442475;
  expect(dot2(inputA, inputB), relativeEquals(expectedOutput));
  expect(dot2(inputB, inputA), relativeEquals(expectedOutput));
}

void testPostmultiplication() {
  Matrix2 inputMatrix = new Matrix2.rotation(.2);
  Vector2 inputVector = new Vector2(1.0, 0.0);
  Matrix2 inputInv = new Matrix2.copy(inputMatrix);
  inputInv.invert();
  print("input $inputMatrix");
  print("input $inputInv");
  Vector2 resultOld = inputMatrix.transposed() * inputVector;
  Vector2 resultOldvInv = inputInv * inputVector;
  Vector2 resultNew = inputVector..postmultiply(inputMatrix);
  expect(resultNew.x, equals(resultOld.x));
  expect(resultNew.y, equals(resultOld.y));
  //matrix inversion can introduce a small error
  assert((resultNew-resultOldvInv).length < .00001);
}

void testCrossProduct() {
  final Vector2 inputA = new Vector2(0.417267069084370, 0.049654430325742);
  final Vector2 inputB = new Vector2(0.944787189721646, 0.490864092468080);
  double expectedOutputCross = inputA.x * inputB.y - inputA.y * inputB.x;
  var result;
  result = cross2(inputA, inputB);
  expect(result, relativeEquals(expectedOutputCross));
  result = new Vector2.zero();
  cross2A(1.0, inputA, result);
  expect(result, relativeEquals(new Vector2(-inputA.y, inputA.x)));
  cross2B(inputA, 1.0, result);
  expect(result, relativeEquals(new Vector2(inputA.y, -inputA.x)));
  cross2B(inputA, 1.0, result);
  expect(result, relativeEquals(new Vector2(inputA.y, -inputA.x)));
}

void testOrthogonalScale() {
  final Vector2 input = new Vector2(0.5, 0.75);
  final Vector2 output = new Vector2.zero();

  input.scaleOrthogonalInto(2.0, output);
  expect(output.x, equals(-1.5));
  expect(output.y, equals(1.0));

  input.scaleOrthogonalInto(-2.0, output);
  expect(output.x, equals(1.5));
  expect(output.y, equals(-1.0));

  expect(0.0, equals(input.dot(output)));
}

void testConstructor() {
  var v1 = new Vector2(2.0, 4.0);
  expect(v1.x, equals(2.0));
  expect(v1.y, equals(4.0));

  var v2 = new Vector2.all(2.0);
  expect(v2.x, equals(2.0));
  expect(v2.y, equals(2.0));
}

void testNegate() {
  var vec1 = new Vector2(1.0, 2.0);
  vec1.negate();
  expect(vec1.x, equals(-1.0));
  expect(vec1.y, equals(-2.0));
}

void testReflect() {
  var v = new Vector2(0.0, 5.0);
  v.reflect(new Vector2(0.0, -1.0));
  expect(v.x, equals(0.0));
  expect(v.y, equals(-5.0));

  v = new Vector2(0.0, -5.0);
  v.reflect(new Vector2(0.0, 1.0));
  expect(v.x, equals(0.0));
  expect(v.y, equals(5.0));

  v = new Vector2(3.0, 0.0);
  v.reflect(new Vector2(-1.0, 0.0));
  expect(v.x, equals(-3.0));
  expect(v.y, equals(0.0));

  v = new Vector2(-3.0, 0.0);
  v.reflect(new Vector2(1.0, 0.0));
  expect(v.x, equals(3.0));
  expect(v.y, equals(0.0));

  v = new Vector2(4.0, 4.0);
  v.reflect(new Vector2(-1.0, -1.0).normalized());
  expect(v.x, relativeEquals(-4.0));
  expect(v.y, relativeEquals(-4.0));

  v = new Vector2(-4.0, -4.0);
  v.reflect(new Vector2(1.0, 1.0).normalized());
  expect(v.x, relativeEquals(4.0));
  expect(v.y, relativeEquals(4.0));
}

void testDistanceTo() {
  var a = new Vector2(1.0, 1.0);
  var b = new Vector2(3.0, 1.0);
  var c = new Vector2(1.0, -1.0);

  expect(a.distanceTo(b), equals(2.0));
  expect(a.distanceTo(c), equals(2.0));
}

void testDistanceToSquared() {
  var a = new Vector2(1.0, 1.0);
  var b = new Vector2(3.0, 1.0);
  var c = new Vector2(1.0, -1.0);

  expect(a.distanceToSquared(b), equals(4.0));
  expect(a.distanceToSquared(c), equals(4.0));
}

void main() {
  group('Vector2', () {
    test('dot product', testDotProduct);
    test('postmultiplication', testPostmultiplication);
    test('cross product', testCrossProduct);
    test('orhtogonal scale', testOrthogonalScale);
    test('reflect', testReflect);
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
