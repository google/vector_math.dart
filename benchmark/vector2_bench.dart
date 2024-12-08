// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:vector_math/vector_math.dart';

Never _unreachableAssertionError() => throw AssertionError('Unreachable');

class ConstructorBenchmark extends BenchmarkBase {
  ConstructorBenchmark() : super('Vector2()');

  @override
  void run() {
    Vector2? v;
    for (var i = 0; i < 100000; i++) {
      v = Vector2(100, 100);
    }
    if (v == null) _unreachableAssertionError();
  }
}

class ConstructorZeroBenchmark extends BenchmarkBase {
  ConstructorZeroBenchmark() : super('Vector2.zero()');

  @override
  void run() {
    Vector2? v;
    for (var i = 0; i < 100000; i++) {
      v = Vector2.zero();
    }
    if (v == null) _unreachableAssertionError();
  }
}

class ConstructorArrayBenchmark extends BenchmarkBase {
  ConstructorArrayBenchmark() : super('Vector2.array()');

  @override
  void run() {
    Vector2? v;
    for (var i = 0.0; i < 100000; i++) {
      v = Vector2.array([i, i]);
    }
    if (v == null) _unreachableAssertionError();
  }
}

class ConstructorAllBenchmark extends BenchmarkBase {
  ConstructorAllBenchmark() : super('Vector2.all()');

  @override
  void run() {
    Vector2? v;
    for (var i = 0.0; i < 100000; i++) {
      v = Vector2.all(i);
    }
    if (v == null) _unreachableAssertionError();
  }
}

class ConstructorCopyBenchmark extends BenchmarkBase {
  ConstructorCopyBenchmark() : super('Vector2.copy()');

  @override
  void run() {
    Vector2? v;
    final copyFrom = Vector2(1, 1);
    for (var i = 0.0; i < 100000; i++) {
      v = Vector2.copy(copyFrom);
    }
    if (v == null) _unreachableAssertionError();
  }
}

class ConstructorFromFloat32ListBenchmark extends BenchmarkBase {
  ConstructorFromFloat32ListBenchmark() : super('Vector2.fromFloat32List()');

  @override
  void run() {
    Vector2? v;
    final list = Float32List.fromList([0.0, 0.0]);
    for (var i = 0.0; i < 100000; i++) {
      v = Vector2.fromFloat32List(list);
    }
    if (v == null) _unreachableAssertionError();
  }
}

class ConstructorFromBufferBenchmark extends BenchmarkBase {
  ConstructorFromBufferBenchmark() : super('Vector2.fromBuffer()');

  @override
  void run() {
    Vector2? v;
    final buffer = Uint32List(2).buffer;
    for (var i = 0.0; i < 100000; i++) {
      v = Vector2.fromBuffer(buffer, 0);
    }
    if (v == null) _unreachableAssertionError();
  }
}

class ConstructorRandomBenchmark extends BenchmarkBase {
  ConstructorRandomBenchmark() : super('Vector2.random()');

  @override
  void run() {
    Vector2? v;
    final random = math.Random();
    for (var i = 0.0; i < 100000; i++) {
      v = Vector2.random(random);
    }
    if (v == null) _unreachableAssertionError();
  }
}

class SetFromBenchmark extends BenchmarkBase {
  SetFromBenchmark() : super('Vector2.setFrom()');
  final Vector2 source = Vector2(100, 100);

  @override
  void run() {
    var v = Vector2.zero();
    for (var i = 0; i < 100000; i++) {
      v = v..setFrom(source);
    }
    if (v.x != 100 || v.y != 100) _unreachableAssertionError();
  }
}

class DotProductBenchmark extends BenchmarkBase {
  DotProductBenchmark() : super('Vector2.dot()');
  final Vector2 v1 = Vector2(100, 100);
  final Vector2 v2 = Vector2(100, 200);

  @override
  void run() {
    var r = .0;
    for (var i = 0; i < 100000; i++) {
      r += v1.dot(v2);
    }
    if (r != 30000 * 100000) _unreachableAssertionError();
  }
}

void main() {
  void report(BenchmarkBase Function() create) => create().report();
  [
    ConstructorBenchmark.new,
    ConstructorZeroBenchmark.new,
    ConstructorArrayBenchmark.new,
    ConstructorAllBenchmark.new,
    ConstructorCopyBenchmark.new,
    ConstructorFromFloat32ListBenchmark.new,
    ConstructorFromBufferBenchmark.new,
    ConstructorRandomBenchmark.new,
    SetFromBenchmark.new,
    DotProductBenchmark.new,
  ].forEach(report);
}
