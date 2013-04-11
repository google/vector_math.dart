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

/// mat3 is a column major matrix where each column is represented by [vec3]. This matrix has 3 columns and 3 dimension.
class mat3 {
  final Float32List _storage = new Float32List(9);
  int index(int row, int col) => (col * 3) + row;
  double entry(int row, int col) => _storage[index(row, col)];
  setEntry(int row, int col, double v) { _storage[index(row, col)] = v; }
  /// Constructs a new mat3.
  mat3(double arg0, double arg1, double arg2, double arg3, double arg4, double arg5, double arg6, double arg7, double arg8) {
    setRaw(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
  }
  /// Constructs a new mat3 from columns.
  mat3.columns(vec3 arg0, vec3 arg1, vec3 arg2) {
    setColumns(arg0, arg1, arg2);
  }
  /// Constructs a new [mat3] from computing the outer product of [u] and [v].
  mat3.outer(vec3 u, vec3 v) {
    _storage[0] = u._storage[0] * v._storage[0];
    _storage[1] = u._storage[0] * v._storage[1];
    _storage[2] = u._storage[0] * v._storage[2];
    _storage[3] = u._storage[1] * v._storage[0];
    _storage[4] = u._storage[1] * v._storage[1];
    _storage[5] = u._storage[1] * v._storage[2];
    _storage[6] = u._storage[2] * v._storage[0];
    _storage[7] = u._storage[2] * v._storage[1];
    _storage[8] = u._storage[2] * v._storage[2];
  }
  /// Constructs a new [mat3] filled with zeros.
  mat3.zero() {
  }
  /// Constructs a new identity [mat3].
  mat3.identity() {
    setIdentity();
  }
  /// Constructs a new [mat3] which is a copy of [other].
  mat3.copy(mat3 other) {
    setMatrix(other);
  }
  //// Constructs a new [mat3] representation a rotation of [radians] around the X axis
  mat3.rotationX(double radians_) {
    setRotationX(radians_);
  }
  //// Constructs a new [mat3] representation a rotation of [radians] around the Y axis
  mat3.rotationY(double radians_) {
    setRotationY(radians_);
  }
  //// Constructs a new [mat3] representation a rotation of [radians] around the Z axis
  mat3.rotationZ(double radians_) {
    setRotationZ(radians_);
  }
  /// Sets the diagonal to [arg].
  mat3 splatDiagonal(double arg) {
    _storage[0] = arg;
    _storage[4] = arg;
    _storage[8] = arg;
    return this;
  }
  /// Sets the entire matrix to the numeric values.
  mat3 setRaw(double arg0, double arg1, double arg2, double arg3, double arg4, double arg5, double arg6, double arg7, double arg8) {
    _storage[8] = arg8;
    _storage[7] = arg7;
    _storage[6] = arg6;
    _storage[5] = arg5;
    _storage[4] = arg4;
    _storage[3] = arg3;
    _storage[2] = arg2;
    _storage[1] = arg1;
    _storage[0] = arg0;
    return this;
  }
  /// Sets the entire matrix to the column values.
  mat3 setColumns(vec3 arg0, vec3 arg1, vec3 arg2) {
    _storage[0] = arg0._storage[0];
    _storage[1] = arg0._storage[1];
    _storage[2] = arg0._storage[2];
    _storage[3] = arg1._storage[0];
    _storage[4] = arg1._storage[1];
    _storage[5] = arg1._storage[2];
    _storage[6] = arg2._storage[0];
    _storage[7] = arg2._storage[1];
    _storage[8] = arg2._storage[2];
    return this;
  }
  /// Sets the entire matrix to the matrix in [arg].
  mat3 setMatrix(mat3 arg) {
    _storage[8] = arg._storage[8];
    _storage[7] = arg._storage[7];
    _storage[6] = arg._storage[6];
    _storage[5] = arg._storage[5];
    _storage[4] = arg._storage[4];
    _storage[3] = arg._storage[3];
    _storage[2] = arg._storage[2];
    _storage[1] = arg._storage[1];
    _storage[0] = arg._storage[0];
    return this;
  }
  /// Sets the upper 2x2 of the matrix to be [arg].
  mat3 setUpper2x2(mat2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[3] = arg._storage[3];
    _storage[4] = arg._storage[4];
    return this;
  }
  /// Sets the diagonal of the matrix to be [arg].
  mat3 setDiagonal3(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[4] = arg._storage[1];
    _storage[8] = arg._storage[2];
    return this;
  }
  /// Sets the diagonal of the matrix to be [arg].
  mat3 setDiagonal2(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[4] = arg._storage[1];
    return this;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    s = '$s[2] ${getRow(2)}\n';
    return s;
  }
  /// Returns the dimension of the matrix.
  int get dimension => 3;
  /// Returns the dimension of the matrix.
  int get length => 3;
  /// Gets element [i] from the matrix.
  double operator[](int i) {
    return _storage[i];
  }
  /// Sets element [i] in the matrix.
  void operator[]=(int i, double v) {
    _storage[i] = v;
  }
  /// Returns row 0
  vec3 get row0 => getRow(0);
  /// Returns row 1
  vec3 get row1 => getRow(1);
  /// Returns row 2
  vec3 get row2 => getRow(2);
  /// Sets row 0 to [arg]
  set row0(vec3 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec3 arg) => setRow(1, arg);
  /// Sets row 2 to [arg]
  set row2(vec3 arg) => setRow(2, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec3 arg) {
    _storage[index(row, 0)] = arg._storage[0];
    _storage[index(row, 1)] = arg._storage[1];
    _storage[index(row, 2)] = arg._storage[2];
  }
  /// Gets the [row] of the matrix
  vec3 getRow(int row) {
    vec3 r = new vec3.zero();
    r._storage[0] = _storage[index(row, 0)];
    r._storage[1] = _storage[index(row, 1)];
    r._storage[2] = _storage[index(row, 2)];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec3 arg) {
    int entry = column * 3;
    _storage[entry+2] = arg._storage[2];
    _storage[entry+1] = arg._storage[1];
    _storage[entry+0] = arg._storage[0];
  }
  /// Gets the [column] of the matrix
  vec3 getColumn(int column) {
    vec3 r = new vec3.zero();
    int entry = column * 3;
    r._storage[2] = _storage[entry+2];
    r._storage[1] = _storage[entry+1];
    r._storage[0] = _storage[entry+0];
    return r;
  }
  mat3 _mul_scale(double arg) {
    mat3 r = new mat3.zero();
    r._storage[8] = _storage[8] * arg;
    r._storage[7] = _storage[7] * arg;
    r._storage[6] = _storage[6] * arg;
    r._storage[5] = _storage[5] * arg;
    r._storage[4] = _storage[4] * arg;
    r._storage[3] = _storage[3] * arg;
    r._storage[2] = _storage[2] * arg;
    r._storage[1] = _storage[1] * arg;
    r._storage[0] = _storage[0] * arg;
    return r;
  }
  mat3 _mul_matrix(mat3 arg) {
    var r = new mat3.zero();
    r._storage[0] =  (_storage[0] * arg._storage[0]) + (_storage[3] * arg._storage[1]) + (_storage[6] * arg._storage[2]);
    r._storage[3] =  (_storage[0] * arg._storage[3]) + (_storage[3] * arg._storage[4]) + (_storage[6] * arg._storage[5]);
    r._storage[6] =  (_storage[0] * arg._storage[6]) + (_storage[3] * arg._storage[7]) + (_storage[6] * arg._storage[8]);
    r._storage[1] =  (_storage[1] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[7] * arg._storage[2]);
    r._storage[4] =  (_storage[1] * arg._storage[3]) + (_storage[4] * arg._storage[4]) + (_storage[7] * arg._storage[5]);
    r._storage[7] =  (_storage[1] * arg._storage[6]) + (_storage[4] * arg._storage[7]) + (_storage[7] * arg._storage[8]);
    r._storage[2] =  (_storage[2] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[8] * arg._storage[2]);
    r._storage[5] =  (_storage[2] * arg._storage[3]) + (_storage[5] * arg._storage[4]) + (_storage[8] * arg._storage[5]);
    r._storage[8] =  (_storage[2] * arg._storage[6]) + (_storage[5] * arg._storage[7]) + (_storage[8] * arg._storage[8]);
    return r;
  }
  vec3 _mul_vector(vec3 arg) {
    vec3 r = new vec3.zero();
    r._storage[2] =  (_storage[2] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[8] * arg._storage[2]);
    r._storage[1] =  (_storage[1] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[7] * arg._storage[2]);
    r._storage[0] =  (_storage[0] * arg._storage[0]) + (_storage[3] * arg._storage[1]) + (_storage[6] * arg._storage[2]);
    return r;
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  dynamic operator*(dynamic arg) {
    if (arg is double) {
      return _mul_scale(arg);
    }
    if (arg is vec3) {
      return _mul_vector(arg);
    }
    if (3 == arg.dimension) {
      return _mul_matrix(arg);
    }
    throw new ArgumentError(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat3 operator+(mat3 arg) {
    mat3 r = new mat3.zero();
    r._storage[0] = _storage[0] + arg._storage[0];
    r._storage[1] = _storage[1] + arg._storage[1];
    r._storage[2] = _storage[2] + arg._storage[2];
    r._storage[3] = _storage[3] + arg._storage[3];
    r._storage[4] = _storage[4] + arg._storage[4];
    r._storage[5] = _storage[5] + arg._storage[5];
    r._storage[6] = _storage[6] + arg._storage[6];
    r._storage[7] = _storage[7] + arg._storage[7];
    r._storage[8] = _storage[8] + arg._storage[8];
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat3 operator-(mat3 arg) {
    mat3 r = new mat3.zero();
    r._storage[0] = _storage[0] - arg._storage[0];
    r._storage[1] = _storage[1] - arg._storage[1];
    r._storage[2] = _storage[2] - arg._storage[2];
    r._storage[3] = _storage[3] - arg._storage[3];
    r._storage[4] = _storage[4] - arg._storage[4];
    r._storage[5] = _storage[5] - arg._storage[5];
    r._storage[6] = _storage[6] - arg._storage[6];
    r._storage[7] = _storage[7] - arg._storage[7];
    r._storage[8] = _storage[8] - arg._storage[8];
    return r;
  }
  /// Returns new matrix -this
  mat3 operator-() {
    mat3 r = new mat3.zero();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    return r;
  }
  /// Zeros [this].
  mat3 setZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
    _storage[4] = 0.0;
    _storage[5] = 0.0;
    _storage[6] = 0.0;
    _storage[7] = 0.0;
    _storage[8] = 0.0;
    return this;
  }
  /// Makes [this] into the identity matrix.
  mat3 setIdentity() {
    _storage[0] = 1.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
    _storage[4] = 1.0;
    _storage[5] = 0.0;
    _storage[6] = 0.0;
    _storage[7] = 0.0;
    _storage[8] = 1.0;
    return this;
  }
  /// Returns the tranpose of this.
  mat3 transposed() {
    mat3 r = new mat3.zero();
    r._storage[0] = _storage[0];
    r._storage[1] = _storage[3];
    r._storage[2] = _storage[6];
    r._storage[3] = _storage[1];
    r._storage[4] = _storage[4];
    r._storage[5] = _storage[7];
    r._storage[6] = _storage[2];
    r._storage[7] = _storage[5];
    r._storage[8] = _storage[8];
    return r;
  }
  mat3 transpose() {
    double temp;
    temp = _storage[3];
    _storage[3] = _storage[1];
    _storage[1] = temp;
    temp = _storage[6];
    _storage[6] = _storage[2];
    _storage[2] = temp;
    temp = _storage[7];
    _storage[7] = _storage[5];
    _storage[5] = temp;
    return this;
  }
  /// Returns the component wise absolute value of this.
  mat3 absolute() {
    mat3 r = new mat3.zero();
    r._storage[0] = _storage[0].abs();
    r._storage[1] = _storage[1].abs();
    r._storage[2] = _storage[2].abs();
    r._storage[3] = _storage[3].abs();
    r._storage[4] = _storage[4].abs();
    r._storage[5] = _storage[5].abs();
    r._storage[6] = _storage[6].abs();
    r._storage[7] = _storage[7].abs();
    r._storage[8] = _storage[8].abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  double determinant() {
    double x = col0.x*((col1.y*col2.z)-(col1.z*col2.y));
    double y = col0.y*((col1.x*col2.z)-(col1.z*col2.x));
    double z = col0.z*((col1.x*col2.y)-(col1.y*col2.x));
    return x - y + z;
  }
  /// Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries
  double trace() {
    double t = 0.0;
    t += _storage[0];
    t += _storage[4];
    t += _storage[8];
    return t;
  }
  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    double norm = 0.0;
    {
      double row_norm = 0.0;
      row_norm += _storage[0].abs();
      row_norm += _storage[1].abs();
      row_norm += _storage[2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += _storage[3].abs();
      row_norm += _storage[4].abs();
      row_norm += _storage[5].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += _storage[6].abs();
      row_norm += _storage[7].abs();
      row_norm += _storage[8].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  double relativeError(mat3 correct) {
    mat3 diff = correct - this;
    double correct_norm = correct.infinityNorm();
    double diff_norm = diff.infinityNorm();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  double absoluteError(mat3 correct) {
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
    vec3 i = new vec3();
    vec3 j = new vec3();
    vec3 k = new vec3();
    i.x = invDet * (col1.y * col2.z - col1.z * col2.y);
    i.y = invDet * (col0.z * col2.y - col0.y * col2.z);
    i.z = invDet * (col0.y * col1.z - col0.z * col1.y);
    j.x = invDet * (col1.z * col2.x - col1.x * col2.z);
    j.y = invDet * (col0.x * col2.z - col0.z * col2.x);
    j.z = invDet * (col0.z * col1.x - col0.x * col1.z);
    k.x = invDet * (col1.x * col2.y - col1.y * col2.x);
    k.y = invDet * (col0.y * col2.x - col0.x * col2.y);
    k.z = invDet * (col0.x * col1.y - col0.y * col1.x);
    col0 = i;
    col1 = j;
    col2 = k;
    return det;
  }
  /// Turns the matrix into a rotation of [radians] around X
  void setRotationX(num radians) {
    double radians_ = radians.toDouble();
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    _storage[0] = 1.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
    _storage[4] = c;
    _storage[5] = s;
    _storage[6] = 0.0;
    _storage[7] = -s;
    _storage[8] = c;
  }
  /// Turns the matrix into a rotation of [radians] around Y
  void setRotationY(num radians) {
    double radians_ = radians.toDouble();
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    _storage[0] = c;
    _storage[1] = 0.0;
    _storage[2] = s;
    _storage[3] = 0.0;
    _storage[4] = 1.0;
    _storage[5] = 0.0;
    _storage[6] = -s;
    _storage[7] = 0.0;
    _storage[8] = c;
  }
  /// Turns the matrix into a rotation of [radians] around Z
  void setRotationZ(num radians) {
    double radians_ = radians.toDouble();
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    _storage[0] = c;
    _storage[1] = s;
    _storage[2] = 0.0;
    _storage[3] = -s;
    _storage[4] = c;
    _storage[5] = 0.0;
    _storage[6] = 0.0;
    _storage[7] = 0.0;
    _storage[8] = 1.0;
  }
  /// Converts into Adjugate matrix and scales by [scale]
  mat3 scaleAdjoint(num scale) {
    double scale_ = scale.toDouble();
    double m00 = _storage[0];
    double m01 = _storage[3];
    double m02 = _storage[6];
    double m10 = _storage[1];
    double m11 = _storage[4];
    double m12 = _storage[7];
    double m20 = _storage[2];
    double m21 = _storage[5];
    double m22 = _storage[8];
    _storage[0] = (m11 * m22 - m12 * m21) * scale_;
    _storage[1] = (m12 * m20 - m10 * m22) * scale_;
    _storage[2] = (m10 * m21 - m11 * m20) * scale_;
    _storage[3] = (m02 * m21 - m01 * m22) * scale_;
    _storage[4] = (m00 * m22 - m02 * m20) * scale_;
    _storage[5] = (m01 * m20 - m00 * m21) * scale_;
    _storage[6] = (m01 * m12 - m02 * m11) * scale_;
    _storage[7] = (m02 * m10 - m00 * m12) * scale_;
    _storage[8] = (m00 * m11 - m01 * m10) * scale_;
    return this;
  }
  /// Rotates [arg] by the absolute rotation of [this]
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  vec3 absoluteRotate(vec3 arg) {
    double m00 = _storage[0].abs();
    double m01 = _storage[3].abs();
    double m02 = _storage[6].abs();
    double m10 = _storage[1].abs();
    double m11 = _storage[4].abs();
    double m12 = _storage[7].abs();
    double m20 = _storage[2].abs();
    double m21 = _storage[5].abs();
    double m22 = _storage[8].abs();
    double x = arg.x;
    double y = arg.y;
    double z = arg.z;
    arg.x = x * m00 + y * m01 + z * m02 + 0.0 * 0.0;
    arg.y = x * m10 + y * m11 + z * m12 + 0.0 * 0.0;
    arg.z = x * m20 + y * m21 + z * m22 + 0.0 * 0.0;
    return arg;
  }
  mat3 clone() {
    return new mat3.copy(this);
  }
  mat3 copyInto(mat3 arg) {
    arg._storage[0] = _storage[0];
    arg._storage[1] = _storage[1];
    arg._storage[2] = _storage[2];
    arg._storage[3] = _storage[3];
    arg._storage[4] = _storage[4];
    arg._storage[5] = _storage[5];
    arg._storage[6] = _storage[6];
    arg._storage[7] = _storage[7];
    arg._storage[8] = _storage[8];
    return arg;
  }
  mat3 copyFrom(mat3 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
    _storage[4] = arg._storage[4];
    _storage[5] = arg._storage[5];
    _storage[6] = arg._storage[6];
    _storage[7] = arg._storage[7];
    _storage[8] = arg._storage[8];
    return this;
  }
  mat3 add(mat3 o) {
    _storage[0] = _storage[0] + o._storage[0];
    _storage[1] = _storage[1] + o._storage[1];
    _storage[2] = _storage[2] + o._storage[2];
    _storage[3] = _storage[3] + o._storage[3];
    _storage[4] = _storage[4] + o._storage[4];
    _storage[5] = _storage[5] + o._storage[5];
    _storage[6] = _storage[6] + o._storage[6];
    _storage[7] = _storage[7] + o._storage[7];
    _storage[8] = _storage[8] + o._storage[8];
    return this;
  }
  mat3 sub(mat3 o) {
    _storage[0] = _storage[0] - o._storage[0];
    _storage[1] = _storage[1] - o._storage[1];
    _storage[2] = _storage[2] - o._storage[2];
    _storage[3] = _storage[3] - o._storage[3];
    _storage[4] = _storage[4] - o._storage[4];
    _storage[5] = _storage[5] - o._storage[5];
    _storage[6] = _storage[6] - o._storage[6];
    _storage[7] = _storage[7] - o._storage[7];
    _storage[8] = _storage[8] - o._storage[8];
    return this;
  }
  mat3 negate() {
    _storage[0] = -_storage[0];
    _storage[1] = -_storage[1];
    _storage[2] = -_storage[2];
    _storage[3] = -_storage[3];
    _storage[4] = -_storage[4];
    _storage[5] = -_storage[5];
    _storage[6] = -_storage[6];
    _storage[7] = -_storage[7];
    _storage[8] = -_storage[8];
    return this;
  }
  mat3 multiply(mat3 arg) {
    final double m00 = _storage[0];
    final double m01 = _storage[3];
    final double m02 = _storage[6];
    final double m10 = _storage[1];
    final double m11 = _storage[4];
    final double m12 = _storage[7];
    final double m20 = _storage[2];
    final double m21 = _storage[5];
    final double m22 = _storage[8];
    final double n00 = arg._storage[0];
    final double n01 = arg._storage[3];
    final double n02 = arg._storage[6];
    final double n10 = arg._storage[1];
    final double n11 = arg._storage[4];
    final double n12 = arg._storage[7];
    final double n20 = arg._storage[2];
    final double n21 = arg._storage[5];
    final double n22 = arg._storage[8];
    _storage[0] =  (m00 * n00) + (m01 * n10) + (m02 * n20);
    _storage[3] =  (m00 * n01) + (m01 * n11) + (m02 * n21);
    _storage[6] =  (m00 * n02) + (m01 * n12) + (m02 * n22);
    _storage[1] =  (m10 * n00) + (m11 * n10) + (m12 * n20);
    _storage[4] =  (m10 * n01) + (m11 * n11) + (m12 * n21);
    _storage[7] =  (m10 * n02) + (m11 * n12) + (m12 * n22);
    _storage[2] =  (m20 * n00) + (m21 * n10) + (m22 * n20);
    _storage[5] =  (m20 * n01) + (m21 * n11) + (m22 * n21);
    _storage[8] =  (m20 * n02) + (m21 * n12) + (m22 * n22);
    return this;
  }
  mat3 transposeMultiply(mat3 arg) {
    double m00 = _storage[0];
    double m01 = _storage[1];
    double m02 = _storage[2];
    double m10 = _storage[3];
    double m11 = _storage[4];
    double m12 = _storage[5];
    double m20 = _storage[6];
    double m21 = _storage[7];
    double m22 = _storage[8];
    _storage[0] =  (m00 * arg._storage[0]) + (m01 * arg._storage[1]) + (m02 * arg._storage[2]);
    _storage[3] =  (m00 * arg._storage[3]) + (m01 * arg._storage[4]) + (m02 * arg._storage[5]);
    _storage[6] =  (m00 * arg._storage[6]) + (m01 * arg._storage[7]) + (m02 * arg._storage[8]);
    _storage[1] =  (m10 * arg._storage[0]) + (m11 * arg._storage[1]) + (m12 * arg._storage[2]);
    _storage[4] =  (m10 * arg._storage[3]) + (m11 * arg._storage[4]) + (m12 * arg._storage[5]);
    _storage[7] =  (m10 * arg._storage[6]) + (m11 * arg._storage[7]) + (m12 * arg._storage[8]);
    _storage[2] =  (m20 * arg._storage[0]) + (m21 * arg._storage[1]) + (m22 * arg._storage[2]);
    _storage[5] =  (m20 * arg._storage[3]) + (m21 * arg._storage[4]) + (m22 * arg._storage[5]);
    _storage[8] =  (m20 * arg._storage[6]) + (m21 * arg._storage[7]) + (m22 * arg._storage[8]);
    return this;
  }
  mat3 multiplyTranspose(mat3 arg) {
    double m00 = _storage[0];
    double m01 = _storage[3];
    double m02 = _storage[6];
    double m10 = _storage[1];
    double m11 = _storage[4];
    double m12 = _storage[7];
    double m20 = _storage[2];
    double m21 = _storage[5];
    double m22 = _storage[8];
    _storage[0] =  (m00 * arg._storage[0]) + (m01 * arg._storage[3]) + (m02 * arg._storage[6]);
    _storage[3] =  (m00 * arg._storage[1]) + (m01 * arg._storage[4]) + (m02 * arg._storage[7]);
    _storage[6] =  (m00 * arg._storage[2]) + (m01 * arg._storage[5]) + (m02 * arg._storage[8]);
    _storage[1] =  (m10 * arg._storage[0]) + (m11 * arg._storage[3]) + (m12 * arg._storage[6]);
    _storage[4] =  (m10 * arg._storage[1]) + (m11 * arg._storage[4]) + (m12 * arg._storage[7]);
    _storage[7] =  (m10 * arg._storage[2]) + (m11 * arg._storage[5]) + (m12 * arg._storage[8]);
    _storage[2] =  (m20 * arg._storage[0]) + (m21 * arg._storage[3]) + (m22 * arg._storage[6]);
    _storage[5] =  (m20 * arg._storage[1]) + (m21 * arg._storage[4]) + (m22 * arg._storage[7]);
    _storage[8] =  (m20 * arg._storage[2]) + (m21 * arg._storage[5]) + (m22 * arg._storage[8]);
    return this;
  }
  vec3 transform(vec3 arg) {
    double x_ =  (_storage[0] * arg._storage[0]) + (_storage[3] * arg._storage[1]) + (_storage[6] * arg._storage[2]);
    double y_ =  (_storage[1] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[7] * arg._storage[2]);
    double z_ =  (_storage[2] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[8] * arg._storage[2]);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }
  vec3 transformed(vec3 arg, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return transform(out);
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset=0]) {
    int i = offset;
    array[i+8] = _storage[8];
    array[i+7] = _storage[7];
    array[i+6] = _storage[6];
    array[i+5] = _storage[5];
    array[i+4] = _storage[4];
    array[i+3] = _storage[3];
    array[i+2] = _storage[2];
    array[i+1] = _storage[1];
    array[i+0] = _storage[0];
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<num> array, [int offset=0]) {
    int i = offset;
    _storage[8] = array[i+8];
    _storage[7] = array[i+7];
    _storage[6] = array[i+6];
    _storage[5] = array[i+5];
    _storage[4] = array[i+4];
    _storage[3] = array[i+3];
    _storage[2] = array[i+2];
    _storage[1] = array[i+1];
    _storage[0] = array[i+0];
  }
  vec3 get right {
    double x = _storage[0];
    double y = _storage[1];
    double z = _storage[2];
    return new vec3(x, y, z);
  }
  vec3 get up {
    double x = _storage[3];
    double y = _storage[4];
    double z = _storage[5];
    return new vec3(x, y, z);
  }
  vec3 get forward {
    double x = _storage[6];
    double y = _storage[7];
    double z = _storage[8];
    return new vec3(x, y, z);
  }
}
