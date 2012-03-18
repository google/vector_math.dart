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
class mat3x3 {
  vec3 col0;
  vec3 col1;
  vec3 col2;
  num get rows() => 3;
  num get cols() => 3;
  num get length() => 3;
  vec3 get row0() => getRow(0);
  vec3 get row1() => getRow(1);
  vec3 get row2() => getRow(2);
  set row0(vec3 arg) => setRow(0, arg);
  set row1(vec3 arg) => setRow(1, arg);
  set row2(vec3 arg) => setRow(2, arg);
  vec3 operator[](int column) {
    assert(column >= 0 && column < 3);
    switch (column) {
      case 0: return col0; break;
      case 1: return col1; break;
      case 2: return col2; break;
    }
    throw new IllegalArgumentException(column);
  }
  vec3 operator[]=(int column, vec3 arg) {
    assert(column >= 0 && column < 3);
    switch (column) {
      case 0: col0 = arg; return col0; break;
      case 1: col1 = arg; return col1; break;
      case 2: col2 = arg; return col2; break;
    }
    throw new IllegalArgumentException(column);
  }
  String toString() {
    String s = '';
    s += '[0] ${getRow(0)}\n';
    s += '[1] ${getRow(1)}\n';
    s += '[2] ${getRow(2)}\n';
    return s;
  }
  void setRow(int row, vec3 arg) {
    assert(row >= 0 && row < 3);
    this[0][row] = arg[0];
    this[1][row] = arg[1];
    this[2][row] = arg[2];
  }
  vec3 getRow(int row) {
    assert(row >= 0 && row < 3);
    vec3 r = new vec3();
    r[0] = this[0][row];
    r[1] = this[1][row];
    r[2] = this[2][row];
    return r;
  }
  void setColumn(int column, vec3 arg) {
    assert(column >= 0 && column < 3);
    this[column] = arg;
  }
  vec3 getColumn(int column) {
    assert(column >= 0 && column < 3);
    return new vec3(this[column]);
  }
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat3x3 r = new mat3x3();
      r[0][0] = this[0][0] * arg;
      r[0][1] = this[0][1] * arg;
      r[0][2] = this[0][2] * arg;
      r[1][0] = this[1][0] * arg;
      r[1][1] = this[1][1] * arg;
      r[1][2] = this[1][2] * arg;
      r[2][0] = this[2][0] * arg;
      r[2][1] = this[2][1] * arg;
      r[2][2] = this[2][2] * arg;
      return r;
    }
    if (arg is vec3) {
      vec3 r = new vec3();
      r[0] = dot(row0, arg);
      r[1] = dot(row1, arg);
      r[2] = dot(row2, arg);
      return r;
    }
    if (3 == arg.cols) {
      Dynamic r = null;
      if (arg.rows == 2) {
        r = new mat3x2();
      }
      if (arg.rows == 3) {
        r = new mat3x3();
      }
      if (arg.rows == 4) {
        r = new mat3x4();
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
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  mat3x3 operator+(mat3x3 arg) {
    mat3x3 r = new mat3x3();
    r[0][0] = this[0][0] + arg[0][0];
    r[0][1] = this[0][1] + arg[0][1];
    r[0][2] = this[0][2] + arg[0][2];
    r[1][0] = this[1][0] + arg[1][0];
    r[1][1] = this[1][1] + arg[1][1];
    r[1][2] = this[1][2] + arg[1][2];
    r[2][0] = this[2][0] + arg[2][0];
    r[2][1] = this[2][1] + arg[2][1];
    r[2][2] = this[2][2] + arg[2][2];
    return r;
  }
  mat3x3 operator-(mat3x3 arg) {
    mat3x3 r = new mat3x3();
    r[0][0] = this[0][0] - arg[0][0];
    r[0][1] = this[0][1] - arg[0][1];
    r[0][2] = this[0][2] - arg[0][2];
    r[1][0] = this[1][0] - arg[1][0];
    r[1][1] = this[1][1] - arg[1][1];
    r[1][2] = this[1][2] - arg[1][2];
    r[2][0] = this[2][0] - arg[2][0];
    r[2][1] = this[2][1] - arg[2][1];
    r[2][2] = this[2][2] - arg[2][2];
    return r;
  }
  mat3x3 operator negate() {
    mat3x3 r = new mat3x3();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    return r;
  }
  mat3x3 transposed() {
    mat3x3 r = new mat3x3();
    r[0][0] = this[0][0];
    r[1][0] = this[0][1];
    r[2][0] = this[0][2];
    r[0][1] = this[1][0];
    r[1][1] = this[1][1];
    r[2][1] = this[1][2];
    r[0][2] = this[2][0];
    r[1][2] = this[2][1];
    r[2][2] = this[2][2];
    return r;
  }
  mat3x3 absolute() {
    mat3x3 r = new mat3x3();
    r[0][0] = this[0][0].abs();
    r[0][1] = this[0][1].abs();
    r[0][2] = this[0][2].abs();
    r[1][0] = this[1][0].abs();
    r[1][1] = this[1][1].abs();
    r[1][2] = this[1][2].abs();
    r[2][0] = this[2][0].abs();
    r[2][1] = this[2][1].abs();
    r[2][2] = this[2][2].abs();
    return r;
  }
  num determinant() {
        num x = this[0][0]*((this[2][2]*this[1][1])-(this[2][1]*this[1][2]));
        num y = this[1][0]*((this[2][2]*this[0][1])-(this[2][1]*this[0][2]));
        num z = this[2][0]*((this[1][2]*this[0][1])-(this[1][1]*this[0][2]));
        return x - y + z;
      }
  num trace() {
    num t = 0.0;
    t += this[0][0];
    t += this[1][1];
    t += this[2][2];
    return t;
  }
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
    return norm;
  }
  num relativeError(mat3x3 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  num absoluteError(mat3x3 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  mat3x3([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4, Dynamic arg5, Dynamic arg6, Dynamic arg7, Dynamic arg8]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col0[0] = 1.0;
    col1[1] = 1.0;
    col2[2] = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num && arg4 is num && arg5 is num && arg6 is num && arg7 is num && arg8 is num) {
      col0[0] = arg0;
      col0[1] = arg1;
      col0[2] = arg2;
      col1[0] = arg3;
      col1[1] = arg4;
      col1[2] = arg5;
      col2[0] = arg6;
      col2[1] = arg7;
      col2[2] = arg8;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null) {
      col0[0] = arg0;
      col1[1] = arg0;
      col2[2] = arg0;
      return;
    }
    if (arg0 is vec3 && arg1 is vec3 && arg2 is vec3) {
      col0 = arg0;
      col1 = arg1;
      col2 = arg2;
      return;
    }
    if (arg0 is mat3x3) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      col2 = arg0.col2;
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
    if (arg0 is mat2x3) {
      col0[0] = arg0.col0[0];
      col0[1] = arg0.col0[1];
      col0[2] = arg0.col0[2];
      col1[0] = arg0.col1[0];
      col1[1] = arg0.col1[1];
      col1[2] = arg0.col1[2];
      return;
    }
    if (arg0 is mat2x2) {
      col0[0] = arg0.col0[0];
      col0[1] = arg0.col0[1];
      col1[0] = arg0.col1[0];
      col1[1] = arg0.col1[1];
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null) {
      col0[0] = arg0[0];
      col1[1] = arg0[1];
    }
    if (arg0 is vec3 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null) {
      col0[0] = arg0[0];
      col1[1] = arg0[1];
      col2[2] = arg0[2];
    }
  }
  mat3x3.outer(vec3 u, vec3 v) {
    col0[0] = u[0] * v[0];
    col0[1] = u[0] * v[1];
    col0[2] = u[0] * v[2];
    col1[0] = u[1] * v[0];
    col1[1] = u[1] * v[1];
    col1[2] = u[1] * v[2];
    col2[0] = u[2] * v[0];
    col2[1] = u[2] * v[1];
    col2[2] = u[2] * v[2];
  }
  mat3x3.zero() {
    col0[0] = 0.0;
    col0[1] = 0.0;
    col0[2] = 0.0;
    col1[0] = 0.0;
    col1[1] = 0.0;
    col1[2] = 0.0;
    col2[0] = 0.0;
    col2[1] = 0.0;
    col2[2] = 0.0;
  }
}
