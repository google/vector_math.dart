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

/// mat4 is a column major matrix where each column is represented by [vec4]. This matrix has 4 columns and 4 dimension.
class mat4 {
  final Float32List _storage = new Float32List(16);
  Float32List get storage => _storage;
  int index(int row, int col) => (col * 4) + row;
  double entry(int row, int col) => _storage[index(row, col)];
  setEntry(int row, int col, double v) { _storage[index(row, col)] = v; }
  /// Constructs a new mat4.
  mat4(double arg0, double arg1, double arg2, double arg3, double arg4, double arg5, double arg6, double arg7, double arg8, double arg9, double arg10, double arg11, double arg12, double arg13, double arg14, double arg15) {
    setRaw(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
  }
  /// Constructs a new mat4 from columns.
  mat4.columns(vec4 arg0, vec4 arg1, vec4 arg2, vec4 arg3) {
    setColumns(arg0, arg1, arg2, arg3);
  }
  /// Constructs a new [mat4] from computing the outer product of [u] and [v].
  mat4.outer(vec4 u, vec4 v) {
    _storage[0] = u._storage[0] * v._storage[0];
    _storage[1] = u._storage[0] * v._storage[1];
    _storage[2] = u._storage[0] * v._storage[2];
    _storage[3] = u._storage[0] * v._storage[3];
    _storage[4] = u._storage[1] * v._storage[0];
    _storage[5] = u._storage[1] * v._storage[1];
    _storage[6] = u._storage[1] * v._storage[2];
    _storage[7] = u._storage[1] * v._storage[3];
    _storage[8] = u._storage[2] * v._storage[0];
    _storage[9] = u._storage[2] * v._storage[1];
    _storage[10] = u._storage[2] * v._storage[2];
    _storage[11] = u._storage[2] * v._storage[3];
    _storage[12] = u._storage[3] * v._storage[0];
    _storage[13] = u._storage[3] * v._storage[1];
    _storage[14] = u._storage[3] * v._storage[2];
    _storage[15] = u._storage[3] * v._storage[3];
  }
  /// Constructs a new [mat4] filled with zeros.
  mat4.zero() {
  }
  /// Constructs a new identity [mat4].
  mat4.identity() {
    setIdentity();
  }
  /// Constructs a new [mat4] which is a copy of [other].
  mat4.copy(mat4 other) {
    setMatrix(other);
  }
  //// Constructs a new [mat4] representation a rotation of [radians] around the X axis
  mat4.rotationX(double radians_) {
    _storage[15] = 1.0;
    setRotationX(radians_);
  }
  //// Constructs a new [mat4] representation a rotation of [radians] around the Y axis
  mat4.rotationY(double radians_) {
    _storage[15] = 1.0;
    setRotationY(radians_);
  }
  //// Constructs a new [mat4] representation a rotation of [radians] around the Z axis
  mat4.rotationZ(double radians_) {
    _storage[15] = 1.0;
    setRotationZ(radians_);
  }
  /// Constructs a new [mat4] translation matrix from [translation]
  mat4.translation(vec3 translation) {
    setIdentity();
    setTranslation(translation);
  }
  /// Constructs a new [mat4] translation from [x], [y], and [z]
  mat4.translationRaw(double x, double y, double z) {
    setIdentity();
    setTranslationRaw(x, y, z);
  }
  //// Constructs a new [mat4] scale of [x], [y], and [z]
  mat4.scaleVec(vec3 scale_) {
    _storage[15] = 1.0;
    _storage[10] = scale_._storage[2];
    _storage[5] = scale_._storage[1];
    _storage[0] = scale_._storage[0];
  }
  //// Constructs a new [mat4] representening a scale of [x], [y], and [z]
  mat4.scaleRaw(double x, double y, double z) {
    _storage[15] = 1.0;
    _storage[10] = z;
    _storage[5] = y;
    _storage[0] = x;
  }
  /// Sets the diagonal to [arg].
  mat4 splatDiagonal(double arg) {
    _storage[0] = arg;
    _storage[5] = arg;
    _storage[10] = arg;
    _storage[15] = arg;
    return this;
  }
  /// Sets the entire matrix to the numeric values.
  mat4 setRaw(double arg0, double arg1, double arg2, double arg3, double arg4, double arg5, double arg6, double arg7, double arg8, double arg9, double arg10, double arg11, double arg12, double arg13, double arg14, double arg15) {
    _storage[15] = arg15;
    _storage[14] = arg14;
    _storage[13] = arg13;
    _storage[12] = arg12;
    _storage[11] = arg11;
    _storage[10] = arg10;
    _storage[9] = arg9;
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
  mat4 setColumns(vec4 arg0, vec4 arg1, vec4 arg2, vec4 arg3) {
    _storage[0] = arg0._storage[0];
    _storage[1] = arg0._storage[1];
    _storage[2] = arg0._storage[2];
    _storage[3] = arg0._storage[3];
    _storage[4] = arg1._storage[0];
    _storage[5] = arg1._storage[1];
    _storage[6] = arg1._storage[2];
    _storage[7] = arg1._storage[3];
    _storage[8] = arg2._storage[0];
    _storage[9] = arg2._storage[1];
    _storage[10] = arg2._storage[2];
    _storage[11] = arg2._storage[3];
    _storage[12] = arg3._storage[0];
    _storage[13] = arg3._storage[1];
    _storage[14] = arg3._storage[2];
    _storage[15] = arg3._storage[3];
    return this;
  }
  /// Sets the entire matrix to the matrix in [arg].
  mat4 setMatrix(mat4 arg) {
    _storage[15] = arg._storage[15];
    _storage[14] = arg._storage[14];
    _storage[13] = arg._storage[13];
    _storage[12] = arg._storage[12];
    _storage[11] = arg._storage[11];
    _storage[10] = arg._storage[10];
    _storage[9] = arg._storage[9];
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
  mat4 setUpper2x2(mat2 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[4] = arg._storage[4];
    _storage[5] = arg._storage[5];
    return this;
  }
  /// Sets the diagonal of the matrix to be [arg].
  mat4 setDiagonal4(vec4 arg) {
    _storage[0] = arg._storage[0];
    _storage[5] = arg._storage[1];
    _storage[10] = arg._storage[2];
    _storage[15] = arg._storage[3];
    return this;
  }
  /// Sets the diagonal of the matrix to be [arg].
  mat4 setDiagonal3(vec3 arg) {
    _storage[0] = arg._storage[0];
    _storage[5] = arg._storage[1];
    _storage[10] = arg._storage[2];
    return this;
  }
  /// Sets the diagonal of the matrix to be [arg].
  mat4 setDiagonal2(vec2 arg) {
    _storage[0] = arg._storage[0];
    _storage[5] = arg._storage[1];
    return this;
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
  /// Returns the dimension of the matrix.
  int get dimension => 4;
  /// Returns the dimension of the matrix.
  int get length => 4;
  /// Gets element [i] from the matrix.
  double operator[](int i) {
    return _storage[i];
  }
  /// Sets element [i] in the matrix.
  void operator[]=(int i, double v) {
    _storage[i] = v;
  }
  /// Returns row 0
  vec4 get row0 => getRow(0);
  /// Returns row 1
  vec4 get row1 => getRow(1);
  /// Returns row 2
  vec4 get row2 => getRow(2);
  /// Returns row 3
  vec4 get row3 => getRow(3);
  /// Sets row 0 to [arg]
  set row0(vec4 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec4 arg) => setRow(1, arg);
  /// Sets row 2 to [arg]
  set row2(vec4 arg) => setRow(2, arg);
  /// Sets row 3 to [arg]
  set row3(vec4 arg) => setRow(3, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec4 arg) {
    _storage[index(row, 0)] = arg._storage[0];
    _storage[index(row, 1)] = arg._storage[1];
    _storage[index(row, 2)] = arg._storage[2];
    _storage[index(row, 3)] = arg._storage[3];
  }
  /// Gets the [row] of the matrix
  vec4 getRow(int row) {
    vec4 r = new vec4.zero();
    r._storage[0] = _storage[index(row, 0)];
    r._storage[1] = _storage[index(row, 1)];
    r._storage[2] = _storage[index(row, 2)];
    r._storage[3] = _storage[index(row, 3)];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec4 arg) {
    int entry = column * 4;
    _storage[entry+3] = arg._storage[3];
    _storage[entry+2] = arg._storage[2];
    _storage[entry+1] = arg._storage[1];
    _storage[entry+0] = arg._storage[0];
  }
  /// Gets the [column] of the matrix
  vec4 getColumn(int column) {
    vec4 r = new vec4.zero();
    int entry = column * 4;
    r._storage[3] = _storage[entry+3];
    r._storage[2] = _storage[entry+2];
    r._storage[1] = _storage[entry+1];
    r._storage[0] = _storage[entry+0];
    return r;
  }
  mat4 _mul_scale(double arg) {
    mat4 r = new mat4.zero();
    r._storage[15] = _storage[15] * arg;
    r._storage[14] = _storage[14] * arg;
    r._storage[13] = _storage[13] * arg;
    r._storage[12] = _storage[12] * arg;
    r._storage[11] = _storage[11] * arg;
    r._storage[10] = _storage[10] * arg;
    r._storage[9] = _storage[9] * arg;
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
  mat4 _mul_matrix(mat4 arg) {
    var r = new mat4.zero();
    r._storage[0] =  (_storage[0] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[8] * arg._storage[2]) + (_storage[12] * arg._storage[3]);
    r._storage[4] =  (_storage[0] * arg._storage[4]) + (_storage[4] * arg._storage[5]) + (_storage[8] * arg._storage[6]) + (_storage[12] * arg._storage[7]);
    r._storage[8] =  (_storage[0] * arg._storage[8]) + (_storage[4] * arg._storage[9]) + (_storage[8] * arg._storage[10]) + (_storage[12] * arg._storage[11]);
    r._storage[12] =  (_storage[0] * arg._storage[12]) + (_storage[4] * arg._storage[13]) + (_storage[8] * arg._storage[14]) + (_storage[12] * arg._storage[15]);
    r._storage[1] =  (_storage[1] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[9] * arg._storage[2]) + (_storage[13] * arg._storage[3]);
    r._storage[5] =  (_storage[1] * arg._storage[4]) + (_storage[5] * arg._storage[5]) + (_storage[9] * arg._storage[6]) + (_storage[13] * arg._storage[7]);
    r._storage[9] =  (_storage[1] * arg._storage[8]) + (_storage[5] * arg._storage[9]) + (_storage[9] * arg._storage[10]) + (_storage[13] * arg._storage[11]);
    r._storage[13] =  (_storage[1] * arg._storage[12]) + (_storage[5] * arg._storage[13]) + (_storage[9] * arg._storage[14]) + (_storage[13] * arg._storage[15]);
    r._storage[2] =  (_storage[2] * arg._storage[0]) + (_storage[6] * arg._storage[1]) + (_storage[10] * arg._storage[2]) + (_storage[14] * arg._storage[3]);
    r._storage[6] =  (_storage[2] * arg._storage[4]) + (_storage[6] * arg._storage[5]) + (_storage[10] * arg._storage[6]) + (_storage[14] * arg._storage[7]);
    r._storage[10] =  (_storage[2] * arg._storage[8]) + (_storage[6] * arg._storage[9]) + (_storage[10] * arg._storage[10]) + (_storage[14] * arg._storage[11]);
    r._storage[14] =  (_storage[2] * arg._storage[12]) + (_storage[6] * arg._storage[13]) + (_storage[10] * arg._storage[14]) + (_storage[14] * arg._storage[15]);
    r._storage[3] =  (_storage[3] * arg._storage[0]) + (_storage[7] * arg._storage[1]) + (_storage[11] * arg._storage[2]) + (_storage[15] * arg._storage[3]);
    r._storage[7] =  (_storage[3] * arg._storage[4]) + (_storage[7] * arg._storage[5]) + (_storage[11] * arg._storage[6]) + (_storage[15] * arg._storage[7]);
    r._storage[11] =  (_storage[3] * arg._storage[8]) + (_storage[7] * arg._storage[9]) + (_storage[11] * arg._storage[10]) + (_storage[15] * arg._storage[11]);
    r._storage[15] =  (_storage[3] * arg._storage[12]) + (_storage[7] * arg._storage[13]) + (_storage[11] * arg._storage[14]) + (_storage[15] * arg._storage[15]);
    return r;
  }
  vec4 _mul_vector(vec4 arg) {
    vec4 r = new vec4.zero();
    r._storage[3] =  (_storage[3] * arg._storage[0]) + (_storage[7] * arg._storage[1]) + (_storage[11] * arg._storage[2]) + (_storage[15] * arg._storage[3]);
    r._storage[2] =  (_storage[2] * arg._storage[0]) + (_storage[6] * arg._storage[1]) + (_storage[10] * arg._storage[2]) + (_storage[14] * arg._storage[3]);
    r._storage[1] =  (_storage[1] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[9] * arg._storage[2]) + (_storage[13] * arg._storage[3]);
    r._storage[0] =  (_storage[0] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[8] * arg._storage[2]) + (_storage[12] * arg._storage[3]);
    return r;
  }
  vec3 _mul_vector3(vec3 arg) {
    vec3 r = new vec3.zero();
    r._storage[0] =  (_storage[0] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[8] * arg._storage[2]) + _storage[12];
    r._storage[1] =  (_storage[1] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[9] * arg._storage[2]) + _storage[13];
    r._storage[2] =  (_storage[2] * arg._storage[0]) + (_storage[6] * arg._storage[1]) + (_storage[10] * arg._storage[2]) + _storage[14];
    return r;
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  dynamic operator*(dynamic arg) {
    if (arg is double) {
      return _mul_scale(arg);
    }
    if (arg is vec4) {
      return _mul_vector(arg);
    }
    if (arg is vec3) {
      return _mul_vector3(arg);
    }
    if (4 == arg.dimension) {
      return _mul_matrix(arg);
    }
    throw new ArgumentError(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat4 operator+(mat4 arg) {
    mat4 r = new mat4.zero();
    r._storage[0] = _storage[0] + arg._storage[0];
    r._storage[1] = _storage[1] + arg._storage[1];
    r._storage[2] = _storage[2] + arg._storage[2];
    r._storage[3] = _storage[3] + arg._storage[3];
    r._storage[4] = _storage[4] + arg._storage[4];
    r._storage[5] = _storage[5] + arg._storage[5];
    r._storage[6] = _storage[6] + arg._storage[6];
    r._storage[7] = _storage[7] + arg._storage[7];
    r._storage[8] = _storage[8] + arg._storage[8];
    r._storage[9] = _storage[9] + arg._storage[9];
    r._storage[10] = _storage[10] + arg._storage[10];
    r._storage[11] = _storage[11] + arg._storage[11];
    r._storage[12] = _storage[12] + arg._storage[12];
    r._storage[13] = _storage[13] + arg._storage[13];
    r._storage[14] = _storage[14] + arg._storage[14];
    r._storage[15] = _storage[15] + arg._storage[15];
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat4 operator-(mat4 arg) {
    mat4 r = new mat4.zero();
    r._storage[0] = _storage[0] - arg._storage[0];
    r._storage[1] = _storage[1] - arg._storage[1];
    r._storage[2] = _storage[2] - arg._storage[2];
    r._storage[3] = _storage[3] - arg._storage[3];
    r._storage[4] = _storage[4] - arg._storage[4];
    r._storage[5] = _storage[5] - arg._storage[5];
    r._storage[6] = _storage[6] - arg._storage[6];
    r._storage[7] = _storage[7] - arg._storage[7];
    r._storage[8] = _storage[8] - arg._storage[8];
    r._storage[9] = _storage[9] - arg._storage[9];
    r._storage[10] = _storage[10] - arg._storage[10];
    r._storage[11] = _storage[11] - arg._storage[11];
    r._storage[12] = _storage[12] - arg._storage[12];
    r._storage[13] = _storage[13] - arg._storage[13];
    r._storage[14] = _storage[14] - arg._storage[14];
    r._storage[15] = _storage[15] - arg._storage[15];
    return r;
  }
  /// Translate this matrix by a [vec3], [vec4], or x,y,z
  mat4 translate(dynamic x, [double y = 0.0, double z = 0.0]) {
    double tx;
    double ty;
    double tz;
    double tw = x is vec4 ? x.w : 1.0;
    if (x is vec3 || x is vec4) {
      tx = x.x;
      ty = x.y;
      tz = x.z;
    } else {
      tx = x;
      ty = y;
      tz = z;
    }
    var t1 = _storage[0] * tx + _storage[4] * ty + _storage[8] * tz + _storage[12] * tw;
    var t2 = _storage[1] * tx + _storage[5] * ty + _storage[9] * tz + _storage[13] * tw;
    var t3 = _storage[2] * tx + _storage[6] * ty + _storage[10] * tz + _storage[14] * tw;
    var t4 = _storage[3] * tx + _storage[7] * ty + _storage[11] * tz + _storage[15] * tw;
    _storage[12] = t1;
    _storage[13] = t2;
    _storage[14] = t3;
    _storage[15] = t4;
    return this;
  }
  /// Rotate this [angle] radians around [axis]
  mat4 rotate(vec3 axis, double angle) {
    var len = axis.length;
    var x = axis.x/len;
    var y = axis.y/len;
    var z = axis.z/len;
    var c = cos(angle);
    var s = sin(angle);
    var C = 1.0 - c;
    var m11 = x * x * C + c;
    var m12 = x * y * C - z * s;
    var m13 = x * z * C + y * s;
    var m21 = y * x * C + z * s;
    var m22 = y * y * C + c;
    var m23 = y * z * C - x * s;
    var m31 = z * x * C - y * s;
    var m32 = z * y * C + x * s;
    var m33 = z * z * C + c;
    var t1 = _storage[0] * m11 + _storage[4] * m21 + _storage[8] * m31 + _storage[12] * 0.0;
    var t2 = _storage[1] * m11 + _storage[5] * m21 + _storage[9] * m31 + _storage[13] * 0.0;
    var t3 = _storage[2] * m11 + _storage[6] * m21 + _storage[10] * m31 + _storage[14] * 0.0;
    var t4 = _storage[3] * m11 + _storage[7] * m21 + _storage[11] * m31 + _storage[15] * 0.0;
    var t5 = _storage[0] * m12 + _storage[4] * m22 + _storage[8] * m32 + _storage[12] * 0.0;
    var t6 = _storage[1] * m12 + _storage[5] * m22 + _storage[9] * m32 + _storage[13] * 0.0;
    var t7 = _storage[2] * m12 + _storage[6] * m22 + _storage[10] * m32 + _storage[14] * 0.0;
    var t8 = _storage[3] * m12 + _storage[7] * m22 + _storage[11] * m32 + _storage[15] * 0.0;
    var t9 = _storage[0] * m13 + _storage[4] * m23 + _storage[8] * m33 + _storage[12] * 0.0;
    var t10 = _storage[1] * m13 + _storage[5] * m23 + _storage[9] * m33 + _storage[13] * 0.0;
    var t11 = _storage[2] * m13 + _storage[6] * m23 + _storage[10] * m33 + _storage[14] * 0.0;
    var t12 = _storage[3] * m13 + _storage[7] * m23 + _storage[11] * m33 + _storage[15] * 0.0;
    _storage[0] = t1;
    _storage[1] = t2;
    _storage[2] = t3;
    _storage[3] = t4;
    _storage[4] = t5;
    _storage[5] = t6;
    _storage[6] = t7;
    _storage[7] = t8;
    _storage[8] = t9;
    _storage[9] = t10;
    _storage[10] = t11;
    _storage[11] = t12;
    return this;
  }
  /// Rotate this [angle] radians around X
  mat4 rotateX(double angle) {
    double cosAngle = cos(angle);
    double sinAngle = sin(angle);
    var t1 = _storage[0] * 0.0 + _storage[4] * cosAngle + _storage[8] * sinAngle + _storage[12] * 0.0;
    var t2 = _storage[1] * 0.0 + _storage[5] * cosAngle + _storage[9] * sinAngle + _storage[13] * 0.0;
    var t3 = _storage[2] * 0.0 + _storage[6] * cosAngle + _storage[10] * sinAngle + _storage[14] * 0.0;
    var t4 = _storage[3] * 0.0 + _storage[7] * cosAngle + _storage[11] * sinAngle + _storage[15] * 0.0;
    var t5 = _storage[0] * 0.0 + _storage[4] * -sinAngle + _storage[8] * cosAngle + _storage[12] * 0.0;
    var t6 = _storage[1] * 0.0 + _storage[5] * -sinAngle + _storage[9] * cosAngle + _storage[13] * 0.0;
    var t7 = _storage[2] * 0.0 + _storage[6] * -sinAngle + _storage[10] * cosAngle + _storage[14] * 0.0;
    var t8 = _storage[3] * 0.0 + _storage[7] * -sinAngle + _storage[11] * cosAngle + _storage[15] * 0.0;
    _storage[4] = t1;
    _storage[5] = t2;
    _storage[6] = t3;
    _storage[7] = t4;
    _storage[8] = t5;
    _storage[9] = t6;
    _storage[10] = t7;
    _storage[11] = t8;
    return this;
  }
  /// Rotate this matrix [angle] radians around Y
  mat4 rotateY(double angle) {
    double cosAngle = cos(angle);
    double sinAngle = sin(angle);
    var t1 = _storage[0] * cosAngle + _storage[4] * 0.0 + _storage[8] * sinAngle + _storage[12] * 0.0;
    var t2 = _storage[1] * cosAngle + _storage[5] * 0.0 + _storage[9] * sinAngle + _storage[13] * 0.0;
    var t3 = _storage[2] * cosAngle + _storage[6] * 0.0 + _storage[10] * sinAngle + _storage[14] * 0.0;
    var t4 = _storage[3] * cosAngle + _storage[7] * 0.0 + _storage[11] * sinAngle + _storage[15] * 0.0;
    var t5 = _storage[0] * -sinAngle + _storage[4] * 0.0 + _storage[8] * cosAngle + _storage[12] * 0.0;
    var t6 = _storage[1] * -sinAngle + _storage[5] * 0.0 + _storage[9] * cosAngle + _storage[13] * 0.0;
    var t7 = _storage[2] * -sinAngle + _storage[6] * 0.0 + _storage[10] * cosAngle + _storage[14] * 0.0;
    var t8 = _storage[3] * -sinAngle + _storage[7] * 0.0 + _storage[11] * cosAngle + _storage[15] * 0.0;
    _storage[0] = t1;
    _storage[1] = t2;
    _storage[2] = t3;
    _storage[3] = t4;
    _storage[8] = t5;
    _storage[9] = t6;
    _storage[10] = t7;
    _storage[11] = t8;
    return this;
  }
  /// Rotate this matrix [angle] radians around Z
  mat4 rotateZ(double angle) {
    double cosAngle = cos(angle);
    double sinAngle = sin(angle);
    var t1 = _storage[0] * cosAngle + _storage[4] * sinAngle + _storage[8] * 0.0 + _storage[12] * 0.0;
    var t2 = _storage[1] * cosAngle + _storage[5] * sinAngle + _storage[9] * 0.0 + _storage[13] * 0.0;
    var t3 = _storage[2] * cosAngle + _storage[6] * sinAngle + _storage[10] * 0.0 + _storage[14] * 0.0;
    var t4 = _storage[3] * cosAngle + _storage[7] * sinAngle + _storage[11] * 0.0 + _storage[15] * 0.0;
    var t5 = _storage[0] * -sinAngle + _storage[4] * cosAngle + _storage[8] * 0.0 + _storage[12] * 0.0;
    var t6 = _storage[1] * -sinAngle + _storage[5] * cosAngle + _storage[9] * 0.0 + _storage[13] * 0.0;
    var t7 = _storage[2] * -sinAngle + _storage[6] * cosAngle + _storage[10] * 0.0 + _storage[14] * 0.0;
    var t8 = _storage[3] * -sinAngle + _storage[7] * cosAngle + _storage[11] * 0.0 + _storage[15] * 0.0;
    _storage[0] = t1;
    _storage[1] = t2;
    _storage[2] = t3;
    _storage[3] = t4;
    _storage[4] = t5;
    _storage[5] = t6;
    _storage[6] = t7;
    _storage[7] = t8;
    return this;
  }
  /// Scale this matrix by a [vec3], [vec4], or x,y,z
  mat4 scale(dynamic x, [double y = null, double z = null]) {
    double sx;
    double sy;
    double sz;
    double sw = x is vec4 ? x.w : 1.0;
    if (x is vec3 || x is vec4) {
      sx = x.x;
      sy = x.y;
      sz = x.z;
    } else {
      sx = x;
      sy = y == null ? x : y.toDouble();
      sz = z == null ? x : z.toDouble();
    }
    _storage[0] *= sx;
    _storage[1] *= sx;
    _storage[2] *= sx;
    _storage[3] *= sx;
    _storage[4] *= sy;
    _storage[5] *= sy;
    _storage[6] *= sy;
    _storage[7] *= sy;
    _storage[8] *= sz;
    _storage[9] *= sz;
    _storage[10] *= sz;
    _storage[11] *= sz;
    _storage[12] *= sw;
    _storage[13] *= sw;
    _storage[14] *= sw;
    _storage[15] *= sw;
    return this;
  }
  /// Returns new matrix -this
  mat4 operator-() {
    mat4 r = new mat4.zero();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    r[3] = -this[3];
    return r;
  }
  /// Zeros [this].
  mat4 setZero() {
    _storage[0] = 0.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
    _storage[4] = 0.0;
    _storage[5] = 0.0;
    _storage[6] = 0.0;
    _storage[7] = 0.0;
    _storage[8] = 0.0;
    _storage[9] = 0.0;
    _storage[10] = 0.0;
    _storage[11] = 0.0;
    _storage[12] = 0.0;
    _storage[13] = 0.0;
    _storage[14] = 0.0;
    _storage[15] = 0.0;
    return this;
  }
  /// Makes [this] into the identity matrix.
  mat4 setIdentity() {
    _storage[0] = 1.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[3] = 0.0;
    _storage[4] = 0.0;
    _storage[5] = 1.0;
    _storage[6] = 0.0;
    _storage[7] = 0.0;
    _storage[8] = 0.0;
    _storage[9] = 0.0;
    _storage[10] = 1.0;
    _storage[11] = 0.0;
    _storage[12] = 0.0;
    _storage[13] = 0.0;
    _storage[14] = 0.0;
    _storage[15] = 1.0;
    return this;
  }
  /// Returns the tranpose of this.
  mat4 transposed() {
    mat4 r = new mat4.zero();
    r._storage[0] = _storage[0];
    r._storage[1] = _storage[4];
    r._storage[2] = _storage[8];
    r._storage[3] = _storage[12];
    r._storage[4] = _storage[1];
    r._storage[5] = _storage[5];
    r._storage[6] = _storage[9];
    r._storage[7] = _storage[13];
    r._storage[8] = _storage[2];
    r._storage[9] = _storage[6];
    r._storage[10] = _storage[10];
    r._storage[11] = _storage[14];
    r._storage[12] = _storage[3];
    r._storage[13] = _storage[7];
    r._storage[14] = _storage[11];
    r._storage[15] = _storage[15];
    return r;
  }
  mat4 transpose() {
    double temp;
    temp = _storage[4];
    _storage[4] = _storage[1];
    _storage[1] = temp;
    temp = _storage[8];
    _storage[8] = _storage[2];
    _storage[2] = temp;
    temp = _storage[12];
    _storage[12] = _storage[3];
    _storage[3] = temp;
    temp = _storage[9];
    _storage[9] = _storage[6];
    _storage[6] = temp;
    temp = _storage[13];
    _storage[13] = _storage[7];
    _storage[7] = temp;
    temp = _storage[14];
    _storage[14] = _storage[11];
    _storage[11] = temp;
    return this;
  }
  /// Returns the component wise absolute value of this.
  mat4 absolute() {
    mat4 r = new mat4.zero();
    r._storage[0] = _storage[0].abs();
    r._storage[1] = _storage[1].abs();
    r._storage[2] = _storage[2].abs();
    r._storage[3] = _storage[3].abs();
    r._storage[4] = _storage[4].abs();
    r._storage[5] = _storage[5].abs();
    r._storage[6] = _storage[6].abs();
    r._storage[7] = _storage[7].abs();
    r._storage[8] = _storage[8].abs();
    r._storage[9] = _storage[9].abs();
    r._storage[10] = _storage[10].abs();
    r._storage[11] = _storage[11].abs();
    r._storage[12] = _storage[12].abs();
    r._storage[13] = _storage[13].abs();
    r._storage[14] = _storage[14].abs();
    r._storage[15] = _storage[15].abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  double determinant() {
    double det2_01_01 = _storage[0] * _storage[5] - _storage[1] * _storage[4];
    double det2_01_02 = _storage[0] * _storage[6] - _storage[2] * _storage[4];
    double det2_01_03 = _storage[0] * _storage[7] - _storage[3] * _storage[4];
    double det2_01_12 = _storage[1] * _storage[6] - _storage[2] * _storage[5];
    double det2_01_13 = _storage[1] * _storage[7] - _storage[3] * _storage[5];
    double det2_01_23 = _storage[2] * _storage[7] - _storage[3] * _storage[6];
    double det3_201_012 = _storage[8] * det2_01_12 - _storage[9] * det2_01_02 + _storage[10] * det2_01_01;
    double det3_201_013 = _storage[8] * det2_01_13 - _storage[9] * det2_01_03 + _storage[11] * det2_01_01;
    double det3_201_023 = _storage[8] * det2_01_23 - _storage[10] * det2_01_03 + _storage[11] * det2_01_02;
    double det3_201_123 = _storage[9] * det2_01_23 - _storage[10] * det2_01_13 + _storage[11] * det2_01_12;
    return ( - det3_201_123 * _storage[12] + det3_201_023 * _storage[13] - det3_201_013 * _storage[14] + det3_201_012 * _storage[15]);
  }
  /// Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries
  double trace() {
    double t = 0.0;
    t += _storage[0];
    t += _storage[5];
    t += _storage[10];
    t += _storage[15];
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
      row_norm += _storage[3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += _storage[4].abs();
      row_norm += _storage[5].abs();
      row_norm += _storage[6].abs();
      row_norm += _storage[7].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += _storage[8].abs();
      row_norm += _storage[9].abs();
      row_norm += _storage[10].abs();
      row_norm += _storage[11].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += _storage[12].abs();
      row_norm += _storage[13].abs();
      row_norm += _storage[14].abs();
      row_norm += _storage[15].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  double relativeError(mat4 correct) {
    mat4 diff = correct - this;
    double correct_norm = correct.infinityNorm();
    double diff_norm = diff.infinityNorm();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  double absoluteError(mat4 correct) {
    double this_norm = infinityNorm();
    double correct_norm = correct.infinityNorm();
    double diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  /// Returns the translation vector from this homogeneous transformation matrix.
  vec3 getTranslation() {
    double z = _storage[14];
    double y = _storage[13];
    double x = _storage[12];
    return new vec3(x, y, z);
  }
  /// Sets the translation vector in this homogeneous transformation matrix.
  void setTranslation(vec3 T) {
    double z = T._storage[2];
    double y = T._storage[1];
    double x = T._storage[0];
    _storage[14] = z;
    _storage[13] = y;
    _storage[12] = x;
  }
  /// Sets the translation vector in this homogeneous transformation matrix.
  void setTranslationRaw(double x, double y, double z) {
    _storage[14] = z;
    _storage[13] = y;
    _storage[12] = x;
  }
  /// Returns the rotation matrix from this homogeneous transformation matrix.
  mat3 getRotation() {
    mat3 r = new mat3.zero();
    r._storage[0] = _storage[0];
    r._storage[1] = _storage[1];
    r._storage[2] = _storage[2];
    r._storage[3] = _storage[4];
    r._storage[4] = _storage[5];
    r._storage[5] = _storage[6];
    r._storage[6] = _storage[8];
    r._storage[7] = _storage[9];
    r._storage[8] = _storage[10];
    return r;
  }
  /// Sets the rotation matrix in this homogeneous transformation matrix.
  void setRotation(mat3 r) {
    _storage[0] = r._storage[0];
    _storage[1] = r._storage[1];
    _storage[2] = r._storage[2];
    _storage[4] = r._storage[3];
    _storage[5] = r._storage[4];
    _storage[6] = r._storage[5];
    _storage[8] = r._storage[6];
    _storage[9] = r._storage[7];
    _storage[10] = r._storage[8];
  }
  /// Transposes just the upper 3x3 rotation matrix.
  mat4 transposeRotation() {
    double temp;
    temp = _storage[1];
    _storage[1] = _storage[4];
    _storage[4] = temp;
    temp = _storage[2];
    _storage[2] = _storage[8];
    _storage[8] = temp;
    temp = _storage[4];
    _storage[4] = _storage[1];
    _storage[1] = temp;
    temp = _storage[6];
    _storage[6] = _storage[9];
    _storage[9] = temp;
    temp = _storage[8];
    _storage[8] = _storage[2];
    _storage[2] = temp;
    temp = _storage[9];
    _storage[9] = _storage[6];
    _storage[6] = temp;
    return this;
  }
  double invert() {
    double a00 = _storage[0];
    double a01 = _storage[1];
    double a02 = _storage[2];
    double a03 = _storage[3];
    double a10 = _storage[4];
    double a11 = _storage[5];
    double a12 = _storage[6];
    double a13 = _storage[7];
    double a20 = _storage[8];
    double a21 = _storage[9];
    double a22 = _storage[10];
    double a23 = _storage[11];
    double a30 = _storage[12];
    double a31 = _storage[13];
    double a32 = _storage[14];
    double a33 = _storage[15];
    var b00 = a00 * a11 - a01 * a10;
    var b01 = a00 * a12 - a02 * a10;
    var b02 = a00 * a13 - a03 * a10;
    var b03 = a01 * a12 - a02 * a11;
    var b04 = a01 * a13 - a03 * a11;
    var b05 = a02 * a13 - a03 * a12;
    var b06 = a20 * a31 - a21 * a30;
    var b07 = a20 * a32 - a22 * a30;
    var b08 = a20 * a33 - a23 * a30;
    var b09 = a21 * a32 - a22 * a31;
    var b10 = a21 * a33 - a23 * a31;
    var b11 = a22 * a33 - a23 * a32;
    var det = (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06);
    if (det == 0.0) { return det; }
    var invDet = 1.0 / det;
    _storage[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;
    _storage[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;
    _storage[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;
    _storage[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;
    _storage[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;
    _storage[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;
    _storage[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;
    _storage[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;
    _storage[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;
    _storage[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;
    _storage[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;
    _storage[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;
    _storage[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;
    _storage[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;
    _storage[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;
    _storage[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;
    return det;
  }
  double invertRotation() {
    double det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    double invDet = 1.0 / det;
    vec4 i = new vec4.zero();
    vec4 j = new vec4.zero();
    vec4 k = new vec4.zero();
    i.x = invDet * (_storage[5] * _storage[10] - _storage[6] * _storage[9]);
    i.y = invDet * (_storage[2] * _storage[9] - _storage[1] * _storage[10]);
    i.z = invDet * (_storage[1] * _storage[6] - _storage[2] * _storage[5]);
    j.x = invDet * (_storage[6] * _storage[8] - _storage[4] * _storage[10]);
    j.y = invDet * (_storage[0] * _storage[10] - _storage[2] * _storage[8]);
    j.z = invDet * (_storage[2] * _storage[4] - _storage[0] * _storage[6]);
    k.x = invDet * (_storage[4] * _storage[9] - _storage[5] * _storage[8]);
    k.y = invDet * (_storage[1] * _storage[8] - _storage[0] * _storage[9]);
    k.z = invDet * (_storage[0] * _storage[5] - _storage[1] * _storage[4]);
    col0 = i;
    col1 = j;
    col2 = k;
    return det;
  }
  /// Sets the upper 3x3 to a rotation of [radians] around X
  void setRotationX(num radians) {
    double radians_ = radians.toDouble();
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    _storage[0] = 1.0;
    _storage[1] = 0.0;
    _storage[2] = 0.0;
    _storage[4] = 0.0;
    _storage[5] = c;
    _storage[6] = s;
    _storage[8] = 0.0;
    _storage[9] = -s;
    _storage[10] = c;
    _storage[3] = 0.0;
    _storage[7] = 0.0;
    _storage[11] = 0.0;
  }
  /// Sets the upper 3x3 to a rotation of [radians] around Y
  void setRotationY(num radians) {
    double radians_ = radians.toDouble();
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    _storage[0] = c;
    _storage[1] = 0.0;
    _storage[2] = s;
    _storage[4] = 0.0;
    _storage[5] = 1.0;
    _storage[6] = 0.0;
    _storage[8] = -s;
    _storage[9] = 0.0;
    _storage[10] = c;
    _storage[3] = 0.0;
    _storage[7] = 0.0;
    _storage[11] = 0.0;
  }
  /// Sets the upper 3x3 to a rotation of [radians] around Z
  void setRotationZ(num radians) {
    double radians_ = radians.toDouble();
    double c = Math.cos(radians_);
    double s = Math.sin(radians_);
    _storage[0] = c;
    _storage[1] = s;
    _storage[2] = 0.0;
    _storage[4] = -s;
    _storage[5] = c;
    _storage[6] = 0.0;
    _storage[8] = 0.0;
    _storage[9] = 0.0;
    _storage[10] = 1.0;
    _storage[3] = 0.0;
    _storage[7] = 0.0;
    _storage[11] = 0.0;
  }
  /// Converts into Adjugate matrix and scales by [scale]
  mat4 scaleAdjoint(num scale) {
    double scale_ = scale.toDouble();
    // Adapted from code by Richard Carling.
    double a1 = _storage[0];
    double b1 = _storage[4];
    double c1 = _storage[8];
    double d1 = _storage[12];
    double a2 = _storage[1];
    double b2 = _storage[5];
    double c2 = _storage[9];
    double d2 = _storage[13];
    double a3 = _storage[2];
    double b3 = _storage[6];
    double c3 = _storage[10];
    double d3 = _storage[14];
    double a4 = _storage[3];
    double b4 = _storage[7];
    double c4 = _storage[11];
    double d4 = _storage[15];
    _storage[0]  =   (b2 * (c3 * d4 - c4 * d3) - c2 * (b3 * d4 - b4 * d3) + d2 * (b3 * c4 - b4 * c3)) * scale_;
    _storage[1]  = - (a2 * (c3 * d4 - c4 * d3) - c2 * (a3 * d4 - a4 * d3) + d2 * (a3 * c4 - a4 * c3)) * scale_;
    _storage[2]  =   (a2 * (b3 * d4 - b4 * d3) - b2 * (a3 * d4 - a4 * d3) + d2 * (a3 * b4 - a4 * b3)) * scale_;
    _storage[3]  = - (a2 * (b3 * c4 - b4 * c3) - b2 * (a3 * c4 - a4 * c3) + c2 * (a3 * b4 - a4 * b3)) * scale_;
    _storage[4]  = - (b1 * (c3 * d4 - c4 * d3) - c1 * (b3 * d4 - b4 * d3) + d1 * (b3 * c4 - b4 * c3)) * scale_;
    _storage[5]  =   (a1 * (c3 * d4 - c4 * d3) - c1 * (a3 * d4 - a4 * d3) + d1 * (a3 * c4 - a4 * c3)) * scale_;
    _storage[6]  = - (a1 * (b3 * d4 - b4 * d3) - b1 * (a3 * d4 - a4 * d3) + d1 * (a3 * b4 - a4 * b3)) * scale_;
    _storage[7]  =   (a1 * (b3 * c4 - b4 * c3) - b1 * (a3 * c4 - a4 * c3) + c1 * (a3 * b4 - a4 * b3)) * scale_;
    _storage[8]  =   (b1 * (c2 * d4 - c4 * d2) - c1 * (b2 * d4 - b4 * d2) + d1 * (b2 * c4 - b4 * c2)) * scale_;
    _storage[9]  = - (a1 * (c2 * d4 - c4 * d2) - c1 * (a2 * d4 - a4 * d2) + d1 * (a2 * c4 - a4 * c2)) * scale_;
    _storage[10]  =   (a1 * (b2 * d4 - b4 * d2) - b1 * (a2 * d4 - a4 * d2) + d1 * (a2 * b4 - a4 * b2)) * scale_;
    _storage[11]  = - (a1 * (b2 * c4 - b4 * c2) - b1 * (a2 * c4 - a4 * c2) + c1 * (a2 * b4 - a4 * b2)) * scale_;
    _storage[12]  = - (b1 * (c2 * d3 - c3 * d2) - c1 * (b2 * d3 - b3 * d2) + d1 * (b2 * c3 - b3 * c2)) * scale_;
    _storage[13]  =   (a1 * (c2 * d3 - c3 * d2) - c1 * (a2 * d3 - a3 * d2) + d1 * (a2 * c3 - a3 * c2)) * scale_;
    _storage[14]  = - (a1 * (b2 * d3 - b3 * d2) - b1 * (a2 * d3 - a3 * d2) + d1 * (a2 * b3 - a3 * b2)) * scale_;
    _storage[15]  =   (a1 * (b2 * c3 - b3 * c2) - b1 * (a2 * c3 - a3 * c2) + c1 * (a2 * b3 - a3 * b2)) * scale_;
    return this;
  }
  /// Rotates [arg] by the absolute rotation of [this]
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  vec3 absoluteRotate(vec3 arg) {
    double m00 = _storage[0].abs();
    double m01 = _storage[4].abs();
    double m02 = _storage[8].abs();
    double m10 = _storage[1].abs();
    double m11 = _storage[5].abs();
    double m12 = _storage[9].abs();
    double m20 = _storage[2].abs();
    double m21 = _storage[6].abs();
    double m22 = _storage[10].abs();
    double x = arg.x;
    double y = arg.y;
    double z = arg.z;
    arg.x = x * m00 + y * m01 + z * m02 + 0.0 * 0.0;
    arg.y = x * m10 + y * m11 + z * m12 + 0.0 * 0.0;
    arg.z = x * m20 + y * m21 + z * m22 + 0.0 * 0.0;
    return arg;
  }
  mat4 clone() {
    return new mat4.copy(this);
  }
  mat4 copyInto(mat4 arg) {
    arg._storage[0] = _storage[0];
    arg._storage[1] = _storage[1];
    arg._storage[2] = _storage[2];
    arg._storage[3] = _storage[3];
    arg._storage[4] = _storage[4];
    arg._storage[5] = _storage[5];
    arg._storage[6] = _storage[6];
    arg._storage[7] = _storage[7];
    arg._storage[8] = _storage[8];
    arg._storage[9] = _storage[9];
    arg._storage[10] = _storage[10];
    arg._storage[11] = _storage[11];
    arg._storage[12] = _storage[12];
    arg._storage[13] = _storage[13];
    arg._storage[14] = _storage[14];
    arg._storage[15] = _storage[15];
    return arg;
  }
  mat4 copyFrom(mat4 arg) {
    _storage[0] = arg._storage[0];
    _storage[1] = arg._storage[1];
    _storage[2] = arg._storage[2];
    _storage[3] = arg._storage[3];
    _storage[4] = arg._storage[4];
    _storage[5] = arg._storage[5];
    _storage[6] = arg._storage[6];
    _storage[7] = arg._storage[7];
    _storage[8] = arg._storage[8];
    _storage[9] = arg._storage[9];
    _storage[10] = arg._storage[10];
    _storage[11] = arg._storage[11];
    _storage[12] = arg._storage[12];
    _storage[13] = arg._storage[13];
    _storage[14] = arg._storage[14];
    _storage[15] = arg._storage[15];
    return this;
  }
  mat4 add(mat4 o) {
    _storage[0] = _storage[0] + o._storage[0];
    _storage[1] = _storage[1] + o._storage[1];
    _storage[2] = _storage[2] + o._storage[2];
    _storage[3] = _storage[3] + o._storage[3];
    _storage[4] = _storage[4] + o._storage[4];
    _storage[5] = _storage[5] + o._storage[5];
    _storage[6] = _storage[6] + o._storage[6];
    _storage[7] = _storage[7] + o._storage[7];
    _storage[8] = _storage[8] + o._storage[8];
    _storage[9] = _storage[9] + o._storage[9];
    _storage[10] = _storage[10] + o._storage[10];
    _storage[11] = _storage[11] + o._storage[11];
    _storage[12] = _storage[12] + o._storage[12];
    _storage[13] = _storage[13] + o._storage[13];
    _storage[14] = _storage[14] + o._storage[14];
    _storage[15] = _storage[15] + o._storage[15];
    return this;
  }
  mat4 sub(mat4 o) {
    _storage[0] = _storage[0] - o._storage[0];
    _storage[1] = _storage[1] - o._storage[1];
    _storage[2] = _storage[2] - o._storage[2];
    _storage[3] = _storage[3] - o._storage[3];
    _storage[4] = _storage[4] - o._storage[4];
    _storage[5] = _storage[5] - o._storage[5];
    _storage[6] = _storage[6] - o._storage[6];
    _storage[7] = _storage[7] - o._storage[7];
    _storage[8] = _storage[8] - o._storage[8];
    _storage[9] = _storage[9] - o._storage[9];
    _storage[10] = _storage[10] - o._storage[10];
    _storage[11] = _storage[11] - o._storage[11];
    _storage[12] = _storage[12] - o._storage[12];
    _storage[13] = _storage[13] - o._storage[13];
    _storage[14] = _storage[14] - o._storage[14];
    _storage[15] = _storage[15] - o._storage[15];
    return this;
  }
  mat4 negate() {
    _storage[0] = -_storage[0];
    _storage[1] = -_storage[1];
    _storage[2] = -_storage[2];
    _storage[3] = -_storage[3];
    _storage[4] = -_storage[4];
    _storage[5] = -_storage[5];
    _storage[6] = -_storage[6];
    _storage[7] = -_storage[7];
    _storage[8] = -_storage[8];
    _storage[9] = -_storage[9];
    _storage[10] = -_storage[10];
    _storage[11] = -_storage[11];
    _storage[12] = -_storage[12];
    _storage[13] = -_storage[13];
    _storage[14] = -_storage[14];
    _storage[15] = -_storage[15];
    return this;
  }
  mat4 multiply(mat4 arg) {
    final double m00 = _storage[0];
    final double m01 = _storage[4];
    final double m02 = _storage[8];
    final double m03 = _storage[12];
    final double m10 = _storage[1];
    final double m11 = _storage[5];
    final double m12 = _storage[9];
    final double m13 = _storage[13];
    final double m20 = _storage[2];
    final double m21 = _storage[6];
    final double m22 = _storage[10];
    final double m23 = _storage[14];
    final double m30 = _storage[3];
    final double m31 = _storage[7];
    final double m32 = _storage[11];
    final double m33 = _storage[15];
    final double n00 = arg._storage[0];
    final double n01 = arg._storage[4];
    final double n02 = arg._storage[8];
    final double n03 = arg._storage[12];
    final double n10 = arg._storage[1];
    final double n11 = arg._storage[5];
    final double n12 = arg._storage[9];
    final double n13 = arg._storage[13];
    final double n20 = arg._storage[2];
    final double n21 = arg._storage[6];
    final double n22 = arg._storage[10];
    final double n23 = arg._storage[14];
    final double n30 = arg._storage[3];
    final double n31 = arg._storage[7];
    final double n32 = arg._storage[11];
    final double n33 = arg._storage[15];
    _storage[0] =  (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    _storage[4] =  (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    _storage[8] =  (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    _storage[12] =  (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    _storage[1] =  (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    _storage[5] =  (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    _storage[9] =  (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    _storage[13] =  (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    _storage[2] =  (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    _storage[6] =  (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    _storage[10] =  (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    _storage[14] =  (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    _storage[3] =  (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    _storage[7] =  (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    _storage[11] =  (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    _storage[15] =  (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
    return this;
  }
  mat4 transposeMultiply(mat4 arg) {
    double m00 = _storage[0];
    double m01 = _storage[1];
    double m02 = _storage[2];
    double m03 = _storage[3];
    double m10 = _storage[4];
    double m11 = _storage[5];
    double m12 = _storage[6];
    double m13 = _storage[7];
    double m20 = _storage[8];
    double m21 = _storage[9];
    double m22 = _storage[10];
    double m23 = _storage[11];
    double m30 = _storage[12];
    double m31 = _storage[13];
    double m32 = _storage[14];
    double m33 = _storage[15];
    _storage[0] =  (m00 * arg._storage[0]) + (m01 * arg._storage[1]) + (m02 * arg._storage[2]) + (m03 * arg._storage[3]);
    _storage[4] =  (m00 * arg._storage[4]) + (m01 * arg._storage[5]) + (m02 * arg._storage[6]) + (m03 * arg._storage[7]);
    _storage[8] =  (m00 * arg._storage[8]) + (m01 * arg._storage[9]) + (m02 * arg._storage[10]) + (m03 * arg._storage[11]);
    _storage[12] =  (m00 * arg._storage[12]) + (m01 * arg._storage[13]) + (m02 * arg._storage[14]) + (m03 * arg._storage[15]);
    _storage[1] =  (m10 * arg._storage[0]) + (m11 * arg._storage[1]) + (m12 * arg._storage[2]) + (m13 * arg._storage[3]);
    _storage[5] =  (m10 * arg._storage[4]) + (m11 * arg._storage[5]) + (m12 * arg._storage[6]) + (m13 * arg._storage[7]);
    _storage[9] =  (m10 * arg._storage[8]) + (m11 * arg._storage[9]) + (m12 * arg._storage[10]) + (m13 * arg._storage[11]);
    _storage[13] =  (m10 * arg._storage[12]) + (m11 * arg._storage[13]) + (m12 * arg._storage[14]) + (m13 * arg._storage[15]);
    _storage[2] =  (m20 * arg._storage[0]) + (m21 * arg._storage[1]) + (m22 * arg._storage[2]) + (m23 * arg._storage[3]);
    _storage[6] =  (m20 * arg._storage[4]) + (m21 * arg._storage[5]) + (m22 * arg._storage[6]) + (m23 * arg._storage[7]);
    _storage[10] =  (m20 * arg._storage[8]) + (m21 * arg._storage[9]) + (m22 * arg._storage[10]) + (m23 * arg._storage[11]);
    _storage[14] =  (m20 * arg._storage[12]) + (m21 * arg._storage[13]) + (m22 * arg._storage[14]) + (m23 * arg._storage[15]);
    _storage[3] =  (m30 * arg._storage[0]) + (m31 * arg._storage[1]) + (m32 * arg._storage[2]) + (m33 * arg._storage[3]);
    _storage[7] =  (m30 * arg._storage[4]) + (m31 * arg._storage[5]) + (m32 * arg._storage[6]) + (m33 * arg._storage[7]);
    _storage[11] =  (m30 * arg._storage[8]) + (m31 * arg._storage[9]) + (m32 * arg._storage[10]) + (m33 * arg._storage[11]);
    _storage[15] =  (m30 * arg._storage[12]) + (m31 * arg._storage[13]) + (m32 * arg._storage[14]) + (m33 * arg._storage[15]);
    return this;
  }
  mat4 multiplyTranspose(mat4 arg) {
    double m00 = _storage[0];
    double m01 = _storage[4];
    double m02 = _storage[8];
    double m03 = _storage[12];
    double m10 = _storage[1];
    double m11 = _storage[5];
    double m12 = _storage[9];
    double m13 = _storage[13];
    double m20 = _storage[2];
    double m21 = _storage[6];
    double m22 = _storage[10];
    double m23 = _storage[14];
    double m30 = _storage[3];
    double m31 = _storage[7];
    double m32 = _storage[11];
    double m33 = _storage[15];
    _storage[0] =  (m00 * arg._storage[0]) + (m01 * arg._storage[4]) + (m02 * arg._storage[8]) + (m03 * arg._storage[12]);
    _storage[4] =  (m00 * arg._storage[1]) + (m01 * arg._storage[5]) + (m02 * arg._storage[9]) + (m03 * arg._storage[13]);
    _storage[8] =  (m00 * arg._storage[2]) + (m01 * arg._storage[6]) + (m02 * arg._storage[10]) + (m03 * arg._storage[14]);
    _storage[12] =  (m00 * arg._storage[3]) + (m01 * arg._storage[7]) + (m02 * arg._storage[11]) + (m03 * arg._storage[15]);
    _storage[1] =  (m10 * arg._storage[0]) + (m11 * arg._storage[4]) + (m12 * arg._storage[8]) + (m13 * arg._storage[12]);
    _storage[5] =  (m10 * arg._storage[1]) + (m11 * arg._storage[5]) + (m12 * arg._storage[9]) + (m13 * arg._storage[13]);
    _storage[9] =  (m10 * arg._storage[2]) + (m11 * arg._storage[6]) + (m12 * arg._storage[10]) + (m13 * arg._storage[14]);
    _storage[13] =  (m10 * arg._storage[3]) + (m11 * arg._storage[7]) + (m12 * arg._storage[11]) + (m13 * arg._storage[15]);
    _storage[2] =  (m20 * arg._storage[0]) + (m21 * arg._storage[4]) + (m22 * arg._storage[8]) + (m23 * arg._storage[12]);
    _storage[6] =  (m20 * arg._storage[1]) + (m21 * arg._storage[5]) + (m22 * arg._storage[9]) + (m23 * arg._storage[13]);
    _storage[10] =  (m20 * arg._storage[2]) + (m21 * arg._storage[6]) + (m22 * arg._storage[10]) + (m23 * arg._storage[14]);
    _storage[14] =  (m20 * arg._storage[3]) + (m21 * arg._storage[7]) + (m22 * arg._storage[11]) + (m23 * arg._storage[15]);
    _storage[3] =  (m30 * arg._storage[0]) + (m31 * arg._storage[4]) + (m32 * arg._storage[8]) + (m33 * arg._storage[12]);
    _storage[7] =  (m30 * arg._storage[1]) + (m31 * arg._storage[5]) + (m32 * arg._storage[9]) + (m33 * arg._storage[13]);
    _storage[11] =  (m30 * arg._storage[2]) + (m31 * arg._storage[6]) + (m32 * arg._storage[10]) + (m33 * arg._storage[14]);
    _storage[15] =  (m30 * arg._storage[3]) + (m31 * arg._storage[7]) + (m32 * arg._storage[11]) + (m33 * arg._storage[15]);
    return this;
  }
  vec3 rotate3(vec3 arg) {
    double x_ =  (_storage[0] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[8] * arg._storage[2]);
    double y_ =  (_storage[1] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[9] * arg._storage[2]);
    double z_ =  (_storage[2] * arg._storage[0]) + (_storage[6] * arg._storage[1]) + (_storage[10] * arg._storage[2]);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }
  vec3 rotated3(vec3 arg, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return rotate3(out);
  }
  vec3 transform3(vec3 arg) {
    double x_ =  (_storage[0] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[8] * arg._storage[2]) + _storage[12];
    double y_ =  (_storage[1] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[9] * arg._storage[2]) + _storage[13];
    double z_ =  (_storage[2] * arg._storage[0]) + (_storage[6] * arg._storage[1]) + (_storage[10] * arg._storage[2]) + _storage[14];
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }
  vec3 transformed3(vec3 arg, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return transform3(out);
  }
  vec4 transform(vec4 arg) {
    double x_ =  (_storage[0] * arg._storage[0]) + (_storage[4] * arg._storage[1]) + (_storage[8] * arg._storage[2]) + (_storage[12] * arg._storage[3]);
    double y_ =  (_storage[1] * arg._storage[0]) + (_storage[5] * arg._storage[1]) + (_storage[9] * arg._storage[2]) + (_storage[13] * arg._storage[3]);
    double z_ =  (_storage[2] * arg._storage[0]) + (_storage[6] * arg._storage[1]) + (_storage[10] * arg._storage[2]) + (_storage[14] * arg._storage[3]);
    double w_ =  (_storage[3] * arg._storage[0]) + (_storage[7] * arg._storage[1]) + (_storage[11] * arg._storage[2]) + (_storage[15] * arg._storage[3]);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    arg.w = w_;
    return arg;
  }
  vec4 transformed(vec4 arg, [vec4 out=null]) {
    if (out == null) {
      out = new vec4.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return transform(out);
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset=0]) {
    int i = offset;
    array[i+15] = _storage[15];
    array[i+14] = _storage[14];
    array[i+13] = _storage[13];
    array[i+12] = _storage[12];
    array[i+11] = _storage[11];
    array[i+10] = _storage[10];
    array[i+9] = _storage[9];
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
    _storage[15] = array[i+15];
    _storage[14] = array[i+14];
    _storage[13] = array[i+13];
    _storage[12] = array[i+12];
    _storage[11] = array[i+11];
    _storage[10] = array[i+10];
    _storage[9] = array[i+9];
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
    double x = _storage[4];
    double y = _storage[5];
    double z = _storage[6];
    return new vec3(x, y, z);
  }
  vec3 get forward {
    double x = _storage[8];
    double y = _storage[9];
    double z = _storage[10];
    return new vec3(x, y, z);
  }
}
