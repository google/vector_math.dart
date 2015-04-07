// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.vector3_test;

import 'dart:typed_data';
import 'dart:math' as Math;

import 'package:unittest/unittest.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testVector3InstacinfFromFloat32List() {
  final Float32List float32List = new Float32List.fromList([1.0, 2.0, 3.0]);
  final Vector3 input = new Vector3.fromFloat32List(float32List);

  expect(input.x, equals(1.0));
  expect(input.y, equals(2.0));
  expect(input.z, equals(3.0));
}

void testVector3InstacingFromByteBuffer() {
  final Float32List float32List =
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0]);
  final ByteBuffer buffer = float32List.buffer;
  final Vector3 zeroOffset = new Vector3.fromBuffer(buffer, 0);
  final Vector3 offsetVector =
      new Vector3.fromBuffer(buffer, Float32List.BYTES_PER_ELEMENT);

  expect(zeroOffset.x, equals(1.0));
  expect(zeroOffset.y, equals(2.0));
  expect(zeroOffset.z, equals(3.0));

  expect(offsetVector.x, equals(2.0));
  expect(offsetVector.y, equals(3.0));
  expect(offsetVector.z, equals(4.0));
}

void testVector3Add() {
  final Vector3 a = new Vector3(5.0, 7.0, 3.0);
  final Vector3 b = new Vector3(3.0, 8.0, 2.0);

  a.add(b);
  expect(a.x, equals(8.0));
  expect(a.y, equals(15.0));
  expect(a.z, equals(5.0));

  b.addScaled(a, 0.5);
  expect(b.x, equals(7.0));
  expect(b.y, equals(15.5));
  expect(b.z, equals(4.5));
}

void testVector3MinMax() {
  final Vector3 a = new Vector3(5.0, 7.0, -3.0);
  final Vector3 b = new Vector3(3.0, 8.0, 2.0);

  Vector3 result = new Vector3.zero();

  Vector3.min(a, b, result);
  expect(result.x, equals(3.0));
  expect(result.y, equals(7.0));
  expect(result.z, equals(-3.0));

  Vector3.max(a, b, result);
  expect(result.x, equals(5.0));
  expect(result.y, equals(8.0));
  expect(result.z, equals(2.0));
}

void testVector3Mix() {
  final Vector3 a = new Vector3(5.0, 7.0, 3.0);
  final Vector3 b = new Vector3(3.0, 8.0, 2.0);

  Vector3 result = new Vector3.zero();

  Vector3.mix(a, b, 0.5, result);
  expect(result.x, equals(4.0));
  expect(result.y, equals(7.5));
  expect(result.z, equals(2.5));

  Vector3.mix(a, b, 0.0, result);
  expect(result.x, equals(5.0));
  expect(result.y, equals(7.0));
  expect(result.z, equals(3.0));

  Vector3.mix(a, b, 1.0, result);
  expect(result.x, equals(3.0));
  expect(result.y, equals(8.0));
  expect(result.z, equals(2.0));
}

void testVector3DotProduct() {
  List<Vector3> inputA = new List<Vector3>();
  List<Vector3> inputB = new List<Vector3>();
  List<double> expectedOutput = new List<double>();
  inputA.add(parseVector('''0.417267069084370
   0.049654430325742
   0.902716109915281'''));
  inputB.add(parseVector('''0.944787189721646
   0.490864092468080
   0.489252638400019'''));
  expectedOutput.add(0.860258396944727);
  assert(inputA.length == inputB.length);
  assert(inputB.length == expectedOutput.length);
  for (int i = 0; i < inputA.length; i++) {
    double output1 = dot3(inputA[i], inputB[i]);
    double output2 = dot3(inputB[i], inputA[i]);
    relativeTest(output1, expectedOutput[i]);
    relativeTest(output2, expectedOutput[i]);
  }
}

void testVector3Postmultiplication() {
  Matrix3 inputMatrix =
      (new Matrix3.rotationX(.4)) * (new Matrix3.rotationZ(.5));
  Vector3 inputVector = new Vector3(1.0, 2.0, 3.0);
  Matrix3 inputInv = new Matrix3.copy(inputMatrix);
  inputInv.invert();
  Vector3 resultOld = inputMatrix.transposed() * inputVector;
  Vector3 resultOldvInv = inputInv * inputVector;
  Vector3 resultNew = inputVector.postmultiply(inputMatrix);

  expect(resultNew.x, equals(resultOld.x));
  expect(resultNew.y, equals(resultOld.y));
  expect(resultNew.z, equals(resultOld.z));
  expect(resultNew.x, equals(resultOldvInv.x));
  expect(resultNew.y, equals(resultOldvInv.y));
  expect(resultNew.z, equals(resultOldvInv.z));
}

