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

/// mat2 is a column major matrix where each column is represented by [vec2]. This matrix has 2 columns and 2 dimension.
class mat2 {
  final Float32List _storage = new Float32List(4);
  int index(int row, int col) => (col * 2) + row;
  double entry(int row, int col) => _storage[index(row, col)];
  setEntry(int row, int col, double v) { _storage[index(row, col)] = v; }
  /// Constructs a new mat2.
  mat2(double arg0, double arg1, double arg2, double arg3) {
    setRaw(arg0, arg1, arg2, arg3);
  }
  /// Constructs a new mat2 from columns.
  mat2.columns(vec2 arg0, vec2 arg1) {
    setColumns(arg0, arg1);
  }
  /// Constructs a new [mat2] from computing the outer product of [u] and [v].
  mat2.outer(vec2 u, vec2 v) {
    _storage[0] = u._storage[0] * v._storage[0];
    _storage[1] = u._storage[0] * v._storage[1];
    _storage[2] = u._storage[1] * v._storage[0];
    _storage[3] = u._storage[1] * v._storage[1];
  }
  /// Constructs a new [mat2] filled with zeros.
  mat2.zero() {
  }
  /// Constructs a new identity [mat2].
  mat2.identity() {
    setIdentity();
  }
  /// Constructs a new [mat2] which is a copy of [other].
  mat2.copy(mat2 other) {
    setMatrix(other);
  }
  /// Constructs a new [mat2] representing a rotation by [radians].
  mat2.rotation(double radians_) {
    setRotation(radians_);
  }
  /// Sets the diagonal to [arg].
  mat2 splatDiagonal(double arg) {
    _storage[0] = arg;
    _storage[3] = arg;
    return this;
  }
  /// Sets the entire matrix to the numeric values.
  mat2 setRaw(double arg0, double arg1, double arg2, double arg3) {
    _storage[3] = arg3;
    _storage[2] = arg2;
    _storage[1] = arg1;
    _storage[0] = arg0;
    return this;
  }
  /// Sets the entire matrix to the column values.
  mat2 setColumns(vec2 arg0, vec2 arg1) {
    _storage[0] = arg0._storage[0];
    _storage[1] = arg0._storage[1];
    _storage[2] = arg1._storage[0];
    _storage[3] = arg1._storage[1];
    return this;
  }
  /// Sets the entire matrix to the matrix in [arg].
  mat2 setMatrix(mat2 arg) {
    _storage[3] = arg._storage[3];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[0];
    return this;
  }
  /// Sets the diagonal of the matrix to be [arg].
  mat2 setDiagonal2(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[3] = arg._storage[1];
    return this;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    return s;
  }
  /// Returns the dimension of the matrix.
  int get dimension => 2;
  /// Returns the dimension of the matrix.
  int get length => 2;
  /// Gets element [i] from the matrix.
  double operator[](int i) {
    return _storage[i];
  }
  /// Sets element [i] in the matrix.
  void operator[]=(int i, double v) {
    _storage[i] = v;
  }
  /// Returns row 0
  vec2 get row0 => getRow(0);
  /// Returns row 1
  vec2 get row1 => getRow(1);
  /// Sets row 0 to [arg]
  set row0(vec2 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec2 arg) => setRow(1, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec2 arg) {
    _storage[index(row, 0)] = arg._storage[0];
    _storage[index(row, 1)] = arg._storage[1];
  }
  /// Gets the [row] of the matrix
  vec2 getRow(int row) {
    vec2 r = new vec2.zero();
    r._storage[0] = _storage[index(row, 0)];
    r._storage[1] = _storage[index(row, 1)];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec2 arg) {
    int entry = column * 2;
    _storage[entry+1] = arg._storage[1];
    _storage[entry+0] = arg._storage[0];
  }
  /// Gets the [column] of the matrix
  vec2 getColumn(int column) {
    vec2 r = new vec2.zero();
    int entry = column * 2;
    r._storage[1] = _storage[entry+1];
    r._storage[0] = _storage[entry+0];
    return r;
  }
  mat2 _mul_scale(double arg) {
    mat2 r = new mat2.zero();
    r._storage[3] = _storage[3] * arg;
    r._storage[2] = _storage[2] * arg;
    r._storage[1] = _storage[1] * arg;
    r._storage[0] = _storage[0] * arg;
    return r;
  }
  mat2 _mul_matrix(mat2 arg) {
    var r = new mat2.zero();
    r._storage[0] =  (_storage[0] * arg._storage[0]) + (_storage[2] * arg._storage[1]);
    r._storage[2] =  (_storage[0] * arg._storage[2]) + (_storage[2] * arg._storage[3]);
    r._storage[1] =  (_storage[1] * arg._storage[0]) + (_storage[3] * arg._storage[1]);
    r._storage[3] =  (_storage[1] * arg._storage[2]) + (_storage[3] * arg._storage[3]);
    return r;
  }
  vec2 _mul_vector(vec2 arg) {
    vec2 r = new vec2.zero();
    r._storage[1] =  (_storage[1] * arg._storage[0]) + (_storage[3] * arg._storage[1]);
    r._storage[0] =  (_storage[0] * arg._storage[0]) + (_storage[2] * arg._storage[1]);
    return r;
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  dynamic operator*(dynamic arg) {
    if (arg is double) {
      return _mul_scale(arg);
    }
    if (arg is vec2) {
      return _mul_vector(arg);
    }
    if (2 == arg.dimension) {
      return _mul_matrix(arg);
    }
    throw new ArgumentError(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat2 operator+(mat2 arg) {
    mat2 r = new mat2.zero();
    r._storage[0] = _storage[0] + arg._storage[0];
    r._storage[1] = _storage[1] + arg._storage[1];
    r._storage[2] = _storage[2] + arg._storage[2];
    r._storage[3] = _storage[3] + arg._storage[3];
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat2 operator-(mat2 arg) {
    mat2 r = new mat2.zero();
    r._storage[0] = _storage[0] - arg._storage[0];
    r._storage[1] = _storage[1] - arg._storage[1];
    r._storage[2] = _storage[2] - arg._storage[2];
    r._storage[3] = _storage[3] - arg._storage[3];
    return r;
  }
  /// Returns new matrix -this
  mat2 operator-() {
    mat2 r = new mat2.zero();
    r[0] = -this[0];
    r[1] = -this[1];
    return r;
  }
  /// Zeros [this].
  mat2 setZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
    return this;
  }
  /// Makes [this] into the identity matrix.
  mat2 setIdentity() {
    _storage[0] = 1.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 1.0;
    return this;
  }
  /// Returns the tranpose of this.
  mat2 transposed() {
    mat2 r = new mat2.zero();
    r._storage[0] = _storage[0];
    r._storage[1] = _storage[2];
    r._storage[2] = _storage[1];
    r._storage[3] = _storage[3];
    return r;
  }
  mat2 transpose() {
    double temp;
    temp = _storage[2];
    _storage[2] = _storage[1];
    _storage[1] = temp;
    return this;
  }
  /// Returns the component wise absolute value of this.
  mat2 absolute() {
    mat2 r = new mat2.zero();
    r._storage[0] = _storage[0].abs();
    r._storage[1] = _storage[1].abs();
    r._storage[2] = _storage[2].abs();
    r._storage[3] = _storage[3].abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  double determinant() {
    return (_storage[0] * _storage[3]) - (_storage[1]*_storage[2]);
  }
  /// Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries
  double trace() {
    double t = 0.0;
    t += _storage[0];
    t += _storage[3];
    return t;
  }
  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    double norm = 0.0;
    {
      double row_norm = 0.0;
      row_norm += _storage[0].abs();
      row_norm += _storage[1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += _storage[2].abs();
      row_norm += _storage[3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  double relativeError(mat2 correct) {
    mat2 diff = correct - this;
    double correct_norm = correct.infinityNorm();
    double diff_norm = diff.infinityNorm();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  double absoluteError(mat2 correct) {
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
    double temp = col0.x;
    col0.x = col1.y * invDet;
    col0.y = - col0.y * invDet;
    col1.x = - col1.x * invDet;
    col1.y = temp * invDet;
    return det;
  }
  /// Turns the matrix into a rotation of [radians]
  void setRotation(num radians) {
    double radians_ = radians.toDouble();
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    _storage[0] = c;
    _storage[1] = s;
    _storage[2] = -s;
    _storage[3] = c;
  }
  /// Converts into Adjugate matrix and scales by [scale]
  mat2 scaleAdjoint(num scale) {
    double scale_ = scale.toDouble();
    double temp = _storage[0];
    _storage[0] = _storage[3] * scale_;
    _storage[2] = - _storage[2] * scale_;
    _storage[1] = - _storage[1] * scale_;
    _storage[3] = temp * scale_;
    return this;
  }
  mat2 clone() {
    return new mat2.copy(this);
  }
  mat2 copyInto(mat2 arg) {
    arg._storage[0] = _storage[0];
    arg._storage[1] = _storage[1];
    arg._storage[2] = _storage[2];
    arg._storage[3] = _storage[3];
    return arg;
  }
  mat2 copyFrom(mat2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
    return this;
  }
  mat2 add(mat2 o) {
    _storage[0] = _storage[0] + o._storage[0];
    _storage[1] = _storage[1] + o._storage[1];
    _storage[2] = _storage[2] + o._storage[2];
    _storage[3] = _storage[3] + o._storage[3];
    return this;
  }
  mat2 sub(mat2 o) {
    _storage[0] = _storage[0] - o._storage[0];
    _storage[1] = _storage[1] - o._storage[1];
    _storage[2] = _storage[2] - o._storage[2];
    _storage[3] = _storage[3] - o._storage[3];
    return this;
  }
  mat2 negate() {
    _storage[0] = -_storage[0];
    _storage[1] = -_storage[1];
    _storage[2] = -_storage[2];
    _storage[3] = -_storage[3];
    return this;
  }
  mat2 multiply(mat2 arg) {
    final double m00 = _storage[0];
    final double m01 = _storage[2];
    final double m10 = _storage[1];
    final double m11 = _storage[3];
    final double n00 = arg._storage[0];
    final double n01 = arg._storage[2];
    final double n10 = arg._storage[1];
    final double n11 = arg._storage[3];
    _storage[0] =  (m00 * n00) + (m01 * n10);
    _storage[2] =  (m00 * n01) + (m01 * n11);
    _storage[1] =  (m10 * n00) + (m11 * n10);
    _storage[3] =  (m10 * n01) + (m11 * n11);
    return this;
  }
  mat2 transposeMultiply(mat2 arg) {
    double m00 = _storage[0];
    double m01 = _storage[1];
    double m10 = _storage[2];
    double m11 = _storage[3];
    _storage[0] =  (m00 * arg._storage[0]) + (m01 * arg._storage[1]);
    _storage[2] =  (m00 * arg._storage[2]) + (m01 * arg._storage[3]);
    _storage[1] =  (m10 * arg._storage[0]) + (m11 * arg._storage[1]);
    _storage[3] =  (m10 * arg._storage[2]) + (m11 * arg._storage[3]);
    return this;
  }
  mat2 multiplyTranspose(mat2 arg) {
    double m00 = _storage[0];
    double m01 = _storage[2];
    double m10 = _storage[1];
    double m11 = _storage[3];
    _storage[0] =  (m00 * arg._storage[0]) + (m01 * arg._storage[2]);
    _storage[2] =  (m00 * arg._storage[1]) + (m01 * arg._storage[3]);
    _storage[1] =  (m10 * arg._storage[0]) + (m11 * arg._storage[2]);
    _storage[3] =  (m10 * arg._storage[1]) + (m11 * arg._storage[3]);
    return this;
  }
  vec2 transform(vec2 arg) {
    double x_ =  (_storage[0] * arg._storage[0]) + (_storage[2] * arg._storage[1]);
    double y_ =  (_storage[1] * arg._storage[0]) + (_storage[3] * arg._storage[1]);
    arg.x = x_;
    arg.y = y_;
    return arg;
  }
  vec2 transformed(vec2 arg, [vec2 out=null]) {
    if (out == null) {
      out = new vec2.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return transform(out);
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset=0]) {
    int i = offset;
    array[i+3] = _storage[3];
    array[i+2] = _storage[2];
    array[i+1] = _storage[1];
    array[i+0] = _storage[0];
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<num> array, [int offset=0]) {
    int i = offset;
    _storage[3] = array[i+3];
    _storage[2] = array[i+2];
    _storage[1] = array[i+1];
    _storage[0] = array[i+0];
  }
}
