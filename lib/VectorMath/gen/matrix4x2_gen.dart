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
class mat4x2 {
  vec2 col0;
  vec2 col1;
  vec2 col2;
  vec2 col3;
  num get rows() => 2;
  num get cols() => 4;
  num get length() => 4;
  vec4 get row0() => getRow(0);
  vec4 get row1() => getRow(1);
  set row0(vec4 arg) => setRow(0, arg);
  set row1(vec4 arg) => setRow(1, arg);
  vec2 operator[](int column) {
    assert(column >= 0 && column < 4);
    switch (column) {
      case 0: return col0; break;
      case 1: return col1; break;
      case 2: return col2; break;
      case 3: return col3; break;
    }
    throw new IllegalArgumentException(column);
  }
  vec2 operator[]=(int column, vec2 arg) {
    assert(column >= 0 && column < 4);
    switch (column) {
      case 0: col0 = arg; return col0; break;
      case 1: col1 = arg; return col1; break;
      case 2: col2 = arg; return col2; break;
      case 3: col3 = arg; return col3; break;
    }
    throw new IllegalArgumentException(column);
  }
  String toString() {
    String s = '';
    s += '[0] ${getRow(0)}\n';
    s += '[1] ${getRow(1)}\n';
    return s;
  }
  void setRow(int row, vec4 arg) {
    assert(row >= 0 && row < 2);
    this[0][row] = arg[0];
    this[1][row] = arg[1];
    this[2][row] = arg[2];
    this[3][row] = arg[3];
  }
  vec4 getRow(int row) {
    assert(row >= 0 && row < 2);
    vec4 r = new vec4();
    r[0] = this[0][row];
    r[1] = this[1][row];
    r[2] = this[2][row];
    r[3] = this[3][row];
    return r;
  }
  void setColumn(int column, vec2 arg) {
    assert(column >= 0 && column < 4);
    this[column] = arg;
  }
  vec2 getColumn(int column) {
    assert(column >= 0 && column < 4);
    return new vec2(this[column]);
  }
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat4x2 r = new mat4x2();
      r[0][0] = this[0][0] * arg;
      r[0][1] = this[0][1] * arg;
      r[1][0] = this[1][0] * arg;
      r[1][1] = this[1][1] * arg;
      r[2][0] = this[2][0] * arg;
      r[2][1] = this[2][1] * arg;
      r[3][0] = this[3][0] * arg;
      r[3][1] = this[3][1] * arg;
      return r;
    }
    if (arg is vec4) {
      vec2 r = new vec2();
      r[0] = dot(row0, arg);
      r[1] = dot(row1, arg);
      return r;
    }
    if (2 == arg.cols) {
      Dynamic r = null;
      if (arg.rows == 2) {
        r = new mat4x2();
      }
      if (arg.rows == 3) {
        r = new mat4x3();
      }
      if (arg.rows == 4) {
        r = new mat4x4();
      }
      for (int j = 0; j < arg.rows; j++) {
        r[0][j] = dot(this.getRow(0), arg.getColumn(j));
      }
      for (int j = 0; j < arg.rows; j++) {
        r[1][j] = dot(this.getRow(1), arg.getColumn(j));
      }
      for (int j = 0; j < arg.rows; j++) {
        r[2][j] = dot(this.getRow(2), arg.getColumn(j));
      }
      for (int j = 0; j < arg.rows; j++) {
        r[3][j] = dot(this.getRow(3), arg.getColumn(j));
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  mat4x2 operator+(mat4x2 arg) {
    mat4x2 r = new mat4x2();
    r[0][0] = this[0][0] + arg[0][0];
    r[0][1] = this[0][1] + arg[0][1];
    r[1][0] = this[1][0] + arg[1][0];
    r[1][1] = this[1][1] + arg[1][1];
    r[2][0] = this[2][0] + arg[2][0];
    r[2][1] = this[2][1] + arg[2][1];
    r[3][0] = this[3][0] + arg[3][0];
    r[3][1] = this[3][1] + arg[3][1];
    return r;
  }
  mat4x2 operator-(mat4x2 arg) {
    mat4x2 r = new mat4x2();
    r[0][0] = this[0][0] - arg[0][0];
    r[0][1] = this[0][1] - arg[0][1];
    r[1][0] = this[1][0] - arg[1][0];
    r[1][1] = this[1][1] - arg[1][1];
    r[2][0] = this[2][0] - arg[2][0];
    r[2][1] = this[2][1] - arg[2][1];
    r[3][0] = this[3][0] - arg[3][0];
    r[3][1] = this[3][1] - arg[3][1];
    return r;
  }
  mat4x2 operator negate() {
    mat4x2 r = new mat4x2();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    r[3] = -this[3];
    return r;
  }
  mat2x4 transposed() {
    mat2x4 r = new mat2x4();
    r[0][0] = this[0][0];
    r[1][0] = this[0][1];
    r[2][0] = this[0][2];
    r[3][0] = this[0][3];
    r[0][1] = this[1][0];
    r[1][1] = this[1][1];
    r[2][1] = this[1][2];
    r[3][1] = this[1][3];
    return r;
  }
  mat4x2 absolute() {
    mat4x2 r = new mat4x2();
    r[0][0] = this[0][0].abs();
    r[0][1] = this[0][1].abs();
    r[1][0] = this[1][0].abs();
    r[1][1] = this[1][1].abs();
    r[2][0] = this[2][0].abs();
    r[2][1] = this[2][1].abs();
    r[3][0] = this[3][0].abs();
    r[3][1] = this[3][1].abs();
    return r;
  }
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
    {
      num row_norm = 0.0;
      row_norm += this[3][0].abs();
      row_norm += this[3][1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  num relativeError(mat4x2 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  num absoluteError(mat4x2 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  mat4x2([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4, Dynamic arg5, Dynamic arg6, Dynamic arg7]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec2();
    col1 = new vec2();
    col2 = new vec2();
    col3 = new vec2();
    col0[0] = 1.0;
    col1[1] = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num && arg4 is num && arg5 is num && arg6 is num && arg7 is num) {
      col0[0] = arg0;
      col0[1] = arg1;
      col1[0] = arg4;
      col1[1] = arg5;
      col2[0] = arg8;
      col2[1] = arg9;
      col3[0] = arg12;
      col3[1] = arg13;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null) {
      col0[0] = arg0;
      col1[1] = arg0;
      return;
    }
    if (arg0 is vec4 && arg1 is vec4 && arg2 is vec4 && arg3 is vec4) {
      col0 = arg0;
      col1 = arg1;
      col2 = arg2;
      col3 = arg3;
      return;
    }
    if (arg0 is mat4x2) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      col2 = arg0.col2;
      col3 = arg0.col3;
      return;
    }
    if (arg0 is mat3x2) {
      col0[0] = arg0.col0[0];
      col0[1] = arg0.col0[1];
      col1[0] = arg0.col1[0];
      col1[1] = arg0.col1[1];
      col2[0] = arg0.col2[0];
      col2[1] = arg0.col2[1];
      return;
    }
    if (arg0 is mat2x2) {
      col0[0] = arg0.col0[0];
      col0[1] = arg0.col0[1];
      col1[0] = arg0.col1[0];
      col1[1] = arg0.col1[1];
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null) {
      col0[0] = arg0[0];
      col1[1] = arg0[1];
    }
  }
  mat4x2.outer(vec4 u, vec2 v) {
    col0[0] = u[0] * v[0];
    col0[1] = u[0] * v[1];
    col1[0] = u[1] * v[0];
    col1[1] = u[1] * v[1];
    col2[0] = u[2] * v[0];
    col2[1] = u[2] * v[1];
    col3[0] = u[3] * v[0];
    col3[1] = u[3] * v[1];
  }
  mat4x2.zero() {
    col0[0] = 0.0;
    col0[1] = 0.0;
    col1[0] = 0.0;
    col1[1] = 0.0;
    col2[0] = 0.0;
    col2[1] = 0.0;
    col3[0] = 0.0;
    col3[1] = 0.0;
  }
}
