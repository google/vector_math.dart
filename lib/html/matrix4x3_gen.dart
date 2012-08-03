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
/// mat4x3 is a column major matrix where each column is represented by [vec3]. This matrix has 4 columns and 3 rows.
class mat4x3 {
  vec3 col0;
  vec3 col1;
  vec3 col2;
  vec3 col3;
  /// Constructs a new mat4x3. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.
  mat4x3([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4, Dynamic arg5, Dynamic arg6, Dynamic arg7, Dynamic arg8, Dynamic arg9, Dynamic arg10, Dynamic arg11]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec3.zero();
    col1 = new vec3.zero();
    col2 = new vec3.zero();
    col3 = new vec3.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    col2.z = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num && arg4 is num && arg5 is num && arg6 is num && arg7 is num && arg8 is num && arg9 is num && arg10 is num && arg11 is num) {
      col0.x = arg0;
      col0.y = arg1;
      col0.z = arg2;
      col1.x = arg3;
      col1.y = arg4;
      col1.z = arg5;
      col2.x = arg6;
      col2.y = arg7;
      col2.z = arg8;
      col3.x = arg9;
      col3.y = arg10;
      col3.z = arg11;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null && arg9 == null && arg10 == null && arg11 == null) {
      col0.x = arg0;
      col1.y = arg0;
      col2.z = arg0;
      return;
    }
    if (arg0 is vec4 && arg1 is vec4 && arg2 is vec4 && arg3 is vec4) {
      col0 = arg0;
      col1 = arg1;
      col2 = arg2;
      col3 = arg3;
      return;
    }
    if (arg0 is mat4x3) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      col2 = arg0.col2;
      col3 = arg0.col3;
      return;
    }
    if (arg0 is mat4x2) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      col2.x = arg0.col2.x;
      col2.y = arg0.col2.y;
      col3.x = arg0.col3.x;
      col3.y = arg0.col3.y;
      return;
    }
    if (arg0 is mat3x3) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col0.z = arg0.col0.z;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      col1.z = arg0.col1.z;
      col2.x = arg0.col2.x;
      col2.y = arg0.col2.y;
      col2.z = arg0.col2.z;
      return;
    }
    if (arg0 is mat3x2) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      col2.x = arg0.col2.x;
      col2.y = arg0.col2.y;
      return;
    }
    if (arg0 is mat2x3) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col0.z = arg0.col0.z;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      col1.z = arg0.col1.z;
      return;
    }
    if (arg0 is mat2x2) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null && arg9 == null && arg10 == null && arg11 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
    }
    if (arg0 is vec3 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null && arg9 == null && arg10 == null && arg11 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
      col2.z = arg0.z;
    }
  }
  /// Constructs a new [mat4x3] from computing the outer product of [u] and [v].
  mat4x3.outer(vec4 u, vec3 v) {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col3 = new vec3();
    col0.x = u.x * v.x;
    col0.y = u.x * v.y;
    col0.z = u.x * v.z;
    col1.x = u.y * v.x;
    col1.y = u.y * v.y;
    col1.z = u.y * v.z;
    col2.x = u.z * v.x;
    col2.y = u.z * v.y;
    col2.z = u.z * v.z;
    col3.x = u.w * v.x;
    col3.y = u.w * v.y;
    col3.z = u.w * v.z;
  }
  /// Constructs a new [mat4x3] filled with zeros.
  mat4x3.zero() {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col3 = new vec3();
    col0.x = 0.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    col1.z = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 0.0;
    col3.x = 0.0;
    col3.y = 0.0;
    col3.z = 0.0;
  }
  /// Constructs a new identity [mat4x3].
  mat4x3.identity() {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col3 = new vec3();
    col0.x = 1.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    col1.z = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 1.0;
    col3.x = 0.0;
    col3.y = 0.0;
    col3.z = 0.0;
  }
  /// Constructs a new [mat4x3] which is a copy of [other].
  mat4x3.copy(mat4x3 other) {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col3 = new vec3();
    col0.x = other.col0.x;
    col0.y = other.col0.y;
    col0.z = other.col0.z;
    col1.x = other.col1.x;
    col1.y = other.col1.y;
    col1.z = other.col1.z;
    col2.x = other.col2.x;
    col2.y = other.col2.y;
    col2.z = other.col2.z;
    col3.x = other.col3.x;
    col3.y = other.col3.y;
    col3.z = other.col3.z;
  }
  mat4x3.raw(num arg0, num arg1, num arg2, num arg3, num arg4, num arg5, num arg6, num arg7, num arg8, num arg9, num arg10, num arg11) {
    col0 = new vec3.zero();
    col1 = new vec3.zero();
    col2 = new vec3.zero();
    col3 = new vec3.zero();
    col0.x = arg0;
    col0.y = arg1;
    col0.z = arg2;
    col1.x = arg3;
    col1.y = arg4;
    col1.z = arg5;
    col2.x = arg6;
    col2.y = arg7;
    col2.z = arg8;
    col3.x = arg9;
    col3.y = arg10;
    col3.z = arg11;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    s = '$s[2] ${getRow(2)}\n';
    return s;
  }
  /// Returns the number of rows in the matrix.
  num get rows() => 3;
  /// Returns the number of columns in the matrix.
  num get cols() => 4;
  /// Returns the number of columns in the matrix.
  num get length() => 4;
  /// Gets the [column] of the matrix
  vec3 operator[](int column) {
    assert(column >= 0 && column < 4);
    switch (column) {
      case 0: return col0;
      case 1: return col1;
      case 2: return col2;
      case 3: return col3;
    }
    throw new IllegalArgumentException(column);
  }
  /// Assigns the [column] of the matrix [arg]
  void operator[]=(int column, vec3 arg) {
    assert(column >= 0 && column < 4);
    switch (column) {
      case 0: col0 = arg; break;
      case 1: col1 = arg; break;
      case 2: col2 = arg; break;
      case 3: col3 = arg; break;
    }
    throw new IllegalArgumentException(column);
  }
  /// Returns row 0
  vec4 get row0() => getRow(0);
  /// Returns row 1
  vec4 get row1() => getRow(1);
  /// Returns row 2
  vec4 get row2() => getRow(2);
  /// Sets row 0 to [arg]
  set row0(vec4 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec4 arg) => setRow(1, arg);
  /// Sets row 2 to [arg]
  set row2(vec4 arg) => setRow(2, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec4 arg) {
    assert(row >= 0 && row < 3);
    col0[row] = arg.x;
    col1[row] = arg.y;
    col2[row] = arg.z;
    col3[row] = arg.w;
  }
  /// Gets the [row] of the matrix
  vec4 getRow(int row) {
    assert(row >= 0 && row < 3);
    vec4 r = new vec4();
    r.x = col0[row];
    r.y = col1[row];
    r.z = col2[row];
    r.w = col3[row];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec3 arg) {
    assert(column >= 0 && column < 4);
    this[column] = arg;
  }
  /// Gets the [column] of the matrix
  vec3 getColumn(int column) {
    assert(column >= 0 && column < 4);
    return new vec3(this[column]);
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat4x3 r = new mat4x3.zero();
      r.col0.x = col0.x * arg;
      r.col0.y = col0.y * arg;
      r.col0.z = col0.z * arg;
      r.col1.x = col1.x * arg;
      r.col1.y = col1.y * arg;
      r.col1.z = col1.z * arg;
      r.col2.x = col2.x * arg;
      r.col2.y = col2.y * arg;
      r.col2.z = col2.z * arg;
      r.col3.x = col3.x * arg;
      r.col3.y = col3.y * arg;
      r.col3.z = col3.z * arg;
      return r;
    }
    if (arg is vec4) {
      vec3 r = new vec3.zero();
      r.x =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z) + (this.col3.x * arg.w);
      r.y =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z) + (this.col3.y * arg.w);
      r.z =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z) + (this.col3.z * arg.w);
      return r;
    }
    if (4 == arg.rows) {
      Dynamic r = null;
      if (arg.cols == 2) {
        r = new mat2x3.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y) + (this.col2.x * arg.col0.z) + (this.col3.x * arg.col0.w);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y) + (this.col2.x * arg.col1.z) + (this.col3.x * arg.col1.w);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y) + (this.col2.y * arg.col0.z) + (this.col3.y * arg.col0.w);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y) + (this.col2.y * arg.col1.z) + (this.col3.y * arg.col1.w);
        r.col0.z =  (this.col0.z * arg.col0.x) + (this.col1.z * arg.col0.y) + (this.col2.z * arg.col0.z) + (this.col3.z * arg.col0.w);
        r.col1.z =  (this.col0.z * arg.col1.x) + (this.col1.z * arg.col1.y) + (this.col2.z * arg.col1.z) + (this.col3.z * arg.col1.w);
        return r;
      }
      if (arg.cols == 3) {
        r = new mat3x3.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y) + (this.col2.x * arg.col0.z) + (this.col3.x * arg.col0.w);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y) + (this.col2.x * arg.col1.z) + (this.col3.x * arg.col1.w);
        r.col2.x =  (this.col0.x * arg.col2.x) + (this.col1.x * arg.col2.y) + (this.col2.x * arg.col2.z) + (this.col3.x * arg.col2.w);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y) + (this.col2.y * arg.col0.z) + (this.col3.y * arg.col0.w);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y) + (this.col2.y * arg.col1.z) + (this.col3.y * arg.col1.w);
        r.col2.y =  (this.col0.y * arg.col2.x) + (this.col1.y * arg.col2.y) + (this.col2.y * arg.col2.z) + (this.col3.y * arg.col2.w);
        r.col0.z =  (this.col0.z * arg.col0.x) + (this.col1.z * arg.col0.y) + (this.col2.z * arg.col0.z) + (this.col3.z * arg.col0.w);
        r.col1.z =  (this.col0.z * arg.col1.x) + (this.col1.z * arg.col1.y) + (this.col2.z * arg.col1.z) + (this.col3.z * arg.col1.w);
        r.col2.z =  (this.col0.z * arg.col2.x) + (this.col1.z * arg.col2.y) + (this.col2.z * arg.col2.z) + (this.col3.z * arg.col2.w);
        return r;
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat4x3 operator+(mat4x3 arg) {
    mat4x3 r = new mat4x3();
    r.col0.x = col0.x + arg.col0.x;
    r.col0.y = col0.y + arg.col0.y;
    r.col0.z = col0.z + arg.col0.z;
    r.col1.x = col1.x + arg.col1.x;
    r.col1.y = col1.y + arg.col1.y;
    r.col1.z = col1.z + arg.col1.z;
    r.col2.x = col2.x + arg.col2.x;
    r.col2.y = col2.y + arg.col2.y;
    r.col2.z = col2.z + arg.col2.z;
    r.col3.x = col3.x + arg.col3.x;
    r.col3.y = col3.y + arg.col3.y;
    r.col3.z = col3.z + arg.col3.z;
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat4x3 operator-(mat4x3 arg) {
    mat4x3 r = new mat4x3();
    r.col0.x = col0.x - arg.col0.x;
    r.col0.y = col0.y - arg.col0.y;
    r.col0.z = col0.z - arg.col0.z;
    r.col1.x = col1.x - arg.col1.x;
    r.col1.y = col1.y - arg.col1.y;
    r.col1.z = col1.z - arg.col1.z;
    r.col2.x = col2.x - arg.col2.x;
    r.col2.y = col2.y - arg.col2.y;
    r.col2.z = col2.z - arg.col2.z;
    r.col3.x = col3.x - arg.col3.x;
    r.col3.y = col3.y - arg.col3.y;
    r.col3.z = col3.z - arg.col3.z;
    return r;
  }
  /// Returns new matrix -this
  mat4x3 operator negate() {
    mat4x3 r = new mat4x3();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    r[3] = -this[3];
    return r;
  }
  /// Returns the tranpose of this.
  mat3x4 transposed() {
    mat3x4 r = new mat3x4();
    r.col0.x = col0.x;
    r.col0.y = col1.x;
    r.col0.z = col2.x;
    r.col0.w = col3.x;
    r.col1.x = col0.y;
    r.col1.y = col1.y;
    r.col1.z = col2.y;
    r.col1.w = col3.y;
    r.col2.x = col0.z;
    r.col2.y = col1.z;
    r.col2.z = col2.z;
    r.col2.w = col3.z;
    return r;
  }
  /// Returns the component wise absolute value of this.
  mat4x3 absolute() {
    mat4x3 r = new mat4x3();
    r.col0.x = col0.x.abs();
    r.col0.y = col0.y.abs();
    r.col0.z = col0.z.abs();
    r.col1.x = col1.x.abs();
    r.col1.y = col1.y.abs();
    r.col1.z = col1.z.abs();
    r.col2.x = col2.x.abs();
    r.col2.y = col2.y.abs();
    r.col2.z = col2.z.abs();
    r.col3.x = col3.x.abs();
    r.col3.y = col3.y.abs();
    r.col3.z = col3.z.abs();
    return r;
  }
  /// Returns infinity norm of the matrix. Used for numerical analysis.
  num infinityNorm() {
    num norm = 0.0;
    {
      num row_norm = 0.0;
      row_norm += this[0][0].abs();
      row_norm += this[0][1].abs();
      row_norm += this[0][2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[1][0].abs();
      row_norm += this[1][1].abs();
      row_norm += this[1][2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[2][0].abs();
      row_norm += this[2][1].abs();
      row_norm += this[2][2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[3][0].abs();
      row_norm += this[3][1].abs();
      row_norm += this[3][2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  num relativeError(mat4x3 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  num absoluteError(mat4x3 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  mat4x3 copy() {
    return new mat4x3.copy(this);
  }
  void copyIntoMatrix(mat4x3 arg) {
    arg.col0.x = col0.x;
    arg.col0.y = col0.y;
    arg.col0.z = col0.z;
    arg.col1.x = col1.x;
    arg.col1.y = col1.y;
    arg.col1.z = col1.z;
    arg.col2.x = col2.x;
    arg.col2.y = col2.y;
    arg.col2.z = col2.z;
    arg.col3.x = col3.x;
    arg.col3.y = col3.y;
    arg.col3.z = col3.z;
  }
  void copyFromMatrix(mat4x3 arg) {
    col0.x = arg.col0.x;
    col0.y = arg.col0.y;
    col0.z = arg.col0.z;
    col1.x = arg.col1.x;
    col1.y = arg.col1.y;
    col1.z = arg.col1.z;
    col2.x = arg.col2.x;
    col2.y = arg.col2.y;
    col2.z = arg.col2.z;
    col3.x = arg.col3.x;
    col3.y = arg.col3.y;
    col3.z = arg.col3.z;
  }
  mat4x3 selfAdd(mat4x3 o) {
    col0.x = col0.x + o.col0.x;
    col0.y = col0.y + o.col0.y;
    col0.z = col0.z + o.col0.z;
    col1.x = col1.x + o.col1.x;
    col1.y = col1.y + o.col1.y;
    col1.z = col1.z + o.col1.z;
    col2.x = col2.x + o.col2.x;
    col2.y = col2.y + o.col2.y;
    col2.z = col2.z + o.col2.z;
    col3.x = col3.x + o.col3.x;
    col3.y = col3.y + o.col3.y;
    col3.z = col3.z + o.col3.z;
    return this;
  }
  mat4x3 selfSub(mat4x3 o) {
    col0.x = col0.x - o.col0.x;
    col0.y = col0.y - o.col0.y;
    col0.z = col0.z - o.col0.z;
    col1.x = col1.x - o.col1.x;
    col1.y = col1.y - o.col1.y;
    col1.z = col1.z - o.col1.z;
    col2.x = col2.x - o.col2.x;
    col2.y = col2.y - o.col2.y;
    col2.z = col2.z - o.col2.z;
    col3.x = col3.x - o.col3.x;
    col3.y = col3.y - o.col3.y;
    col3.z = col3.z - o.col3.z;
    return this;
  }
  mat4x3 selfScale(num o) {
    col0.x = col0.x * o;
    col0.y = col0.y * o;
    col0.z = col0.z * o;
    col1.x = col1.x * o;
    col1.y = col1.y * o;
    col1.z = col1.z * o;
    col2.x = col2.x * o;
    col2.y = col2.y * o;
    col2.z = col2.z * o;
    col3.x = col3.x * o;
    col3.y = col3.y * o;
    col3.z = col3.z * o;
    return this;
  }
  mat4x3 selfNegate() {
    col0.x = -col0.x;
    col0.y = -col0.y;
    col0.z = -col0.z;
    col1.x = -col1.x;
    col1.y = -col1.y;
    col1.z = -col1.z;
    col2.x = -col2.x;
    col2.y = -col2.y;
    col2.z = -col2.z;
    col3.x = -col3.x;
    col3.y = -col3.y;
    col3.z = -col3.z;
    return this;
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(Float32Array array, [int offset=0]) {
    int i = offset;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col0.z;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
    array[i] = col2.z;
    i++;
    array[i] = col3.x;
    i++;
    array[i] = col3.y;
    i++;
    array[i] = col3.z;
    i++;
  }
  /// Returns a copy of [this] as a [Float32Array].
  Float32Array copyAsArray() {
    Float32Array array = new Float32Array(12);
    int i = 0;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col0.z;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
    array[i] = col2.z;
    i++;
    array[i] = col3.x;
    i++;
    array[i] = col3.y;
    i++;
    array[i] = col3.z;
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
    col0.z = array[i];
    i++;
    col1.x = array[i];
    i++;
    col1.y = array[i];
    i++;
    col1.z = array[i];
    i++;
    col2.x = array[i];
    i++;
    col2.y = array[i];
    i++;
    col2.z = array[i];
    i++;
    col3.x = array[i];
    i++;
    col3.y = array[i];
    i++;
    col3.z = array[i];
    i++;
  }
}
