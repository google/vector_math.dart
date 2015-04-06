// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.vector2_list_test;

import 'dart:typed_data';

import 'package:unittest/unittest.dart';

import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_lists.dart';

import 'test_utils.dart';

void main() {
  test('Vector2List with offset', () {
    Vector2List list = new Vector2List(10, 1);
    list[0] = new Vector2(1.0, 2.0);
    relativeTest(list[0].x, 1.0);
    relativeTest(list[0].y, 2.0);
    relativeTest(list.buffer[0], 0.0); // unset
    relativeTest(list.buffer[1], 1.0);
    relativeTest(list.buffer[2], 2.0);
    relativeTest(list.buffer[3], 0.0); // unset
  });

  test('Vector2List.view', () {
    Float32List buffer = new Float32List(8);
    Vector2List list = new Vector2List.view(buffer, 1, 3);
    // The list length should be (8 - 1) ~/ 3 == 2.
    expect(list.length, 2);
    list[0] = new Vector2(1.0, 2.0);
    list[1] = new Vector2(3.0, 4.0);
    expect(buffer[0], 0.0);
    expect(buffer[1], 1.0);
    expect(buffer[2], 2.0);
    expect(buffer[3], 0.0);
    expect(buffer[4], 3.0);
    expect(buffer[5], 4.0);
    expect(buffer[6], 0.0);
    expect(buffer[7], 0.0);
  });

  test('Vector2List.view tight fit', () {
    Float32List buffer = new Float32List(8);
    Vector2List list = new Vector2List.view(buffer, 2, 4);
    // The list length should be (8 - 2) ~/ 2 == 2 as the stride of the last
    // element is negligible.
    expect(list.length, 2);
    list[0] = new Vector2(1.0, 2.0);
    list[1] = new Vector2(3.0, 4.0);
    expect(buffer[0], 0.0);
    expect(buffer[1], 0.0);
    expect(buffer[2], 1.0);
    expect(buffer[3], 2.0);
    expect(buffer[4], 0.0);
    expect(buffer[5], 0.0);
    expect(buffer[6], 3.0);
    expect(buffer[7], 4.0);
  });

  test('Vector2List.fromList', () {
    List<Vector2> input = new List<Vector2>(3);
    input[0] = new Vector2(1.0, 2.0);
    input[1] = new Vector2(3.0, 4.0);
    input[2] = new Vector2(5.0, 6.0);
    Vector2List list = new Vector2List.fromList(input, 2, 5);
    expect(list.buffer.length, 17);
    expect(list.buffer[0], 0.0);
    expect(list.buffer[1], 0.0);
    expect(list.buffer[2], 1.0);
    expect(list.buffer[3], 2.0);
    expect(list.buffer[4], 0.0);
    expect(list.buffer[5], 0.0);
    expect(list.buffer[6], 0.0);
    expect(list.buffer[7], 3.0);
    expect(list.buffer[8], 4.0);
    expect(list.buffer[9], 0.0);
    expect(list.buffer[10], 0.0);
    expect(list.buffer[11], 0.0);
    expect(list.buffer[12], 5.0);
    expect(list.buffer[13], 6.0);
    expect(list.buffer[14], 0.0);
    expect(list.buffer[15], 0.0);
    expect(list.buffer[16], 0.0);
  });
}
