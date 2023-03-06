// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of '../../vector_math.dart';

/// 3D Matrix.
/// Values are stored in column major order.
class Matrix3 {
  /// The components of the matrix.
  final Float32List storage;

  /// Solve [A] * [x] = [b].
  static void solve2(Matrix3 A, Vector2 x, Vector2 b) {
    final a11 = A.entry(0, 0);
    final a12 = A.entry(0, 1);
    final a21 = A.entry(1, 0);
    final a22 = A.entry(1, 1);
    final bx = b.x - A.storage[6];
    final by = b.y - A.storage[7];
    var det = a11 * a22 - a12 * a21;

    if (det != 0.0) {
      det = 1.0 / det;
    }

    x
      ..x = det * (a22 * bx - a12 * by)
      ..y = det * (a11 * by - a21 * bx);
  }

  /// Solve [A] * [x] = [b].
  static void solve(Matrix3 A, Vector3 x, Vector3 b) {
    final A0x = A.entry(0, 0);
    final A0y = A.entry(1, 0);
    final A0z = A.entry(2, 0);
    final A1x = A.entry(0, 1);
    final A1y = A.entry(1, 1);
    final A1z = A.entry(2, 1);
    final A2x = A.entry(0, 2);
    final A2y = A.entry(1, 2);
    final A2z = A.entry(2, 2);
    double rx, ry, rz;
    double det;

    // Column1 cross Column 2
    rx = A1y * A2z - A1z * A2y;
    ry = A1z * A2x - A1x * A2z;
    rz = A1x * A2y - A1y * A2x;

    // A.getColumn(0).dot(x)
    det = A0x * rx + A0y * ry + A0z * rz;
    if (det != 0.0) {
      det = 1.0 / det;
    }

    // b dot [Column1 cross Column 2]
    final x_ = det * (b.x * rx + b.y * ry + b.z * rz);

    // Column2 cross b
    rx = -(A2y * b.z - A2z * b.y);
    ry = -(A2z * b.x - A2x * b.z);
    rz = -(A2x * b.y - A2y * b.x);
    // Column0 dot -[Column2 cross b (Column3)]
    final y_ = det * (A0x * rx + A0y * ry + A0z * rz);

    // b cross Column 1
    rx = -(b.y * A1z - b.z * A1y);
    ry = -(b.z * A1x - b.x * A1z);
    rz = -(b.x * A1y - b.y * A1x);
    // Column0 dot -[b cross Column 1]
    final z_ = det * (A0x * rx + A0y * ry + A0z * rz);

    x
      ..x = x_
      ..y = y_
      ..z = z_;
  }

  /// New matrix with specified values.
  Matrix3(
    double arg0,
    double arg1,
    double arg2,
    double arg3,
    double arg4,
    double arg5,
    double arg6,
    double arg7,
    double arg8,
  ) : storage = Float32List(9)
          ..[0] = arg0
          ..[1] = arg1
          ..[2] = arg2
          ..[3] = arg3
          ..[4] = arg4
          ..[5] = arg5
          ..[6] = arg6
          ..[7] = arg7
          ..[8] = arg8;

  /// New matrix from [values].
  Matrix3.fromList(List<double> values)
      : storage = Float32List.fromList(values);

  /// Constructs a new [Matrix3] filled with zeros.
  Matrix3.zero() : storage = Float32List(9);

  /// Identity matrix.
  Matrix3.identity()
      : storage = Float32List(9)
          ..[0] = 1.0
          ..[4] = 1.0
          ..[8] = 1.0;

  /// Copes values from [other].
  Matrix3.copy(Matrix3 other) : storage = Float32List.fromList(other.storage);

  /// Constructs a new [Matrix3]from columns.
  Matrix3.columns(Vector3 arg0, Vector3 arg1, Vector3 arg2)
      : storage = Float32List(9)
          ..[0] = arg0[0]
          ..[1] = arg0[1]
          ..[2] = arg0[2]
          ..[3] = arg1[0]
          ..[4] = arg1[1]
          ..[5] = arg1[2]
          ..[6] = arg2[0]
          ..[7] = arg2[1]
          ..[8] = arg2[2];

