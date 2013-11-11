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

/// 4D Matrix.
/// Values are stored in column major order.
class Matrix4 {
  final Float32List storage;

  /// Solve [A] * [x] = [b].
  static void solve2(Matrix4 A, Vector2 x, Vector2 b) {
    final double a11 = A.entry(0,0);
    final double a12 = A.entry(0,1);
    final double a21 = A.entry(1,0);
    final double a22 = A.entry(1,1);
    final double bx = b.x - A.storage[8];
    final double by = b.y - A.storage[9];
    double det = a11 * a22 - a12 * a21;

    if (det != 0.0){
      det = 1.0 / det;
    }

    x.x = det * (a22 * bx - a12 * by);
    x.y = det * (a11 * by - a21 * bx);
  }

  /// Solve [A] * [x] = [b].
  static void solve3(Matrix4 A, Vector3 x, Vector3 b) {
    final double A0x = A.entry(0, 0);
    final double A0y = A.entry(1, 0);
    final double A0z = A.entry(2, 0);
    final double A1x = A.entry(0, 1);
    final double A1y = A.entry(1, 1);
    final double A1z = A.entry(2, 1);
    final double A2x = A.entry(0, 2);
    final double A2y = A.entry(1, 2);
    final double A2z = A.entry(2, 2);
    final double bx = b.x - A.storage[12];
    final double by = b.y - A.storage[13];
    final double bz = b.z - A.storage[14];
    double rx, ry, rz;
    double det;

    // Column1 cross Column 2
    rx = A1y * A2z - A1z * A2y;
    ry = A1z * A2x - A1x * A2z;
    rz = A1x * A2y - A1y * A2x;

    // A.getColumn(0).dot(x)
    det = A0x * rx + A0y * ry + A0z * rz;
    if (det != 0.0){
      det = 1.0 / det;
    }

    // b dot [Column1 cross Column 2]
    final double x_ = det * (bx * rx + by * ry + bz * rz);

    // Column2 cross b
    rx = -(A2y * bz - A2z * by);
    ry = -(A2z * bx - A2x * bz);
    rz = -(A2x * by - A2y * bx);
    // Column0 dot -[Column2 cross b (Column3)]
    final double y_ = det * (A0x * rx + A0y * ry + A0z * rz);

    // b cross Column 1
    rx = -(by * A1z - bz * A1y);
    ry = -(bz * A1x - bx * A1z);
    rz = -(bx * A1y - by * A1x);
    // Column0 dot -[b cross Column 1]
    final double z_ = det * (A0x * rx + A0y * ry + A0z * rz);

    x.x = x_;
    x.y = y_;
    x.z = z_;
  }

  /// Solve [A] * [x] = [b].
  static void solve(Matrix4 A, Vector4 x, Vector4 b) {
    final double a00 = A.storage[0];
    final double a01 = A.storage[1];
    final double a02 = A.storage[2];
    final double a03 = A.storage[3];
    final double a10 = A.storage[4];
    final double a11 = A.storage[5];
    final double a12 = A.storage[6];
    final double a13 = A.storage[7];
    final double a20 = A.storage[8];
    final double a21 = A.storage[9];
    final double a22 = A.storage[10];
    final double a23 = A.storage[11];
    final double a30 = A.storage[12];
    final double a31 = A.storage[13];
    final double a32 = A.storage[14];
    final double a33 = A.storage[15];
    final double b00 = a00 * a11 - a01 * a10;
    final double b01 = a00 * a12 - a02 * a10;
    final double b02 = a00 * a13 - a03 * a10;
    final double b03 = a01 * a12 - a02 * a11;
    final double b04 = a01 * a13 - a03 * a11;
    final double b05 = a02 * a13 - a03 * a12;
    final double b06 = a20 * a31 - a21 * a30;
    final double b07 = a20 * a32 - a22 * a30;
    final double b08 = a20 * a33 - a23 * a30;
    final double b09 = a21 * a32 - a22 * a31;
    final double b10 = a21 * a33 - a23 * a31;
    final double b11 = a22 * a33 - a23 * a32;

    final double bX = b.storage[0];
    final double bY = b.storage[1];
    final double bZ = b.storage[2];
    final double bW = b.storage[3];

    double det = b00 * b11 - b01 * b10 +
                 b02 * b09 + b03 * b08 -
                 b04 * b07 + b05 * b06;

    if (det != 0.0) { det = 1.0/det;  }

    x.x =  det * (
           (a11 * b11 - a12 * b10 + a13 * b09) * bX -
           (a10 * b11 - a12 * b08 + a13 * b07) * bY +
           (a10 * b10 - a11 * b08 + a13 * b06) * bZ -
           (a10 * b09 - a11 * b07 + a12 * b06) * bW);

    x.y =  det * -(
           (a01 * b11 - a02 * b10 + a03 * b09) * bX -
           (a00 * b11 - a02 * b08 + a03 * b07) * bY +
           (a00 * b10 - a01 * b08 + a03 * b06) * bZ -
           (a00 * b09 - a01 * b07 + a02 * b06) * bW);

    x.z =  det * (
           (a31 * b05 - a32 * b04 + a33 * b03) * bX -
           (a30 * b05 - a32 * b02 + a33 * b01) * bY +
           (a30 * b04 - a31 * b02 + a33 * b00) * bZ -
           (a30 * b03 - a31 * b01 + a32 * b00) * bW);

    x.w =  det * -(
           (a21 * b05 - a22 * b04 + a23 * b03) * bX -
           (a20 * b05 - a22 * b02 + a23 * b01) * bY +
           (a20 * b04 - a21 * b02 + a23 * b00) * bZ -
           (a20 * b03 - a21 * b01 + a22 * b00) * bW);

  }

  /// Return index in storage for [row], [col] value.
  int index(int row, int col) => (col * 4) + row;

  /// Value at [row], [col].
  double entry(int row, int col) => storage[index(row, col)];

  /// Set value at [row], [col] to be [v].
  setEntry(int row, int col, double v) { storage[index(row, col)] = v; }

  /// Constructs a new mat4.
  Matrix4(double arg0, double arg1, double arg2, double arg3,
          double arg4, double arg5, double arg6, double arg7,
          double arg8, double arg9, double arg10, double arg11,
          double arg12, double arg13, double arg14, double arg15) : storage = new Float32List(16) {
    setValues(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10,
              arg11, arg12, arg13, arg14, arg15);
  }

  /// Zero matrix.
  Matrix4.zero() : storage = new Float32List(16);

  /// Identity matrix.
  Matrix4.identity() : storage = new Float32List(16) {
    setIdentity();
  }

  /// Copies values from [other].
  Matrix4.copy(Matrix4 other) : storage = new Float32List(16) {
    setFrom(other);
  }

  /// Constructs a new mat4 from columns.
  Matrix4.columns(Vector4 arg0, Vector4 arg1, Vector4 arg2, Vector4 arg3) : storage = new Float32List(16) {
    setColumns(arg0, arg1, arg2, arg3);
  }

  /// Outer product of [u] and [v].
  Matrix4.outer(Vector4 u, Vector4 v) : storage = new Float32List(16) {
    storage[0] = u.storage[0] * v.storage[0];
    storage[1] = u.storage[0] * v.storage[1];
    storage[2] = u.storage[0] * v.storage[2];
    storage[3] = u.storage[0] * v.storage[3];
    storage[4] = u.storage[1] * v.storage[0];
    storage[5] = u.storage[1] * v.storage[1];
    storage[6] = u.storage[1] * v.storage[2];
    storage[7] = u.storage[1] * v.storage[3];
    storage[8] = u.storage[2] * v.storage[0];
    storage[9] = u.storage[2] * v.storage[1];
    storage[10] = u.storage[2] * v.storage[2];
    storage[11] = u.storage[2] * v.storage[3];
    storage[12] = u.storage[3] * v.storage[0];
    storage[13] = u.storage[3] * v.storage[1];
    storage[14] = u.storage[3] * v.storage[2];
    storage[15] = u.storage[3] * v.storage[3];
  }


  /// Rotation of [radians_] around X.
  Matrix4.rotationX(double radians_) : storage = new Float32List(16) {
    storage[15] = 1.0;
    setRotationX(radians_);
  }

