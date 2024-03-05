// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_64.dart' as v64;

import 'test_utils.dart';

void testQuaternionInstacinfFromFloat32List() {
  final float32List = Float32List.fromList([1.0, 2.0, 3.0, 4.0]);
  final input = Quaternion.fromFloat32List(float32List);

  expect(input.x, equals(1.0));
  expect(input.y, equals(2.0));
  expect(input.z, equals(3.0));
  expect(input.w, equals(4.0));
}

void testQuaternionInstacingFromByteBuffer() {
  final float32List = Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final buffer = float32List.buffer;
  final zeroOffset = Quaternion.fromBuffer(buffer, 0);
  final offsetVector =
      Quaternion.fromBuffer(buffer, Float32List.bytesPerElement);

  expect(zeroOffset.x, equals(1.0));
  expect(zeroOffset.y, equals(2.0));
  expect(zeroOffset.z, equals(3.0));
  expect(zeroOffset.w, equals(4.0));

  expect(offsetVector.x, equals(2.0));
  expect(offsetVector.y, equals(3.0));
  expect(offsetVector.z, equals(4.0));
  expect(offsetVector.w, equals(5.0));
}

void testNegate(List<Quaternion> input, List<Quaternion> expectedOutput) {
  assert(input.length == expectedOutput.length);
  for (var i = 0; i < input.length; i++) {
    final output1 = -input[i];
    final output2 = input[i]..negate();
    relativeTest(output1, expectedOutput[i]);
    relativeTest(output2, expectedOutput[i]);
  }
}

void testConjugate(List<Quaternion> input, List<Quaternion> expectedOutput) {
  assert(input.length == expectedOutput.length);
  for (var i = 0; i < input.length; i++) {
    final output = input[i]..conjugate();
    relativeTest(output, expectedOutput[i]);
  }
}

void testQuaternionMatrixRoundTrip(List<Quaternion> input) {
  for (var i = 0; i < input.length; i++) {
    final R = input[i].asRotationMatrix();
    final output = Quaternion.fromRotation(R);
    relativeTest(output, input[i]);
  }
}

void testQuaternionMultiply(List<Quaternion> inputA, List<Quaternion> inputB,
    List<Quaternion> expectedOutput) {
  for (var i = 0; i < inputA.length; i++) {
    final output = inputA[i] * inputB[i];
    relativeTest(output, expectedOutput[i]);
  }
}

void testQuaternionVectorRotate(List<Quaternion> inputA, List<Vector3> inputB,
    List<Vector3> expectedOutput) {
  assert((inputA.length == inputB.length) &&
      (inputB.length == expectedOutput.length));
  for (var i = 0; i < inputA.length; i++) {
    final output = inputA[i].rotate(inputB[i]);
    relativeTest(output, expectedOutput[i]);
  }
}

void testQuaternionNegate() {
  final input = <Quaternion>[];
  input.add(Quaternion.identity());
  input.add(Quaternion(0.18260, 0.54770, 0.73030, 0.36510));
  input.add(Quaternion(0.9889, 0.0, 0.0, 0.14834));
  final expectedOutput = <Quaternion>[];
  expectedOutput.add(Quaternion(-0.0, -0.0, -0.0, -1.0));
  expectedOutput.add(Quaternion(-0.18260, -0.54770, -0.73030, -0.36510));
  expectedOutput.add(Quaternion(-0.9889, -0.0, -0.0, -0.1483));
  testNegate(input, expectedOutput);
}

void testQuaternionConjugate() {
  final input = <Quaternion>[];
  input.add(Quaternion.identity());
  input.add(Quaternion(0.18260, 0.54770, 0.73030, 0.36510));
  input.add(Quaternion(0.9889, 0.0, 0.0, 0.14834));
  final expectedOutput = <Quaternion>[];
  expectedOutput.add(Quaternion(-0.0, -0.0, -0.0, 1.0));
  expectedOutput.add(Quaternion(-0.18260, -0.54770, -0.73030, 0.36510));
  expectedOutput.add(Quaternion(-0.9889, -0.0, -0.0, 0.1483));
  testConjugate(input, expectedOutput);
}