  /// Outer product of [u] and [v].
  Matrix3.outer(Vector3 u, Vector3 v)
      : storage = Float32List(9)
          ..[0] = u[0] * v[0]
          ..[1] = u[0] * v[1]
          ..[2] = u[0] * v[2]
          ..[3] = u[1] * v[0]
          ..[4] = u[1] * v[1]
          ..[5] = u[1] * v[2]
          ..[6] = u[2] * v[0]
          ..[7] = u[2] * v[1]
          ..[8] = u[2] * v[2];

  /// Rotation of [radians] around X axis.
  factory Matrix3.rotationX(double radians) =>
      Matrix3.zero()..setRotationX(radians);

  /// Rotation of [radians] around Y axis.
  factory Matrix3.rotationY(double radians) =>
      Matrix3.zero()..setRotationY(radians);

  /// Rotation of [radians] around Z axis.
  factory Matrix3.rotationZ(double radians) =>
      Matrix3.zero()..setRotationZ(radians);

  /// Return index in storage for [row], [col] value.
  int index(int row, int col) => (col * 3) + row;

  /// Value at [row], [col].
  double entry(int row, int col) {
    assert((row >= 0) && (row < dimension));
    assert((col >= 0) && (col < dimension));

    return storage[index(row, col)];
  }

  /// Set value at [row], [col] to be [v].
  void setEntry(int row, int col, double v) {
    assert((row >= 0) && (row < dimension));
    assert((col >= 0) && (col < dimension));

    storage[index(row, col)] = v;
  }

  /// Sets the matrix with specified values.
  void setValues(double arg0, double arg1, double arg2, double arg3,
      double arg4, double arg5, double arg6, double arg7, double arg8) {
    storage[0] = arg0;
    storage[1] = arg1;
    storage[2] = arg2;
    storage[3] = arg3;
    storage[4] = arg4;
    storage[5] = arg5;
    storage[6] = arg6;
    storage[7] = arg7;
    storage[8] = arg8;
  }

  /// Sets the entire matrix to the column values.
  void setColumns(Vector3 arg0, Vector3 arg1, Vector3 arg2) {
    storage[0] = arg0[0];
    storage[1] = arg0[1];
    storage[2] = arg0[2];
    storage[3] = arg1[0];
    storage[4] = arg1[1];
    storage[5] = arg1[2];
    storage[6] = arg2[0];
    storage[7] = arg2[1];
    storage[8] = arg2[2];
  }

  /// Sets the entire matrix to the matrix in [other].
  void setFrom(Matrix3 other) {
    storage[0] = other.storage[0];
    storage[1] = other.storage[1];
    storage[2] = other.storage[2];
    storage[3] = other.storage[3];
    storage[4] = other.storage[4];
    storage[5] = other.storage[5];
    storage[6] = other.storage[6];
    storage[7] = other.storage[7];
    storage[8] = other.storage[8];
  }

  /// Set this to the outer product of [u] and [v].
  void setOuter(Vector3 u, Vector3 v) {
    storage[0] = u[0] * v[0];
    storage[1] = u[0] * v[1];
    storage[2] = u[0] * v[2];
    storage[3] = u[1] * v[0];
    storage[4] = u[1] * v[1];
    storage[5] = u[1] * v[2];
    storage[6] = u[2] * v[0];
    storage[7] = u[2] * v[1];
    storage[8] = u[2] * v[2];
  }

  /// Set the diagonal of the matrix.
  void splatDiagonal(double arg) {
    storage[0] = arg;
    storage[4] = arg;
    storage[8] = arg;
  }

  /// Set the diagonal of the matrix.
  void setDiagonal(Vector3 arg) {
    storage[0] = arg[0];
    storage[4] = arg[1];
    storage[8] = arg[2];
  }

  /// Sets the upper 2x2 of the matrix to be [arg].
  void setUpper2x2(Matrix2 arg) {
    storage[0] = arg[0];
    storage[1] = arg[1];
    storage[3] = arg[2];
    storage[4] = arg[3];
  }

