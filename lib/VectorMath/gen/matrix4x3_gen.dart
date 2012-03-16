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
class mat4x3Gen {
  vec3 col0;
  vec3 col1;
  vec3 col2;
  vec3 col3;
  mat4x3Gen([Dynamic col0_, Dynamic col1_, Dynamic col2_, Dynamic col3_]) {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col3 = new vec3();
    col0[0] = 1.0;
    col1[1] = 1.0;
    col2[2] = 1.0;
    if (col0_ is vec3 && col1_ is vec3 && col2_ is vec3 && col3_ is vec3) {
      col0 = col0_;
      col1 = col1_;
      col2 = col2_;
      col3 = col3_;
    }
  }
  num get rows() => 3;
  num get cols() => 4;
  num get length() => 4;
  vec4 get row0() => getRow(0);
  vec4 get row1() => getRow(1);
  vec4 get row2() => getRow(2);
  set row0(vec4 arg) => setRow(0, arg);
  set row1(vec4 arg) => setRow(1, arg);
  set row2(vec4 arg) => setRow(2, arg);
  vec3 operator[](int column) {
    assert(column >= 0 && column < 4);
    switch (column) {
      case 0: return col0; break;
      case 1: return col1; break;
      case 2: return col2; break;
      case 3: return col3; break;
    }
    throw new IllegalArgumentException(column);
  }
  vec3 operator[]=(int column, vec3 arg) {
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
    s += '[2] ${getRow(2)}\n';
    return s;
  }
  void setRow(int row, vec4 arg) {
    assert(row >= 0 && row < 3);
    this[0][row] = arg[0];
    this[1][row] = arg[1];
    this[2][row] = arg[2];
    this[3][row] = arg[3];
  }
  vec4 getRow(int row) {
    assert(row >= 0 && row < 3);
    vec4 r = new vec4();
    r[0] = this[0][row];
    r[1] = this[1][row];
    r[2] = this[2][row];
    r[3] = this[3][row];
    return r;
  }
  void setColumn(int column, vec3 arg) {
    assert(column >= 0 && column < 4);
    this[column] = arg;
  }
  vec3 getColumn(int column) {
    assert(column >= 0 && column < 4);
    return new vec3(this[column]);
  }
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat4x3Gen r = new mat4x3Gen();
      r[0][0] = this[0][0] * arg;
      r[0][1] = this[0][1] * arg;
      r[0][2] = this[0][2] * arg;
      r[1][0] = this[1][0] * arg;
      r[1][1] = this[1][1] * arg;
      r[1][2] = this[1][2] * arg;
      r[2][0] = this[2][0] * arg;
      r[2][1] = this[2][1] * arg;
      r[2][2] = this[2][2] * arg;
      r[3][0] = this[3][0] * arg;
      r[3][1] = this[3][1] * arg;
      r[3][2] = this[3][2] * arg;
      return r;
    }
    if (arg is vec4) {
      vec3 r = new vec3();
      r[0] = dot(row0, arg);
      r[1] = dot(row1, arg);
      r[2] = dot(row2, arg);
      return r;
    }
    if (3 == arg.cols) {
      Dynamic r = null;
      if (arg.rows == 2) {
        r = new mat4x2Gen();
      }
      if (arg.rows == 3) {
        r = new mat4x3Gen();
      }
      if (arg.rows == 4) {
        r = new mat4x4Gen();
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
  mat4x3Gen operator+(mat4x3 arg) {
    mat4x3Gen r = new mat4x3Gen();
    r[0][0] = this[0][0] + arg[0][0];
    r[0][1] = this[0][1] + arg[0][1];
    r[0][2] = this[0][2] + arg[0][2];
    r[1][0] = this[1][0] + arg[1][0];
    r[1][1] = this[1][1] + arg[1][1];
    r[1][2] = this[1][2] + arg[1][2];
    r[2][0] = this[2][0] + arg[2][0];
    r[2][1] = this[2][1] + arg[2][1];
    r[2][2] = this[2][2] + arg[2][2];
    r[3][0] = this[3][0] + arg[3][0];
    r[3][1] = this[3][1] + arg[3][1];
    r[3][2] = this[3][2] + arg[3][2];
    return r;
  }
  mat4x3Gen operator-(mat4x3 arg) {
    mat4x3Gen r = new mat4x3Gen();
    r[0][0] = this[0][0] - arg[0][0];
    r[0][1] = this[0][1] - arg[0][1];
    r[0][2] = this[0][2] - arg[0][2];
    r[1][0] = this[1][0] - arg[1][0];
    r[1][1] = this[1][1] - arg[1][1];
    r[1][2] = this[1][2] - arg[1][2];
    r[2][0] = this[2][0] - arg[2][0];
    r[2][1] = this[2][1] - arg[2][1];
    r[2][2] = this[2][2] - arg[2][2];
    r[3][0] = this[3][0] - arg[3][0];
    r[3][1] = this[3][1] - arg[3][1];
    r[3][2] = this[3][2] - arg[3][2];
    return r;
  }
  mat3x4Gen transposed() {
    mat3x4Gen r = new mat3x4Gen();
    r[0][0] = this[0][0];
    r[1][0] = this[0][1];
    r[2][0] = this[0][2];
    r[3][0] = this[0][3];
    r[0][1] = this[1][0];
    r[1][1] = this[1][1];
    r[2][1] = this[1][2];
    r[3][1] = this[1][3];
    r[0][2] = this[2][0];
    r[1][2] = this[2][1];
    r[2][2] = this[2][2];
    r[3][2] = this[2][3];
    return r;
  }
  mat4x3Gen absolute() {
    mat4x3Gen r = new mat4x3Gen();
    r[0][0] = this[0][0].abs();
    r[0][1] = this[0][1].abs();
    r[0][2] = this[0][2].abs();
    r[1][0] = this[1][0].abs();
    r[1][1] = this[1][1].abs();
    r[1][2] = this[1][2].abs();
    r[2][0] = this[2][0].abs();
    r[2][1] = this[2][1].abs();
    r[2][2] = this[2][2].abs();
    r[3][0] = this[3][0].abs();
    r[3][1] = this[3][1].abs();
    r[3][2] = this[3][2].abs();
    return r;
  }
}
