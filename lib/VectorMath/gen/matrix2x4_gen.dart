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
/// mat2x4 is a column major matrix where each column is represented by [vec4]. This matrix has 2 columns and 4 rows.
class mat2x4 {
  vec4 col0;
  vec4 col1;
  /// Constructs a new mat2x4. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.
  mat2x4([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4, Dynamic arg5, Dynamic arg6, Dynamic arg7]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num && arg4 is num && arg5 is num && arg6 is num && arg7 is num) {
      col0.x = arg0;
      col0.y = arg1;
      col0.z = arg2;
      col0.w = arg3;
      col1.x = arg4;
      col1.y = arg5;
      col1.z = arg6;
      col1.w = arg7;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null) {
      col0.x = arg0;
      col1.y = arg0;
      return;
    }
    if (arg0 is vec2 && arg1 is vec2) {
      col0 = arg0;
      col1 = arg1;
      return;
    }
    if (arg0 is mat2x4) {
      col0 = arg0.col0;
      col1 = arg0.col1;
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
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
    }
  }
  /// Constructs a new [mat2x4] from computing the outer product of [u] and [v].
  mat2x4.outer(vec2 u, vec4 v) {
    col0 = new vec4();
    col1 = new vec4();
    col0.x = u.x * v.x;
    col0.y = u.x * v.y;
    col0.z = u.x * v.z;
    col0.w = u.x * v.w;
    col1.x = u.y * v.x;
    col1.y = u.y * v.y;
    col1.z = u.y * v.z;
    col1.w = u.y * v.w;
  }
  /// Constructs a new [mat2x4] filled with zeros.
  mat2x4.zero() {
    col0 = new vec4();
    col1 = new vec4();
    col0.x = 0.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col0.w = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    col1.z = 0.0;
    col1.w = 0.0;
  }
  /// Constructs a new identity [mat2x4].
  mat2x4.identity() {
    col0 = new vec4();
    col1 = new vec4();
    col0.x = 1.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col0.w = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    col1.z = 0.0;
    col1.w = 0.0;
  }
  /// Constructs a new [mat2x4] which is a copy of [other].
  mat2x4.copy(mat2x4 other) {
    col0 = new vec4();
    col1 = new vec4();
    col0.x = other.col0.x;
    col0.y = other.col0.y;
    col0.z = other.col0.z;
    col0.w = other.col0.w;
    col1.x = other.col1.x;
    col1.y = other.col1.y;
    col1.z = other.col1.z;
    col1.w = other.col1.w;
  }
  mat2x4.raw(num arg0, num arg1, num arg2, num arg3, num arg4, num arg5, num arg6, num arg7) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col0.x = arg0;
    col0.y = arg1;
    col0.z = arg2;
    col0.w = arg3;
    col1.x = arg4;
    col1.y = arg5;
    col1.z = arg6;
    col1.w = arg7;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    s = '$s[2] ${getRow(2)}\n';
    s = '$s[3] ${getRow(3)}\n';
    return s;
  }
  /// Returns the number of rows in the matrix.
  num get rows() => 4;
  /// Returns the number of columns in the matrix.
  num get cols() => 2;
  /// Returns the number of columns in the matrix.
  num get length() => 2;
  /// Gets the [column] of the matrix
  vec4 operator[](int column) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: return col0;
      case 1: return col1;
    }
    throw new IllegalArgumentException(column);
  }
  /// Assigns the [column] of the matrix [arg]
  void operator[]=(int column, vec4 arg) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: col0 = arg; break;
      case 1: col1 = arg; break;
    }
    throw new IllegalArgumentException(column);
  }
  /// Returns row 0
  vec2 get row0() => getRow(0);
  /// Returns row 1
  vec2 get row1() => getRow(1);
  /// Returns row 2
  vec2 get row2() => getRow(2);
  /// Returns row 3
  vec2 get row3() => getRow(3);
  /// Sets row 0 to [arg]
  set row0(vec2 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec2 arg) => setRow(1, arg);
  /// Sets row 2 to [arg]
  set row2(vec2 arg) => setRow(2, arg);
  /// Sets row 3 to [arg]
  set row3(vec2 arg) => setRow(3, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec2 arg) {
    assert(row >= 0 && row < 4);
    col0[row] = arg.x;
    col1[row] = arg.y;
  }
  /// Gets the [row] of the matrix
  vec2 getRow(int row) {
    assert(row >= 0 && row < 4);
    vec2 r = new vec2();
    r.x = col0[row];
    r.y = col1[row];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec4 arg) {
    assert(column >= 0 && column < 2);
    this[column] = arg;
  }
  /// Gets the [column] of the matrix
  vec4 getColumn(int column) {
    assert(column >= 0 && column < 2);
    return new vec4(this[column]);
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat2x4 r = new mat2x4.zero();
      r.col0.x = col0.x * arg;
      r.col0.y = col0.y * arg;
      r.col0.z = col0.z * arg;
      r.col0.w = col0.w * arg;
      r.col1.x = col1.x * arg;
      r.col1.y = col1.y * arg;
      r.col1.z = col1.z * arg;
      r.col1.w = col1.w * arg;
      return r;
    }
    if (arg is vec2) {
      vec4 r = new vec4.zero();
      r.x =  (this.col0.x * arg.x) + (this.col1.x * arg.y);
      r.y =  (this.col0.y * arg.x) + (this.col1.y * arg.y);
      r.z =  (this.col0.z * arg.x) + (this.col1.z * arg.y);
      r.w =  (this.col0.w * arg.x) + (this.col1.w * arg.y);
      return r;
    }
    if (2 == arg.rows) {
      Dynamic r = null;
      if (arg.cols == 2) {
        r = new mat2x4.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y);
        r.col0.z =  (this.col0.z * arg.col0.x) + (this.col1.z * arg.col0.y);
        r.col1.z =  (this.col0.z * arg.col1.x) + (this.col1.z * arg.col1.y);
        r.col0.w =  (this.col0.w * arg.col0.x) + (this.col1.w * arg.col0.y);
        r.col1.w =  (this.col0.w * arg.col1.x) + (this.col1.w * arg.col1.y);
        return r;
      }
      if (arg.cols == 3) {
        r = new mat3x4.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y);
        r.col2.x =  (this.col0.x * arg.col2.x) + (this.col1.x * arg.col2.y);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y);
        r.col2.y =  (this.col0.y * arg.col2.x) + (this.col1.y * arg.col2.y);
        r.col0.z =  (this.col0.z * arg.col0.x) + (this.col1.z * arg.col0.y);
        r.col1.z =  (this.col0.z * arg.col1.x) + (this.col1.z * arg.col1.y);
        r.col2.z =  (this.col0.z * arg.col2.x) + (this.col1.z * arg.col2.y);
        r.col0.w =  (this.col0.w * arg.col0.x) + (this.col1.w * arg.col0.y);
        r.col1.w =  (this.col0.w * arg.col1.x) + (this.col1.w * arg.col1.y);
        r.col2.w =  (this.col0.w * arg.col2.x) + (this.col1.w * arg.col2.y);
        return r;
      }
      if (arg.cols == 4) {
        r = new mat4x4.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y);
        r.col2.x =  (this.col0.x * arg.col2.x) + (this.col1.x * arg.col2.y);
        r.col3.x =  (this.col0.x * arg.col3.x) + (this.col1.x * arg.col3.y);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y);
        r.col2.y =  (this.col0.y * arg.col2.x) + (this.col1.y * arg.col2.y);
        r.col3.y =  (this.col0.y * arg.col3.x) + (this.col1.y * arg.col3.y);
        r.col0.z =  (this.col0.z * arg.col0.x) + (this.col1.z * arg.col0.y);
        r.col1.z =  (this.col0.z * arg.col1.x) + (this.col1.z * arg.col1.y);
        r.col2.z =  (this.col0.z * arg.col2.x) + (this.col1.z * arg.col2.y);
        r.col3.z =  (this.col0.z * arg.col3.x) + (this.col1.z * arg.col3.y);
        r.col0.w =  (this.col0.w * arg.col0.x) + (this.col1.w * arg.col0.y);
        r.col1.w =  (this.col0.w * arg.col1.x) + (this.col1.w * arg.col1.y);
        r.col2.w =  (this.col0.w * arg.col2.x) + (this.col1.w * arg.col2.y);
        r.col3.w =  (this.col0.w * arg.col3.x) + (this.col1.w * arg.col3.y);
        return r;
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat2x4 operator+(mat2x4 arg) {
    mat2x4 r = new mat2x4();
    r.col0.x = col0.x + arg.col0.x;
    r.col0.y = col0.y + arg.col0.y;
    r.col0.z = col0.z + arg.col0.z;
    r.col0.w = col0.w + arg.col0.w;
    r.col1.x = col1.x + arg.col1.x;
    r.col1.y = col1.y + arg.col1.y;
    r.col1.z = col1.z + arg.col1.z;
    r.col1.w = col1.w + arg.col1.w;
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat2x4 operator-(mat2x4 arg) {
    mat2x4 r = new mat2x4();
    r.col0.x = col0.x - arg.col0.x;
    r.col0.y = col0.y - arg.col0.y;
    r.col0.z = col0.z - arg.col0.z;
    r.col0.w = col0.w - arg.col0.w;
    r.col1.x = col1.x - arg.col1.x;
    r.col1.y = col1.y - arg.col1.y;
    r.col1.z = col1.z - arg.col1.z;
    r.col1.w = col1.w - arg.col1.w;
    return r;
  }
  /// Returns new matrix -this
  mat2x4 operator negate() {
    mat2x4 r = new mat2x4();
    r[0] = -this[0];
    r[1] = -this[1];
    return r;
  }
  /// Returns the tranpose of this.
  mat4x2 transposed() {
    mat4x2 r = new mat4x2();
    r.col0.x = col0.x;
    r.col0.y = col1.x;
    r.col1.x = col0.y;
    r.col1.y = col1.y;
    r.col2.x = col0.z;
    r.col2.y = col1.z;
    r.col3.x = col0.w;
    r.col3.y = col1.w;
    return r;
  }
  /// Returns the component wise absolute value of this.
  mat2x4 absolute() {
    mat2x4 r = new mat2x4();
    r.col0.x = col0.x.abs();
    r.col0.y = col0.y.abs();
    r.col0.z = col0.z.abs();
    r.col0.w = col0.w.abs();
    r.col1.x = col1.x.abs();
    r.col1.y = col1.y.abs();
    r.col1.z = col1.z.abs();
    r.col1.w = col1.w.abs();
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
      row_norm += this[0][3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[1][0].abs();
      row_norm += this[1][1].abs();
      row_norm += this[1][2].abs();
      row_norm += this[1][3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  num relativeError(mat2x4 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  num absoluteError(mat2x4 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  mat2x4 copy() {
    return new mat2x4.copy(this);
  }
  void copyIntoMatrix(mat2x4 arg) {
    arg.col0.x = col0.x;
    arg.col0.y = col0.y;
    arg.col0.z = col0.z;
    arg.col0.w = col0.w;
    arg.col1.x = col1.x;
    arg.col1.y = col1.y;
    arg.col1.z = col1.z;
    arg.col1.w = col1.w;
  }
  void copyFromMatrix(mat2x4 arg) {
    col0.x = arg.col0.x;
    col0.y = arg.col0.y;
    col0.z = arg.col0.z;
    col0.w = arg.col0.w;
    col1.x = arg.col1.x;
    col1.y = arg.col1.y;
    col1.z = arg.col1.z;
    col1.w = arg.col1.w;
  }
  mat2x4 selfAdd(mat2x4 o) {
    col0.x = col0.x + o.col0.x;
    col0.y = col0.y + o.col0.y;
    col0.z = col0.z + o.col0.z;
    col0.w = col0.w + o.col0.w;
    col1.x = col1.x + o.col1.x;
    col1.y = col1.y + o.col1.y;
    col1.z = col1.z + o.col1.z;
    col1.w = col1.w + o.col1.w;
    return this;
  }
  mat2x4 selfSub(mat2x4 o) {
    col0.x = col0.x - o.col0.x;
    col0.y = col0.y - o.col0.y;
    col0.z = col0.z - o.col0.z;
    col0.w = col0.w - o.col0.w;
    col1.x = col1.x - o.col1.x;
    col1.y = col1.y - o.col1.y;
    col1.z = col1.z - o.col1.z;
    col1.w = col1.w - o.col1.w;
    return this;
  }
  mat2x4 selfScale(num o) {
    col0.x = col0.x * o;
    col0.y = col0.y * o;
    col0.z = col0.z * o;
    col0.w = col0.w * o;
    col1.x = col1.x * o;
    col1.y = col1.y * o;
    col1.z = col1.z * o;
    col1.w = col1.w * o;
    return this;
  }
  mat2x4 selfNegate() {
    col0.x = -col0.x;
    col0.y = -col0.y;
    col0.z = -col0.z;
    col0.w = -col0.w;
    col1.x = -col1.x;
    col1.y = -col1.y;
    col1.z = -col1.z;
    col1.w = -col1.w;
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
    array[i] = col0.w;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col1.w;
    i++;
  }
  /// Returns a copy of [this] as a [Float32Array].
  Float32Array copyAsArray() {
    Float32Array array = new Float32Array(8);
    int i = 0;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col0.z;
    i++;
    array[i] = col0.w;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col1.w;
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
    col0.w = array[i];
    i++;
    col1.x = array[i];
    i++;
    col1.y = array[i];
    i++;
    col1.z = array[i];
    i++;
    col1.w = array[i];
    i++;
  }
}