  /// Returns a printable string
  @override
  String toString() => '[0] ${getRow(0)}\n[1] ${getRow(1)}\n[2] ${getRow(2)}\n';

  /// Dimension of the matrix.
  int get dimension => 3;

  /// Access the element of the matrix at the index [i].
  double operator [](int i) => storage[i];

  /// Set the element of the matrix at the index [i].
  void operator []=(int i, double v) {
    storage[i] = v;
  }

  /// Check if two matrices are the same.
  @override
  bool operator ==(Object other) =>
      (other is Matrix3) &&
      (storage[0] == other.storage[0]) &&
      (storage[1] == other.storage[1]) &&
      (storage[2] == other.storage[2]) &&
      (storage[3] == other.storage[3]) &&
      (storage[4] == other.storage[4]) &&
      (storage[5] == other.storage[5]) &&
      (storage[6] == other.storage[6]) &&
      (storage[7] == other.storage[7]) &&
      (storage[8] == other.storage[8]);

  @override
  int get hashCode => Object.hashAll(storage);

  /// Returns row 0
  Vector3 get row0 => getRow(0);

  /// Returns row 1
  Vector3 get row1 => getRow(1);

  /// Returns row 2
  Vector3 get row2 => getRow(2);

  /// Sets row 0 to [arg]
  set row0(Vector3 arg) => setRow(0, arg);

  /// Sets row 1 to [arg]
  set row1(Vector3 arg) => setRow(1, arg);

  /// Sets row 2 to [arg]
  set row2(Vector3 arg) => setRow(2, arg);

  /// Assigns the [row] of to [arg].
  void setRow(int row, Vector3 arg) {
    storage[index(row, 0)] = arg[0];
    storage[index(row, 1)] = arg[1];
    storage[index(row, 2)] = arg[2];
  }

