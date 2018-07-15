// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.opengl_matrix_test;

import 'dart:math';
import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testUnproject() {
  Vector3 position = new Vector3(0.0, 0.0, 0.0);
  Vector3 focusPosition = new Vector3(0.0, 0.0, -1.0);
  Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
  Matrix4 lookat = makeViewMatrix(position, focusPosition, upDirection);
  double n = 0.1;
  double f = 1000.0;
  double l = -10.0;
  double r = 10.0;
  double b = -10.0;
  double t = 10.0;
  Matrix4 frustum = makeFrustumMatrix(l, r, b, t, n, f);
  Matrix4 C = frustum * lookat as Matrix4;
  Vector3 re = new Vector3.zero();
  unproject(C, 0.0, 100.0, 0.0, 100.0, 50.0, 50.0, 1.0, re);
}

void testLookAt() {
  Vector3 eyePosition = new Vector3(0.0, 0.0, 0.0);
  Vector3 lookAtPosition = new Vector3(0.0, 0.0, -1.0);
  Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);

  Matrix4 lookat = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
  assert(lookat.getColumn(0).w == 0.0);
  assert(lookat.getColumn(1).w == 0.0);
  assert(lookat.getColumn(2).w == 0.0);
  assert(lookat.getColumn(3).w == 1.0);

  relativeTest(lookat.getColumn(0), new Vector4(1.0, 0.0, 0.0, 0.0));
  relativeTest(lookat.getColumn(1), new Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(lookat.getColumn(2), new Vector4(0.0, 0.0, 1.0, 0.0));
}

void testFrustumMatrix() {
  double n = 0.1;
  double f = 1000.0;
  double l = -1.0;
  double r = 1.0;
  double b = -1.0;
  double t = 1.0;
  Matrix4 frustum = makeFrustumMatrix(l, r, b, t, n, f);
  relativeTest(
      frustum.getColumn(0), new Vector4(2 * n / (r - l), 0.0, 0.0, 0.0));
  relativeTest(
      frustum.getColumn(1), new Vector4(0.0, 2 * n / (t - b), 0.0, 0.0));
  relativeTest(
      frustum.getColumn(2),
      new Vector4(
          (r + l) / (r - l), (t + b) / (t - b), -(f + n) / (f - n), -1.0));
  relativeTest(
      frustum.getColumn(3), new Vector4(0.0, 0.0, -2.0 * f * n / (f - n), 0.0));
}

void testPerspectiveMatrix() {
  final double fov = pi / 2;
  final double aspectRatio = 2.0;
  final double zNear = 1.0;
  final double zFar = 100.0;

  Matrix4 perspective = makePerspectiveMatrix(fov, aspectRatio, zNear, zFar);
  relativeTest(perspective.getColumn(0), new Vector4(0.5, 0.0, 0.0, 0.0));
  relativeTest(perspective.getColumn(1), new Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(
      perspective.getColumn(2), new Vector4(0.0, 0.0, -101.0 / 99.0, -1.0));
  relativeTest(
      perspective.getColumn(3), new Vector4(0.0, 0.0, -200.0 / 99.0, 0.0));
}

void testInfiniteMatrix() {
  final double fov = pi / 2;
  final double aspectRatio = 2.0;
  final double zNear = 1.0;

  Matrix4 infinite = makeInfiniteMatrix(fov, aspectRatio, zNear);
  relativeTest(infinite.getColumn(0), new Vector4(0.5, 0.0, 0.0, 0.0));
  relativeTest(infinite.getColumn(1), new Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(infinite.getColumn(2), new Vector4(0.0, 0.0, -1.0, -1.0));
  relativeTest(infinite.getColumn(3), new Vector4(0.0, 0.0, -2.0, 0.0));
}

void testOrthographicMatrix() {
  double n = 0.1;
  double f = 1000.0;
  double l = -1.0;
  double r = 1.0;
  double b = -1.0;
  double t = 1.0;
  Matrix4 ortho = makeOrthographicMatrix(l, r, b, t, n, f);
  relativeTest(ortho.getColumn(0), new Vector4(2 / (r - l), 0.0, 0.0, 0.0));
  relativeTest(ortho.getColumn(1), new Vector4(0.0, 2 / (t - b), 0.0, 0.0));
  relativeTest(ortho.getColumn(2), new Vector4(0.0, 0.0, -2 / (f - n), 0.0));
  relativeTest(
      ortho.getColumn(3),
      new Vector4(
          -(r + l) / (r - l), -(t + b) / (t - b), -(f + n) / (f - n), 1.0));
}

void testModelMatrix() {
  Matrix4 view = new Matrix4.zero();
  Vector3 position = new Vector3(1.0, 1.0, 1.0);
  Vector3 focus = new Vector3(0.0, 0.0, -1.0);
  Vector3 up = new Vector3(0.0, 1.0, 0.0);

  setViewMatrix(view, position, focus, up);

  Matrix4 model = new Matrix4.zero();

  Vector3 forward = focus.clone();
  forward.sub(position);
  forward.normalize();

  Vector3 right = forward.cross(up).normalized();
  Vector3 u = right.cross(forward).normalized();

  setModelMatrix(model, forward, u, position.x, position.y, position.z);

  Matrix4 result1 = view.clone();
  result1.multiply(model);

  relativeTest(result1, new Matrix4.identity());
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
