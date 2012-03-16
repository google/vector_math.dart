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
class mat2x4Gen {
  vec4 col0;
  vec4 col1;
  mat2x4Gen([Dynamic col0_, Dynamic col1_]) {
    col0 = new vec4();
    col1 = new vec4();
    col0[0] = 1.0;
    col1[1] = 1.0;
    if (col0_ is vec4 && col1_ is vec4) {
      col0 = col0_;
      col1 = col1_;
    }
  }
  num get rows() => 4;
  num get cols() => 2;
  num get length() => 2;
  vec2 get row0() => getRow(0);
  vec2 get row1() => getRow(1);
  vec2 get row2() => getRow(2);
  vec2 get row3() => getRow(3);
  set row0(vec2 arg) => setRow(0, arg);
  set row1(vec2 arg) => setRow(1, arg);
  set row2(vec2 arg) => setRow(2, arg);
  set row3(vec2 arg) => setRow(3, arg);
  vec4 operator[](int column) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: return col0; break;
      case 1: return col1; break;
    }
    throw new IllegalArgumentException(column);
  }
  vec4 operator[]=(int column, vec4 arg) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: col0 = arg; return col0; break;
      case 1: col1 = arg; return col1; break;
    }
    throw new IllegalArgumentException(column);
  }
  String toString() {
    String s = '';
    s += '[0] ${getRow(0)}\n';
    s += '[1] ${getRow(1)}\n';
    s += '[2] ${getRow(2)}\n';
    s += '[3] ${getRow(3)}\n';
    return s;
  }
  void setRow(int row, vec2 arg) {
    assert(row >= 0 && row < 4);
    this[0][row] = arg[0];
    this[1][row] = arg[1];
  }
  vec2 getRow(int row) {
    assert(row >= 0 && row < 4);
    vec2 r = new vec2();
    r[0] = this[0][row];
    r[1] = this[1][row];
    return r;
  }
  void setColumn(int column, vec4 arg) {
    assert(column >= 0 && column < 2);
    this[column] = arg;
  }
  vec4 getColumn(int column) {
    assert(column >= 0 && column < 2);
    return new vec4(this[column]);
  }
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat2x4Gen r = new mat2x4Gen();
      r[0][0] = this[0][0] * arg;
      r[0][1] = this[0][1] * arg;
      r[0][2] = this[0][2] * arg;
      r[0][3] = this[0][3] * arg;
      r[1][0] = this[1][0] * arg;
      r[1][1] = this[1][1] * arg;
      r[1][2] = this[1][2] * arg;
      r[1][3] = this[1][3] * arg;
      return r;
    }
    if (arg is vec2) {
      vec4 r = new vec4();
      r[0] = dot(row0, arg);
      r[1] = dot(row1, arg);
      r[2] = dot(row2, arg);
      r[3] = dot(row3, arg);
      return r;
    }
    if (4 == arg.cols) {
      Dynamic r = null;
      if (arg.rows == 2) {
        r = new mat2x2Gen();
      }
      if (arg.rows == 3) {
        r = new mat2x3Gen();
      }
      if (arg.rows == 4) {
        r = new mat2x4Gen();
      }
      for (int j = 0; j < arg.rows; j++) {
        r[0][j] = dot(this.getRow(0), arg.getColumn(j));
      }
      for (int j = 0; j < arg.rows; j++) {
        r[1][j] = dot(this.getRow(1), arg.getColumn(j));
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  mat2x4Gen operator+(mat2x4 arg) {
    mat2x4Gen r = new mat2x4Gen();
    r[0][0] = this[0][0] + arg[0][0];
    r[0][1] = this[0][1] + arg[0][1];
    r[0][2] = this[0][2] + arg[0][2];
    r[0][3] = this[0][3] + arg[0][3];
    r[1][0] = this[1][0] + arg[1][0];
    r[1][1] = this[1][1] + arg[1][1];
    r[1][2] = this[1][2] + arg[1][2];
    r[1][3] = this[1][3] + arg[1][3];
    return r;
  }
  mat2x4Gen operator-(mat2x4 arg) {
    mat2x4Gen r = new mat2x4Gen();
    r[0][0] = this[0][0] - arg[0][0];
    r[0][1] = this[0][1] - arg[0][1];
    r[0][2] = this[0][2] - arg[0][2];
    r[0][3] = this[0][3] - arg[0][3];
    r[1][0] = this[1][0] - arg[1][0];
    r[1][1] = this[1][1] - arg[1][1];
    r[1][2] = this[1][2] - arg[1][2];
    r[1][3] = this[1][3] - arg[1][3];
    return r;
  }
  mat4x2Gen transposed() {
    mat4x2Gen r = new mat4x2Gen();
    r[0][0] = this[0][0];
    r[1][0] = this[0][1];
    r[0][1] = this[1][0];
    r[1][1] = this[1][1];
    r[0][2] = this[2][0];
    r[1][2] = this[2][1];
    r[0][3] = this[3][0];
    r[1][3] = this[3][1];
    return r;
  }
  mat2x4Gen absolute() {
    mat2x4Gen r = new mat2x4Gen();
    r[0][0] = this[0][0].abs();
    r[0][1] = this[0][1].abs();
    r[0][2] = this[0][2].abs();
    r[0][3] = this[0][3].abs();
    r[1][0] = this[1][0].abs();
    r[1][1] = this[1][1].abs();
    r[1][2] = this[1][2].abs();
    r[1][3] = this[1][3].abs();
    return r;
  }
}
