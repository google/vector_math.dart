// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.quaternion_test;

import 'dart:typed_data';
import 'dart:math' as math;

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testQuaternionInstacinfFromFloat32List() {
  final Float32List float32List =
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0]);
  final Quaternion input = new Quaternion.fromFloat32List(float32List);

  expect(input.x, equals(1.0));
  expect(input.y, equals(2.0));
  expect(input.z, equals(3.0));
  expect(input.w, equals(4.0));
}

void testQuaternionInstacingFromByteBuffer() {
  final Float32List float32List =
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final ByteBuffer buffer = float32List.buffer;
  final Quaternion zeroOffset = new Quaternion.fromBuffer(buffer, 0);
  final Quaternion offsetVector =
      new Quaternion.fromBuffer(buffer, Float32List.bytesPerElement);

  expect(zeroOffset.x, equals(1.0));
  expect(zeroOffset.y, equals(2.0));
  expect(zeroOffset.z, equals(3.0));
  expect(zeroOffset.w, equals(4.0));

  expect(offsetVector.x, equals(2.0));
  expect(offsetVector.y, equals(3.0));
  expect(offsetVector.z, equals(4.0));
  expect(offsetVector.w, equals(5.0));
}

void testConjugate(List<Quaternion> input, List<Quaternion> expectedOutput) {
  assert(input.length == expectedOutput.length);
  for (int i = 0; i < input.length; i++) {
    Quaternion output = input[i]..conjugate();
    relativeTest(output, expectedOutput[i]);
  }
}

void testQuaternionMatrixRoundTrip(List<Quaternion> input) {
  for (int i = 0; i < input.length; i++) {
    Matrix3 R = input[i].asRotationMatrix();
    Quaternion output = new Quaternion.fromRotation(R);
    relativeTest(output, input[i]);
  }
}

void testQuaternionMultiply(List<Quaternion> inputA, List<Quaternion> inputB,
    List<Quaternion> expectedOutput) {
  for (int i = 0; i < inputA.length; i++) {
    Quaternion output = inputA[i] * inputB[i];
    relativeTest(output, expectedOutput[i]);
  }
}

void testQuaternionVectorRotate(List<Quaternion> inputA, List<Vector3> inputB,
    List<Vector3> expectedOutput) {
  assert((inputA.length == inputB.length) &&
      (inputB.length == expectedOutput.length));
  for (int i = 0; i < inputA.length; i++) {
    Vector3 output = inputA[i].rotate(inputB[i]);
    relativeTest(output, expectedOutput[i]);
  }
}

void testQuaternionConjugate() {
  List<Quaternion> input = new List<Quaternion>();
  input.add(new Quaternion.identity());
  input.add(new Quaternion(0.18260, 0.54770, 0.73030, 0.36510));
  input.add(new Quaternion(0.9889, 0.0, 0.0, 0.14834));
  List<Quaternion> expectedOutput = new List<Quaternion>();
  expectedOutput.add(new Quaternion(-0.0, -0.0, -0.0, 1.0));
  expectedOutput.add(new Quaternion(-0.18260, -0.54770, -0.73030, 0.36510));
  expectedOutput.add(new Quaternion(-0.9889, -0.0, -0.0, 0.1483));
  testConjugate(input, expectedOutput);
}

