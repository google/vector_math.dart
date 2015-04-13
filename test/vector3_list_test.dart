// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.vector3_list_test;

import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_lists.dart';

import 'test_utils.dart';

void testVector3ListWithOffset() {
  Vector3List list = new Vector3List(10, 1);
  list[0] = new Vector3(1.0, 2.0, 3.0);
  relativeTest(list[0].x, 1.0);
  relativeTest(list[0].y, 2.0);
  relativeTest(list[0].z, 3.0);
  relativeTest(list.buffer[0], 0.0); // unset
  relativeTest(list.buffer[1], 1.0);
  relativeTest(list.buffer[2], 2.0);
  relativeTest(list.buffer[3], 3.0);
  relativeTest(list.buffer[4], 0.0); // unset
}

void testVector3ListView() {
  Float32List buffer = new Float32List(10);
  Vector3List list = new Vector3List.view(buffer, 1, 4);
  // The list length should be (10 - 1) ~/ 4 == 2.
  expect(list.length, 2);
  list[0] = new Vector3(1.0, 2.0, 3.0);
  list[1] = new Vector3(4.0, 5.0, 6.0);
  expect(buffer[0], 0.0);
  expect(buffer[1], 1.0);
  expect(buffer[2], 2.0);
  expect(buffer[3], 3.0);
  expect(buffer[4], 0.0);
  expect(buffer[5], 4.0);
  expect(buffer[6], 5.0);
  expect(buffer[7], 6.0);
  expect(buffer[8], 0.0);
  expect(buffer[9], 0.0);
}

void testVector3ListViewTightFit() {
  Float32List buffer = new Float32List(10);
  Vector3List list = new Vector3List.view(buffer, 2, 5);
  // The list length should be (10 - 2) ~/ 4 == 2 as the stride of the last
  // element is negligible.
  expect(list.length, 2);
  list[0] = new Vector3(1.0, 2.0, 3.0);
  list[1] = new Vector3(4.0, 5.0, 6.0);
  expect(buffer[0], 0.0);
  expect(buffer[1], 0.0);
  expect(buffer[2], 1.0);
  expect(buffer[3], 2.0);
  expect(buffer[4], 3.0);
  expect(buffer[5], 0.0);
  expect(buffer[6], 0.0);
  expect(buffer[7], 4.0);
  expect(buffer[8], 5.0);
  expect(buffer[9], 6.0);
}

void testVector3ListFromList() {
  List<Vector3> input = new List<Vector3>(3);
  input[0] = new Vector3(1.0, 2.0, 3.0);
  input[1] = new Vector3(4.0, 5.0, 6.0);
  input[2] = new Vector3(7.0, 8.0, 9.0);
  Vector3List list = new Vector3List.fromList(input, 2, 5);
  expect(list.buffer.length, 17);
  expect(list.buffer[0], 0.0);
  expect(list.buffer[1], 0.0);
  expect(list.buffer[2], 1.0);
  expect(list.buffer[3], 2.0);
  expect(list.buffer[4], 3.0);
  expect(list.buffer[5], 0.0);
  expect(list.buffer[6], 0.0);
  expect(list.buffer[7], 4.0);
  expect(list.buffer[8], 5.0);
  expect(list.buffer[9], 6.0);
  expect(list.buffer[10], 0.0);
  expect(list.buffer[11], 0.0);
  expect(list.buffer[12], 7.0);
  expect(list.buffer[13], 8.0);
  expect(list.buffer[14], 9.0);
  expect(list.buffer[15], 0.0);
  expect(list.buffer[16], 0.0);
}

void testVector3ListSetValue() {
  final list = new Vector3List(2);

  list.setValues(1, 1.0, 2.0, 3.0);

  expect(list.buffer[0], 0.0);
  expect(list.buffer[1], 0.0);
  expect(list.buffer[2], 0.0);
  expect(list.buffer[3], 1.0);
  expect(list.buffer[4], 2.0);
  expect(list.buffer[5], 3.0);
}

void testVector3ListSetZero() {
  final list = new Vector3List.view(
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));

  list.setZero(1);

  expect(list.buffer[0], 1.0);
  expect(list.buffer[1], 2.0);
  expect(list.buffer[2], 3.0);
  expect(list.buffer[3], 0.0);
  expect(list.buffer[4], 0.0);
  expect(list.buffer[5], 0.0);
}

void testVector3ListAdd() {
  final list = new Vector3List.view(
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));

  list.add(1, $v3(2.0, 2.0, 2.0));

  expect(list.buffer[0], 1.0);
  expect(list.buffer[1], 2.0);
  expect(list.buffer[2], 3.0);
  expect(list.buffer[3], 6.0);
  expect(list.buffer[4], 7.0);
  expect(list.buffer[5], 8.0);
}

void testVector3ListAddScaled() {
  final list = new Vector3List.view(
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));

  list.addScaled(1, $v3(2.0, 2.0, 2.0), 2.0);

  expect(list.buffer[0], 1.0);
  expect(list.buffer[1], 2.0);
  expect(list.buffer[2], 3.0);
  expect(list.buffer[3], 8.0);
  expect(list.buffer[4], 9.0);
  expect(list.buffer[5], 10.0);
}

void testVector3ListSub() {
  final list = new Vector3List.view(
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));

  list.sub(1, $v3(2.0, 2.0, 2.0));

  expect(list.buffer[0], 1.0);
  expect(list.buffer[1], 2.0);
  expect(list.buffer[2], 3.0);
  expect(list.buffer[3], 2.0);
  expect(list.buffer[4], 3.0);
  expect(list.buffer[5], 4.0);
}

void testVector3ListMultiply() {
  final list = new Vector3List.view(
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));

  list.multiply(1, $v3(2.0, 3.0, 4.0));

  expect(list.buffer[0], 1.0);
  expect(list.buffer[1], 2.0);
  expect(list.buffer[2], 3.0);
  expect(list.buffer[3], 8.0);
  expect(list.buffer[4], 15.0);
  expect(list.buffer[5], 24.0);
}

void testVector3ListScale() {
  final list = new Vector3List.view(
      new Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));

  list.scale(1, 2.0);

  expect(list.buffer[0], 1.0);
  expect(list.buffer[1], 2.0);
  expect(list.buffer[2], 3.0);
  expect(list.buffer[3], 8.0);
  expect(list.buffer[4], 10.0);
  expect(list.buffer[5], 12.0);
}

void main() {
  group('Vector3List', () {
    test('with offset', testVector3ListWithOffset);
    test('view', testVector3ListView);
    test('view tight fit', testVector3ListViewTightFit);
    test('fromList', testVector3ListFromList);
    test('setValue', testVector3ListSetValue);
    test('setZero', testVector3ListSetZero);
    test('add', testVector3ListAdd);
    test('addScaled', testVector3ListAddScaled);
    test('sub', testVector3ListSub);
    test('multiply', testVector3ListMultiply);
    test('scale', testVector3ListScale);
  });
}
