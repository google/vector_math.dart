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
/// mat3x2 is a column major matrix where each column is represented by [vec2]. This matrix has 3 columns and 2 rows.
class mat3x2 {
  vec2 col0;
  vec2 col1;
  vec2 col2;
  /// Constructs a new mat3x2. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.
  mat3x2([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4, Dynamic arg5]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col2 = new vec2.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num && arg4 is num && arg5 is num) {
      col0.x = arg0;
      col0.y = arg1;
      col1.x = arg2;
      col1.y = arg3;
      col2.x = arg4;
      col2.y = arg5;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null) {
      col0.x = arg0;
      col1.y = arg0;
      return;
    }
    if (arg0 is vec3 && arg1 is vec3 && arg2 is vec3) {
      col0 = arg0;
      col1 = arg1;
      col2 = arg2;
      return;
    }
    if (arg0 is mat3x2) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      col2 = arg0.col2;
      return;
    }
    if (arg0 is mat2x2) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
    }
  }
  /// Constructs a new [mat3x2] from computing the outer product of [u] and [v].
  mat3x2.outer(vec3 u, vec2 v) {
    col0 = new vec2();
    col1 = new vec2();
    col2 = new vec2();
    col0.x = u.x * v.x;
    col0.y = u.x * v.y;
    col1.x = u.y * v.x;
    col1.y = u.y * v.y;
    col2.x = u.z * v.x;
    col2.y = u.z * v.y;
  }
  /// Constructs a new [mat3x2] filled with zeros.
  mat3x2.zero() {
    col0 = new vec2();
    col1 = new vec2();
    col2 = new vec2();
    col0.x = 0.0;
    col0.y = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
  }
  /// Constructs a new identity [mat3x2].
  mat3x2.identity() {
    col0 = new vec2();
    col1 = new vec2();
    col2 = new vec2();
    col0.x = 1.0;
    col0.y = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    col2.x = 0.0;
    col2.y = 0.0;
  }
  /// Constructs a new [mat3x2] which is a copy of [other].
  mat3x2.copy(mat3x2 other) {
    col0 = new vec2();
    col1 = new vec2();
    col2 = new vec2();
    col0.x = other.col0.x;
    col0.y = other.col0.y;
    col1.x = other.col1.x;
    col1.y = other.col1.y;
    col2.x = other.col2.x;
    col2.y = other.col2.y;
  }
  mat3x2.raw(num arg0, num arg1, num arg2, num arg3, num arg4, num arg5) {
    col0 = new vec2.zero();
    col1 = new vec2.zero();
    col2 = new vec2.zero();
    col0.x = arg0;
    col0.y = arg1;
    col1.x = arg2;
    col1.y = arg3;
    col2.x = arg4;
    col2.y = arg5;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    return s;
  }
  /// Returns the number of rows in the matrix.
  num get rows() => 2;
  /// Returns the number of columns in the matrix.
  num get cols() => 3;
  /// Returns the number of columns in the matrix.
  num get length() => 3;
  /// Gets the [column] of the matrix
  vec2 operator[](int column) {
    assert(column >= 0 && column < 3);
    switch (column) {
      case 0: return col0;
      case 1: return col1;
      case 2: return col2;
    }
    throw new IllegalArgumentException(column);
  }
  /// Assigns the [column] of the matrix [arg]
  void operator[]=(int column, vec2 arg) {
    assert(column >= 0 && column < 3);
    switch (column) {
      case 0: col0 = arg; break;
      case 1: col1 = arg; break;
      case 2: col2 = arg; break;
    }
    throw new IllegalArgumentException(column);
  }
  /// Returns row 0
  vec3 get row0() => getRow(0);
  /// Returns row 1
  vec3 get row1() => getRow(1);
  /// Sets row 0 to [arg]
  set row0(vec3 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec3 arg) => setRow(1, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec3 arg) {
    assert(row >= 0 && row < 2);
    col0[row] = arg.x;
    col1[row] = arg.y;
    col2[row] = arg.z;
  }
  /// Gets the [row] of the matrix
  vec3 getRow(int row) {
    assert(row >= 0 && row < 2);
    vec3 r = new vec3();
    r.x = col0[row];
    r.y = col1[row];
    r.z = col2[row];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec2 arg) {
    assert(column >= 0 && column < 3);
    this[column] = arg;
  }
  /// Gets the [column] of the matrix
  vec2 getColumn(int column) {
    assert(column >= 0 && column < 3);
    return new vec2(this[column]);
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat3x2 r = new mat3x2.zero();
      r.col0.x = col0.x * arg;
      r.col0.y = col0.y * arg;
      r.col1.x = col1.x * arg;
      r.col1.y = col1.y * arg;
      r.col2.x = col2.x * arg;
      r.col2.y = col2.y * arg;
      return r;
    }
    if (arg is vec3) {
      vec2 r = new vec2.zero();
      r.x =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z);
      r.y =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z);
      return r;
    }
    if (3 == arg.rows) {
      Dynamic r = null;
      if (arg.cols == 2) {
        r = new mat2x2.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y) + (this.col2.x * arg.col0.z);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y) + (this.col2.x * arg.col1.z);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y) + (this.col2.y * arg.col0.z);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y) + (this.col2.y * arg.col1.z);
        return r;
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat3x2 operator+(mat3x2 arg) {
    mat3x2 r = new mat3x2();
    r.col0.x = col0.x + arg.col0.x;
    r.col0.y = col0.y + arg.col0.y;
    r.col1.x = col1.x + arg.col1.x;
    r.col1.y = col1.y + arg.col1.y;
    r.col2.x = col2.x + arg.col2.x;
    r.col2.y = col2.y + arg.col2.y;
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat3x2 operator-(mat3x2 arg) {
    mat3x2 r = new mat3x2();
    r.col0.x = col0.x - arg.col0.x;
    r.col0.y = col0.y - arg.col0.y;
    r.col1.x = col1.x - arg.col1.x;
    r.col1.y = col1.y - arg.col1.y;
    r.col2.x = col2.x - arg.col2.x;
    r.col2.y = col2.y - arg.col2.y;
    return r;
  }
  /// Returns new matrix -this
  mat3x2 operator negate() {
    mat3x2 r = new mat3x2();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    return r;
  }
  /// Returns the tranpose of this.
  mat2x3 transposed() {
    mat2x3 r = new mat2x3();
    r.col0.x = col0.x;
    r.col0.y = col1.x;
    r.col0.z = col2.x;
    r.col1.x = col0.y;
    r.col1.y = col1.y;
    r.col1.z = col2.y;
    return r;
  }
  /// Returns the component wise absolute value of this.
  mat3x2 absolute() {
    mat3x2 r = new mat3x2();
    r.col0.x = col0.x.abs();
    r.col0.y = col0.y.abs();
    r.col1.x = col1.x.abs();
    r.col1.y = col1.y.abs();
    r.col2.x = col2.x.abs();
    r.col2.y = col2.y.abs();
    return r;
  }
  /// Returns infinity norm of the matrix. Used for numerical analysis.
  num infinityNorm() {
    num norm = 0.0;
    {
      num row_norm = 0.0;
      row_norm += this[0][0].abs();
      row_norm += this[0][1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[1][0].abs();
      row_norm += this[1][1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[2][0].abs();
      row_norm += this[2][1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  num relativeError(mat3x2 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  num absoluteError(mat3x2 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  mat3x2 copy() {
    return new mat3x2.copy(this);
  }
  mat3x2 copyInto(mat3x2 arg) {
    arg.col0.x = col0.x;
    arg.col0.y = col0.y;
    arg.col1.x = col1.x;
    arg.col1.y = col1.y;
    arg.col2.x = col2.x;
    arg.col2.y = col2.y;
    return arg;
  }
  mat3x2 copyFrom(mat3x2 arg) {
    col0.x = arg.col0.x;
    col0.y = arg.col0.y;
    col1.x = arg.col1.x;
    col1.y = arg.col1.y;
    col2.x = arg.col2.x;
    col2.y = arg.col2.y;
    return this;
  }
  mat3x2 selfAdd(mat3x2 o) {
    col0.x = col0.x + o.col0.x;
    col0.y = col0.y + o.col0.y;
    col1.x = col1.x + o.col1.x;
    col1.y = col1.y + o.col1.y;
    col2.x = col2.x + o.col2.x;
    col2.y = col2.y + o.col2.y;
    return this;
  }
  mat3x2 selfSub(mat3x2 o) {
    col0.x = col0.x - o.col0.x;
    col0.y = col0.y - o.col0.y;
    col1.x = col1.x - o.col1.x;
    col1.y = col1.y - o.col1.y;
    col2.x = col2.x - o.col2.x;
    col2.y = col2.y - o.col2.y;
    return this;
  }
  mat3x2 selfScale(num o) {
    col0.x = col0.x * o;
    col0.y = col0.y * o;
    col1.x = col1.x * o;
    col1.y = col1.y * o;
    col2.x = col2.x * o;
    col2.y = col2.y * o;
    return this;
  }
  mat3x2 selfNegate() {
    col0.x = -col0.x;
    col0.y = -col0.y;
    col1.x = -col1.x;
    col1.y = -col1.y;
    col2.x = -col2.x;
    col2.y = -col2.y;
    return this;
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(Float32List array, [int offset=0]) {
    int i = offset;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
  }
  /// Returns a copy of [this] as a [Float32List].
  Float32List copyAsArray() {
    Float32List array = new Float32List(6);
    int i = 0;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
    return array;
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(Float32List array, [int offset=0]) {
    int i = offset;
    col0.x = array[i];
    i++;
    col0.y = array[i];
    i++;
    col1.x = array[i];
    i++;
    col1.y = array[i];
    i++;
    col2.x = array[i];
    i++;
    col2.y = array[i];
    i++;
  }
}
