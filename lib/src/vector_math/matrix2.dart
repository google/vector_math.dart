/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/

part of vector_math;

/// 2D Matrix.
/// Values are stored in column major order.
class Matrix2 {
  final Float32List storage = new Float32List(4);

  /// Solve [A] * [x] = [b].
  static void solve(Matrix2 A, Vector2 x, Vector2 b) {
    final double a11 = A.entry(0, 0);
    final double a12 = A.entry(0, 1);
    final double a21 = A.entry(1, 0);
    final double a22 = A.entry(1, 1);
    final double bx = b.x;
    final double by = b.y;
    double det = a11 * a22 - a12 * a21;

    if (det != 0.0) {
      det = 1.0 / det;
    }

    x.x = det * (a22 * bx - a12 * by);
    x.y = det * (a11 * by - a21 * bx);
  }

  /// Return index in storage for [row], [col] value.
  int index(int row, int col) => (col * 2) + row;

  /// Value at [row], [col].
  double entry(int row, int col) => storage[index(row, col)];

  /// Set value at [row], [col] to be [v].
  setEntry(int row, int col, double v) { storage[index(row, col)] = v; }

  /// New matrix with specified values.
  Matrix2(double arg0, double arg1, double arg2, double arg3) {
    setValues(arg0, arg1, arg2, arg3);
  }

  /// Zero matrix.
  Matrix2.zero();

  /// Identity matrix.
  Matrix2.identity() {
    setIdentity();
  }

  /// Copies values from [other].
  Matrix2.copy(Matrix2 other) {
    setFrom(other);
  }

  /// Matrix with values from column arguments.
  Matrix2.columns(Vector2 arg0, Vector2 arg1) {
    setColumns(arg0, arg1);
  }

  /// Outer product of [u] and [v].
  Matrix2.outer(Vector2 u, Vector2 v) {
    storage[0] = u.storage[0] * v.storage[0];
    storage[1] = u.storage[0] * v.storage[1];
    storage[2] = u.storage[1] * v.storage[0];
    storage[3] = u.storage[1] * v.storage[1];
  }

  /// Rotation of [radians_].
  Matrix2.rotation(double radians_) {
    setRotation(radians_);
  }

  /// Sets the matrix with specified values.
  Matrix2 setValues(double arg0, double arg1, double arg2, double arg3) {
    storage[3] = arg3;
    storage[2] = arg2;
    storage[1] = arg1;
    storage[0] = arg0;
    return this;
  }

  /// Sets the entire matrix to the column values.
  Matrix2 setColumns(Vector2 arg0, Vector2 arg1) {
    storage[0] = arg0.storage[0];
    storage[1] = arg0.storage[1];
    storage[2] = arg1.storage[0];
    storage[3] = arg1.storage[1];
    return this;
  }

  /// Sets the entire matrix to the matrix in [arg].
  Matrix2 setFrom(Matrix2 arg) {
    storage[3] = arg.storage[3];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[0];
    return this;
  }

  /// Sets the diagonal to [arg].
  Matrix2 splatDiagonal(double arg) {
    storage[0] = arg;
    storage[3] = arg;
    return this;
  }

