// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.triangle_test;

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testCopyNormalInto() {
  final triangle = new Triangle.points(new Vector3(1.0, 0.0, 1.0),
      new Vector3(0.0, 2.0, 1.0), new Vector3(1.0, 2.0, 0.0));
  final normal = new Vector3.zero();

  triangle.copyNormalInto(normal);

  relativeTest(normal, new Vector3(-0.666666666, -0.333333333, -0.666666666));
}

void main() {
  group('Triangle', () {
    test('CopyNormalInto', testCopyNormalInto);
  });
}