void testQuaternionMatrixQuaternionRoundTrip() {
  final input = <Quaternion>[];
  input.add(Quaternion.identity()..normalize());
  input.add(Quaternion(0.18260, 0.54770, 0.73030, 0.36510)..normalize());
  input.add(Quaternion(0.9889, 0.0, 0.0, 0.14834)..normalize());
  input.add(Quaternion(0.388127, 0.803418, -0.433317, -0.126429)..normalize());
  input.add(Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
  input.add(Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
  input.add(Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
  testQuaternionMatrixRoundTrip(input);
}

void testQuaternionMultiplying() {
  final inputA = <Quaternion>[];
  inputA.add(Quaternion(0.18260, 0.54770, 0.73030, 0.36510));
  inputA.add(Quaternion(0.9889, 0.0, 0.0, 0.14834));
  final inputB = <Quaternion>[];
  inputB.add(Quaternion(0.9889, 0.0, 0.0, 0.14834));
  inputB.add(Quaternion(0.18260, 0.54770, 0.73030, 0.36510));
  final expectedOutput = <Quaternion>[];
  expectedOutput.add(Quaternion(0.388127, 0.803418, -0.433317, -0.126429));
  expectedOutput.add(Quaternion(0.388127, -0.64097, 0.649924, -0.126429));
  testQuaternionMultiply(inputA, inputB, expectedOutput);
}

void testQuaternionNormalize() {
  final inputA = <Quaternion>[];
  final inputB = <Vector3>[];
  final expectedOutput = <Vector3>[];

  inputA.add(Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
  inputB.add(Vector3(1.0, 1.0, 1.0));
  expectedOutput.add(Vector3(-1.0, 1.0, 1.0));

  inputA.add(Quaternion.identity()..normalize());
  inputB.add(Vector3(1.0, 2.0, 3.0));
  expectedOutput.add(Vector3(1.0, 2.0, 3.0));

  inputA.add(Quaternion(0.18260, 0.54770, 0.73030, 0.36510)..normalize());
  inputB.add(Vector3(1.0, 0.0, 0.0));
  expectedOutput.add(Vector3(-0.6667, -0.3333, 0.6667));

  {
    inputA.add(Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
    inputB.add(Vector3(1.0, 0.0, 0.0));
    expectedOutput.add(Vector3(1.0, 0.0, 0.0));

    inputA.add(Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
    inputB.add(Vector3(0.0, 1.0, 0.0));
    expectedOutput.add(Vector3(0.0, 0.0, -1.0));

    inputA.add(Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
    inputB.add(Vector3(0.0, 0.0, 1.0));
    expectedOutput.add(Vector3(0.0, 1.0, 0.0));
  }

  {
    inputA.add(Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
    inputB.add(Vector3(1.0, 0.0, 0.0));
    expectedOutput.add(Vector3(0.0, 0.0, 1.0));

    inputA.add(Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
    inputB.add(Vector3(0.0, 1.0, 0.0));
    expectedOutput.add(Vector3(0.0, 1.0, 0.0));

    inputA.add(Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
    inputB.add(Vector3(0.0, 0.0, 1.0));
    expectedOutput.add(Vector3(-1.0, 0.0, 0.0));
  }

  {
    inputA.add(Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
    inputB.add(Vector3(1.0, 0.0, 0.0));
    expectedOutput.add(Vector3(0.0, -1.0, 0.0));

    inputA.add(Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
    inputB.add(Vector3(0.0, 1.0, 0.0));
    expectedOutput.add(Vector3(1.0, 0.0, 0.0));

    inputA.add(Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
    inputB.add(Vector3(0.0, 0.0, 1.0));
    expectedOutput.add(Vector3(0.0, 0.0, 1.0));
  }

  testQuaternionVectorRotate(inputA, inputB, expectedOutput);
}

void testQuaternionAxisAngle() {
  // Test conversion to and from axis-angle representation
  {
    final q = Quaternion.axisAngle(Vector3(0.0, 1.0, 0.0), 0.5 * math.pi);
    relativeTest(q.radians, 0.5 * math.pi);
    relativeTest(q.axis, Vector3(0.0, 1.0, 0.0));
  }

  {
    // Degenerate test: 0-angle
    final q = Quaternion.axisAngle(Vector3(1.0, 0.0, 0.0), 0.0);
    relativeTest(q.radians, 0.0);
  }
}

void testFromTwoVectors() {
  {
    // "Normal" test case
    final a = Vector3(1.0, 0.0, 0.0);
    final b = Vector3(0.0, 1.0, 0.0);
    final q = Quaternion.fromTwoVectors(a, b);
    relativeTest(q.radians, 0.5 * math.pi);
    relativeTest(q.axis, Vector3(0.0, 0.0, 1.0));
  }
  {
    // Degenerate null rotation
    final a = Vector3(1.0, 0.0, 0.0);
    final b = Vector3(1.0, 0.0, 0.0);
    final q = Quaternion.fromTwoVectors(a, b);
    relativeTest(q.radians, 0.0);
    // Axis can be arbitrary
  }
  {
    // Parallel vectors in opposite direction
    final a = Vector3(1.0, 0.0, 0.0);
    final b = Vector3(-1.0, 0.0, 0.0);
    final q = Quaternion.fromTwoVectors(a, b);
    relativeTest(q.radians, math.pi);
  }
}

void testSmallAngleQuaternionAxis() {
  final quaternion32 =
      Quaternion.axisAngle(Vector3(0.0, 0.0, 1.0), 0.6 * degrees2Radians);
  relativeTest(quaternion32.axis, Vector3(0.0, 0.0, 1.0));
  relativeTest(quaternion32.radians, 0.6 * degrees2Radians);
  final quaternion64 =
      v64.Quaternion.axisAngle(v64.Vector3(0, 0, 1), 0.01 * degrees2Radians);
  expect(
      quaternion64.axis.relativeError(v64.Vector3(0, 0, 1)), closeTo(0, 1e-5));
  expect(quaternion64.radians, closeTo(0.01 * degrees2Radians, 1e-5));
}

void main() {
  group('Quaternion', () {
    test('Float32List instacing', testQuaternionInstacinfFromFloat32List);
    test('ByteBuffer instacing', testQuaternionInstacingFromByteBuffer);
    test('Negate', testQuaternionNegate);
    test('Conjugate', testQuaternionConjugate);
    test('Matrix Quaternion Round Trip',
        testQuaternionMatrixQuaternionRoundTrip);
    test('Multiply', testQuaternionMultiplying);
    test('Normalize', testQuaternionNormalize);
    test('Axis-Angle', testQuaternionAxisAngle);
    test('Construction from two vectors', testFromTwoVectors);
    test('Axis of quaternion from small angle', testSmallAngleQuaternionAxis);
  });
}