  /// Rotation of [radians_] around Y.
  Matrix4.rotationY(double radians_) : storage = new Float32List(16) {
    storage[15] = 1.0;
    setRotationY(radians_);
  }

  /// Rotation of [radians_] around Z.
  Matrix4.rotationZ(double radians_) : storage = new Float32List(16) {
    storage[15] = 1.0;
    setRotationZ(radians_);
  }

  /// Translation matrix.
  Matrix4.translation(Vector3 translation) : storage = new Float32List(16) {
    setIdentity();
    setTranslation(translation);
  }

  /// Translation matrix.
  Matrix4.translationValues(double x, double y, double z) : storage = new Float32List(16) {
    setIdentity();
    setTranslationRaw(x, y, z);
  }

  /// Scale matrix.
  Matrix4.diagonal3(Vector3 scale_) : storage = new Float32List(16) {
    storage[15] = 1.0;
    storage[10] = scale_.storage[2];
    storage[5] = scale_.storage[1];
    storage[0] = scale_.storage[0];
  }

  /// Scale matrix.
  Matrix4.diagonal3Values(double x, double y, double z) : storage = new Float32List(16) {
    storage[15] = 1.0;
    storage[10] = z;
    storage[5] = y;
    storage[0] = x;
  }

  /// Constructs Matrix4 with given Float32List as [storage].
  Matrix4.fromFloat32List(Float32List this.storage);

  /// Constructs Matrix4 with a [storage] that views given [buffer] starting at [offset].
  /// [offset] has to be multiple of [Float32List.BYTES_PER_ELEMENT].
  Matrix4.fromBuffer(ByteBuffer buffer, int offset) : storage = new Float32List.view(buffer, offset, 16);

  /// Sets the diagonal to [arg].
  Matrix4 splatDiagonal(double arg) {
    storage[0] = arg;
    storage[5] = arg;
    storage[10] = arg;
    storage[15] = arg;
    return this;
  }

  /// Sets the matrix with specified values.
  Matrix4 setValues(double arg0, double arg1, double arg2,
                 double arg3, double arg4, double arg5,
                 double arg6, double arg7, double arg8,
                 double arg9, double arg10, double arg11,
                 double arg12, double arg13, double arg14, double arg15) {
    storage[15] = arg15;
    storage[14] = arg14;
    storage[13] = arg13;
    storage[12] = arg12;
    storage[11] = arg11;
    storage[10] = arg10;
    storage[9] = arg9;
    storage[8] = arg8;
    storage[7] = arg7;
    storage[6] = arg6;
    storage[5] = arg5;
    storage[4] = arg4;
    storage[3] = arg3;
    storage[2] = arg2;
    storage[1] = arg1;
    storage[0] = arg0;
    return this;
  }

  /// Sets the entire matrix to the column values.
  Matrix4 setColumns(Vector4 arg0, Vector4 arg1, Vector4 arg2, Vector4 arg3) {
    storage[0] = arg0.storage[0];
    storage[1] = arg0.storage[1];
    storage[2] = arg0.storage[2];
    storage[3] = arg0.storage[3];
    storage[4] = arg1.storage[0];
    storage[5] = arg1.storage[1];
    storage[6] = arg1.storage[2];
    storage[7] = arg1.storage[3];
    storage[8] = arg2.storage[0];
    storage[9] = arg2.storage[1];
    storage[10] = arg2.storage[2];
    storage[11] = arg2.storage[3];
    storage[12] = arg3.storage[0];
    storage[13] = arg3.storage[1];
    storage[14] = arg3.storage[2];
    storage[15] = arg3.storage[3];
    return this;
  }

  /// Sets the entire matrix to the matrix in [arg].
  Matrix4 setFrom(Matrix4 arg) {
    storage[15] = arg.storage[15];
    storage[14] = arg.storage[14];
    storage[13] = arg.storage[13];
    storage[12] = arg.storage[12];
    storage[11] = arg.storage[11];
    storage[10] = arg.storage[10];
    storage[9] = arg.storage[9];
    storage[8] = arg.storage[8];
    storage[7] = arg.storage[7];
    storage[6] = arg.storage[6];
    storage[5] = arg.storage[5];
    storage[4] = arg.storage[4];
    storage[3] = arg.storage[3];
    storage[2] = arg.storage[2];
    storage[1] = arg.storage[1];
    storage[0] = arg.storage[0];
    return this;
  }
  /// Sets the matrix from translation [arg0] and rotation [arg1].
  Matrix4 setFromTranslationRotation(Vector3 arg0, Quaternion arg1) {
    double x = arg1[0];
    double y = arg1[1];
    double z = arg1[2];
    double w = arg1[3];
    double x2 = x + x;
    double y2 = y + y;
    double z2 = z + z;
    double xx = x * x2;
    double xy = x * y2;
    double xz = x * z2;
    double yy = y * y2;
    double yz = y * z2;
    double zz = z * z2;
    double wx = w * x2;
    double wy = w * y2;
    double wz = w * z2;

    storage[0] = 1.0 - (yy + zz);
    storage[1] = xy + wz;
    storage[2] = xz - wy;
    storage[3] = 0.0;
    storage[4] = xy - wz;
    storage[5] = 1.0 - (xx + zz);
    storage[6] = yz + wx;
    storage[7] = 0.0;
    storage[8] = xz + wy;
    storage[9] = yz - wx;
    storage[10] = 1.0 - (xx + yy);
    storage[11] = 0.0;
    storage[12] = arg0[0];
    storage[13] = arg0[1];
    storage[14] = arg0[2];
    storage[15] = 1.0;
    return this;
  }

  /// Sets the upper 2x2 of the matrix to be [arg].
  Matrix4 setUpper2x2(Matrix2 arg) {
    storage[0] = arg.storage[0];
    storage[1] = arg.storage[1];
    storage[4] = arg.storage[2];
    storage[5] = arg.storage[3];
    return this;
  }

  /// Sets the diagonal of the matrix to be [arg].
  Matrix4 setDiagonal(Vector4 arg) {
    storage[0] = arg.storage[0];
    storage[5] = arg.storage[1];
    storage[10] = arg.storage[2];
    storage[15] = arg.storage[3];
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

  /// Dimension of the matrix.
  int get dimension => 4;

  double operator[](int i) => storage[i];

  void operator[]=(int i, double v) {
    storage[i] = v;
  }

  /// Returns row 0
  Vector4 get row0 => getRow(0);

  /// Returns row 1
  Vector4 get row1 => getRow(1);

  /// Returns row 2
  Vector4 get row2 => getRow(2);

  /// Returns row 3
  Vector4 get row3 => getRow(3);

  /// Sets row 0 to [arg]
  set row0(Vector4 arg) => setRow(0, arg);

  /// Sets row 1 to [arg]
  set row1(Vector4 arg) => setRow(1, arg);

  /// Sets row 2 to [arg]
  set row2(Vector4 arg) => setRow(2, arg);

  /// Sets row 3 to [arg]
  set row3(Vector4 arg) => setRow(3, arg);

  /// Assigns the [row] of the matrix [arg]
  void setRow(int row, Vector4 arg) {
    storage[index(row, 0)] = arg.storage[0];
    storage[index(row, 1)] = arg.storage[1];
    storage[index(row, 2)] = arg.storage[2];
    storage[index(row, 3)] = arg.storage[3];
  }

  /// Gets the [row] of the matrix
  Vector4 getRow(int row) {
    Vector4 r = new Vector4.zero();
    r.storage[0] = storage[index(row, 0)];
    r.storage[1] = storage[index(row, 1)];
    r.storage[2] = storage[index(row, 2)];
    r.storage[3] = storage[index(row, 3)];
    return r;
  }

  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, Vector4 arg) {
    int entry = column * 4;
    storage[entry+3] = arg.storage[3];
    storage[entry+2] = arg.storage[2];
    storage[entry+1] = arg.storage[1];
    storage[entry+0] = arg.storage[0];
  }

