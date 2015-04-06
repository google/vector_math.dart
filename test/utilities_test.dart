// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.utilities_test;

import 'dart:math' as Math;

import 'package:unittest/unittest.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testDegrees() {
  relativeTest(degrees(Math.PI), 180.0);
}

void testRadians() {
  relativeTest(radians(90.0), Math.PI / 2.0);
}

void testMix() {
  relativeTest(mix(2.5, 3.0, 1.0), 3.0);
  relativeTest(mix(1.0, 3.0, 0.5), 2.0);
  relativeTest(mix(2.5, 3.0, 0.0), 2.5);
  relativeTest(mix(-1.0, 0.0, 2.0), 1.0);
}

void main() {
  test('degrees', testDegrees);
  test('radians', testRadians);
  test('mix', testMix);
}
