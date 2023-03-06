// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of '../../vector_math.dart';

/// 2D Matrix.
/// Values are stored in column major order.
class Matrix2 {
  /// The components of the matrix.
  final Float32List storage;

  /// Solve [A] * [x] = [b].
  static void solve(Matrix2 A, Vector2 x, Vector2 b) {
    final a11 = A.entry(0, 0);
    final a12 = A.entry(0, 1);
    final a21 = A.entry(1, 0);
    final a22 = A.entry(1, 1);
    final bx = b.x;
    final by = b.y;
    var det = a11 * a22 - a12 * a21;

    if (det != 0.0) {
      det = 1.0 / det;
    }

    x
      ..x = det * (a22 * bx - a12 * by)
      ..y = det * (a11 * by - a21 * bx);
  }

  /// New matrix with specified values.
  Matrix2(double arg0, double arg1, double arg2, double arg3)
      : storage = Float32List(4)
          ..[0] = arg0
          ..[1] = arg1
          ..[2] = arg2
          ..[3] = arg3;

  /// New matrix from [values].
  Matrix2.fromList(List<double> values)
      : storage = Float32List.fromList(values);

  /// Zero matrix.
  Matrix2.zero() : storage = Float32List(4);

  /// Identity matrix.
  Matrix2.identity()
      : storage = Float32List(4)
          ..[0] = 1
          ..[3] = 1;

  /// Copies values from [other].
  Matrix2.copy(Matrix2 other) : storage = Float32List.fromList(other.storage);

  /// Matrix with values from column arguments.
  Matrix2.columns(Vector2 arg0, Vector2 arg1)
      : storage = Float32List(4)
          ..[0] = arg0[0]
          ..[1] = arg0[1]
          ..[2] = arg1[0]
          ..[3] = arg1[1];

  /// Outer product of [u] and [v].
  Matrix2.outer(Vector2 u, Vector2 v)
      : storage = Float32List(4)
          ..[0] = u[0] * v[0]
          ..[1] = u[0] * v[1]
          ..[2] = u[1] * v[0]
          ..[3] = u[1] * v[1];

  /// Rotation of [radians].
  factory Matrix2.rotation(double radians) =>
      Matrix2.zero()..setRotation(radians);

  /// Return index in storage for [row], [col] value.
  int index(int row, int col) => (col * 2) + row;

  /// Value at [row], [col].
  double entry(int row, int col) {
    assert((row >= 0) && (row < dimension));
    assert((col >= 0) && (col < dimension));

    return this[index(row, col)];
  }

  /// Set value at [row], [col] to be [v].
  void setEntry(int row, int col, double v) {
    assert((row >= 0) && (row < dimension));
    assert((col >= 0) && (col < dimension));

    this[index(row, col)] = v;
  }

  /// Sets the matrix with specified values.
  void setValues(double arg0, double arg1, double arg2, double arg3) {
    this[0] = arg0;
    this[1] = arg1;
    this[2] = arg2;
    this[3] = arg3;
  }

  /// Sets the entire matrix to the column values.
  void setColumns(Vector2 arg0, Vector2 arg1) {
    this[0] = arg0[0];
    this[1] = arg0[1];
    this[2] = arg1[0];
    this[3] = arg1[1];
  }

  /// Sets the entire matrix to the matrix in [other].
  void setFrom(Matrix2 other) {
    this[3] = other[3];
    this[2] = other[2];
    this[1] = other[1];
    this[0] = other[0];
  }

  /// Set this to the outer product of [u] and [v].
  void setOuter(Vector2 u, Vector2 v) {
    this[0] = u[0] * v[0];
    this[1] = u[0] * v[1];
    this[2] = u[1] * v[0];
    this[3] = u[1] * v[1];
  }

  /// Sets the diagonal to [arg].
  void splatDiagonal(double arg) {
    this[0] = arg;
    this[3] = arg;
  }

  /// Sets the diagonal of the matrix to be [arg].
  void setDiagonal(Vector2 arg) {
    this[0] = arg[0];
    this[3] = arg[1];
  }

  /// Returns a printable string
  @override
  String toString() => '[0] ${getRow(0)}\n[1] ${getRow(1)}\n';

  /// Dimension of the matrix.
  int get dimension => 2;

  /// Access the element of the matrix at the index [i].
  double operator [](int i) => storage[i];

  /// Set the element of the matrix at the index [i].
  void operator []=(int i, double v) {
    storage[i] = v;
  }