void testVector3CrossProduct() {
  List<Vector3> inputA = new List<Vector3>();
  List<Vector3> inputB = new List<Vector3>();
  List<Vector3> expectedOutput = new List<Vector3>();

  inputA.add(parseVector('''0.417267069084370
   0.049654430325742
   0.902716109915281'''));
  inputB.add(parseVector('''0.944787189721646
   0.490864092468080
   0.489252638400019'''));
  expectedOutput.add(parseVector('''  -0.418817363004761
   0.648725602136344
   0.157908551498227'''));

  inputA.add(parseVector('''0.944787189721646
      0.490864092468080
      0.489252638400019'''));
  inputB.add(parseVector('''0.417267069084370
      0.049654430325742
      0.902716109915281'''));
  expectedOutput.add(parseVector(''' 0.418817363004761
  -0.648725602136344
  -0.157908551498227'''));

  assert(inputA.length == inputB.length);
  assert(inputB.length == expectedOutput.length);

  for (int i = 0; i < inputA.length; i++) {
    Vector3 output = new Vector3.zero();
    cross3(inputA[i], inputB[i], output);
    relativeTest(output, expectedOutput[i]);
  }

  {
    Vector3 x = new Vector3(1.0, 0.0, 0.0);
    Vector3 y = new Vector3(0.0, 1.0, 0.0);
    Vector3 z = new Vector3(0.0, 0.0, 1.0);
    Vector3 output;

    output = x.cross(y);
    relativeTest(output, new Vector3(0.0, 0.0, 1.0));
    output = y.cross(x);
    relativeTest(output, new Vector3(0.0, 0.0, -1.0));

    output = x.cross(z);
    relativeTest(output, new Vector3(0.0, -1.0, 0.0));
    output = z.cross(x);
    relativeTest(output, new Vector3(0.0, 1.0, 0.0));

    output = y.cross(z);
    relativeTest(output, new Vector3(1.0, 0.0, 0.0));
    output = z.cross(y);
    relativeTest(output, new Vector3(-1.0, 0.0, 0.0));
  }
}

void testVector3Constructor() {
  var v1 = new Vector3(2.0, 4.0, -1.5);
  expect(v1.x, equals(2.0));
  expect(v1.y, equals(4.0));
  expect(v1.z, equals(-1.5));

  var v2 = new Vector3.all(2.0);
  expect(v2.x, equals(2.0));
  expect(v2.y, equals(2.0));
  expect(v2.z, equals(2.0));
}

void testVector3Length() {
  final Vector3 a = new Vector3(5.0, 7.0, 3.0);

  relativeTest(a.length, 9.1104);
  relativeTest(a.length2, 83.0);

  relativeTest(a.normalizeLength(), 9.1104);
  relativeTest(a.x, 0.5488);
  relativeTest(a.y, 0.7683);
  relativeTest(a.z, 0.3292);
}

void testVector3Negate() {
  var vec3 = new Vector4(1.0, 2.0, 3.0, 4.0);
  vec3.negate();
  expect(vec3.x, equals(-1.0));
  expect(vec3.y, equals(-2.0));
  expect(vec3.z, equals(-3.0));
  expect(vec3.w, equals(-4.0));
}

