// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math_matrix_bench;

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_operations.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class MatrixMultiplyBenchmark extends BenchmarkBase {
  MatrixMultiplyBenchmark() : super('MatrixMultiply');
  final Float32List A = Float32List(16);
  final Float32List B = Float32List(16);
  final Float32List C = Float32List(16);

  static void main() {
    MatrixMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44Operations.multiply(C, 0, A, 0, B, 0);
    }
  }
}

class SIMDMatrixMultiplyBenchmark extends BenchmarkBase {
  SIMDMatrixMultiplyBenchmark() : super('SIMDMatrixMultiply');
  final Float32x4List A = Float32x4List(4);
  final Float32x4List B = Float32x4List(4);
  final Float32x4List C = Float32x4List(4);

  static void main() {
    SIMDMatrixMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44SIMDOperations.multiply(C, 0, A, 0, B, 0);
    }
  }
}

class VectorTransformBenchmark extends BenchmarkBase {
  VectorTransformBenchmark() : super('VectorTransform');
  final Float32List A = Float32List(16);
  final Float32List B = Float32List(4);
  final Float32List C = Float32List(4);

  static void main() {
    VectorTransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44Operations.transform4(C, 0, A, 0, B, 0);
    }
  }
}

class SIMDVectorTransformBenchmark extends BenchmarkBase {
  SIMDVectorTransformBenchmark() : super('SIMDVectorTransform');
  final Float32x4List A = Float32x4List(4);
  final Float32x4List B = Float32x4List(1);
  final Float32x4List C = Float32x4List(1);

  static void main() {
    SIMDVectorTransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44SIMDOperations.transform4(C, 0, A, 0, B, 0);
    }
  }
}

class ViewMatrixBenchmark extends BenchmarkBase {
  ViewMatrixBenchmark() : super('setViewMatrix');

  final Matrix4 M = Matrix4.zero();
  final Vector3 P = Vector3.zero();
  final Vector3 F = Vector3.zero();
  final Vector3 U = Vector3.zero();

  static void main() {
    ViewMatrixBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      setViewMatrix(M, P, F, U);
    }
  }
}

class Aabb2TransformBenchmark extends BenchmarkBase {
  Aabb2TransformBenchmark() : super('aabb2Transform');

  static final Matrix3 M = Matrix3.rotationZ(math.pi / 4);
  static final Vector2 P1 = Vector2(10.0, 10.0);
  static final Vector2 P2 = Vector2(20.0, 30.0);
  static final Vector2 P3 = Vector2(100.0, 50.0);
  static final Aabb2 B1 = Aabb2.minMax(P1, P2);
  static final Aabb2 B2 = Aabb2.minMax(P1, P3);
  static final Aabb2 B3 = Aabb2.minMax(P2, P3);
  static final Aabb2 temp = Aabb2();

  static void main() {
    Aabb2TransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(B1);
      temp.transform(M);
      temp.copyFrom(B2);
      temp.transform(M);
      temp.copyFrom(B3);
      temp.transform(M);
    }
  }
}

class Aabb2RotateBenchmark extends BenchmarkBase {
  Aabb2RotateBenchmark() : super('aabb2Rotate');

  static final Matrix3 M = Matrix3.rotationZ(math.pi / 4);
  static final Vector2 P1 = Vector2(10.0, 10.0);
  static final Vector2 P2 = Vector2(20.0, 30.0);
  static final Vector2 P3 = Vector2(100.0, 50.0);
  static final Aabb2 B1 = Aabb2.minMax(P1, P2);
  static final Aabb2 B2 = Aabb2.minMax(P1, P3);
  static final Aabb2 B3 = Aabb2.minMax(P2, P3);
  static final Aabb2 temp = Aabb2();

  static void main() {
    Aabb2RotateBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(B1);
      temp.rotate(M);
      temp.copyFrom(B2);
      temp.rotate(M);
      temp.copyFrom(B3);
      temp.rotate(M);
    }
  }
}

class Aabb3TransformBenchmark extends BenchmarkBase {
  Aabb3TransformBenchmark() : super('aabb3Transform');

  static final Matrix4 M = Matrix4.rotationZ(math.pi / 4);
  static final Vector3 P1 = Vector3(10.0, 10.0, 0.0);
  static final Vector3 P2 = Vector3(20.0, 30.0, 1.0);
  static final Vector3 P3 = Vector3(100.0, 50.0, 10.0);
  static final Aabb3 B1 = Aabb3.minMax(P1, P2);
  static final Aabb3 B2 = Aabb3.minMax(P1, P3);
  static final Aabb3 B3 = Aabb3.minMax(P2, P3);
  static final Aabb3 temp = Aabb3();

  static void main() {
    Aabb3TransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(B1);
      temp.transform(M);
      temp.copyFrom(B2);
      temp.transform(M);
      temp.copyFrom(B3);
      temp.transform(M);
    }
  }
}