  /// Check if two matrices are the same.
  @override
  bool operator ==(Object other) =>
      (other is Matrix2) &&
      (this[0] == other[0]) &&
      (this[1] == other[1]) &&
      (this[2] == other[2]) &&
      (this[3] == other[3]);

  @override
  int get hashCode => Object.hashAll(storage);

  /// Returns row 0
  Vector2 get row0 => getRow(0);

  /// Returns row 1
  Vector2 get row1 => getRow(1);

  /// Sets row 0 to [arg]
  set row0(Vector2 arg) => setRow(0, arg);

  /// Sets row 1 to [arg]
  set row1(Vector2 arg) => setRow(1, arg);

  /// Sets [row] of the matrix to values in [arg]
  void setRow(int row, Vector2 arg) {
    this[index(row, 0)] = arg[0];
    this[index(row, 1)] = arg[1];
  }

  /// Gets the [row] of the matrix
  Vector2 getRow(int row) => Vector2(this[index(row, 0)], this[index(row, 1)]);

  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, Vector2 arg) {
    final entry = column * 2;
    this[entry + 1] = arg[1];
    this[entry + 0] = arg[0];
  }

  /// Gets the [column] of the matrix
  Vector2 getColumn(int column) {
    final entry = column * 2;
    return Vector2(this[entry + 0], this[entry + 1]);
  }

  /// Create a copy of this.
  Matrix2 clone() => Matrix2.copy(this);

  /// Copy this into [other].
  Matrix2 copyInto(Matrix2 other) => other..setFrom(this);

  /// Returns a new vector or matrix by multiplying this with [other].
  dynamic operator *(dynamic other) {
    if (other is double) {
      return scaled(other);
    }
    if (other is Vector2) {
      return transformed(other);
    }
    if (other is Matrix2) {
      return multiplied(other);
    }
    throw ArgumentError(other);
  }

  /// Returns new matrix after component wise this + [other]
  Matrix2 operator +(Matrix2 other) => clone()..add(other);

  /// Returns new matrix after component wise this - [other]
  Matrix2 operator -(Matrix2 other) => clone()..sub(other);

  /// Returns new matrix -this
  Matrix2 operator -() => clone()..negate();

  /// Zeros this.
  void setZero() {
    this[0] = 0.0;
    this[1] = 0.0;
    this[2] = 0.0;
    this[3] = 0.0;
  }

  /// Makes this into the identity matrix.
  void setIdentity() {
    this[0] = 1.0;
    this[1] = 0.0;
    this[2] = 0.0;
    this[3] = 1.0;
  }

  /// Returns the tranpose of this.
  Matrix2 transposed() => clone()..transpose();

  void transpose() {
    final temp = this[2];
    this[2] = this[1];
    this[1] = temp;
  }

  /// Returns the component wise absolute value of this.
  Matrix2 absolute() =>
      Matrix2(this[0].abs(), this[1].abs(), this[3].abs(), this[3].abs());

  /// Returns the determinant of this matrix.
  double determinant() => (this[0] * this[3]) - (this[1] * this[2]);

  /// Returns the dot product of row [i] and [v].
  double dotRow(int i, Vector2 v) => this[i] * v[0] + this[2 + i] * v[1];

  /// Returns the dot product of column [j] and [v].
  double dotColumn(int j, Vector2 v) =>
      this[j * 2] * v[0] + this[(j * 2) + 1] * v[1];

  /// Trace of the matrix.
  double trace() => this[0] + this[3];

  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    final result = math.max(
      this[0].abs() + this[1].abs(),
      this[2].abs() + this[3].abs(),
    );
    return result > 0 ? result : 0;
  }

  /// Returns relative error between this and [correct]
  double relativeError(Matrix2 correct) {
    final diff = correct - this;
    final correctNorm = correct.infinityNorm();
    final diffNorm = diff.infinityNorm();
    return diffNorm / correctNorm;
  }

  /// Returns absolute error between this and [correct]
  double absoluteError(Matrix2 correct) =>
      (infinityNorm() - correct.infinityNorm()).abs();

  /// Invert the matrix. Returns the determinant.
  double invert() {
    final det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    final invDet = 1.0 / det;
    final temp = this[0];
    this[0] = this[3] * invDet;
    this[1] = -this[1] * invDet;
    this[2] = -this[2] * invDet;
    this[3] = temp * invDet;
    return det;
  }

  /// Set this matrix to be the inverse of [other]
  double copyInverse(Matrix2 other) {
    final det = other.determinant();
    if (det == 0.0) {
      setFrom(other);
      return 0.0;
    }
    final invDet = 1.0 / det;
    this[0] = other[3] * invDet;
    this[1] = -other[1] * invDet;
    this[2] = -other[2] * invDet;
    this[3] = other[0] * invDet;
    return det;
  }

  /// Turns the matrix into a rotation of [radians]
  void setRotation(double radians) {
    final c = math.cos(radians);
    final s = math.sin(radians);
    this[0] = c;
    this[1] = s;
    this[2] = -s;
    this[3] = c;
  }

  /// Converts into Adjugate matrix and scales by [scale]
  void scaleAdjoint(double scale) {
    final temp = this[0];
    this[0] = this[3] * scale;
    this[2] = -this[2] * scale;
    this[1] = -this[1] * scale;
    this[3] = temp * scale;
  }

  /// Scale this by [scale].
  void scale(double scale) {
    this[0] *= scale;
    this[1] *= scale;
    this[2] *= scale;
    this[3] *= scale;
  }

  /// Create a copy of this scaled by [scale].
  Matrix2 scaled(double scale) => clone()..scale(scale);

  /// Add [other] to this.
  void add(Matrix2 other) {
    this[0] += other[0];
    this[1] += other[1];
    this[2] += other[2];
    this[3] += other[3];
  }

  /// Subtract [other] from this.
  void sub(Matrix2 other) {
    this[0] -= other[0];
    this[1] -= other[1];
    this[2] -= other[2];
    this[3] -= other[3];
  }

  /// Negate this.
  void negate() {
    this[0] *= -1;
    this[1] *= -1;
    this[2] *= -1;
    this[3] *= -1;
  }

  /// Multiply this with [other] and store it in this.
  void multiply(Matrix2 other) {
    final m00 = this[0];
    final m01 = this[2];
    final m10 = this[1];
    final m11 = this[3];
    final n00 = other[0];
    final n01 = other[2];
    final n10 = other[1];
    final n11 = other[3];
    this[0] = (m00 * n00) + (m01 * n10);
    this[2] = (m00 * n01) + (m01 * n11);
    this[1] = (m10 * n00) + (m11 * n10);
    this[3] = (m10 * n01) + (m11 * n11);
  }

  /// Multiply this with [other] and return the product.
  Matrix2 multiplied(Matrix2 other) => clone()..multiply(other);

  /// Multiply a transposed this with [other].
  void transposeMultiply(Matrix2 other) {
    final m00 = this[0];
    final m01 = this[1];
    final m10 = this[2];
    final m11 = this[3];
    this[0] = (m00 * other[0]) + (m01 * other[1]);
    this[2] = (m00 * other[2]) + (m01 * other[3]);
    this[1] = (m10 * other[0]) + (m11 * other[1]);
    this[3] = (m10 * other[2]) + (m11 * other[3]);
  }

  /// Multiply this with a transposed [other].
  void multiplyTranspose(Matrix2 other) {
    final m00 = this[0];
    final m01 = this[2];
    final m10 = this[1];
    final m11 = this[3];
    this[0] = (m00 * other[0]) + (m01 * other[2]);
    this[2] = (m00 * other[1]) + (m01 * other[3]);
    this[1] = (m10 * other[0]) + (m11 * other[2]);
    this[3] = (m10 * other[1]) + (m11 * other[3]);
  }

  /// Transform [arg] of type [Vector2] using the transformation defined by
  /// this.
  Vector2 transform(Vector2 arg) {
    final x = (this[0] * arg[0]) + (this[2] * arg[1]);
    final y = (this[1] * arg[0]) + (this[3] * arg[1]);
    return arg..setValues(x, y);
  }

  /// Transform a copy of [arg] of type [Vector2] using the transformation
  /// defined by this. If a [out] parameter is supplied, the copy is stored in
  /// [out].
  Vector2 transformed(Vector2 arg, [Vector2? out]) {
    final outLocal = (out?..setFrom(arg)) ?? arg.clone();
    return transform(outLocal);
  }

  /// Copies this into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset = 0]) {
    array[offset + 3] = this[3];
    array[offset + 2] = this[2];
    array[offset + 1] = this[1];
    array[offset + 0] = this[0];
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    this[0] = array[offset + 0];
    this[1] = array[offset + 1];
    this[2] = array[offset + 2];
    this[3] = array[offset + 3];
  }
}