void testVector3Reflect() {
  var v = new Vector3(5.0, 0.0, 0.0);
  v.reflect(new Vector3(-1.0, 0.0, 0.0));
  expect(v.x, equals(-5.0));
  expect(v.y, equals(0.0));
  expect(v.y, equals(0.0));

  v = new Vector3(0.0, 5.0, 0.0);
  v.reflect(new Vector3(0.0, -1.0, 0.0));
  expect(v.x, equals(0.0));
  expect(v.y, equals(-5.0));
  expect(v.z, equals(0.0));

  v = new Vector3(0.0, 0.0, 5.0);
  v.reflect(new Vector3(0.0, 0.0, -1.0));
  expect(v.x, equals(0.0));
  expect(v.y, equals(0.0));
  expect(v.z, equals(-5.0));

  v = new Vector3(-5.0, 0.0, 0.0);
  v.reflect(new Vector3(1.0, 0.0, 0.0));
  expect(v.x, equals(5.0));
  expect(v.y, equals(0.0));
  expect(v.y, equals(0.0));

  v = new Vector3(0.0, -5.0, 0.0);
  v.reflect(new Vector3(0.0, 1.0, 0.0));
  expect(v.x, equals(0.0));
  expect(v.y, equals(5.0));
  expect(v.z, equals(0.0));

  v = new Vector3(0.0, 0.0, -5.0);
  v.reflect(new Vector3(0.0, 0.0, 1.0));
  expect(v.x, equals(0.0));
  expect(v.y, equals(0.0));
  expect(v.z, equals(5.0));

  v = new Vector3(4.0, 4.0, 4.0);
  v.reflect(new Vector3(-1.0, -1.0, -1.0).normalized());
  relativeTest(v.x, -4.0);
  relativeTest(v.y, -4.0);
  relativeTest(v.z, -4.0);

  v = new Vector3(-4.0, -4.0, -4.0);
  v.reflect(new Vector3(1.0, 1.0, 1.0).normalized());
  relativeTest(v.x, 4.0);
  relativeTest(v.y, 4.0);
  relativeTest(v.z, 4.0);

  v = new Vector3(10.0, 20.0, 2.0);
  v.reflect(new Vector3(-10.0, -20.0, -2.0).normalized());
  relativeTest(v.x, -10.0);
  relativeTest(v.y, -20.0);
  relativeTest(v.z, -2.0);
}

void testVector3Projection() {
  var v = new Vector3(1.0, 1.0, 1.0);
  var a = 2.0 / 3.0;
  var b = 1.0 / 3.0;
  var m = new Matrix4(
      a, b, -b, 0.0, b, a, b, 0.0, -b, b, a, 0.0, 0.0, 0.0, 0.0, 1.0);

  v.applyProjection(m);
  relativeTest(v.x, a);
  relativeTest(v.y, 4.0 / 3.0);
  relativeTest(v.z, a);
}

void testVector3DistanceTo() {
  var a = new Vector3(1.0, 1.0, 1.0);
  var b = new Vector3(1.0, 3.0, 1.0);
  var c = new Vector3(1.0, 1.0, -1.0);

  expect(a.distanceTo(b), equals(2.0));
  expect(a.distanceTo(c), equals(2.0));
}

void testVector3DistanceToSquared() {
  var a = new Vector3(1.0, 1.0, 1.0);
  var b = new Vector3(1.0, 3.0, 1.0);
  var c = new Vector3(1.0, 1.0, -1.0);

  expect(a.distanceToSquared(b), equals(4.0));
  expect(a.distanceToSquared(c), equals(4.0));
}

void testVector3AngleTo() {
  final v0 = new Vector3(1.0, 0.0, 0.0);
  final v1 = new Vector3(0.0, 1.0, 0.0);

  expect(v0.angleTo(v0), equals(0.0));
  expect(v0.angleTo(v1), equals(Math.PI / 2.0));
}

void testVector3AngleToSigned() {
  final v0 = new Vector3(1.0, 0.0, 0.0);
  final v1 = new Vector3(0.0, 1.0, 0.0);
  final n = new Vector3(0.0, 0.0, 1.0);

  expect(v0.angleToSigned(v0, n), equals(0.0));
  expect(v0.angleToSigned(v1, n), equals(Math.PI / 2.0));
  expect(v1.angleToSigned(v0, n), equals(-Math.PI / 2.0));
}

void main() {
  group('Vector3', () {
    test('dot product', testVector3DotProduct);
    test('postmultiplication', testVector3Postmultiplication);
    test('cross product', testVector3CrossProduct);
    test('reflect', testVector3Reflect);
    test('projection', testVector3Projection);
    test('length', testVector3Length);
    test('Negate', testVector3Negate);
    test('Constructor', testVector3Constructor);
    test('add', testVector3Add);
    test('min/max', testVector3MinMax);
    test('mix', testVector3Mix);
    test('distanceTo', testVector3DistanceTo);
    test('distanceToSquared', testVector3DistanceToSquared);
    test('angleTo', testVector3AngleTo);
    test('angleToSinged', testVector3AngleToSigned);
    test('instancing from Float32List', testVector3InstacinfFromFloat32List);
    test('instancing from ByteBuffer', testVector3InstacingFromByteBuffer);
  });
}
