// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math_matrix_bench;

import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_operations.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class MatrixMultiplyBenchmark extends BenchmarkBase {
  MatrixMultiplyBenchmark() : super("MatrixMultiply");
  final Float32List A = new Float32List(16);
  final Float32List B = new Float32List(16);
  final Float32List C = new Float32List(16);

  static void main() {
    new MatrixMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 200; i++) {
      Matrix44Operations.multiply(C, 0, A, 0, B, 0);
    }
  }
}

class SIMDMatrixMultiplyBenchmark extends BenchmarkBase {
  SIMDMatrixMultiplyBenchmark() : super("SIMDMatrixMultiply");
  final Float32x4List A = new Float32x4List(4);
  final Float32x4List B = new Float32x4List(4);
  final Float32x4List C = new Float32x4List(4);

  static void main() {
    new SIMDMatrixMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 200; i++) {
      Matrix44SIMDOperations.multiply(C, 0, A, 0, B, 0);
    }
  }
}

class VectorTransformBenchmark extends BenchmarkBase {
  VectorTransformBenchmark() : super("VectorTransform");
  final Float32List A = new Float32List(16);
  final Float32List B = new Float32List(4);
  final Float32List C = new Float32List(4);

  static void main() {
    new VectorTransformBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 200; i++) {
      Matrix44Operations.transform4(C, 0, A, 0, B, 0);
    }
  }
}

class SIMDVectorTransformBenchmark extends BenchmarkBase {
  SIMDVectorTransformBenchmark() : super("SIMDVectorTransform");
  final Float32x4List A = new Float32x4List(4);
  final Float32x4List B = new Float32x4List(1);
  final Float32x4List C = new Float32x4List(1);

  static void main() {
    new SIMDVectorTransformBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 200; i++) {
      Matrix44SIMDOperations.transform4(C, 0, A, 0, B, 0);
    }
  }
}

class ViewMatrixBenchmark extends BenchmarkBase {
  ViewMatrixBenchmark() : super("setViewMatrix");

  final Matrix4 M = new Matrix4.zero();
  final Vector3 P = new Vector3.zero();
  final Vector3 F = new Vector3.zero();
  final Vector3 U = new Vector3.zero();

  static void main() {
    new ViewMatrixBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 100; i++) {
      setViewMatrix(M, P, F, U);
    }
  }
}

void main() {
  MatrixMultiplyBenchmark.main();
  SIMDMatrixMultiplyBenchmark.main();
  VectorTransformBenchmark.main();
  SIMDVectorTransformBenchmark.main();
  ViewMatrixBenchmark.main();
}