  /// Gets the [column] of the matrix
  Vector4 getColumn(int column) {
    Vector4 r = new Vector4.zero();
    int entry = column * 4;
    r.storage[3] = storage[entry+3];
    r.storage[2] = storage[entry+2];
    r.storage[1] = storage[entry+1];
    r.storage[0] = storage[entry+0];
    return r;
  }

  /// Clone matrix.
  Matrix4 clone() {
    return new Matrix4.copy(this);
  }

  /// Copy into [arg].
  Matrix4 copyInto(Matrix4 arg) {
    arg.storage[0] = storage[0];
    arg.storage[1] = storage[1];
    arg.storage[2] = storage[2];
    arg.storage[3] = storage[3];
    arg.storage[4] = storage[4];
    arg.storage[5] = storage[5];
    arg.storage[6] = storage[6];
    arg.storage[7] = storage[7];
    arg.storage[8] = storage[8];
    arg.storage[9] = storage[9];
    arg.storage[10] = storage[10];
    arg.storage[11] = storage[11];
    arg.storage[12] = storage[12];
    arg.storage[13] = storage[13];
    arg.storage[14] = storage[14];
    arg.storage[15] = storage[15];
    return arg;
  }

  // TODO: Clean up functions below here.
  Matrix4 _mul_scale(double arg) {
    Matrix4 r = new Matrix4.zero();
    r.storage[15] = storage[15] * arg;
    r.storage[14] = storage[14] * arg;
    r.storage[13] = storage[13] * arg;
    r.storage[12] = storage[12] * arg;
    r.storage[11] = storage[11] * arg;
    r.storage[10] = storage[10] * arg;
    r.storage[9] = storage[9] * arg;
    r.storage[8] = storage[8] * arg;
    r.storage[7] = storage[7] * arg;
    r.storage[6] = storage[6] * arg;
    r.storage[5] = storage[5] * arg;
    r.storage[4] = storage[4] * arg;
    r.storage[3] = storage[3] * arg;
    r.storage[2] = storage[2] * arg;
    r.storage[1] = storage[1] * arg;
    r.storage[0] = storage[0] * arg;
    return r;
  }

  Matrix4 _mul_matrix(Matrix4 arg) {
    var r = new Matrix4.zero();
    r.storage[0] = (storage[0] * arg.storage[0]) + (storage[4] * arg.storage[1]) + (storage[8] * arg.storage[2]) + (storage[12] * arg.storage[3]);
    r.storage[4] = (storage[0] * arg.storage[4]) + (storage[4] * arg.storage[5]) + (storage[8] * arg.storage[6]) + (storage[12] * arg.storage[7]);
    r.storage[8] = (storage[0] * arg.storage[8]) + (storage[4] * arg.storage[9]) + (storage[8] * arg.storage[10]) + (storage[12] * arg.storage[11]);
    r.storage[12] = (storage[0] * arg.storage[12]) + (storage[4] * arg.storage[13]) + (storage[8] * arg.storage[14]) + (storage[12] * arg.storage[15]);
    r.storage[1] = (storage[1] * arg.storage[0]) + (storage[5] * arg.storage[1]) + (storage[9] * arg.storage[2]) + (storage[13] * arg.storage[3]);
    r.storage[5] = (storage[1] * arg.storage[4]) + (storage[5] * arg.storage[5]) + (storage[9] * arg.storage[6]) + (storage[13] * arg.storage[7]);
    r.storage[9] = (storage[1] * arg.storage[8]) + (storage[5] * arg.storage[9]) + (storage[9] * arg.storage[10]) + (storage[13] * arg.storage[11]);
    r.storage[13] = (storage[1] * arg.storage[12]) + (storage[5] * arg.storage[13]) + (storage[9] * arg.storage[14]) + (storage[13] * arg.storage[15]);
    r.storage[2] = (storage[2] * arg.storage[0]) + (storage[6] * arg.storage[1]) + (storage[10] * arg.storage[2]) + (storage[14] * arg.storage[3]);
    r.storage[6] = (storage[2] * arg.storage[4]) + (storage[6] * arg.storage[5]) + (storage[10] * arg.storage[6]) + (storage[14] * arg.storage[7]);
    r.storage[10] = (storage[2] * arg.storage[8]) + (storage[6] * arg.storage[9]) + (storage[10] * arg.storage[10]) + (storage[14] * arg.storage[11]);
    r.storage[14] = (storage[2] * arg.storage[12]) + (storage[6] * arg.storage[13]) + (storage[10] * arg.storage[14]) + (storage[14] * arg.storage[15]);
    r.storage[3] = (storage[3] * arg.storage[0]) + (storage[7] * arg.storage[1]) + (storage[11] * arg.storage[2]) + (storage[15] * arg.storage[3]);
    r.storage[7] = (storage[3] * arg.storage[4]) + (storage[7] * arg.storage[5]) + (storage[11] * arg.storage[6]) + (storage[15] * arg.storage[7]);
    r.storage[11] = (storage[3] * arg.storage[8]) + (storage[7] * arg.storage[9]) + (storage[11] * arg.storage[10]) + (storage[15] * arg.storage[11]);
    r.storage[15] = (storage[3] * arg.storage[12]) + (storage[7] * arg.storage[13]) + (storage[11] * arg.storage[14]) + (storage[15] * arg.storage[15]);
    return r;
  }

  Vector4 _mul_vector(Vector4 arg) {
    Vector4 r = new Vector4.zero();
    r.storage[3] = (storage[3] * arg.storage[0]) + (storage[7] * arg.storage[1]) + (storage[11] * arg.storage[2]) + (storage[15] * arg.storage[3]);
    r.storage[2] = (storage[2] * arg.storage[0]) + (storage[6] * arg.storage[1]) + (storage[10] * arg.storage[2]) + (storage[14] * arg.storage[3]);
    r.storage[1] = (storage[1] * arg.storage[0]) + (storage[5] * arg.storage[1]) + (storage[9] * arg.storage[2]) + (storage[13] * arg.storage[3]);
    r.storage[0] = (storage[0] * arg.storage[0]) + (storage[4] * arg.storage[1]) + (storage[8] * arg.storage[2]) + (storage[12] * arg.storage[3]);
    return r;
  }

  Vector3 _mul_vector3(Vector3 arg) {
    Vector3 r = new Vector3.zero();
    r.storage[0] = (storage[0] * arg.storage[0]) + (storage[4] * arg.storage[1]) + (storage[8] * arg.storage[2]) + storage[12];
    r.storage[1] = (storage[1] * arg.storage[0]) + (storage[5] * arg.storage[1]) + (storage[9] * arg.storage[2]) + storage[13];
    r.storage[2] = (storage[2] * arg.storage[0]) + (storage[6] * arg.storage[1]) + (storage[10] * arg.storage[2]) + storage[14];
    return r;
  }

  /// Returns a new vector or matrix by multiplying [this] with [arg].
  dynamic operator*(dynamic arg) {
    if (arg is double) {
      return _mul_scale(arg);
    }
    if (arg is Vector4) {
      return _mul_vector(arg);
    }
    if (arg is Vector3) {
      return _mul_vector3(arg);
    }
    if (4 == arg.dimension) {
      return _mul_matrix(arg);
    }
    throw new ArgumentError(arg);
  }

  /// Returns new matrix after component wise [this] + [arg]
  Matrix4 operator+(Matrix4 arg) {
    Matrix4 r = new Matrix4.zero();
    r.storage[0] = storage[0] + arg.storage[0];
    r.storage[1] = storage[1] + arg.storage[1];
    r.storage[2] = storage[2] + arg.storage[2];
    r.storage[3] = storage[3] + arg.storage[3];
    r.storage[4] = storage[4] + arg.storage[4];
    r.storage[5] = storage[5] + arg.storage[5];
    r.storage[6] = storage[6] + arg.storage[6];
    r.storage[7] = storage[7] + arg.storage[7];
    r.storage[8] = storage[8] + arg.storage[8];
    r.storage[9] = storage[9] + arg.storage[9];
    r.storage[10] = storage[10] + arg.storage[10];
    r.storage[11] = storage[11] + arg.storage[11];
    r.storage[12] = storage[12] + arg.storage[12];
    r.storage[13] = storage[13] + arg.storage[13];
    r.storage[14] = storage[14] + arg.storage[14];
    r.storage[15] = storage[15] + arg.storage[15];
    return r;
  }