void testQuaternionMatrixQuaternionRoundTrip() {
  List<Quaternion> input = new List<Quaternion>();
  input.add(new Quaternion.identity()..normalize());
  input.add(new Quaternion(0.18260, 0.54770, 0.73030, 0.36510)..normalize());
  input.add(new Quaternion(0.9889, 0.0, 0.0, 0.14834)..normalize());
  input.add(
      new Quaternion(0.388127, 0.803418, -0.433317, -0.126429)..normalize());
  input.add(new Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
  input.add(new Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
  input.add(new Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
  testQuaternionMatrixRoundTrip(input);
}

void testQuaternionMultiplying() {
  List<Quaternion> inputA = new List<Quaternion>();
  inputA.add(new Quaternion(0.18260, 0.54770, 0.73030, 0.36510));
  inputA.add(new Quaternion(0.9889, 0.0, 0.0, 0.14834));
  List<Quaternion> inputB = new List<Quaternion>();
  inputB.add(new Quaternion(0.9889, 0.0, 0.0, 0.14834));
  inputB.add(new Quaternion(0.18260, 0.54770, 0.73030, 0.36510));
  List<Quaternion> expectedOutput = new List<Quaternion>();
  expectedOutput.add(new Quaternion(0.388127, 0.803418, -0.433317, -0.126429));
  expectedOutput.add(new Quaternion(0.388127, -0.64097, 0.649924, -0.126429));
  testQuaternionMultiply(inputA, inputB, expectedOutput);
}

void testQuaternionNormalize() {
  List<Quaternion> inputA = new List<Quaternion>();
  List<Vector3> inputB = new List<Vector3>();
  List<Vector3> expectedOutput = new List<Vector3>();

  inputA.add(new Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
  inputB.add(new Vector3(1.0, 1.0, 1.0));
  expectedOutput.add(new Vector3(-1.0, 1.0, 1.0));

  inputA.add(new Quaternion.identity()..normalize());
  inputB.add(new Vector3(1.0, 2.0, 3.0));
  expectedOutput.add(new Vector3(1.0, 2.0, 3.0));

  inputA.add(new Quaternion(0.18260, 0.54770, 0.73030, 0.36510)..normalize());
  inputB.add(new Vector3(1.0, 0.0, 0.0));
  expectedOutput.add(new Vector3(-0.6667, -0.3333, 0.6667));

  {
    inputA.add(new Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
    inputB.add(new Vector3(1.0, 0.0, 0.0));
    expectedOutput.add(new Vector3(1.0, 0.0, 0.0));

    inputA.add(new Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
    inputB.add(new Vector3(0.0, 1.0, 0.0));
    expectedOutput.add(new Vector3(0.0, 0.0, -1.0));

    inputA.add(new Quaternion(1.0, 0.0, 0.0, 1.0)..normalize());
    inputB.add(new Vector3(0.0, 0.0, 1.0));
    expectedOutput.add(new Vector3(0.0, 1.0, 0.0));
  }

  {
    inputA.add(new Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
    inputB.add(new Vector3(1.0, 0.0, 0.0));
    expectedOutput.add(new Vector3(0.0, 0.0, 1.0));

    inputA.add(new Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
    inputB.add(new Vector3(0.0, 1.0, 0.0));
    expectedOutput.add(new Vector3(0.0, 1.0, 0.0));

    inputA.add(new Quaternion(0.0, 1.0, 0.0, 1.0)..normalize());
    inputB.add(new Vector3(0.0, 0.0, 1.0));
    expectedOutput.add(new Vector3(-1.0, 0.0, 0.0));
  }

  {
    inputA.add(new Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
    inputB.add(new Vector3(1.0, 0.0, 0.0));
    expectedOutput.add(new Vector3(0.0, -1.0, 0.0));

    inputA.add(new Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
    inputB.add(new Vector3(0.0, 1.0, 0.0));
    expectedOutput.add(new Vector3(1.0, 0.0, 0.0));

    inputA.add(new Quaternion(0.0, 0.0, 1.0, 1.0)..normalize());
    inputB.add(new Vector3(0.0, 0.0, 1.0));
    expectedOutput.add(new Vector3(0.0, 0.0, 1.0));
  }

  testQuaternionVectorRotate(inputA, inputB, expectedOutput);
}

void testQuaternionAxisAngle() {
  // Test conversion to and from axis-angle representation
  {
    Quaternion q =
        new Quaternion.axisAngle(new Vector3(0.0, 1.0, 0.0), 0.5 * math.pi);
    relativeTest(q.radians, 0.5 * math.pi);
    relativeTest(q.axis, new Vector3(0.0, 1.0, 0.0));
  }

  {
    // Degenerate test: 0-angle
    Quaternion q = new Quaternion.axisAngle(new Vector3(1.0, 0.0, 0.0), 0.0);
    relativeTest(q.radians, 0.0);
  }
}

void testFromTwoVectors() {
  {
    // "Normal" test case
    Vector3 a = new Vector3(1.0, 0.0, 0.0);
    Vector3 b = new Vector3(0.0, 1.0, 0.0);
    Quaternion q = new Quaternion.fromTwoVectors(a, b);
    relativeTest(q.radians, 0.5 * math.pi);
    relativeTest(q.axis, new Vector3(0.0, 0.0, 1.0));
  }
  {
    // Degenerate null rotation
    Vector3 a = new Vector3(1.0, 0.0, 0.0);
    Vector3 b = new Vector3(1.0, 0.0, 0.0);
    Quaternion q = new Quaternion.fromTwoVectors(a, b);
    relativeTest(q.radians, 0.0);
    // Axis can be arbitrary
  }
  {
    // Parallel vectors in opposite direction
    Vector3 a = new Vector3(1.0, 0.0, 0.0);
    Vector3 b = new Vector3(-1.0, 0.0, 0.0);
    Quaternion q = new Quaternion.fromTwoVectors(a, b);
    relativeTest(q.radians, math.pi);
  }
}

void main() {
  group('Quaternion', () {
    test('Float32List instacing', testQuaternionInstacingFromByteBuffer);
    test('ByteBuffer instacing', testQuaternionInstacingFromByteBuffer);
    test('Conjugate', testQuaternionConjugate);
    test('Matrix Quaternion Round Trip',
        testQuaternionMatrixQuaternionRoundTrip);
    test('Multiply', testQuaternionMultiplying);
    test('Normalize', testQuaternionNormalize);
    test('Axis-Angle', testQuaternionAxisAngle);
    test('Construction from two vectors', testFromTwoVectors);
  });
}
