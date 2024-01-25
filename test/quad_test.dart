// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testQuadCopy() {
  final quad = Quad.points(Vector3(1.0, 0.0, 1.0), Vector3(0.0, 2.0, 1.0),
      Vector3(1.0, 0.0, 0.0), Vector3(0.0, 2.0, 0.0));
  final quadCopy = Quad.copy(quad);

  relativeTest(quadCopy.point0, quad.point0);
  relativeTest(quadCopy.point1, quad.point1);
  relativeTest(quadCopy.point2, quad.point2);
  relativeTest(quadCopy.point3, quad.point3);
}

void testQuadCopyNormalInto() {
  final quad = Quad.points(Vector3(1.0, 0.0, 1.0), Vector3(0.0, 2.0, 1.0),
      Vector3(1.0, 0.0, 0.0), Vector3(0.0, 2.0, 0.0));
  final normal = Vector3.zero();

  quad.copyNormalInto(normal);

  relativeTest(normal, Vector3(-0.8944271802902222, -0.4472135901451111, 0.0));
}

void testQuadCopyTriangles() {
  final quad = Quad.points(Vector3(1.0, 0.0, 1.0), Vector3(0.0, 2.0, 1.0),
      Vector3(1.0, 0.0, 0.0), Vector3(0.0, 2.0, 0.0));
  final t1 = Triangle();
  final t2 = Triangle();
  final normal = Vector3.zero();
  final t1Normal = Vector3.zero();
  final t2Normal = Vector3.zero();

  quad.copyNormalInto(normal);

  quad.copyTriangles(t1, t2);
  t1.copyNormalInto(t1Normal);
  t2.copyNormalInto(t2Normal);

  relativeTest(t1Normal, normal);
  relativeTest(t2Normal, normal);
}

void testQuadEquals() {
  final v1 = Vector3(1.0, 0.0, 1.0);
  final v2 = Vector3(0.0, 2.0, 1.0);
  final v3 = Vector3(1.0, 0.0, 0.0);
  final v4 = Vector3(0.0, 2.0, 0.0);
  final quad = Quad.points(v1, v2, v3, v4);

  expect(quad, Quad.points(v1, v2, v3, v4));

  expect(quad, isNot(Quad.points(Vector3.zero(), v2, v3, v4)));
  expect(quad, isNot(Quad.points(v1, Vector3.zero(), v3, v4)));
  expect(quad, isNot(Quad.points(v1, v2, Vector3.zero(), v4)));
  expect(quad, isNot(Quad.points(v1, v2, v3, Vector3.zero())));

  expect(Quad.points(v1, v2, v3, v4).hashCode,
      equals(Quad.points(v1, v2, v3, v4).hashCode));
}

void main() {
  group('Quad', () {
    test('Copy', testQuadCopy);
    test('CopyNormalInto', testQuadCopyNormalInto);
    test('CopyTriangles', testQuadCopyTriangles);
    test('equals', testQuadEquals);
  });
}
