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
class mat2x2Gen {
  vec2 col0;
  vec2 col1;
  mat2x2Gen([Dynamic col0_, Dynamic col1_]) {
    col0 = new vec2();
    col1 = new vec2();
    col0[0] = 1.0;
    col1[1] = 1.0;
    if (col0_ is vec2 && col1_ is vec2) {
      col0 = col0_;
      col1 = col1_;
    }
  }
  num get rows() => 2;
  num get cols() => 2;
  num get length() => 2;
  vec2 get row0() => getRow(0);
  vec2 get row1() => getRow(1);
  set row0(vec2 arg) => setRow(0, arg);
  set row1(vec2 arg) => setRow(1, arg);
  vec2 operator[](int column) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: return col0; break;
      case 1: return col1; break;
    }
    throw new IllegalArgumentException(column);
  }
  vec2 operator[]=(int column, vec2 arg) {
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
    return s;
  }
  void setRow(int row, vec2 arg) {
    assert(row >= 0 && row < 2);
    this[0][row] = arg[0];
    this[1][row] = arg[1];
  }
  vec2 getRow(int row) {
    assert(row >= 0 && row < 2);
    vec2 r = new vec2();
    r[0] = this[0][row];
    r[1] = this[1][row];
    return r;
  }
  void setColumn(int column, vec2 arg) {
    assert(column >= 0 && column < 2);
    this[column] = arg;
  }
  vec2 getColumn(int column) {
    assert(column >= 0 && column < 2);
    return new vec2(this[column]);
  }
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat2x2Gen r = new mat2x2Gen();
      r[0][0] = this[0][0] * arg;
      r[0][1] = this[0][1] * arg;
      r[1][0] = this[1][0] * arg;
      r[1][1] = this[1][1] * arg;
      return r;
    }
    if (arg is vec2) {
      vec2 r = new vec2();
      r[0] = dot(row0, arg);
      r[1] = dot(row1, arg);
      return r;
    }
    if (2 == arg.cols) {
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
  mat2x2Gen operator+(mat2x2 arg) {
    mat2x2Gen r = new mat2x2Gen();
    r[0][0] = this[0][0] + arg[0][0];
    r[0][1] = this[0][1] + arg[0][1];
    r[1][0] = this[1][0] + arg[1][0];
    r[1][1] = this[1][1] + arg[1][1];
    return r;
  }
  mat2x2Gen operator-(mat2x2 arg) {
    mat2x2Gen r = new mat2x2Gen();
    r[0][0] = this[0][0] - arg[0][0];
    r[0][1] = this[0][1] - arg[0][1];
    r[1][0] = this[1][0] - arg[1][0];
    r[1][1] = this[1][1] - arg[1][1];
    return r;
  }
  mat2x2Gen transposed() {
    mat2x2Gen r = new mat2x2Gen();
    r[0][0] = this[0][0];
    r[1][0] = this[0][1];
    r[0][1] = this[1][0];
    r[1][1] = this[1][1];
    return r;
  }
  mat2x2Gen absolute() {
    mat2x2Gen r = new mat2x2Gen();
    r[0][0] = this[0][0].abs();
    r[0][1] = this[0][1].abs();
    r[1][0] = this[1][0].abs();
    r[1][1] = this[1][1].abs();
    return r;
  }
}