  /// Gets the [row] of the matrix
  Vector3 getRow(int row) => Vector3(
        storage[index(row, 0)],
        storage[index(row, 1)],
        storage[index(row, 2)],
      );

  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, Vector3 arg) {
    final entry = column * 3;
    storage[entry + 2] = arg[2];
    storage[entry + 1] = arg[1];
    storage[entry + 0] = arg[0];
  }

  /// Gets the [column] of the matrix
  Vector3 getColumn(int column) {
    final entry = column * 3;
    return Vector3(storage[entry + 0], storage[entry + 1], storage[entry + 2]);
  }

  /// Clone of this.
  Matrix3 clone() => Matrix3.copy(this);

  /// Copy this into [other].
  Matrix3 copyInto(Matrix3 other) => other..setFrom(this);

  /// Returns a new vector or matrix by multiplying this with [other].
  dynamic operator *(dynamic other) {
    if (other is double) {
      return scaled(other);
    }
    if (other is Vector3) {
      return transformed(other);
    }
    if (other is Matrix3) {
      return multiplied(other);
    }
    throw ArgumentError(other);
  }

  /// Returns new matrix after component wise this + [other]
  Matrix3 operator +(Matrix3 other) => clone()..add(other);

  /// Returns new matrix after component wise this - [other]
  Matrix3 operator -(Matrix3 other) => clone()..sub(other);

  /// Returns new matrix -this
  Matrix3 operator -() => clone()..negate();

  /// Zeros this.
  void setZero() {
    storage[0] = 0.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = 0.0;
    storage[5] = 0.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 0.0;
  }

  /// Makes this into the identity matrix.
  void setIdentity() {
    storage[0] = 1.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = 1.0;
    storage[5] = 0.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 1.0;
  }

  /// Returns the tranpose of this.
  Matrix3 transposed() => clone()..transpose();

  /// Transpose this.
  void transpose() {
    double temp;
    temp = storage[3];
    storage[3] = storage[1];
    storage[1] = temp;
    temp = storage[6];
    storage[6] = storage[2];
    storage[2] = temp;
    temp = storage[7];
    storage[7] = storage[5];
    storage[5] = temp;
  }

  /// Returns the component wise absolute value of this.
  Matrix3 absolute() => Matrix3(
        storage[0].abs(),
        storage[1].abs(),
        storage[2].abs(),
        storage[3].abs(),
        storage[4].abs(),
        storage[5].abs(),
        storage[6].abs(),
        storage[7].abs(),
        storage[8].abs(),
      );

  /// Returns the determinant of this matrix.
  double determinant() {
    final x =
        storage[0] * ((storage[4] * storage[8]) - (storage[5] * storage[7]));
    final y =
        storage[1] * ((storage[3] * storage[8]) - (storage[5] * storage[6]));
    final z =
        storage[2] * ((storage[3] * storage[7]) - (storage[4] * storage[6]));
    return x - y + z;
  }

  /// Returns the dot product of row [i] and [v].
  double dotRow(int i, Vector3 v) =>
      storage[i] * v[0] + storage[3 + i] * v[1] + storage[6 + i] * v[2];

  /// Returns the dot product of column [j] and [v].
  double dotColumn(int j, Vector3 v) =>
      storage[j * 3] * v[0] +
      storage[j * 3 + 1] * v[1] +
      storage[j * 3 + 2] * v[2];

  /// Returns the trace of the matrix. The trace of a matrix is the sum of
  /// the diagonal entries.
  double trace() {
    var t = 0.0;
    t += storage[0];
    t += storage[4];
    t += storage[8];
    return t;
  }

  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    final row1 = storage[0].abs() + storage[1].abs() + storage[2].abs();
    final row2 = storage[3].abs() + storage[4].abs() + storage[5].abs();
    final row3 = storage[6].abs() + storage[7].abs() + storage[8].abs();
    return math.max(row1, math.max(row2, math.max(row3, 0)));
  }

  /// Returns relative error between this and [correct]
  double relativeError(Matrix3 correct) {
    final diff = correct - this;
    final correct_norm = correct.infinityNorm();
    final diff_norm = diff.infinityNorm();
    return diff_norm / correct_norm;
  }

  /// Returns absolute error between this and [correct]
  double absoluteError(Matrix3 correct) {
    final this_norm = infinityNorm();
    final correct_norm = correct.infinityNorm();
    final diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }

  /// Invert the matrix. Returns the determinant.
  double invert() => copyInverse(this);

  /// Set this matrix to be the inverse of [other]
  double copyInverse(Matrix3 other) {
    final det = other.determinant();
    if (det == 0.0) {
      setFrom(other);
      return 0.0;
    }
    final invDet = 1.0 / det;
    final ix = invDet *
        (other.storage[4] * other.storage[8] -
            other.storage[5] * other.storage[7]);
    final iy = invDet *
        (other.storage[2] * other.storage[7] -
            other.storage[1] * other.storage[8]);
    final iz = invDet *
        (other.storage[1] * other.storage[5] -
            other.storage[2] * other.storage[4]);
    final jx = invDet *
        (other.storage[5] * other.storage[6] -
            other.storage[3] * other.storage[8]);
    final jy = invDet *
        (other.storage[0] * other.storage[8] -
            other.storage[2] * other.storage[6]);
    final jz = invDet *
        (other.storage[2] * other.storage[3] -
            other.storage[0] * other.storage[5]);
    final kx = invDet *
        (other.storage[3] * other.storage[7] -
            other.storage[4] * other.storage[6]);
    final ky = invDet *
        (other.storage[1] * other.storage[6] -
            other.storage[0] * other.storage[7]);
    final kz = invDet *
        (other.storage[0] * other.storage[4] -
            other.storage[1] * other.storage[3]);
    storage[0] = ix;
    storage[1] = iy;
    storage[2] = iz;
    storage[3] = jx;
    storage[4] = jy;
    storage[5] = jz;
    storage[6] = kx;
    storage[7] = ky;
    storage[8] = kz;
    return det;
  }

  /// Set this matrix to be the normal matrix of [arg].
  void copyNormalMatrix(Matrix4 arg) {
    copyInverse(arg.getRotation());
    transpose();
  }

  /// Turns the matrix into a rotation of [radians] around X
  void setRotationX(double radians) {
    final c = math.cos(radians);
    final s = math.sin(radians);
    storage[0] = 1.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = c;
    storage[5] = s;
    storage[6] = 0.0;
    storage[7] = -s;
    storage[8] = c;
  }

  /// Turns the matrix into a rotation of [radians] around Y
  void setRotationY(double radians) {
    final c = math.cos(radians);
    final s = math.sin(radians);
    storage[0] = c;
    storage[1] = 0.0;
    storage[2] = s;
    storage[3] = 0.0;
    storage[4] = 1.0;
    storage[5] = 0.0;
    storage[6] = -s;
    storage[7] = 0.0;
    storage[8] = c;
  }

  /// Turns the matrix into a rotation of [radians] around Z
  void setRotationZ(double radians) {
    final c = math.cos(radians);
    final s = math.sin(radians);
    storage[0] = c;
    storage[1] = s;
    storage[2] = 0.0;
    storage[3] = -s;
    storage[4] = c;
    storage[5] = 0.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 1.0;
  }

  /// Converts into Adjugate matrix and scales by [scale]
  void scaleAdjoint(double scale) {
    final m00 = storage[0];
    final m01 = storage[3];
    final m02 = storage[6];
    final m10 = storage[1];
    final m11 = storage[4];
    final m12 = storage[7];
    final m20 = storage[2];
    final m21 = storage[5];
    final m22 = storage[8];
    storage[0] = (m11 * m22 - m12 * m21) * scale;
    storage[1] = (m12 * m20 - m10 * m22) * scale;
    storage[2] = (m10 * m21 - m11 * m20) * scale;
    storage[3] = (m02 * m21 - m01 * m22) * scale;
    storage[4] = (m00 * m22 - m02 * m20) * scale;
    storage[5] = (m01 * m20 - m00 * m21) * scale;
    storage[6] = (m01 * m12 - m02 * m11) * scale;
    storage[7] = (m02 * m10 - m00 * m12) * scale;
    storage[8] = (m00 * m11 - m01 * m10) * scale;
  }

  /// Rotates [arg] by the absolute rotation of this
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  Vector3 absoluteRotate(Vector3 arg) {
    final m00 = storage[0].abs();
    final m01 = storage[3].abs();
    final m02 = storage[6].abs();
    final m10 = storage[1].abs();
    final m11 = storage[4].abs();
    final m12 = storage[7].abs();
    final m20 = storage[2].abs();
    final m21 = storage[5].abs();
    final m22 = storage[8].abs();
    final x = arg[0];
    final y = arg[1];
    final z = arg[2];
    arg[0] = x * m00 + y * m01 + z * m02;
    arg[1] = x * m10 + y * m11 + z * m12;
    arg[2] = x * m20 + y * m21 + z * m22;
    return arg;
  }

  /// Rotates [arg] by the absolute rotation of this
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  Vector2 absoluteRotate2(Vector2 arg) {
    final m00 = storage[0].abs();
    final m01 = storage[3].abs();
    final m10 = storage[1].abs();
    final m11 = storage[4].abs();
    final x = arg[0];
    final y = arg[1];
    arg[0] = x * m00 + y * m01;
    arg[1] = x * m10 + y * m11;
    return arg;
  }

  /// Transforms [arg] with this.
  Vector2 transform2(Vector2 arg) => arg
    ..setValues(
      (storage[0] * arg[0]) + (storage[3] * arg[1]) + storage[6],
      (storage[1] * arg[0]) + (storage[4] * arg[1]) + storage[7],
    );

  /// Scales this by [scale].
  void scale(double scale) {
    storage[0] *= scale;
    storage[1] *= scale;
    storage[2] *= scale;
    storage[3] *= scale;
    storage[4] *= scale;
    storage[5] *= scale;
    storage[6] *= scale;
    storage[7] *= scale;
    storage[8] *= scale;
  }

  /// Create a copy of this and scale it by [scale].
  Matrix3 scaled(double scale) => clone()..scale(scale);

  /// Add [other] to this.
  void add(Matrix3 other) {
    storage[0] += other.storage[0];
    storage[1] += other.storage[1];
    storage[2] += other.storage[2];
    storage[3] += other.storage[3];
    storage[4] += other.storage[4];
    storage[5] += other.storage[5];
    storage[6] += other.storage[6];
    storage[7] += other.storage[7];
    storage[8] += other.storage[8];
  }

  /// Subtract [other] from this.
  void sub(Matrix3 other) {
    storage[0] -= other.storage[0];
    storage[1] -= other.storage[1];
    storage[2] -= other.storage[2];
    storage[3] -= other.storage[3];
    storage[4] -= other.storage[4];
    storage[5] -= other.storage[5];
    storage[6] -= other.storage[6];
    storage[7] -= other.storage[7];
    storage[8] -= other.storage[8];
  }

  /// Negate this.
  void negate() {
    storage[0] *= -1;
    storage[1] *= -1;
    storage[2] *= -1;
    storage[3] *= -1;
    storage[4] *= -1;
    storage[5] *= -1;
    storage[6] *= -1;
    storage[7] *= -1;
    storage[8] *= -1;
  }

  /// Multiply this by [other].
  void multiply(Matrix3 other) {
    final m00 = storage[0];
    final m01 = storage[3];
    final m02 = storage[6];
    final m10 = storage[1];
    final m11 = storage[4];
    final m12 = storage[7];
    final m20 = storage[2];
    final m21 = storage[5];
    final m22 = storage[8];
    final n00 = other.storage[0];
    final n01 = other.storage[3];
    final n02 = other.storage[6];
    final n10 = other.storage[1];
    final n11 = other.storage[4];
    final n12 = other.storage[7];
    final n20 = other.storage[2];
    final n21 = other.storage[5];
    final n22 = other.storage[8];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20);
    storage[3] = (m00 * n01) + (m01 * n11) + (m02 * n21);
    storage[6] = (m00 * n02) + (m01 * n12) + (m02 * n22);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20);
    storage[4] = (m10 * n01) + (m11 * n11) + (m12 * n21);
    storage[7] = (m10 * n02) + (m11 * n12) + (m12 * n22);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20);
    storage[5] = (m20 * n01) + (m21 * n11) + (m22 * n21);
    storage[8] = (m20 * n02) + (m21 * n12) + (m22 * n22);
  }

  /// Create a copy of this and multiply it by [other].
  Matrix3 multiplied(Matrix3 other) => clone()..multiply(other);

  void transposeMultiply(Matrix3 other) {
    final m00 = storage[0];
    final m01 = storage[1];
    final m02 = storage[2];
    final m10 = storage[3];
    final m11 = storage[4];
    final m12 = storage[5];
    final m20 = storage[6];
    final m21 = storage[7];
    final m22 = storage[8];
    final n00 = other.storage[0];
    final n01 = other.storage[3];
    final n02 = other.storage[6];
    final n10 = other.storage[1];
    final n11 = other.storage[4];
    final n12 = other.storage[7];
    final n20 = other.storage[2];
    final n21 = other.storage[5];
    final n22 = other.storage[8];
    storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20);
    storage[3] = (m00 * n01) + (m01 * n11) + (m02 * n21);
    storage[6] = (m00 * n02) + (m01 * n12) + (m02 * n22);
    storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20);
    storage[4] = (m10 * n01) + (m11 * n11) + (m12 * n21);
    storage[7] = (m10 * n02) + (m11 * n12) + (m12 * n22);
    storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20);
    storage[5] = (m20 * n01) + (m21 * n11) + (m22 * n21);
    storage[8] = (m20 * n02) + (m21 * n12) + (m22 * n22);
  }

  void multiplyTranspose(Matrix3 other) {
    final m00 = storage[0];
    final m01 = storage[3];
    final m02 = storage[6];
    final m10 = storage[1];
    final m11 = storage[4];
    final m12 = storage[7];
    final m20 = storage[2];
    final m21 = storage[5];
    final m22 = storage[8];
    final n00 = other.storage[0];
    final n01 = other.storage[3];
    final n02 = other.storage[6];
    final n10 = other.storage[1];
    final n11 = other.storage[4];
    final n12 = other.storage[7];
    final n20 = other.storage[2];
    final n21 = other.storage[5];
    final n22 = other.storage[8];
    storage[0] = (m00 * n00) + (m01 * n01) + (m02 * n02);
    storage[3] = (m00 * n10) + (m01 * n11) + (m02 * n12);
    storage[6] = (m00 * n20) + (m01 * n21) + (m02 * n22);
    storage[1] = (m10 * n00) + (m11 * n01) + (m12 * n02);
    storage[4] = (m10 * n10) + (m11 * n11) + (m12 * n12);
    storage[7] = (m10 * n20) + (m11 * n21) + (m12 * n22);
    storage[2] = (m20 * n00) + (m21 * n01) + (m22 * n02);
    storage[5] = (m20 * n10) + (m21 * n11) + (m22 * n12);
    storage[8] = (m20 * n20) + (m21 * n21) + (m22 * n22);
  }

  /// Transform [arg] of type [Vector3] using the transformation defined by
  /// this.
  Vector3 transform(Vector3 arg) => arg
    ..setValues(
      (storage[0] * arg[0]) + (storage[3] * arg[1]) + (storage[6] * arg[2]),
      (storage[1] * arg[0]) + (storage[4] * arg[1]) + (storage[7] * arg[2]),
      (storage[2] * arg[0]) + (storage[5] * arg[1]) + (storage[8] * arg[2]),
    );

  /// Transform a copy of [arg] of type [Vector3] using the transformation
  /// defined by this. If a [out] parameter is supplied, the copy is stored in
  /// [out].
  Vector3 transformed(Vector3 arg, [Vector3? out]) {
    final outLocal = (out?..setFrom(arg)) ?? arg.clone();
    return transform(outLocal);
  }

  /// Copies this into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset = 0]) {
    array[offset + 0] = storage[0];
    array[offset + 1] = storage[1];
    array[offset + 2] = storage[2];
    array[offset + 3] = storage[3];
    array[offset + 4] = storage[4];
    array[offset + 5] = storage[5];
    array[offset + 6] = storage[6];
    array[offset + 7] = storage[7];
    array[offset + 8] = storage[8];
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    storage[0] = array[offset + 0];
    storage[1] = array[offset + 1];
    storage[2] = array[offset + 2];
    storage[3] = array[offset + 3];
    storage[4] = array[offset + 4];
    storage[5] = array[offset + 5];
    storage[6] = array[offset + 6];
    storage[7] = array[offset + 7];
    storage[8] = array[offset + 8];
  }

  /// Multiply this to each set of xyz values in [array] starting at [offset].
  List<double> applyToVector3Array(List<double> array, [int offset = 0]) {
    for (var i = 0, j = offset; i < array.length; i += 3, j += 3) {
      final v = Vector3.array(array, j)..applyMatrix3(this);
      array[j] = v[0];
      array[j + 1] = v[1];
      array[j + 2] = v[2];
    }

    return array;
  }

  Vector3 get right => Vector3(storage[0], storage[1], storage[2]);

  Vector3 get up => Vector3(storage[3], storage[4], storage[5]);

  Vector3 get forward => Vector3(storage[6], storage[7], storage[8]);

  /// Is this the identity matrix?
  bool isIdentity() =>
      storage[0] == 1.0 // col 1
      &&
      storage[1] == 0.0 &&
      storage[2] == 0.0 &&
      storage[3] == 0.0 // col 2
      &&
      storage[4] == 1.0 &&
      storage[5] == 0.0 &&
      storage[6] == 0.0 // col 3
      &&
      storage[7] == 0.0 &&
      storage[8] == 1.0;

  /// Is this the zero matrix?
  bool isZero() =>
      storage[0] == 0.0 // col 1
      &&
      storage[1] == 0.0 &&
      storage[2] == 0.0 &&
      storage[3] == 0.0 // col 2
      &&
      storage[4] == 0.0 &&
      storage[5] == 0.0 &&
      storage[6] == 0.0 // col 3
      &&
      storage[7] == 0.0 &&
      storage[8] == 0.0;
}
