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

part of vector_math_64;

//TODO (fox32): Update documentation comments!

/// 2D Matrix.
/// Values are stored in column major order.
class Matrix2 {
  final Float64List _storage;

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

    x.x = det * (a22 * bx - a12 * by);
    x.y = det * (a11 * by - a21 * bx);
  }

  /// The components of the matrix.
  Float64List get storage => _storage;

  /// Return index in storage for [row], [col] value.
  int index(int row, int col) => (col * 2) + row;

  /// Value at [row], [col].
  double entry(int row, int col) => _storage[index(row, col)];

  /// Set value at [row], [col] to be [v].
  void setEntry(int row, int col, double v) {
    _storage[index(row, col)] = v;
  }

  /// New matrix with specified values.
  Matrix2(double arg0, double arg1, double arg2, double arg3)
      : _storage = new Float64List(4) {
    setValues(arg0, arg1, arg2, arg3);
  }

  /// Zero matrix.
  Matrix2.zero()
      : _storage = new Float64List(4);

  /// Identity matrix.
  Matrix2.identity()
      : _storage = new Float64List(4) {
    setIdentity();
  }

  /// Copies values from [other].
  Matrix2.copy(Matrix2 other)
      : _storage = new Float64List(4) {
    setFrom(other);
  }

  /// Matrix with values from column arguments.
  Matrix2.columns(Vector2 arg0, Vector2 arg1)
      : _storage = new Float64List(4) {
    setColumns(arg0, arg1);
  }

  /// Outer product of [u] and [v].
  Matrix2.outer(Vector2 u, Vector2 v)
      : _storage = new Float64List(4) {
    final uStorage = u._storage;
    final vStorage = v._storage;
    _storage[0] = uStorage[0] * vStorage[0];
    _storage[1] = uStorage[0] * vStorage[1];
    _storage[2] = uStorage[1] * vStorage[0];
    _storage[3] = uStorage[1] * vStorage[1];
  }

  /// Rotation of [radians_].
  Matrix2.rotation(double radians)
      : _storage = new Float64List(4) {
    setRotation(radians);
  }

  /// Sets the matrix with specified values.
  void setValues(double arg0, double arg1, double arg2, double arg3) {
    _storage[3] = arg3;
    _storage[2] = arg2;
    _storage[1] = arg1;
    _storage[0] = arg0;
  }

  /// Sets the entire matrix to the column values.
  void setColumns(Vector2 arg0, Vector2 arg1) {
    final arg0Storage = arg0._storage;
    final arg1Storage = arg1._storage;
    _storage[0] = arg0Storage[0];
    _storage[1] = arg0Storage[1];
    _storage[2] = arg1Storage[0];
    _storage[3] = arg1Storage[1];
  }

  /// Sets the entire matrix to the matrix in [arg].
  void setFrom(Matrix2 arg) {
    final argStorage = arg._storage;
    _storage[3] = argStorage[3];
    _storage[2] = argStorage[2];
    _storage[1] = argStorage[1];
    _storage[0] = argStorage[0];
  }

  /// Sets the diagonal to [arg].
  void splatDiagonal(double arg) {
    _storage[0] = arg;
    _storage[3] = arg;
  }

  /// Sets the diagonal of the matrix to be [arg].
  void setDiagonal(Vector2 arg) {
    final argStorage = arg._storage;
    storage[0] = argStorage[0];
    storage[3] = argStorage[1];
  }

  /// Returns a printable string
  String toString() => '[0] ${getRow(0)}\n[1] ${getRow(1)}\n';

  /// Dimension of the matrix.
  int get dimension => 2;

  /// Access the element of the matrix at the index [i].
  double operator [](int i) => _storage[i];

  /// Set the element of the matrix at the index [i].
  void operator []=(int i, double v) {
    _storage[i] = v;
  }

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
    final argStorage = arg._storage;
    _storage[index(row, 0)] = argStorage[0];
    _storage[index(row, 1)] = argStorage[1];
  }

  /// Gets the [row] of the matrix
  Vector2 getRow(int row) {
    final r = new Vector2.zero();
    r._storage[0] = _storage[index(row, 0)];
    r._storage[1] = _storage[index(row, 1)];
    return r;
  }

  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, Vector2 arg) {
    final argStorage = arg._storage;
    final entry = column * 2;
    _storage[entry + 1] = argStorage[1];
    _storage[entry + 0] = argStorage[0];
  }

  /// Gets the [column] of the matrix
  Vector2 getColumn(int column) {
    final r = new Vector2.zero();
    final entry = column * 2;
    final rStorage = r._storage;
    rStorage[1] = _storage[entry + 1];
    rStorage[0] = _storage[entry + 0];
    return r;
  }

  /// Create a copy of [this].
  Matrix2 clone() => new Matrix2.copy(this);

  /// Copy [this] into [arg].
  Matrix2 copyInto(Matrix2 arg) {
    final argStorage = arg._storage;
    argStorage[0] = _storage[0];
    argStorage[1] = _storage[1];
    argStorage[2] = _storage[2];
    argStorage[3] = _storage[3];
    return arg; //TODO (fox32): Remove return value?
  }

  /// Returns a new vector or matrix by multiplying [this] with [arg].
  operator *(dynamic arg) {
    if (arg is double) {
      return scaled(arg);
    }
    if (arg is Vector2) {
      return transformed(arg);
    }
    if (arg is Matrix2) {
      return multiplied(arg);
    }
    throw new ArgumentError(arg);
  }

  /// Returns new matrix after component wise [this] + [arg]
  Matrix2 operator +(Matrix2 arg) => clone()..add(arg);

  /// Returns new matrix after component wise [this] - [arg]
  Matrix2 operator -(Matrix2 arg) => clone()..sub(arg);

  /// Returns new matrix -this
  Matrix2 operator -() => clone()..negate();

  /// Zeros [this].
  void setZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
  }

  /// Makes [this] into the identity matrix.
  void setIdentity() {
    _storage[0] = 1.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 1.0;
  }

  /// Returns the tranpose of this.
  Matrix2 transposed() => clone()..transpose();

  /// Transpose [this].
  void transpose() {
    var temp;
    temp = _storage[2];
    _storage[2] = _storage[1];
    _storage[1] = temp;
  }

  /// Calculates the component wise absolute value of this.
  void absolute() {
    _storage[0] = _storage[0].abs();
    _storage[1] = _storage[1].abs();
    _storage[2] = _storage[2].abs();
    _storage[3] = _storage[3].abs();
  }

  /// Returns the determinant of this matrix.
  double determinant() => (_storage[0] * _storage[3]) - (_storage[1] *
      _storage[2]);

  /// Returns the dot product of row [i] and [v].
  double dotRow(int i, Vector2 v) {
    final vStorage = v._storage;
    return _storage[i] * vStorage[0] + _storage[2 + i] * vStorage[1];
  }

  /// Returns the dot product of column [j] and [v].
  double dotColumn(int j, Vector2 v) {
    final vStorage = v._storage;
    return _storage[j * 2] * vStorage[0] + _storage[(j * 2) + 1] * vStorage[1];
  }

  /// Trace of the matrix.
  double trace() {
    var t = 0.0;
    t += _storage[0];
    t += _storage[3];
    return t;
  }

  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    var norm = 0.0;
    {
      var row_norm = 0.0;
      row_norm += _storage[0].abs();
      row_norm += _storage[1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      var row_norm = 0.0;
      row_norm += _storage[2].abs();
      row_norm += _storage[3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }

  /// Returns relative error between [this] and [correct]
  double relativeError(Matrix2 correct) {
    final diff = correct - this;
    final correct_norm = correct.infinityNorm();
    final diff_norm = diff.infinityNorm();
    return diff_norm / correct_norm;
  }

  /// Returns absolute error between [this] and [correct]
  double absoluteError(Matrix2 correct) {
    final this_norm = infinityNorm();
    final correct_norm = correct.infinityNorm();
    final diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }

  /// Invert the matrix. Returns the determinant.
  double invert() {
    final det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    final invDet = 1.0 / det;
    final temp = _storage[0];
    _storage[0] = _storage[3] * invDet;
    _storage[1] = -_storage[1] * invDet;
    _storage[2] = -_storage[2] * invDet;
    _storage[3] = temp * invDet;
    return det;
  }

  /// Set this matrix to be the inverse of [arg]
  double copyInverse(Matrix2 arg) {
    final det = arg.determinant();
    if (det == 0.0) {
      setFrom(arg);
      return 0.0;
    }
    final invDet = 1.0 / det;
    final argStorage = arg._storage;
    _storage[0] = argStorage[3] * invDet;
    _storage[1] = -argStorage[1] * invDet;
    _storage[2] = -argStorage[2] * invDet;
    _storage[3] = argStorage[0] * invDet;
    return det;
  }

  /// Turns the matrix into a rotation of [radians]
  void setRotation(double radians) {
    final c = Math.cos(radians);
    final s = Math.sin(radians);
    _storage[0] = c;
    _storage[1] = s;
    _storage[2] = -s;
    _storage[3] = c;
  }

  /// Converts into Adjugate matrix and scales by [scale]
  void scaleAdjoint(double scale) {
    final temp = _storage[0];
    _storage[0] = _storage[3] * scale;
    _storage[2] = -_storage[2] * scale;
    _storage[1] = -_storage[1] * scale;
    _storage[3] = temp * scale;
  }

  /// Scale [this] by [scale].
  void scale(double scale) {
    _storage[0] = _storage[0] * scale;
    _storage[1] = _storage[1] * scale;
    _storage[2] = _storage[2] * scale;
    _storage[3] = _storage[3] * scale;
  }

  /// Create a copy of [this] scaled by [scale].
  Matrix2 scaled(double scale) => clone()..scale(scale);

  /// Add [o] to [this].
  void add(Matrix2 o) {
    final oStorage = o._storage;
    _storage[0] = _storage[0] + oStorage[0];
    _storage[1] = _storage[1] + oStorage[1];
    _storage[2] = _storage[2] + oStorage[2];
    _storage[3] = _storage[3] + oStorage[3];
  }

  /// Subtract [o] to [this].
  void sub(Matrix2 o) {
    final oStorage = o._storage;
    _storage[0] = _storage[0] - oStorage[0];
    _storage[1] = _storage[1] - oStorage[1];
    _storage[2] = _storage[2] - oStorage[2];
    _storage[3] = _storage[3] - oStorage[3];
  }

  /// Negate [this].
  void negate() {
    _storage[0] = -_storage[0];
    _storage[1] = -_storage[1];
    _storage[2] = -_storage[2];
    _storage[3] = -_storage[3];
  }

  /// Multiply [this] with [arg] and store it in [this].
  void multiply(Matrix2 arg) {
    final m00 = _storage[0];
    final m01 = _storage[2];
    final m10 = _storage[1];
    final m11 = _storage[3];
    final argStorage = arg._storage;
    final n00 = argStorage[0];
    final n01 = argStorage[2];
    final n10 = argStorage[1];
    final n11 = argStorage[3];
    _storage[0] = (m00 * n00) + (m01 * n10);
    _storage[2] = (m00 * n01) + (m01 * n11);
    _storage[1] = (m10 * n00) + (m11 * n10);
    _storage[3] = (m10 * n01) + (m11 * n11);
  }

  /// Multiply [this] with [arg] and return the product.
  Matrix2 multiplied(Matrix2 arg) => clone()..multiply(arg);

  void transposeMultiply(Matrix2 arg) {
    final m00 = _storage[0];
    final m01 = _storage[1];
    final m10 = _storage[2];
    final m11 = _storage[3];
    final argStorage = arg._storage;
    _storage[0] = (m00 * argStorage[0]) + (m01 * argStorage[1]);
    _storage[2] = (m00 * argStorage[2]) + (m01 * argStorage[3]);
    _storage[1] = (m10 * argStorage[0]) + (m11 * argStorage[1]);
    _storage[3] = (m10 * argStorage[2]) + (m11 * argStorage[3]);
  }

  void multiplyTranspose(Matrix2 arg) {
    final m00 = _storage[0];
    final m01 = _storage[2];
    final m10 = _storage[1];
    final m11 = _storage[3];
    final argStorage = arg._storage;
    _storage[0] = (m00 * argStorage[0]) + (m01 * argStorage[2]);
    _storage[2] = (m00 * argStorage[1]) + (m01 * argStorage[3]);
    _storage[1] = (m10 * argStorage[0]) + (m11 * argStorage[2]);
    _storage[3] = (m10 * argStorage[1]) + (m11 * argStorage[3]);
  }

  Vector2 transform(Vector2 arg) {
    final argStorage = arg._storage;
    double x = (storage[0] * argStorage[0]) + (storage[2] * argStorage[1]);
    double y = (storage[1] * argStorage[0]) + (storage[3] * argStorage[1]);
    argStorage[0] = x;
    argStorage[1] = y;
    return arg; //TODO (fox32): Remove the return type here?
  }

  Vector2 transformed(Vector2 arg, [Vector2 out = null]) {
    //TODO (fox32): The style with the out parameter doesn't match the style of the library, remove?
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
    array[i + 3] = _storage[3];
    array[i + 2] = _storage[2];
    array[i + 1] = _storage[1];
    array[i + 0] = _storage[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    int i = offset;
    _storage[3] = array[i + 3];
    _storage[2] = array[i + 2];
    _storage[1] = array[i + 1];
    _storage[0] = array[i + 0];
  }
}
