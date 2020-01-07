// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.opengl_matrix_test;

import 'dart:math';
import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testUnproject() {
  var position = Vector3(0.0, 0.0, 0.0);
  var focusPosition = Vector3(0.0, 0.0, -1.0);
  var upDirection = Vector3(0.0, 1.0, 0.0);
  var lookat = makeViewMatrix(position, focusPosition, upDirection);
  var n = 0.1;
  var f = 1000.0;
  var l = -10.0;
  var r = 10.0;
  var b = -10.0;
  var t = 10.0;
  var frustum = makeFrustumMatrix(l, r, b, t, n, f);
  var C = frustum * lookat as Matrix4;
  var re = Vector3.zero();
  unproject(C, 0.0, 100.0, 0.0, 100.0, 50.0, 50.0, 1.0, re);
}

void testLookAt() {
  var eyePosition = Vector3(0.0, 0.0, 0.0);
  var lookAtPosition = Vector3(0.0, 0.0, -1.0);
  var upDirection = Vector3(0.0, 1.0, 0.0);

  var lookat = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
  assert(lookat.getColumn(0).w == 0.0);
  assert(lookat.getColumn(1).w == 0.0);
  assert(lookat.getColumn(2).w == 0.0);
  assert(lookat.getColumn(3).w == 1.0);

  relativeTest(lookat.getColumn(0), Vector4(1.0, 0.0, 0.0, 0.0));
  relativeTest(lookat.getColumn(1), Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(lookat.getColumn(2), Vector4(0.0, 0.0, 1.0, 0.0));
}

void testFrustumMatrix() {
  var n = 0.1;
  var f = 1000.0;
  var l = -1.0;
  var r = 1.0;
  var b = -1.0;
  var t = 1.0;
  var frustum = makeFrustumMatrix(l, r, b, t, n, f);
  relativeTest(frustum.getColumn(0), Vector4(2 * n / (r - l), 0.0, 0.0, 0.0));
  relativeTest(frustum.getColumn(1), Vector4(0.0, 2 * n / (t - b), 0.0, 0.0));
  relativeTest(frustum.getColumn(2),
      Vector4((r + l) / (r - l), (t + b) / (t - b), -(f + n) / (f - n), -1.0));
  relativeTest(
      frustum.getColumn(3), Vector4(0.0, 0.0, -2.0 * f * n / (f - n), 0.0));
}

void testPerspectiveMatrix() {
  final double fov = pi / 2;
  final double aspectRatio = 2.0;
  final double zNear = 1.0;
  final double zFar = 100.0;

  var perspective = makePerspectiveMatrix(fov, aspectRatio, zNear, zFar);
  relativeTest(perspective.getColumn(0), Vector4(0.5, 0.0, 0.0, 0.0));
  relativeTest(perspective.getColumn(1), Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(
      perspective.getColumn(2), Vector4(0.0, 0.0, -101.0 / 99.0, -1.0));
  relativeTest(perspective.getColumn(3), Vector4(0.0, 0.0, -200.0 / 99.0, 0.0));
}

void testInfiniteMatrix() {
  final double fov = pi / 2;
  final double aspectRatio = 2.0;
  final double zNear = 1.0;

  var infinite = makeInfiniteMatrix(fov, aspectRatio, zNear);
  relativeTest(infinite.getColumn(0), Vector4(0.5, 0.0, 0.0, 0.0));
  relativeTest(infinite.getColumn(1), Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(infinite.getColumn(2), Vector4(0.0, 0.0, -1.0, -1.0));
  relativeTest(infinite.getColumn(3), Vector4(0.0, 0.0, -2.0, 0.0));
}

void testOrthographicMatrix() {
  var n = 0.1;
  var f = 1000.0;
  var l = -1.0;
  var r = 1.0;
  var b = -1.0;
  var t = 1.0;
  var ortho = makeOrthographicMatrix(l, r, b, t, n, f);
  relativeTest(ortho.getColumn(0), Vector4(2 / (r - l), 0.0, 0.0, 0.0));
  relativeTest(ortho.getColumn(1), Vector4(0.0, 2 / (t - b), 0.0, 0.0));
  relativeTest(ortho.getColumn(2), Vector4(0.0, 0.0, -2 / (f - n), 0.0));
  relativeTest(ortho.getColumn(3),
      Vector4(-(r + l) / (r - l), -(t + b) / (t - b), -(f + n) / (f - n), 1.0));
}

void testModelMatrix() {
  var view = Matrix4.zero();
  var position = Vector3(1.0, 1.0, 1.0);
  var focus = Vector3(0.0, 0.0, -1.0);
  var up = Vector3(0.0, 1.0, 0.0);

  setViewMatrix(view, position, focus, up);

  var model = Matrix4.zero();

  var forward = focus.clone();
  forward.sub(position);
  forward.normalize();

  var right = forward.cross(up).normalized();
  var u = right.cross(forward).normalized();

  setModelMatrix(model, forward, u, position.x, position.y, position.z);

  var result1 = view.clone();
  result1.multiply(model);

  relativeTest(result1, Matrix4.identity());
}

void main() {
  group('OpenGL', () {
    test('LookAt', testLookAt);
    test('Unproject', testUnproject);
    test('Frustum', testFrustumMatrix);
    test('Perspective', testPerspectiveMatrix);
    test('Infinite', testInfiniteMatrix);
    test('Orthographic', testOrthographicMatrix);
    test('ModelMatrix', testModelMatrix);
  });
}