class Aabb3RotateBenchmark extends BenchmarkBase {
  Aabb3RotateBenchmark() : super('aabb3Rotate');

  static final Matrix4 M = Matrix4.rotationZ(math.pi / 4);
  static final Vector3 P1 = Vector3(10.0, 10.0, 0.0);
  static final Vector3 P2 = Vector3(20.0, 30.0, 1.0);
  static final Vector3 P3 = Vector3(100.0, 50.0, 10.0);
  static final Aabb3 B1 = Aabb3.minMax(P1, P2);
  static final Aabb3 B2 = Aabb3.minMax(P1, P3);
  static final Aabb3 B3 = Aabb3.minMax(P2, P3);
  static final Aabb3 temp = Aabb3();

  static void main() {
    Aabb3RotateBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(B1);
      temp.rotate(M);
      temp.copyFrom(B2);
      temp.rotate(M);
      temp.copyFrom(B3);
      temp.rotate(M);
    }
  }
}

class Matrix3DeterminantBenchmark extends BenchmarkBase {
  Matrix3DeterminantBenchmark() : super('Matrix3.determinant');

  final Matrix3 MX = Matrix3.rotationX(math.pi / 4);
  final Matrix3 MY = Matrix3.rotationY(math.pi / 4);
  final Matrix3 MZ = Matrix3.rotationZ(math.pi / 4);

  static void main() {
    Matrix3DeterminantBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 800; i++) {
      MX.determinant();
      MY.determinant();
      MZ.determinant();
    }
  }
}

class Matrix3TransformVector3Benchmark extends BenchmarkBase {
  Matrix3TransformVector3Benchmark() : super('Matrix3.transform(Vector3)');

  final Matrix3 MX = Matrix3.rotationX(math.pi / 4);
  final Matrix3 MY = Matrix3.rotationY(math.pi / 4);
  final Matrix3 MZ = Matrix3.rotationZ(math.pi / 4);
  final Vector3 V1 = Vector3(10.0, 20.0, 1.0);
  final Vector3 V2 = Vector3(-10.0, 20.0, 1.0);
  final Vector3 V3 = Vector3(10.0, -20.0, 1.0);

  static void main() {
    Matrix3TransformVector3Benchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 800; i++) {
      MX.transform(V1);
      MX.transform(V2);
      MX.transform(V3);
      MY.transform(V1);
      MY.transform(V2);
      MY.transform(V3);
      MZ.transform(V1);
      MZ.transform(V2);
      MZ.transform(V3);
    }
  }
}

class Matrix3TransformVector2Benchmark extends BenchmarkBase {
  Matrix3TransformVector2Benchmark() : super('Matrix3.transform(Vector2)');

  final Matrix3 MX = Matrix3.rotationX(math.pi / 4);
  final Matrix3 MY = Matrix3.rotationY(math.pi / 4);
  final Matrix3 MZ = Matrix3.rotationZ(math.pi / 4);
  final Vector2 V1 = Vector2(10.0, 20.0);
  final Vector2 V2 = Vector2(-10.0, 20.0);
  final Vector2 V3 = Vector2(10.0, -20.0);

  static void main() {
    Matrix3TransformVector2Benchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 800; i++) {
      MX.transform2(V1);
      MX.transform2(V2);
      MX.transform2(V3);
      MY.transform2(V1);
      MY.transform2(V2);
      MY.transform2(V3);
      MZ.transform2(V1);
      MZ.transform2(V2);
      MZ.transform2(V3);
    }
  }
}

class Matrix3TransposeMultiplyBenchmark extends BenchmarkBase {
  Matrix3TransposeMultiplyBenchmark() : super('Matrix3.transposeMultiply');

  final Matrix3 MX = Matrix3.rotationX(math.pi / 4);
  final Matrix3 MY = Matrix3.rotationY(math.pi / 4);
  final Matrix3 MZ = Matrix3.rotationZ(math.pi / 4);
  final Matrix3 temp = Matrix3.zero();

  static void main() {
    Matrix3TransposeMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.setIdentity();
      temp.transposeMultiply(MX);
      temp.transposeMultiply(MY);
      temp.transposeMultiply(MZ);
    }
  }
}

void main() {
  MatrixMultiplyBenchmark.main();
  SIMDMatrixMultiplyBenchmark.main();
  VectorTransformBenchmark.main();
  SIMDVectorTransformBenchmark.main();
  ViewMatrixBenchmark.main();
  Aabb2TransformBenchmark.main();
  Aabb2RotateBenchmark.main();
  Aabb3TransformBenchmark.main();
  Aabb3RotateBenchmark.main();
  Matrix3DeterminantBenchmark.main();
  Matrix3TransformVector3Benchmark.main();
  Matrix3TransformVector2Benchmark.main();
  Matrix3TransposeMultiplyBenchmark.main();
}