  /// Returns new matrix after component wise [this] - [arg]
  Matrix4 operator-(Matrix4 arg) {
    Matrix4 r = new Matrix4.zero();
    r.storage[0] = storage[0] - arg.storage[0];
    r.storage[1] = storage[1] - arg.storage[1];
    r.storage[2] = storage[2] - arg.storage[2];
    r.storage[3] = storage[3] - arg.storage[3];
    r.storage[4] = storage[4] - arg.storage[4];
    r.storage[5] = storage[5] - arg.storage[5];
    r.storage[6] = storage[6] - arg.storage[6];
    r.storage[7] = storage[7] - arg.storage[7];
    r.storage[8] = storage[8] - arg.storage[8];
    r.storage[9] = storage[9] - arg.storage[9];
    r.storage[10] = storage[10] - arg.storage[10];
    r.storage[11] = storage[11] - arg.storage[11];
    r.storage[12] = storage[12] - arg.storage[12];
    r.storage[13] = storage[13] - arg.storage[13];
    r.storage[14] = storage[14] - arg.storage[14];
    r.storage[15] = storage[15] - arg.storage[15];
    return r;
  }

  /// Translate this matrix by a [Vector3], [Vector4], or x,y,z
  Matrix4 translate(dynamic x, [double y = 0.0, double z = 0.0]) {
    double tx;
    double ty;
    double tz;
    double tw = x is Vector4 ? x.w : 1.0;
    if (x is Vector3 || x is Vector4) {
      tx = x.x;
      ty = x.y;
      tz = x.z;
    } else {
      tx = x;
      ty = y;
      tz = z;
    }
    var t1 = storage[0] * tx + storage[4] * ty + storage[8] * tz + storage[12] * tw;
    var t2 = storage[1] * tx + storage[5] * ty + storage[9] * tz + storage[13] * tw;
    var t3 = storage[2] * tx + storage[6] * ty + storage[10] * tz + storage[14] * tw;
    var t4 = storage[3] * tx + storage[7] * ty + storage[11] * tz + storage[15] * tw;
    storage[12] = t1;
    storage[13] = t2;
    storage[14] = t3;
    storage[15] = t4;
    return this;
  }

  /// Rotate this [angle] radians around [axis]
  Matrix4 rotate(Vector3 axis, double angle) {
    var len = axis.length;
    var x = axis.x/len;
    var y = axis.y/len;
    var z = axis.z/len;
    var c = Math.cos(angle);
    var s = Math.sin(angle);
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
    var t1 = storage[0] * m11 + storage[4] * m21 + storage[8] * m31;
    var t2 = storage[1] * m11 + storage[5] * m21 + storage[9] * m31;
    var t3 = storage[2] * m11 + storage[6] * m21 + storage[10] * m31;
    var t4 = storage[3] * m11 + storage[7] * m21 + storage[11] * m31;
    var t5 = storage[0] * m12 + storage[4] * m22 + storage[8] * m32;
    var t6 = storage[1] * m12 + storage[5] * m22 + storage[9] * m32;
    var t7 = storage[2] * m12 + storage[6] * m22 + storage[10] * m32;
    var t8 = storage[3] * m12 + storage[7] * m22 + storage[11] * m32;
    var t9 = storage[0] * m13 + storage[4] * m23 + storage[8] * m33;
    var t10 = storage[1] * m13 + storage[5] * m23 + storage[9] * m33;
    var t11 = storage[2] * m13 + storage[6] * m23 + storage[10] * m33;
    var t12 = storage[3] * m13 + storage[7] * m23 + storage[11] * m33;
    storage[0] = t1;
    storage[1] = t2;
    storage[2] = t3;
    storage[3] = t4;
    storage[4] = t5;
    storage[5] = t6;
    storage[6] = t7;
    storage[7] = t8;
    storage[8] = t9;
    storage[9] = t10;
    storage[10] = t11;
    storage[11] = t12;
    return this;
  }

  /// Rotate this [angle] radians around X
  Matrix4 rotateX(double angle) {
    double cosAngle = Math.cos(angle);
    double sinAngle = Math.sin(angle);
    var t1 = storage[4] * cosAngle + storage[8] * sinAngle;
    var t2 = storage[5] * cosAngle + storage[9] * sinAngle;
    var t3 = storage[6] * cosAngle + storage[10] * sinAngle;
    var t4 = storage[7] * cosAngle + storage[11] * sinAngle;
    var t5 = storage[4] * -sinAngle + storage[8] * cosAngle;
    var t6 = storage[5] * -sinAngle + storage[9] * cosAngle;
    var t7 = storage[6] * -sinAngle + storage[10] * cosAngle;
    var t8 = storage[7] * -sinAngle + storage[11] * cosAngle;
    storage[4] = t1;
    storage[5] = t2;
    storage[6] = t3;
    storage[7] = t4;
    storage[8] = t5;
    storage[9] = t6;
    storage[10] = t7;
    storage[11] = t8;
    return this;
  }

  /// Rotate this matrix [angle] radians around Y
  Matrix4 rotateY(double angle) {
    double cosAngle = Math.cos(angle);
    double sinAngle = Math.sin(angle);
    var t1 = storage[0] * cosAngle + storage[8] * sinAngle;
    var t2 = storage[1] * cosAngle + storage[9] * sinAngle;
    var t3 = storage[2] * cosAngle + storage[10] * sinAngle;
    var t4 = storage[3] * cosAngle + storage[11] * sinAngle;
    var t5 = storage[0] * -sinAngle + storage[8] * cosAngle;
    var t6 = storage[1] * -sinAngle + storage[9] * cosAngle;
    var t7 = storage[2] * -sinAngle + storage[10] * cosAngle;
    var t8 = storage[3] * -sinAngle + storage[11] * cosAngle;
    storage[0] = t1;
    storage[1] = t2;
    storage[2] = t3;
    storage[3] = t4;
    storage[8] = t5;
    storage[9] = t6;
    storage[10] = t7;
    storage[11] = t8;
    return this;
  }

  /// Rotate this matrix [angle] radians around Z
  Matrix4 rotateZ(double angle) {
    double cosAngle = Math.cos(angle);
    double sinAngle = Math.sin(angle);
    var t1 = storage[0] * cosAngle + storage[4] * sinAngle;
    var t2 = storage[1] * cosAngle + storage[5] * sinAngle;
    var t3 = storage[2] * cosAngle + storage[6] * sinAngle;
    var t4 = storage[3] * cosAngle + storage[7] * sinAngle;
    var t5 = storage[0] * -sinAngle + storage[4] * cosAngle;
    var t6 = storage[1] * -sinAngle + storage[5] * cosAngle;
    var t7 = storage[2] * -sinAngle + storage[6] * cosAngle;
    var t8 = storage[3] * -sinAngle + storage[7] * cosAngle;
    storage[0] = t1;
    storage[1] = t2;
    storage[2] = t3;
    storage[3] = t4;
    storage[4] = t5;
    storage[5] = t6;
    storage[6] = t7;
    storage[7] = t8;
    return this;
  }

