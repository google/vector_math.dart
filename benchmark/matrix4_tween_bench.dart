// Copyright (c) 2019, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

mixin Setup on BenchmarkBase {
  final beginTransform = Matrix4.compose(
    Vector3(1.0, 1.0, 1.0),
    Quaternion.euler(0.0, 0.0, 0.0),
    Vector3(1.0, 1.0, 1.0),
  );

  final Matrix4 endTransform = Matrix4.compose(
    Vector3(5.0, 260.0, 1.0),
    Quaternion.euler(0.0, 1.0, -0.7),
    Vector3(0.6, 0.6, 0.6),
  );

  @override
  void run() {
    var sum_traces = 0.0;
    for (var i = 0; i <= 1024; i++) {
      final t = i / 1024.0;
      final m1 = lerp(beginTransform, endTransform, t);
      final m2 = lerp(endTransform, beginTransform, t);
      sum_traces += m1.trace();
      sum_traces += m2.trace();
    }
    if (sum_traces < 6320 || sum_traces > 6321) {
      throw StateError('Bad result: $sum_traces');
    }
  }

  Matrix4 lerp(Matrix4 begin, Matrix4 end, double t);
}

class Matrix4TweenBenchmark1 extends BenchmarkBase with Setup {
  Matrix4TweenBenchmark1() : super('Matrix4TweenBenchmark1');

  @override
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

class Matrix4TweenBenchmark2 extends BenchmarkBase with Setup {
  Matrix4TweenBenchmark2() : super('Matrix4TweenBenchmark2');

  @override
  Matrix4 lerp(Matrix4 begin, Matrix4 end, double t) {
    begin.decompose(beginTranslation, beginRotation, beginScale);
    end.decompose(endTranslation, endRotation, endScale);
    Vector3.mix(beginTranslation, endTranslation, t, lerpTranslation);
    final Quaternion lerpRotation =
        (beginRotation.scaled(1.0 - t) + endRotation.scaled(t)).normalized();
    Vector3.mix(beginScale, endScale, t, lerpScale);
    return Matrix4.compose(lerpTranslation, lerpRotation, lerpScale);
  }

  // Pre-allocated vectors.
  static final Vector3 beginTranslation = Vector3.zero();
  static final Vector3 endTranslation = Vector3.zero();
  static final Vector3 lerpTranslation = Vector3.zero();
  static final Quaternion beginRotation = Quaternion.identity();
  static final Quaternion endRotation = Quaternion.identity();
  static final Vector3 beginScale = Vector3.zero();
  static final Vector3 endScale = Vector3.zero();
  static final Vector3 lerpScale = Vector3.zero();
}

class Matrix4TweenBenchmark3 extends BenchmarkBase with Setup {
  Matrix4TweenBenchmark3() : super('Matrix4TweenBenchmark3');

  @override
  Matrix4 lerp(Matrix4 begin, Matrix4 end, double t) {
    if (beginTranslation == null) _lerpInit();
    begin.decompose(beginTranslation, beginRotation, beginScale);
    end.decompose(endTranslation, endRotation, endScale);
    Vector3.mix(beginTranslation, endTranslation, t, lerpTranslation);
    final Quaternion lerpRotation =
        (beginRotation.scaled(1.0 - t) + endRotation.scaled(t)).normalized();
    Vector3.mix(beginScale, endScale, t, lerpScale);
    return Matrix4.compose(lerpTranslation, lerpRotation, lerpScale);
  }

  // Manually initialized pre-allocated vectors.
  static Vector3 beginTranslation;
  static Vector3 endTranslation;
  static Vector3 lerpTranslation;
  static Quaternion beginRotation;
  static Quaternion endRotation;
  static Vector3 beginScale;
  static Vector3 endScale;
  static Vector3 lerpScale;
  static void _lerpInit() {
    beginTranslation = Vector3.zero();
    endTranslation = Vector3.zero();
    lerpTranslation = Vector3.zero();
    beginRotation = Quaternion.identity();
    endRotation = Quaternion.identity();
    beginScale = Vector3.zero();
    endScale = Vector3.zero();
    lerpScale = Vector3.zero();
  }
}

void main() {
  final benchmarks = [
    Matrix4TweenBenchmark1(),
    Matrix4TweenBenchmark2(),
    Matrix4TweenBenchmark3(),
  ];
  // Warmup all bencmarks.
  for (var b in benchmarks) {
    b.run();
  }
  for (var b in benchmarks) {
    b.exercise();
  }
  for (var b in benchmarks) {
    b.report();
  }
}