  /// Sets the diagonal of the matrix to be [arg].
  Matrix2 setDiagonal(Vector2 arg) {
    storage[0] = arg.storage[0];
    storage[3] = arg.storage[1];
    return this;
  }

  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    return s;
  }

  /// Dimension of the matrix.
  int get dimension => 2;

  double operator[](int i) => storage[i];

  void operator[]=(int i, double v) { storage[i] = v; }
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
    storage[index(row, 0)] = arg.storage[0];
    storage[index(row, 1)] = arg.storage[1];
  }

  /// Gets the [row] of the matrix
  Vector2 getRow(int row) {
    Vector2 r = new Vector2.zero();
    r.storage[0] = storage[index(row, 0)];
    r.storage[1] = storage[index(row, 1)];
    return r;
  }

  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, Vector2 arg) {
    int entry = column * 2;
    storage[entry + 1] = arg.storage[1];
    storage[entry + 0] = arg.storage[0];
  }

  /// Gets the [column] of the matrix
  Vector2 getColumn(int column) {
    Vector2 r = new Vector2.zero();
    int entry = column * 2;
    r.storage[1] = storage[entry + 1];
    r.storage[0] = storage[entry + 0];
    return r;
  }

  Matrix2 clone() {
    return new Matrix2.copy(this);
  }

  Matrix2 copyInto(Matrix2 arg) {
    arg.storage[0] = storage[0];
    arg.storage[1] = storage[1];
    arg.storage[2] = storage[2];
    arg.storage[3] = storage[3];
    return arg;
  }

  // TODO: Clean up functions below here.
  Matrix2 _mul_scale(double arg) {
    Matrix2 r = new Matrix2.zero();
    r.storage[3] = storage[3] * arg;
    r.storage[2] = storage[2] * arg;
    r.storage[1] = storage[1] * arg;
    r.storage[0] = storage[0] * arg;
    return r;
  }

  Matrix2 _mul_matrix(Matrix2 arg) {
    var r = new Matrix2.zero();
    r.storage[0] = (storage[0] * arg.storage[0]) +
                    (storage[2] * arg.storage[1]);
    r.storage[2] = (storage[0] * arg.storage[2]) +
                    (storage[2] * arg.storage[3]);
    r.storage[1] = (storage[1] * arg.storage[0]) +
                    (storage[3] * arg.storage[1]);
    r.storage[3] = (storage[1] * arg.storage[2]) +
                    (storage[3] * arg.storage[3]);
    return r;
  }

  Vector2 _mul_vector(Vector2 arg) {
    Vector2 r = new Vector2.zero();
    r.storage[1] = (storage[1] * arg.storage[0]) +
                    (storage[3] * arg.storage[1]);
    r.storage[0] = (storage[0] * arg.storage[0]) +
                    (storage[2] * arg.storage[1]);
    return r;
  }

  /// Returns a new vector or matrix by multiplying [this] with [arg].
  dynamic operator*(dynamic arg) {
    if (arg is double) {
      return _mul_scale(arg);
    }
    if (arg is Vector2) {
      return _mul_vector(arg);
    }
    if (2 == arg.dimension) {
      return _mul_matrix(arg);
    }
    throw new ArgumentError(arg);
  }

  /// Returns new matrix after component wise [this] + [arg]
  Matrix2 operator +(Matrix2 arg) {
    Matrix2 r = new Matrix2.zero();
    r.storage[0] = storage[0] + arg.storage[0];
    r.storage[1] = storage[1] + arg.storage[1];
    r.storage[2] = storage[2] + arg.storage[2];
    r.storage[3] = storage[3] + arg.storage[3];
    return r;
  }

  /// Returns new matrix after component wise [this] - [arg]
  Matrix2 operator -(Matrix2 arg) {
    Matrix2 r = new Matrix2.zero();
    r.storage[0] = storage[0] - arg.storage[0];
    r.storage[1] = storage[1] - arg.storage[1];
    r.storage[2] = storage[2] - arg.storage[2];
    r.storage[3] = storage[3] - arg.storage[3];
    return r;
  }

  /// Returns new matrix -this
  Matrix2 operator -() {
    Matrix2 r = new Matrix2.zero();
    r[0] = -storage[0];
    r[1] = -storage[1];
    return r;
  }

  /// Zeros [this].
  Matrix2 setZero() {
    storage[0] = 0.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    return this;
  }

  /// Makes [this] into the identity matrix.
  Matrix2 setIdentity() {
    storage[0] = 1.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 1.0;
    return this;
  }

  /// Returns the tranpose of this.
  Matrix2 transposed() {
    Matrix2 r = new Matrix2.zero();
    r.storage[0] = storage[0];
    r.storage[1] = storage[2];
    r.storage[2] = storage[1];
    r.storage[3] = storage[3];
    return r;
  }

  Matrix2 transpose() {
    double temp;
    temp = storage[2];
    storage[2] = storage[1];
    storage[1] = temp;
    return this;
  }

  /// Returns the component wise absolute value of this.
  Matrix2 absolute() {
    Matrix2 r = new Matrix2.zero();
    r.storage[0] = storage[0].abs();
    r.storage[1] = storage[1].abs();
    r.storage[2] = storage[2].abs();
    r.storage[3] = storage[3].abs();
    return r;
  }

  /// Returns the determinant of this matrix.
  double determinant() {
    return (storage[0] * storage[3]) - (storage[1] * storage[2]);
  }

  /// Returns the dot product of row [i] and [v].
  double dotRow(int i, Vector2 v) {
    return storage[i] * v.storage[0] + storage[2 + i] * v.storage[1];
  }

  /// Returns the dot product of column [j] and [v].
  double dotColumn(int j, Vector2 v) {
    return storage[j * 2] * v.storage[0] + storage[(j * 2) + 1] * v.storage[1];
  }

  /// Trace of the matrix.
  double trace() {
    double t = 0.0;
    t += storage[0];
    t += storage[3];
    return t;
  }

  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    double norm = 0.0;
    {
      double row_norm = 0.0;
      row_norm += storage[0].abs();
      row_norm += storage[1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += storage[2].abs();
      row_norm += storage[3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }

  /// Returns relative error between [this] and [correct]
  double relativeError(Matrix2 correct) {
    Matrix2 diff = correct - this;
    double correct_norm = correct.infinityNorm();
    double diff_norm = diff.infinityNorm();
    return diff_norm / correct_norm;
  }

  /// Returns absolute error between [this] and [correct]
  double absoluteError(Matrix2 correct) {
    double this_norm = infinityNorm();
    double correct_norm = correct.infinityNorm();
    double diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }

  /// Invert the matrix. Returns the determinant.
  double invert() {
    double det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    double invDet = 1.0 / det;
    double temp = storage[0];
    storage[0] = storage[3] * invDet;
    storage[1] = -storage[1] * invDet;
    storage[2] = -storage[2] * invDet;
    storage[3] = temp * invDet;
    return det;
  }

  /// Set this matrix to be the inverse of [arg]
  double copyInverse(Matrix2 arg) {
    double det = arg.determinant();
    if (det == 0.0) {
      setFrom(arg);
      return 0.0;
    }
    double invDet = 1.0 / det;
    storage[0] = arg.storage[3] * invDet;
    storage[1] = -arg.storage[1] * invDet;
    storage[2] = -arg.storage[2] * invDet;
    storage[3] = arg.storage[0] * invDet;
    return det;
  }

  /// Turns the matrix into a rotation of [radians]
  void setRotation(double radians) {
    double c = Math.cos(radians);
    double s = Math.sin(radians);
    storage[0] = c;
    storage[1] = s;
    storage[2] = -s;
    storage[3] = c;
  }

  /// Converts into Adjugate matrix and scales by [scale]
  Matrix2 scaleAdjoint(double scale) {
    double temp = storage[0];
    storage[0] = storage[3] * scale;
    storage[2] = -storage[2] * scale;
    storage[1] = -storage[1] * scale;
    storage[3] = temp * scale;
    return this;
  }

  Matrix2 add(Matrix2 o) {
    storage[0] = storage[0] + o.storage[0];
    storage[1] = storage[1] + o.storage[1];
    storage[2] = storage[2] + o.storage[2];
    storage[3] = storage[3] + o.storage[3];
    return this;
  }

  Matrix2 sub(Matrix2 o) {
    storage[0] = storage[0] - o.storage[0];
    storage[1] = storage[1] - o.storage[1];
    storage[2] = storage[2] - o.storage[2];
    storage[3] = storage[3] - o.storage[3];
    return this;
  }

  Matrix2 negate() {
    storage[0] = -storage[0];
    storage[1] = -storage[1];
    storage[2] = -storage[2];
    storage[3] = -storage[3];
    return this;
  }

  Matrix2 multiply(Matrix2 arg) {
    final double m00 = storage[0];
    final double m01 = storage[2];
    final double m10 = storage[1];
    final double m11 = storage[3];
    final double n00 = arg.storage[0];
    final double n01 = arg.storage[2];
    final double n10 = arg.storage[1];
    final double n11 = arg.storage[3];
    storage[0] = (m00 * n00) + (m01 * n10);
    storage[2] = (m00 * n01) + (m01 * n11);
    storage[1] = (m10 * n00) + (m11 * n10);
    storage[3] = (m10 * n01) + (m11 * n11);
    return this;
  }

  Matrix2 transposeMultiply(Matrix2 arg) {
    double m00 = storage[0];
    double m01 = storage[1];
    double m10 = storage[2];
    double m11 = storage[3];
    storage[0] = (m00 * arg.storage[0]) + (m01 * arg.storage[1]);
    storage[2] = (m00 * arg.storage[2]) + (m01 * arg.storage[3]);
    storage[1] = (m10 * arg.storage[0]) + (m11 * arg.storage[1]);
    storage[3] = (m10 * arg.storage[2]) + (m11 * arg.storage[3]);
    return this;
  }

  Matrix2 multiplyTranspose(Matrix2 arg) {
    double m00 = storage[0];
    double m01 = storage[2];
    double m10 = storage[1];
    double m11 = storage[3];
    storage[0] = (m00 * arg.storage[0]) + (m01 * arg.storage[2]);
    storage[2] = (m00 * arg.storage[1]) + (m01 * arg.storage[3]);
    storage[1] = (m10 * arg.storage[0]) + (m11 * arg.storage[2]);
    storage[3] = (m10 * arg.storage[1]) + (m11 * arg.storage[3]);
    return this;
  }

  Vector2 transform(Vector2 arg) {
    double x_ = (storage[0] * arg.storage[0]) +
                (storage[2] * arg.storage[1]);
    double y_ = (storage[1] * arg.storage[0]) +
                (storage[3] * arg.storage[1]);
    arg.x = x_;
    arg.y = y_;
    return arg;
  }

  Vector2 transformed(Vector2 arg, [Vector2 out = null]) {
    if (out == null) {
      out = new Vector2.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return transform(out);
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset = 0]) {
    int i = offset;
    array[i + 3] = storage[3];
    array[i + 2] = storage[2];
    array[i + 1] = storage[1];
    array[i + 0] = storage[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    int i = offset;
    storage[3] = array[i + 3];
    storage[2] = array[i + 2];
    storage[1] = array[i + 1];
    storage[0] = array[i + 0];
  }
}
