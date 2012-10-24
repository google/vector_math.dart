/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
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
/// mat2 is a column major matrix where each column is represented by [vec2]. This matrix has 2 columns and 2 rows.
class mat2 {
  vec2 col0;
  vec2 col1;
  /// Constructs a new mat2. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.
  mat2([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    if (arg0 is double && arg1 is double && arg2 is double && arg3 is double) {
      col0.x = arg0;
      col0.y = arg1;
      col1.x = arg2;
      col1.y = arg3;
      return;
    }
    if (arg0 is double && arg1 == null && arg2 == null && arg3 == null) {
      col0.x = arg0;
      col1.y = arg0;
      return;
    }
    if (arg0 is vec2 && arg1 is vec2) {
      col0 = arg0;
      col1 = arg1;
      return;
    }
    if (arg0 is mat2) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
    }
    throw new ArgumentError('Invalid arguments');
  }
  /// Constructs a new [mat2] from computing the outer product of [u] and [v].
  mat2.outer(vec2 u, vec2 v) {
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col0.x = u.x * v.x;
    col0.y = u.x * v.y;
    col1.x = u.y * v.x;
    col1.y = u.y * v.y;
  }
  /// Constructs a new [mat2] filled with zeros.
  mat2.zero() {
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col0.x = 0.0;
    col0.y = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
  }
  /// Constructs a new identity [mat2].
  mat2.identity() {
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col0.x = 1.0;
    col1.y = 1.0;
  }
  /// Constructs a new [mat2] which is a copy of [other].
  mat2.copy(mat2 other) {
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col0.x = other.col0.x;
    col0.y = other.col0.y;
    col1.x = other.col1.x;
    col1.y = other.col1.y;
  }
  /// Constructs a new [mat2] representing a rotation by [radians].
  mat2.rotation(double radians_) {
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    setRotation(radians_);
  }
  mat2.raw(double arg0, double arg1, double arg2, double arg3) {
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col0.x = arg0;
    col0.y = arg1;
    col1.x = arg2;
    col1.y = arg3;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    return s;
  }
  /// Returns the number of rows in the matrix.
  int get rows => 2;
  /// Returns the number of columns in the matrix.
  int get cols => 2;
  /// Returns the number of columns in the matrix.
  int get length => 2;
  /// Gets the [column] of the matrix
  vec2 operator[](int column) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: return col0;
      case 1: return col1;
    }
    throw new IllegalArgumentException(column);
  }
  /// Assigns the [column] of the matrix [arg]
  void operator[]=(int column, vec2 arg) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: col0 = arg; break;
      case 1: col1 = arg; break;
    }
    throw new IllegalArgumentException(column);
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
    assert(row >= 0 && row < 2);
    col0[row] = arg.x;
    col1[row] = arg.y;
  }
  /// Gets the [row] of the matrix
  vec2 getRow(int row) {
    assert(row >= 0 && row < 2);
    vec2 r = new vec2.zero();
    r.x = col0[row];
    r.y = col1[row];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec2 arg) {
    assert(column >= 0 && column < 2);
    this[column] = arg;
  }
  /// Gets the [column] of the matrix
  vec2 getColumn(int column) {
    assert(column >= 0 && column < 2);
    return new vec2.copy(this[column]);
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  Dynamic operator*(Dynamic arg) {
    if (arg is double) {
      mat2 r = new mat2.zero();
      r.col0.x = col0.x * arg;
      r.col0.y = col0.y * arg;
      r.col1.x = col1.x * arg;
      r.col1.y = col1.y * arg;
      return r;
    }
    if (arg is vec2) {
      vec2 r = new vec2.zero();
      r.x =  (this.col0.x * arg.x) + (this.col1.x * arg.y);
      r.y =  (this.col0.y * arg.x) + (this.col1.y * arg.y);
      return r;
    }
    if (2 == arg.rows) {
      Dynamic r = null;
      if (arg.cols == 2) {
        r = new mat2.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y);
        return r;
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat2 operator+(mat2 arg) {
    mat2 r = new mat2.zero();
    r.col0.x = col0.x + arg.col0.x;
    r.col0.y = col0.y + arg.col0.y;
    r.col1.x = col1.x + arg.col1.x;
    r.col1.y = col1.y + arg.col1.y;
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat2 operator-(mat2 arg) {
    mat2 r = new mat2.zero();
    r.col0.x = col0.x - arg.col0.x;
    r.col0.y = col0.y - arg.col0.y;
    r.col1.x = col1.x - arg.col1.x;
    r.col1.y = col1.y - arg.col1.y;
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
    col0.x = 0.0;
    col0.y = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    return this;
  }
  /// Makes [this] into the identity matrix.
  mat2 setIdentity() {
    col0.x = 1.0;
    col0.y = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    return this;
  }
  /// Returns the tranpose of this.
  mat2 transposed() {
    mat2 r = new mat2.zero();
    r.col0.x = col0.x;
    r.col0.y = col1.x;
    r.col1.x = col0.y;
    r.col1.y = col1.y;
    return r;
  }
  mat2 transpose() {
    double temp;
    temp = col1.x;
    col1.x = col0.y;
    col0.y = temp;
    return this;
  }
  /// Returns the component wise absolute value of this.
  mat2 absolute() {
    mat2 r = new mat2.zero();
    r.col0.x = col0.x.abs();
    r.col0.y = col0.y.abs();
    r.col1.x = col1.x.abs();
    r.col1.y = col1.y.abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  double determinant() {
    return (col0.x * col1.y) - (col0.y*col1.x);
  }
  /// Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries
  double trace() {
    double t = 0.0;
    t += col0.x;
    t += col1.y;
    return t;
  }
  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    double norm = 0.0;
    {
      double row_norm = 0.0;
      row_norm += this[0][0].abs();
      row_norm += this[0][1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += this[1][0].abs();
      row_norm += this[1][1].abs();
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
  void setRotation(double radians_) {
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    col0.x = c;
    col0.y = s;
    col1.x = -s;
    col1.y = c;
  }
  /// Converts into Adjugate matrix and scales by [scale]
  mat2 scaleAdjoint(double scale_) {
    double temp = col0.x;
    col0.x = col1.y * scale_;
    col1.x = - col1.x * scale_;
    col0.y = - col0.y * scale_;
    col1.y = temp * scale_;
    return this;
  }
  mat2 clone() {
    return new mat2.copy(this);
  }
  mat2 copyInto(mat2 arg) {
    arg.col0.x = col0.x;
    arg.col0.y = col0.y;
    arg.col1.x = col1.x;
    arg.col1.y = col1.y;
    return arg;
  }
  mat2 copyFrom(mat2 arg) {
    col0.x = arg.col0.x;
    col0.y = arg.col0.y;
    col1.x = arg.col1.x;
    col1.y = arg.col1.y;
    return this;
  }
  mat2 add(mat2 o) {
    col0.x = col0.x + o.col0.x;
    col0.y = col0.y + o.col0.y;
    col1.x = col1.x + o.col1.x;
    col1.y = col1.y + o.col1.y;
    return this;
  }
  mat2 sub(mat2 o) {
    col0.x = col0.x - o.col0.x;
    col0.y = col0.y - o.col0.y;
    col1.x = col1.x - o.col1.x;
    col1.y = col1.y - o.col1.y;
    return this;
  }
  mat2 negate() {
    col0.x = -col0.x;
    col0.y = -col0.y;
    col1.x = -col1.x;
    col1.y = -col1.y;
    return this;
  }
  mat2 multiply(mat2 arg) {
    final double m00 = col0.x;
    final double m01 = col1.x;
    final double m10 = col0.y;
    final double m11 = col1.y;
    final double n00 = arg.col0.x;
    final double n01 = arg.col1.x;
    final double n10 = arg.col0.y;
    final double n11 = arg.col1.y;
    col0.x =  (m00 * n00) + (m01 * n10);
    col1.x =  (m00 * n01) + (m01 * n11);
    col0.y =  (m10 * n00) + (m11 * n10);
    col1.y =  (m10 * n01) + (m11 * n11);
    return this;
  }
  mat2 transposeMultiply(mat2 arg) {
    double m00 = col0.x;
    double m01 = col0.y;
    double m10 = col1.x;
    double m11 = col1.y;
    col0.x =  (m00 * arg.col0.x) + (m01 * arg.col0.y);
    col1.x =  (m00 * arg.col1.x) + (m01 * arg.col1.y);
    col0.y =  (m10 * arg.col0.x) + (m11 * arg.col0.y);
    col1.y =  (m10 * arg.col1.x) + (m11 * arg.col1.y);
    return this;
  }
  mat2 multiplyTranspose(mat2 arg) {
    double m00 = col0.x;
    double m01 = col1.x;
    double m10 = col0.y;
    double m11 = col1.y;
    col0.x =  (m00 * arg.col0.x) + (m01 * arg.col1.x);
    col1.x =  (m00 * arg.col0.y) + (m01 * arg.col1.y);
    col0.y =  (m10 * arg.col0.x) + (m11 * arg.col1.x);
    col1.y =  (m10 * arg.col0.y) + (m11 * arg.col1.y);
    return this;
  }
  vec2 transform(vec2 arg) {
    double x_ =  (this.col0.x * arg.x) + (this.col1.x * arg.y);
    double y_ =  (this.col0.y * arg.x) + (this.col1.y * arg.y);
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
  void copyIntoArray(Float32Array array, [int offset=0]) {
    int i = offset;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
  }
  /// Returns a copy of [this] as a [Float32Array].
  Float32Array copyAsArray() {
    Float32Array array = new Float32Array(4);
    int i = 0;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    return array;
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(Float32Array array, [int offset=0]) {
    int i = offset;
    col0.x = array[i];
    i++;
    col0.y = array[i];
    i++;
    col1.x = array[i];
    i++;
    col1.y = array[i];
    i++;
  }
}