  /// Scale this matrix by a [Vector3], [Vector4], or x,y,z
  Matrix4 scale(dynamic x, [double y = null, double z = null]) {
    double sx;
    double sy;
    double sz;
    double sw = x is Vector4 ? x.w : 1.0;
    if (x is Vector3 || x is Vector4) {
      sx = x.x;
      sy = x.y;
      sz = x.z;
    } else {
      sx = x;
      sy = y == null ? x : y.toDouble();
      sz = z == null ? x : z.toDouble();
    }
    storage[0] *= sx;
    storage[1] *= sx;
    storage[2] *= sx;
    storage[3] *= sx;
    storage[4] *= sy;
    storage[5] *= sy;
    storage[6] *= sy;
    storage[7] *= sy;
    storage[8] *= sz;
    storage[9] *= sz;
    storage[10] *= sz;
    storage[11] *= sz;
    storage[12] *= sw;
    storage[13] *= sw;
    storage[14] *= sw;
    storage[15] *= sw;
    return this;
  }
  /// Returns new matrix -this
  Matrix4 operator-() {
    Matrix4 r = new Matrix4.zero();
    r[0] = -storage[0];
    r[1] = -storage[1];
    r[2] = -storage[2];
    r[3] = -storage[3];
    return r;
  }
  /// Zeros [this].
  Matrix4 setZero() {
    storage[0] = 0.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = 0.0;
    storage[5] = 0.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 0.0;
    storage[9] = 0.0;
    storage[10] = 0.0;
    storage[11] = 0.0;
    storage[12] = 0.0;
    storage[13] = 0.0;
    storage[14] = 0.0;
    storage[15] = 0.0;
    return this;
  }
  /// Makes [this] into the identity matrix.
  Matrix4 setIdentity() {
    storage[0] = 1.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = 0.0;
    storage[5] = 1.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 0.0;
    storage[9] = 0.0;
    storage[10] = 1.0;
    storage[11] = 0.0;
    storage[12] = 0.0;
    storage[13] = 0.0;
    storage[14] = 0.0;
    storage[15] = 1.0;
    return this;
  }
  /// Returns the tranpose of this.
  Matrix4 transposed() {
    Matrix4 r = new Matrix4.zero();
    r.storage[0] = storage[0];
    r.storage[1] = storage[4];
    r.storage[2] = storage[8];
    r.storage[3] = storage[12];
    r.storage[4] = storage[1];
    r.storage[5] = storage[5];
    r.storage[6] = storage[9];
    r.storage[7] = storage[13];
    r.storage[8] = storage[2];
    r.storage[9] = storage[6];
    r.storage[10] = storage[10];
    r.storage[11] = storage[14];
    r.storage[12] = storage[3];
    r.storage[13] = storage[7];
    r.storage[14] = storage[11];
    r.storage[15] = storage[15];
    return r;
  }
  Matrix4 transpose() {
    double temp;
    temp = storage[4];
    storage[4] = storage[1];
    storage[1] = temp;
    temp = storage[8];
    storage[8] = storage[2];
    storage[2] = temp;
    temp = storage[12];
    storage[12] = storage[3];
    storage[3] = temp;
    temp = storage[9];
    storage[9] = storage[6];
    storage[6] = temp;
    temp = storage[13];
    storage[13] = storage[7];
    storage[7] = temp;
    temp = storage[14];
    storage[14] = storage[11];
    storage[11] = temp;
    return this;
  }
  /// Returns the component wise absolute value of this.
  Matrix4 absolute() {
    Matrix4 r = new Matrix4.zero();
    r.storage[0] = storage[0].abs();
    r.storage[1] = storage[1].abs();
    r.storage[2] = storage[2].abs();
    r.storage[3] = storage[3].abs();
    r.storage[4] = storage[4].abs();
    r.storage[5] = storage[5].abs();
    r.storage[6] = storage[6].abs();
    r.storage[7] = storage[7].abs();
    r.storage[8] = storage[8].abs();
    r.storage[9] = storage[9].abs();
    r.storage[10] = storage[10].abs();
    r.storage[11] = storage[11].abs();
    r.storage[12] = storage[12].abs();
    r.storage[13] = storage[13].abs();
    r.storage[14] = storage[14].abs();
    r.storage[15] = storage[15].abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  double determinant() {
    double det2_01_01 = storage[0] * storage[5] - storage[1] * storage[4];
    double det2_01_02 = storage[0] * storage[6] - storage[2] * storage[4];
    double det2_01_03 = storage[0] * storage[7] - storage[3] * storage[4];
    double det2_01_12 = storage[1] * storage[6] - storage[2] * storage[5];
    double det2_01_13 = storage[1] * storage[7] - storage[3] * storage[5];
    double det2_01_23 = storage[2] * storage[7] - storage[3] * storage[6];
    double det3_201_012 = storage[8] * det2_01_12 - storage[9] * det2_01_02 +
                          storage[10] * det2_01_01;
    double det3_201_013 = storage[8] * det2_01_13 - storage[9] * det2_01_03 +
                          storage[11] * det2_01_01;
    double det3_201_023 = storage[8] * det2_01_23 - storage[10] * det2_01_03 +
                          storage[11] * det2_01_02;
    double det3_201_123 = storage[9] * det2_01_23 - storage[10] * det2_01_13 +
                          storage[11] * det2_01_12;
    return -det3_201_123 * storage[12] + det3_201_023 * storage[13] -
            det3_201_013 * storage[14] + det3_201_012 * storage[15];
  }

  /// Returns the dot product of row [i] and [v].
  double dotRow(int i, Vector4 v) {
    return storage[i] * v.storage[0]
         + storage[4+i] * v.storage[1]
         + storage[8+i] * v.storage[2]
         + storage[12+i] * v.storage[3];
  }

  /// Returns the dot product of column [j] and [v].
  double dotColumn(int j, Vector4 v) {
    return storage[j*4] * v.storage[0]
         + storage[j*4+1] * v.storage[1]
         + storage[j*4+2] * v.storage[2]
         + storage[j*4+3] * v.storage[3];
  }

  /// Returns the trace of the matrix. The trace of a matrix is the sum of the
  /// diagonal entries.
  double trace() {
    double t = 0.0;
    t += storage[0];
    t += storage[5];
    t += storage[10];
    t += storage[15];
    return t;
  }

  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    double norm = 0.0;
    {
      double row_norm = 0.0;
      row_norm += storage[0].abs();
      row_norm += storage[1].abs();
      row_norm += storage[2].abs();
      row_norm += storage[3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += storage[4].abs();
      row_norm += storage[5].abs();
      row_norm += storage[6].abs();
      row_norm += storage[7].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += storage[8].abs();
      row_norm += storage[9].abs();
      row_norm += storage[10].abs();
      row_norm += storage[11].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += storage[12].abs();
      row_norm += storage[13].abs();
      row_norm += storage[14].abs();
      row_norm += storage[15].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }

  /// Returns relative error between [this] and [correct]
  double relativeError(Matrix4 correct) {
    Matrix4 diff = correct - this;
    double correct_norm = correct.infinityNorm();
    double diff_norm = diff.infinityNorm();
    return diff_norm/correct_norm;
  }

  /// Returns absolute error between [this] and [correct]
  double absoluteError(Matrix4 correct) {
    double this_norm = infinityNorm();
    double correct_norm = correct.infinityNorm();
    double diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }

  /// Returns the translation vector from this homogeneous transformation matrix.
  Vector3 getTranslation() {
    double z = storage[14];
    double y = storage[13];
    double x = storage[12];
    return new Vector3(x, y, z);
  }

  /// Sets the translation vector in this homogeneous transformation matrix.
  void setTranslation(Vector3 T) {
    double z = T.storage[2];
    double y = T.storage[1];
    double x = T.storage[0];
    storage[14] = z;
    storage[13] = y;
    storage[12] = x;
  }

  /// Sets the translation vector in this homogeneous transformation matrix.
  void setTranslationRaw(double x, double y, double z) {
    storage[14] = z;
    storage[13] = y;
    storage[12] = x;
  }

  /// Returns the rotation matrix from this homogeneous transformation matrix.
  Matrix3 getRotation() {
    Matrix3 r = new Matrix3.zero();
    r.storage[0] = storage[0];
    r.storage[1] = storage[1];
    r.storage[2] = storage[2];
    r.storage[3] = storage[4];
    r.storage[4] = storage[5];
    r.storage[5] = storage[6];
    r.storage[6] = storage[8];
    r.storage[7] = storage[9];
    r.storage[8] = storage[10];
    return r;
  }

  /// Sets the rotation matrix in this homogeneous transformation matrix.
  void setRotation(Matrix3 r) {
    storage[0] = r.storage[0];
    storage[1] = r.storage[1];
    storage[2] = r.storage[2];
    storage[4] = r.storage[3];
    storage[5] = r.storage[4];
    storage[6] = r.storage[5];
    storage[8] = r.storage[6];
    storage[9] = r.storage[7];
    storage[10] = r.storage[8];
  }

  /// Transposes just the upper 3x3 rotation matrix.
  Matrix4 transposeRotation() {
    double temp;
    temp = storage[1];
    storage[1] = storage[4];
    storage[4] = temp;
    temp = storage[2];
    storage[2] = storage[8];
    storage[8] = temp;
    temp = storage[4];
    storage[4] = storage[1];
    storage[1] = temp;
    temp = storage[6];
    storage[6] = storage[9];
    storage[9] = temp;
    temp = storage[8];
    storage[8] = storage[2];
    storage[2] = temp;
    temp = storage[9];
    storage[9] = storage[6];
    storage[6] = temp;
    return this;
  }

  double invert() {
    double a00 = storage[0];
    double a01 = storage[1];
    double a02 = storage[2];
    double a03 = storage[3];
    double a10 = storage[4];
    double a11 = storage[5];
    double a12 = storage[6];
    double a13 = storage[7];
    double a20 = storage[8];
    double a21 = storage[9];
    double a22 = storage[10];
    double a23 = storage[11];
    double a30 = storage[12];
    double a31 = storage[13];
    double a32 = storage[14];
    double a33 = storage[15];
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
    storage[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;
    storage[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;
    storage[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;
    storage[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;
    storage[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;
    storage[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;
    storage[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;
    storage[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;
    storage[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;
    storage[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;
    storage[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;
    storage[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;
    storage[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;
    storage[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;
    storage[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;
    storage[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;
    return det;
  }

  /// Set this matrix to be the inverse of [arg]
  double copyInverse(Matrix4 arg) {
    double a00 = arg.storage[0];
    double a01 = arg.storage[1];
    double a02 = arg.storage[2];
    double a03 = arg.storage[3];
    double a10 = arg.storage[4];
    double a11 = arg.storage[5];
    double a12 = arg.storage[6];
    double a13 = arg.storage[7];
    double a20 = arg.storage[8];
    double a21 = arg.storage[9];
    double a22 = arg.storage[10];
    double a23 = arg.storage[11];
    double a30 = arg.storage[12];
    double a31 = arg.storage[13];
    double a32 = arg.storage[14];
    double a33 = arg.storage[15];
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
    if (det == 0.0) {
      setFrom(arg);
      return 0.0;
    }
    var invDet = 1.0 / det;
    storage[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;
    storage[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;
    storage[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;
    storage[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;
    storage[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;
    storage[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;
    storage[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;
    storage[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;
    storage[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;
    storage[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;
    storage[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;
    storage[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;
    storage[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;
    storage[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;
    storage[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;
    storage[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;
    return det;
  }

  double invertRotation() {
    double det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    double invDet = 1.0 / det;
    double ix;
    double iy;
    double iz;
    double jx;
    double jy;
    double jz;
    double kx;
    double ky;
    double kz;
    ix = invDet * (storage[5] * storage[10] - storage[6] * storage[9]);
    iy = invDet * (storage[2] * storage[9] - storage[1] * storage[10]);
    iz = invDet * (storage[1] * storage[6] - storage[2] * storage[5]);
    jx = invDet * (storage[6] * storage[8] - storage[4] * storage[10]);
    jy = invDet * (storage[0] * storage[10] - storage[2] * storage[8]);
    jz = invDet * (storage[2] * storage[4] - storage[0] * storage[6]);
    kx = invDet * (storage[4] * storage[9] - storage[5] * storage[8]);
    ky = invDet * (storage[1] * storage[8] - storage[0] * storage[9]);
    kz = invDet * (storage[0] * storage[5] - storage[1] * storage[4]);
    storage[0] = ix;
    storage[1] = iy;
    storage[2] = iz;
    storage[4] = jx;
    storage[5] = jy;
    storage[6] = jz;
    storage[8] = kx;
    storage[9] = ky;
    storage[10] = kz;
    return det;
  }
  /// Sets the upper 3x3 to a rotation of [radians] around X
  void setRotationX(double radians) {
    double c = Math.cos(radians);
    double s = Math.sin(radians);
    storage[0] = 1.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[4] = 0.0;
    storage[5] = c;
    storage[6] = s;
    storage[8] = 0.0;
    storage[9] = -s;
    storage[10] = c;
    storage[3] = 0.0;
    storage[7] = 0.0;
    storage[11] = 0.0;
  }

  /// Sets the upper 3x3 to a rotation of [radians] around Y
  void setRotationY(double radians) {
    double c = Math.cos(radians);
    double s = Math.sin(radians);
    storage[0] = c;
    storage[1] = 0.0;
    storage[2] = s;
    storage[4] = 0.0;
    storage[5] = 1.0;
    storage[6] = 0.0;
    storage[8] = -s;
    storage[9] = 0.0;
    storage[10] = c;
    storage[3] = 0.0;
    storage[7] = 0.0;
    storage[11] = 0.0;
  }

  /// Sets the upper 3x3 to a rotation of [radians] around Z
  void setRotationZ(double radians) {
    double c = Math.cos(radians);
    double s = Math.sin(radians);
    storage[0] = c;
    storage[1] = s;
    storage[2] = 0.0;
    storage[4] = -s;
    storage[5] = c;
    storage[6] = 0.0;
    storage[8] = 0.0;
    storage[9] = 0.0;
    storage[10] = 1.0;
    storage[3] = 0.0;
    storage[7] = 0.0;
    storage[11] = 0.0;
  }

  /// Converts into Adjugate matrix and scales by [scale]
  Matrix4 scaleAdjoint(double scale) {
    // Adapted from code by Richard Carling.
    double a1 = storage[0];
    double b1 = storage[4];
    double c1 = storage[8];
    double d1 = storage[12];
    double a2 = storage[1];
    double b2 = storage[5];
    double c2 = storage[9];
    double d2 = storage[13];
    double a3 = storage[2];
    double b3 = storage[6];
    double c3 = storage[10];
    double d3 = storage[14];
    double a4 = storage[3];
    double b4 = storage[7];
    double c4 = storage[11];
    double d4 = storage[15];
    storage[0]  =   (b2 * (c3 * d4 - c4 * d3) - c2 * (b3 * d4 - b4 * d3) + d2 * (b3 * c4 - b4 * c3)) * scale;
    storage[1]  = - (a2 * (c3 * d4 - c4 * d3) - c2 * (a3 * d4 - a4 * d3) + d2 * (a3 * c4 - a4 * c3)) * scale;
    storage[2]  =   (a2 * (b3 * d4 - b4 * d3) - b2 * (a3 * d4 - a4 * d3) + d2 * (a3 * b4 - a4 * b3)) * scale;
    storage[3]  = - (a2 * (b3 * c4 - b4 * c3) - b2 * (a3 * c4 - a4 * c3) + c2 * (a3 * b4 - a4 * b3)) * scale;
    storage[4]  = - (b1 * (c3 * d4 - c4 * d3) - c1 * (b3 * d4 - b4 * d3) + d1 * (b3 * c4 - b4 * c3)) * scale;
    storage[5]  =   (a1 * (c3 * d4 - c4 * d3) - c1 * (a3 * d4 - a4 * d3) + d1 * (a3 * c4 - a4 * c3)) * scale;
    storage[6]  = - (a1 * (b3 * d4 - b4 * d3) - b1 * (a3 * d4 - a4 * d3) + d1 * (a3 * b4 - a4 * b3)) * scale;
    storage[7]  =   (a1 * (b3 * c4 - b4 * c3) - b1 * (a3 * c4 - a4 * c3) + c1 * (a3 * b4 - a4 * b3)) * scale;
    storage[8]  =   (b1 * (c2 * d4 - c4 * d2) - c1 * (b2 * d4 - b4 * d2) + d1 * (b2 * c4 - b4 * c2)) * scale;
    storage[9]  = - (a1 * (c2 * d4 - c4 * d2) - c1 * (a2 * d4 - a4 * d2) + d1 * (a2 * c4 - a4 * c2)) * scale;
    storage[10]  =   (a1 * (b2 * d4 - b4 * d2) - b1 * (a2 * d4 - a4 * d2) + d1 * (a2 * b4 - a4 * b2)) * scale;
    storage[11]  = - (a1 * (b2 * c4 - b4 * c2) - b1 * (a2 * c4 - a4 * c2) + c1 * (a2 * b4 - a4 * b2)) * scale;
    storage[12]  = - (b1 * (c2 * d3 - c3 * d2) - c1 * (b2 * d3 - b3 * d2) + d1 * (b2 * c3 - b3 * c2)) * scale;
    storage[13]  =   (a1 * (c2 * d3 - c3 * d2) - c1 * (a2 * d3 - a3 * d2) + d1 * (a2 * c3 - a3 * c2)) * scale;
    storage[14]  = - (a1 * (b2 * d3 - b3 * d2) - b1 * (a2 * d3 - a3 * d2) + d1 * (a2 * b3 - a3 * b2)) * scale;
    storage[15]  =   (a1 * (b2 * c3 - b3 * c2) - b1 * (a2 * c3 - a3 * c2) + c1 * (a2 * b3 - a3 * b2)) * scale;
    return this;
  }

  /// Rotates [arg] by the absolute rotation of [this]
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  Vector3 absoluteRotate(Vector3 arg) {
    double m00 = storage[0].abs();
    double m01 = storage[4].abs();
    double m02 = storage[8].abs();
    double m10 = storage[1].abs();
    double m11 = storage[5].abs();
    double m12 = storage[9].abs();
    double m20 = storage[2].abs();
    double m21 = storage[6].abs();
    double m22 = storage[10].abs();
    double x = arg.x;
    double y = arg.y;
    double z = arg.z;
    arg.x = x * m00 + y * m01 + z * m02 + 0.0 * 0.0;
    arg.y = x * m10 + y * m11 + z * m12 + 0.0 * 0.0;
    arg.z = x * m20 + y * m21 + z * m22 + 0.0 * 0.0;
    return arg;
  }

  Matrix4 add(Matrix4 o) {
    storage[0] = storage[0] + o.storage[0];
    storage[1] = storage[1] + o.storage[1];
    storage[2] = storage[2] + o.storage[2];
    storage[3] = storage[3] + o.storage[3];
    storage[4] = storage[4] + o.storage[4];
    storage[5] = storage[5] + o.storage[5];
    storage[6] = storage[6] + o.storage[6];
    storage[7] = storage[7] + o.storage[7];
    storage[8] = storage[8] + o.storage[8];
    storage[9] = storage[9] + o.storage[9];
    storage[10] = storage[10] + o.storage[10];
    storage[11] = storage[11] + o.storage[11];
    storage[12] = storage[12] + o.storage[12];
    storage[13] = storage[13] + o.storage[13];
    storage[14] = storage[14] + o.storage[14];
    storage[15] = storage[15] + o.storage[15];
    return this;
  }

  Matrix4 sub(Matrix4 o) {
    storage[0] = storage[0] - o.storage[0];
    storage[1] = storage[1] - o.storage[1];
    storage[2] = storage[2] - o.storage[2];
    storage[3] = storage[3] - o.storage[3];
    storage[4] = storage[4] - o.storage[4];
    storage[5] = storage[5] - o.storage[5];
    storage[6] = storage[6] - o.storage[6];
    storage[7] = storage[7] - o.storage[7];
    storage[8] = storage[8] - o.storage[8];
    storage[9] = storage[9] - o.storage[9];
    storage[10] = storage[10] - o.storage[10];
    storage[11] = storage[11] - o.storage[11];
    storage[12] = storage[12] - o.storage[12];
    storage[13] = storage[13] - o.storage[13];
    storage[14] = storage[14] - o.storage[14];
    storage[15] = storage[15] - o.storage[15];
    return this;
  }

  Matrix4 negate() {
    storage[0] = -storage[0];
    storage[1] = -storage[1];
    storage[2] = -storage[2];
    storage[3] = -storage[3];
    storage[4] = -storage[4];
    storage[5] = -storage[5];
    storage[6] = -storage[6];
    storage[7] = -storage[7];
    storage[8] = -storage[8];
    storage[9] = -storage[9];
    storage[10] = -storage[10];
    storage[11] = -storage[11];
    storage[12] = -storage[12];
    storage[13] = -storage[13];
    storage[14] = -storage[14];
    storage[15] = -storage[15];
    return this;
  }

  Matrix4 multiply(Matrix4 arg) {
    final double m00 = storage[0];
    final double m01 = storage[4];
    final double m02 = storage[8];
    final double m03 = storage[12];
    final double m10 = storage[1];
    final double m11 = storage[5];
    final double m12 = storage[9];
    final double m13 = storage[13];
    final double m20 = storage[2];
    final double m21 = storage[6];
    final double m22 = storage[10];
    final double m23 = storage[14];
    final double m30 = storage[3];
    final double m31 = storage[7];
    final double m32 = storage[11];
    final double m33 = storage[15];
    final double n00 = arg.storage[0];
    final double n01 = arg.storage[4];
    final double n02 = arg.storage[8];
    final double n03 = arg.storage[12];
    final double n10 = arg.storage[1];
    final double n11 = arg.storage[5];
    final double n12 = arg.storage[9];
    final double n13 = arg.storage[13];
    final double n20 = arg.storage[2];
    final double n21 = arg.storage[6];
    final double n22 = arg.storage[10];
    final double n23 = arg.storage[14];
    final double n30 = arg.storage[3];
    final double n31 = arg.storage[7];
    final double n32 = arg.storage[11];
    final double n33 = arg.storage[15];
    storage[0] =  (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    storage[4] =  (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    storage[8] =  (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    storage[12] =  (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    storage[1] =  (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    storage[5] =  (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    storage[9] =  (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    storage[13] =  (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    storage[2] =  (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    storage[6] =  (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    storage[10] =  (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    storage[14] =  (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    storage[3] =  (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    storage[7] =  (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    storage[11] =  (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    storage[15] =  (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
    return this;
  }

  Matrix4 transposeMultiply(Matrix4 arg) {
    double m00 = storage[0];
    double m01 = storage[1];
    double m02 = storage[2];
    double m03 = storage[3];
    double m10 = storage[4];
    double m11 = storage[5];
    double m12 = storage[6];
    double m13 = storage[7];
    double m20 = storage[8];
    double m21 = storage[9];
    double m22 = storage[10];
    double m23 = storage[11];
    double m30 = storage[12];
    double m31 = storage[13];
    double m32 = storage[14];
    double m33 = storage[15];
    storage[0] =  (m00 * arg.storage[0]) + (m01 * arg.storage[1]) + (m02 * arg.storage[2]) + (m03 * arg.storage[3]);
    storage[4] =  (m00 * arg.storage[4]) + (m01 * arg.storage[5]) + (m02 * arg.storage[6]) + (m03 * arg.storage[7]);
    storage[8] =  (m00 * arg.storage[8]) + (m01 * arg.storage[9]) + (m02 * arg.storage[10]) + (m03 * arg.storage[11]);
    storage[12] =  (m00 * arg.storage[12]) + (m01 * arg.storage[13]) + (m02 * arg.storage[14]) + (m03 * arg.storage[15]);
    storage[1] =  (m10 * arg.storage[0]) + (m11 * arg.storage[1]) + (m12 * arg.storage[2]) + (m13 * arg.storage[3]);
    storage[5] =  (m10 * arg.storage[4]) + (m11 * arg.storage[5]) + (m12 * arg.storage[6]) + (m13 * arg.storage[7]);
    storage[9] =  (m10 * arg.storage[8]) + (m11 * arg.storage[9]) + (m12 * arg.storage[10]) + (m13 * arg.storage[11]);
    storage[13] =  (m10 * arg.storage[12]) + (m11 * arg.storage[13]) + (m12 * arg.storage[14]) + (m13 * arg.storage[15]);
    storage[2] =  (m20 * arg.storage[0]) + (m21 * arg.storage[1]) + (m22 * arg.storage[2]) + (m23 * arg.storage[3]);
    storage[6] =  (m20 * arg.storage[4]) + (m21 * arg.storage[5]) + (m22 * arg.storage[6]) + (m23 * arg.storage[7]);
    storage[10] =  (m20 * arg.storage[8]) + (m21 * arg.storage[9]) + (m22 * arg.storage[10]) + (m23 * arg.storage[11]);
    storage[14] =  (m20 * arg.storage[12]) + (m21 * arg.storage[13]) + (m22 * arg.storage[14]) + (m23 * arg.storage[15]);
    storage[3] =  (m30 * arg.storage[0]) + (m31 * arg.storage[1]) + (m32 * arg.storage[2]) + (m33 * arg.storage[3]);
    storage[7] =  (m30 * arg.storage[4]) + (m31 * arg.storage[5]) + (m32 * arg.storage[6]) + (m33 * arg.storage[7]);
    storage[11] =  (m30 * arg.storage[8]) + (m31 * arg.storage[9]) + (m32 * arg.storage[10]) + (m33 * arg.storage[11]);
    storage[15] =  (m30 * arg.storage[12]) + (m31 * arg.storage[13]) + (m32 * arg.storage[14]) + (m33 * arg.storage[15]);
    return this;
  }

  Matrix4 multiplyTranspose(Matrix4 arg) {
    double m00 = storage[0];
    double m01 = storage[4];
    double m02 = storage[8];
    double m03 = storage[12];
    double m10 = storage[1];
    double m11 = storage[5];
    double m12 = storage[9];
    double m13 = storage[13];
    double m20 = storage[2];
    double m21 = storage[6];
    double m22 = storage[10];
    double m23 = storage[14];
    double m30 = storage[3];
    double m31 = storage[7];
    double m32 = storage[11];
    double m33 = storage[15];
    storage[0] =  (m00 * arg.storage[0]) + (m01 * arg.storage[4]) + (m02 * arg.storage[8]) + (m03 * arg.storage[12]);
    storage[4] =  (m00 * arg.storage[1]) + (m01 * arg.storage[5]) + (m02 * arg.storage[9]) + (m03 * arg.storage[13]);
    storage[8] =  (m00 * arg.storage[2]) + (m01 * arg.storage[6]) + (m02 * arg.storage[10]) + (m03 * arg.storage[14]);
    storage[12] =  (m00 * arg.storage[3]) + (m01 * arg.storage[7]) + (m02 * arg.storage[11]) + (m03 * arg.storage[15]);
    storage[1] =  (m10 * arg.storage[0]) + (m11 * arg.storage[4]) + (m12 * arg.storage[8]) + (m13 * arg.storage[12]);
    storage[5] =  (m10 * arg.storage[1]) + (m11 * arg.storage[5]) + (m12 * arg.storage[9]) + (m13 * arg.storage[13]);
    storage[9] =  (m10 * arg.storage[2]) + (m11 * arg.storage[6]) + (m12 * arg.storage[10]) + (m13 * arg.storage[14]);
    storage[13] =  (m10 * arg.storage[3]) + (m11 * arg.storage[7]) + (m12 * arg.storage[11]) + (m13 * arg.storage[15]);
    storage[2] =  (m20 * arg.storage[0]) + (m21 * arg.storage[4]) + (m22 * arg.storage[8]) + (m23 * arg.storage[12]);
    storage[6] =  (m20 * arg.storage[1]) + (m21 * arg.storage[5]) + (m22 * arg.storage[9]) + (m23 * arg.storage[13]);
    storage[10] =  (m20 * arg.storage[2]) + (m21 * arg.storage[6]) + (m22 * arg.storage[10]) + (m23 * arg.storage[14]);
    storage[14] =  (m20 * arg.storage[3]) + (m21 * arg.storage[7]) + (m22 * arg.storage[11]) + (m23 * arg.storage[15]);
    storage[3] =  (m30 * arg.storage[0]) + (m31 * arg.storage[4]) + (m32 * arg.storage[8]) + (m33 * arg.storage[12]);
    storage[7] =  (m30 * arg.storage[1]) + (m31 * arg.storage[5]) + (m32 * arg.storage[9]) + (m33 * arg.storage[13]);
    storage[11] =  (m30 * arg.storage[2]) + (m31 * arg.storage[6]) + (m32 * arg.storage[10]) + (m33 * arg.storage[14]);
    storage[15] =  (m30 * arg.storage[3]) + (m31 * arg.storage[7]) + (m32 * arg.storage[11]) + (m33 * arg.storage[15]);
    return this;
  }

  Vector3 rotate3(Vector3 arg) {
    double x_ =  (storage[0] * arg.storage[0]) + (storage[4] * arg.storage[1]) + (storage[8] * arg.storage[2]);
    double y_ =  (storage[1] * arg.storage[0]) + (storage[5] * arg.storage[1]) + (storage[9] * arg.storage[2]);
    double z_ =  (storage[2] * arg.storage[0]) + (storage[6] * arg.storage[1]) + (storage[10] * arg.storage[2]);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }

  Vector3 rotated3(Vector3 arg, [Vector3 out=null]) {
    if (out == null) {
      out = new Vector3.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return rotate3(out);
  }

  Vector3 transform3(Vector3 arg) {
    double x_ =  (storage[0] * arg.storage[0]) + (storage[4] * arg.storage[1]) + (storage[8] * arg.storage[2]) + storage[12];
    double y_ =  (storage[1] * arg.storage[0]) + (storage[5] * arg.storage[1]) + (storage[9] * arg.storage[2]) + storage[13];
    double z_ =  (storage[2] * arg.storage[0]) + (storage[6] * arg.storage[1]) + (storage[10] * arg.storage[2]) + storage[14];
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }

  Vector3 transformed3(Vector3 arg, [Vector3 out=null]) {
    if (out == null) {
      out = new Vector3.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return transform3(out);
  }

  Vector4 transform(Vector4 arg) {
    double x_ =  (storage[0] * arg.storage[0]) + (storage[4] * arg.storage[1]) + (storage[8] * arg.storage[2]) + (storage[12] * arg.storage[3]);
    double y_ =  (storage[1] * arg.storage[0]) + (storage[5] * arg.storage[1]) + (storage[9] * arg.storage[2]) + (storage[13] * arg.storage[3]);
    double z_ =  (storage[2] * arg.storage[0]) + (storage[6] * arg.storage[1]) + (storage[10] * arg.storage[2]) + (storage[14] * arg.storage[3]);
    double w_ =  (storage[3] * arg.storage[0]) + (storage[7] * arg.storage[1]) + (storage[11] * arg.storage[2]) + (storage[15] * arg.storage[3]);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    arg.w = w_;
    return arg;
  }

  Vector4 transformed(Vector4 arg, [Vector4 out=null]) {
    if (out == null) {
      out = new Vector4.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return transform(out);
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset=0]) {
    int i = offset;
    array[i+15] = storage[15];
    array[i+14] = storage[14];
    array[i+13] = storage[13];
    array[i+12] = storage[12];
    array[i+11] = storage[11];
    array[i+10] = storage[10];
    array[i+9] = storage[9];
    array[i+8] = storage[8];
    array[i+7] = storage[7];
    array[i+6] = storage[6];
    array[i+5] = storage[5];
    array[i+4] = storage[4];
    array[i+3] = storage[3];
    array[i+2] = storage[2];
    array[i+1] = storage[1];
    array[i+0] = storage[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset=0]) {
    int i = offset;
    storage[15] = array[i+15];
    storage[14] = array[i+14];
    storage[13] = array[i+13];
    storage[12] = array[i+12];
    storage[11] = array[i+11];
    storage[10] = array[i+10];
    storage[9] = array[i+9];
    storage[8] = array[i+8];
    storage[7] = array[i+7];
    storage[6] = array[i+6];
    storage[5] = array[i+5];
    storage[4] = array[i+4];
    storage[3] = array[i+3];
    storage[2] = array[i+2];
    storage[1] = array[i+1];
    storage[0] = array[i+0];
  }

  Vector3 get right {
    double x = storage[0];
    double y = storage[1];
    double z = storage[2];
    return new Vector3(x, y, z);
  }

  Vector3 get up {
    double x = storage[4];
    double y = storage[5];
    double z = storage[6];
    return new Vector3(x, y, z);
  }

  Vector3 get forward {
    double x = storage[8];
    double y = storage[9];
    double z = storage[10];
    return new Vector3(x, y, z);
  }
}
