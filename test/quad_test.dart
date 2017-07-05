// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.quad_test;

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testQuadCopyNormalInto() {
  final quad = new Quad.points(
      new Vector3(1.0, 0.0, 1.0),
      new Vector3(0.0, 2.0, 1.0),
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 2.0, 0.0));
  final normal = new Vector3.zero();

  quad.copyNormalInto(normal);

  relativeTest(
      normal, new Vector3(-0.8944271802902222, -0.4472135901451111, 0.0));
}

void testQuadCopyTriangles() {
  final quad = new Quad.points(
      new Vector3(1.0, 0.0, 1.0),
      new Vector3(0.0, 2.0, 1.0),
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 2.0, 0.0));
  final t1 = new Triangle();
  final t2 = new Triangle();
  final normal = new Vector3.zero();
  final t1Normal = new Vector3.zero();
  final t2Normal = new Vector3.zero();

  quad.copyNormalInto(normal);

  quad.copyTriangles(t1, t2);
  t1.copyNormalInto(t1Normal);
  t2.copyNormalInto(t2Normal);

  relativeTest(t1Normal, normal);
  relativeTest(t2Normal, normal);
}

void main() {
  group('Quad', () {
    test('CopyNormalInto', testQuadCopyNormalInto);
    test('CopyTriangles', testQuadCopyTriangles);
  });
}
