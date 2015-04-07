// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.vector2_test;

import 'package:unittest/unittest.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testVector2Add() {
  final Vector2 a = new Vector2(5.0, 7.0);
  final Vector2 b = new Vector2(3.0, 8.0);

  a.add(b);
  expect(a.x, equals(8.0));
  expect(a.y, equals(15.0));

  b.addScaled(a, 0.5);
  expect(b.x, equals(7.0));
  expect(b.y, equals(15.5));
}

void testVector2MinMax() {
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

void testVector2Mix() {
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

void testVector2DotProduct() {
  final Vector2 inputA = new Vector2(0.417267069084370, 0.049654430325742);
  final Vector2 inputB = new Vector2(0.944787189721646, 0.490864092468080);
  final double expectedOutput = 0.418602158442475;
  relativeTest(dot2(inputA, inputB), expectedOutput);
  relativeTest(dot2(inputB, inputA), expectedOutput);
}

void testVector2Postmultiplication() {
  Matrix2 inputMatrix = new Matrix2.rotation(.2);
  Vector2 inputVector = new Vector2(1.0, 0.0);
  Matrix2 inputInv = new Matrix2.copy(inputMatrix);
  inputInv.invert();
  // print("input $inputMatrix");
  // print("input $inputInv");
  Vector2 resultOld = inputMatrix.transposed() * inputVector;
  Vector2 resultOldvInv = inputInv * inputVector;
  Vector2 resultNew = inputVector.postmultiply(inputMatrix);
  expect(resultNew.x, equals(resultOld.x));
  expect(resultNew.y, equals(resultOld.y));
  //matrix inversion can introduce a small error
  assert((resultNew - resultOldvInv).length < .00001);
}

void testVector2CrossProduct() {
  final Vector2 inputA = new Vector2(0.417267069084370, 0.049654430325742);
  final Vector2 inputB = new Vector2(0.944787189721646, 0.490864092468080);
  double expectedOutputCross = inputA.x * inputB.y - inputA.y * inputB.x;
  var result;
  result = cross2(inputA, inputB);
  relativeTest(result, expectedOutputCross);
  result = new Vector2.zero();
  cross2A(1.0, inputA, result);
  relativeTest(result, new Vector2(-inputA.y, inputA.x));
  cross2B(inputA, 1.0, result);
  relativeTest(result, new Vector2(inputA.y, -inputA.x));
  cross2B(inputA, 1.0, result);
  relativeTest(result, new Vector2(inputA.y, -inputA.x));
}

void testVector2OrthogonalScale() {
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

void testVector2Constructor() {
  var v1 = new Vector2(2.0, 4.0);
  expect(v1.x, equals(2.0));
  expect(v1.y, equals(4.0));

  var v2 = new Vector2.all(2.0);
  expect(v2.x, equals(2.0));
  expect(v2.y, equals(2.0));
}

void testVector2Length() {
  final Vector2 a = new Vector2(5.0, 7.0);

  relativeTest(a.length, 8.6);
  relativeTest(a.length2, 74.0);

  relativeTest(a.normalizeLength(), 8.6);
  relativeTest(a.x, 0.5812);
  relativeTest(a.y, 0.8137);
}

void testVector2Negate() {
  var vec1 = new Vector2(1.0, 2.0);
  vec1.negate();
  expect(vec1.x, equals(-1.0));
  expect(vec1.y, equals(-2.0));
}

void testVector2Reflect() {
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
  relativeTest(v.x, -4.0);
  relativeTest(v.y, -4.0);

  v = new Vector2(-4.0, -4.0);
  v.reflect(new Vector2(1.0, 1.0).normalized());
  relativeTest(v.x, 4.0);
  relativeTest(v.y, 4.0);
}

void testVector2DistanceTo() {
  var a = new Vector2(1.0, 1.0);
  var b = new Vector2(3.0, 1.0);
  var c = new Vector2(1.0, -1.0);

  expect(a.distanceTo(b), equals(2.0));
  expect(a.distanceTo(c), equals(2.0));
}

void testVector2DistanceToSquared() {
  var a = new Vector2(1.0, 1.0);
  var b = new Vector2(3.0, 1.0);
  var c = new Vector2(1.0, -1.0);

  expect(a.distanceToSquared(b), equals(4.0));
  expect(a.distanceToSquared(c), equals(4.0));
}

void main() {
  group('Vector2', () {
    test('dot product', testVector2DotProduct);
    test('postmultiplication', testVector2Postmultiplication);
    test('cross product', testVector2CrossProduct);
    test('orhtogonal scale', testVector2OrthogonalScale);
    test('reflect', testVector2Reflect);
    test('length', testVector2Length);
    test('Negate', testVector2Negate);
    test('Constructor', testVector2Constructor);
    test('add', testVector2Add);
    test('min/max', testVector2MinMax);
    test('mix', testVector2Mix);
    test('distanceTo', testVector2DistanceTo);
    test('distanceToSquared', testVector2DistanceToSquared);
  });
}
