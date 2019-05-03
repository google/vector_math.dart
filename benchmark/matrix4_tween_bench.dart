// Copyright (c) 2019, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math_matrix4_tween_bench;

//import 'dart:typed_data';
import 'package:vector_math/vector_math_64.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class Matrix4TweenBenchmark extends BenchmarkBase {
  Matrix4TweenBenchmark() : super("Matrix4TweenBenchmark");

  final beginTransform = new Matrix4.compose(
      Vector3(1.0, 1.0, 1.0),
      Quaternion.euler(0.0, 0.0, 0.0),
      Vector3(1.0, 1.0, 1.0));

  final Matrix4 endTransform = new Matrix4.compose(
      Vector3(5.0, 260.0, 1.0),
      Quaternion.euler(0.0, 1.0, -0.7),
      Vector3(0.6, 0.6, 0.6));

  static void main() {
    new Matrix4TweenBenchmark().report();
  }

  @override
  void run() {
    double sum_traces = 0;
    for (int i = 0; i <= 1024; i++) {
      double t = i / 1024.0;
      Matrix4 m1 = lerp(beginTransform, endTransform, t);
      Matrix4 m2 = lerp(endTransform, beginTransform, t);
      sum_traces += m1.trace();
      sum_traces += m2.trace();
    }
    if (sum_traces < 6320 || sum_traces > 6321) {
      throw 'Bad result: ${sum_traces}';
    }
  }

  Matrix4 lerp(Matrix4 begin, Matrix4 end, double t) {
    final Vector3 beginTranslation = Vector3.zero();
    final Vector3 endTranslation = Vector3.zero();
    final Quaternion beginRotation = Quaternion.identity();
    final Quaternion endRotation = Quaternion.identity();
    final Vector3 beginScale = Vector3.zero();
    final Vector3 endScale = Vector3.zero();
    begin.decompose(beginTranslation, beginRotation, beginScale);
    end.decompose(endTranslation, endRotation, endScale);
    final Vector3 lerpTranslation =
       beginTranslation * (1.0 - t) + endTranslation * t;
    final Quaternion lerpRotation =
      (beginRotation.scaled(1.0 - t) + endRotation.scaled(t)).normalized();
    final Vector3 lerpScale = beginScale * (1.0 - t) + endScale * t;
    return Matrix4.compose(lerpTranslation, lerpRotation, lerpScale);
  }
}

void main() {
  Matrix4TweenBenchmark.main();
}
