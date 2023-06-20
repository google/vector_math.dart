// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:vector_math/vector_math.dart';

class ConstructorBenchmark extends BenchmarkBase {
  ConstructorBenchmark() : super('Vector2()');

  static void main() {
    ConstructorBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100000; i++) {
      Vector2(100, 100);
    }
  }
}

class ConstructorZeroBenchmark extends BenchmarkBase {
  ConstructorZeroBenchmark() : super('Vector2.zero()');

  static void main() {
    ConstructorZeroBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100000; i++) {
      Vector2.zero();
    }
  }
}

class ConstructorArrayBenchmark extends BenchmarkBase {
  ConstructorArrayBenchmark() : super('Vector2.array()');

  static void main() {
    ConstructorArrayBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0.0; i < 100000; i++) {
      Vector2.array([i, i]);
    }
  }
}

class ConstructorAllBenchmark extends BenchmarkBase {
  ConstructorAllBenchmark() : super('Vector2.all()');

  static void main() {
    ConstructorAllBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0.0; i < 100000; i++) {
      Vector2.all(i);
    }
  }
}

class ConstructorCopyBenchmark extends BenchmarkBase {
  ConstructorCopyBenchmark() : super('Vector2.copy()');

  static void main() {
    ConstructorCopyBenchmark().report();
  }

  @override
  void run() {
    final copyFrom = Vector2(1, 1);
    for (var i = 0.0; i < 100000; i++) {
      Vector2.copy(copyFrom);
    }
  }
}

class ConstructorFromFloat32ListBenchmark extends BenchmarkBase {
  ConstructorFromFloat32ListBenchmark() : super('Vector2.fromFloat32List()');

  static void main() {
    ConstructorFromFloat32ListBenchmark().report();
  }

  @override
  void run() {
    final list = Float32List.fromList([0.0, 0.0]);
    for (var i = 0.0; i < 100000; i++) {
      Vector2.fromFloat32List(list);
    }
  }
}

class ConstructorFromBufferBenchmark extends BenchmarkBase {
  ConstructorFromBufferBenchmark() : super('Vector2.fromBuffer()');

  static void main() {
    ConstructorFromBufferBenchmark().report();
  }

  @override
  void run() {
    final buffer = Uint32List(2).buffer;
    for (var i = 0.0; i < 100000; i++) {
      Vector2.fromBuffer(buffer, 0);
    }
  }
}

class ConstructorRandomBenchmark extends BenchmarkBase {
  ConstructorRandomBenchmark() : super('Vector2.random()');

  static void main() {
    ConstructorRandomBenchmark().report();
  }

  @override
  void run() {
    final random = math.Random();
    for (var i = 0.0; i < 100000; i++) {
      Vector2.random(random);
    }
  }
}

class SetFromBenchmark extends BenchmarkBase {
  SetFromBenchmark() : super('Vector2.setFrom()');
  final Vector2 v1 = Vector2(100, 100);
  final Vector2 v2 = Vector2.zero();

  static void main() {
    SetFromBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100000; i++) {
      v2.setFrom(v1);
    }
  }
}

class DotProductBenchmark extends BenchmarkBase {
  DotProductBenchmark() : super('Vector2.dot()');
  final Vector2 v1 = Vector2(100, 100);
  final Vector2 v2 = Vector2(100, 200);

  static void main() {
    DotProductBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100000; i++) {
      v1.dot(v2);
    }
  }
}

void main() {
  ConstructorBenchmark.main();
  ConstructorZeroBenchmark.main();
  ConstructorArrayBenchmark.main();
  ConstructorAllBenchmark.main();
  ConstructorCopyBenchmark.main();
  ConstructorFromFloat32ListBenchmark.main();
  ConstructorFromBufferBenchmark.main();
  ConstructorRandomBenchmark.main();
  SetFromBenchmark.main();
  DotProductBenchmark.main();
}
