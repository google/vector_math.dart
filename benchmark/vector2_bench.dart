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

  static void main() {
    ConstructorAllBenchmark().report();
  }

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

  static void main() {
    ConstructorCopyBenchmark().report();
  }

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

// --- Before --- //

/*
$ dart run benchmark/vector2_bench.dart

Vector2()(RunTime): 202.8197194309024 us.
Vector2.zero()(RunTime): 200.17709611451943 us.
Vector2.array()(RunTime): 391.3436018957346 us.
Vector2.all()(RunTime): 388.8081180811808 us.
Vector2.copy()(RunTime): 386.95465071401003 us.
Vector2.fromFloat32List()(RunTime): 389.3649748159628 us.
Vector2.fromBuffer()(RunTime): 5980.412087912088 us.
Vector2.random()(RunTime): 25577.240506329115 us.
Vector2.setFrom()(RunTime): 243.5085574572127 us.
Vector2.dot()(RunTime): 195.64618896387455 us.

$ dart compile exe -o benchmark/vector2_bench.exe benchmark/vector2_bench.dart
$ ./benchmark/vector2_bench.exe

Vector2()(RunTime): 3862.1923076923076 us.
Vector2.zero()(RunTime): 194.03286978508217 us.
Vector2.array()(RunTime): 7367.800699300699 us.
Vector2.all()(RunTime): 3860.874125874126 us.
Vector2.copy()(RunTime): 3835.0874125874125 us.
Vector2.fromFloat32List()(RunTime): 386.48084365325076 us.
Vector2.fromBuffer()(RunTime): 6011.754491017964 us.
Vector2.random()(RunTime): 11294.576923076924 us.
Vector2.setFrom()(RunTime): 519.39625 us.
Vector2.dot()(RunTime): 196.22144129875272 us.
*/

// --- After --- //

/*
$ dart run benchmark/vector2_bench.dart

Vector2()(RunTime): 3732.437062937063 us.
Vector2.zero()(RunTime): 3483.7631184407796 us.
Vector2.array()(RunTime): 3571.7739520958085 us.
Vector2.all()(RunTime): 3741.715034965035 us.
Vector2.copy()(RunTime): 3838.61013986014 us.
Vector2.fromFloat32List()(RunTime): 1719.3718140929536 us.
Vector2.fromBuffer()(RunTime): 6143.877245508982 us.
Vector2.random()(RunTime): 29626.848484848484 us.
Vector2.setFrom()(RunTime): 234.90559195133363 us.
Vector2.dot()(RunTime): 389.8708860759494 us.

$ dart compile exe -o benchmark/vector2_bench.exe benchmark/vector2_bench.dart
$ ./benchmark/vector2_bench.exe

Vector2()(RunTime): 3528.176911544228 us.
Vector2.zero()(RunTime): 3356.08095952024 us.
Vector2.array()(RunTime): 7313.762237762237 us.
Vector2.all()(RunTime): 3485.455772113943 us.
Vector2.copy()(RunTime): 3624.082 us.
Vector2.fromFloat32List()(RunTime): 1638.9460269865067 us.
Vector2.fromBuffer()(RunTime): 7060.604895104895 us.
Vector2.random()(RunTime): 11604.103448275862 us.
Vector2.setFrom()(RunTime): 349.6024287222809 us.
Vector2.dot()(RunTime): 386.6904991327809 us.
*/
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
