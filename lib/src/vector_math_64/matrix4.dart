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

part of vector_math_64;

/// 4D Matrix.
/// Values are stored in column major order.
class Matrix4 {
  final Float64List _storage44;

  /// Solve [A] * [x] = [b].
  static void solve2(Matrix4 A, Vector2 x, Vector2 b) {
    final a11 = A.entry(0, 0);
    final a12 = A.entry(0, 1);
    final a21 = A.entry(1, 0);
    final a22 = A.entry(1, 1);
    final bx = b.x - A._storage44[8];
    final by = b.y - A._storage44[9];
    var det = a11 * a22 - a12 * a21;

    if (det != 0.0) {
      det = 1.0 / det;
    }

    x.x = det * (a22 * bx - a12 * by);
    x.y = det * (a11 * by - a21 * bx);
  }

  /// Solve [A] * [x] = [b].
  static void solve3(Matrix4 A, Vector3 x, Vector3 b) {
    final A0x = A.entry(0, 0);
    final A0y = A.entry(1, 0);
    final A0z = A.entry(2, 0);
    final A1x = A.entry(0, 1);
    final A1y = A.entry(1, 1);
    final A1z = A.entry(2, 1);
    final A2x = A.entry(0, 2);
    final A2y = A.entry(1, 2);
    final A2z = A.entry(2, 2);
    final bx = b.x - A._storage44[12];
    final by = b.y - A._storage44[13];
    final bz = b.z - A._storage44[14];
    var rx, ry, rz;
    var det;

    // Column1 cross Column 2
    rx = A1y * A2z - A1z * A2y;
    ry = A1z * A2x - A1x * A2z;
    rz = A1x * A2y - A1y * A2x;

    // A.getColumn(0).dot(x)
    det = A0x * rx + A0y * ry + A0z * rz;
    if (det != 0.0) {
      det = 1.0 / det;
    }

    // b dot [Column1 cross Column 2]
    final x_ = det * (bx * rx + by * ry + bz * rz);

    // Column2 cross b
    rx = -(A2y * bz - A2z * by);
    ry = -(A2z * bx - A2x * bz);
    rz = -(A2x * by - A2y * bx);
    // Column0 dot -[Column2 cross b (Column3)]
    final y_ = det * (A0x * rx + A0y * ry + A0z * rz);

    // b cross Column 1
    rx = -(by * A1z - bz * A1y);
    ry = -(bz * A1x - bx * A1z);
    rz = -(bx * A1y - by * A1x);
    // Column0 dot -[b cross Column 1]
    final z_ = det * (A0x * rx + A0y * ry + A0z * rz);

    x.x = x_;
    x.y = y_;
    x.z = z_;
  }

  /// Solve [A] * [x] = [b].
  static void solve(Matrix4 A, Vector4 x, Vector4 b) {
    final a00 = A._storage44[0];
    final a01 = A._storage44[1];
    final a02 = A._storage44[2];
    final a03 = A._storage44[3];
    final a10 = A._storage44[4];
    final a11 = A._storage44[5];
    final a12 = A._storage44[6];
    final a13 = A._storage44[7];
    final a20 = A._storage44[8];
    final a21 = A._storage44[9];
    final a22 = A._storage44[10];
    final a23 = A._storage44[11];
    final a30 = A._storage44[12];
    final a31 = A._storage44[13];
    final a32 = A._storage44[14];
    final a33 = A._storage44[15];
    final b00 = a00 * a11 - a01 * a10;
    final b01 = a00 * a12 - a02 * a10;
    final b02 = a00 * a13 - a03 * a10;
    final b03 = a01 * a12 - a02 * a11;
    final b04 = a01 * a13 - a03 * a11;
    final b05 = a02 * a13 - a03 * a12;
    final b06 = a20 * a31 - a21 * a30;
    final b07 = a20 * a32 - a22 * a30;
    final b08 = a20 * a33 - a23 * a30;
    final b09 = a21 * a32 - a22 * a31;
    final b10 = a21 * a33 - a23 * a31;
    final b11 = a22 * a33 - a23 * a32;

    final bX = b._storage4[0];
    final bY = b._storage4[1];
    final bZ = b._storage4[2];
    final bW = b._storage4[3];

    var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 *
        b06;

    if (det != 0.0) {
      det = 1.0 / det;
    }

    x.x = det * (
        (a11 * b11 - a12 * b10 + a13 * b09) * bX -
        (a10 * b11 - a12 * b08 + a13 * b07) * bY +
        (a10 * b10 - a11 * b08 + a13 * b06) * bZ -
        (a10 * b09 - a11 * b07 + a12 * b06) * bW);

    x.y = det * -(
        (a01 * b11 - a02 * b10 + a03 * b09) * bX -
        (a00 * b11 - a02 * b08 + a03 * b07) * bY +
        (a00 * b10 - a01 * b08 + a03 * b06) * bZ -
        (a00 * b09 - a01 * b07 + a02 * b06) * bW);

    x.z = det * (
        (a31 * b05 - a32 * b04 + a33 * b03) * bX -
        (a30 * b05 - a32 * b02 + a33 * b01) * bY +
        (a30 * b04 - a31 * b02 + a33 * b00) * bZ -
        (a30 * b03 - a31 * b01 + a32 * b00) * bW);

    x.w = det * -(
        (a21 * b05 - a22 * b04 + a23 * b03) * bX -
        (a20 * b05 - a22 * b02 + a23 * b01) * bY +
        (a20 * b04 - a21 * b02 + a23 * b00) * bZ -
        (a20 * b03 - a21 * b01 + a22 * b00) * bW);
  }

  /// The components of the matrix.
  Float64List get storage => _storage44;

  /// Return index in storage for [row], [col] value.
  int index(int row, int col) => (col * 4) + row;

  /// Value at [row], [col].
  double entry(int row, int col) => _storage44[index(row, col)];

  /// Set value at [row], [col] to be [v].
  setEntry(int row, int col, double v) {
    _storage44[index(row, col)] = v;
  }

  /// Constructs a new mat4.
  factory Matrix4(double arg0, double arg1, double arg2, double arg3, double
      arg4, double arg5, double arg6, double arg7, double arg8, double arg9, double
      arg10, double arg11, double arg12, double arg13, double arg14, double arg15) =>
      new Matrix4.zero()..setValues(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7,
      arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);

  /// Zero matrix.
  Matrix4.zero()
      : _storage44 = new Float64List(16);

  /// Identity matrix.
  factory Matrix4.identity() => new Matrix4.zero()..setIdentity();

  /// Copies values from [other].
  factory Matrix4.copy(Matrix4 other) => new Matrix4.zero()..setFrom(other);

  /// Constructs a new mat4 from columns.
  factory Matrix4.columns(Vector4 arg0, Vector4 arg1, Vector4 arg2, Vector4
      arg3) => new Matrix4.zero()..setColumns(arg0, arg1, arg2, arg3);

  /// Outer product of [u] and [v].
  factory Matrix4.outer(Vector4 u, Vector4 v) =>
      new Matrix4.zero()..setOuter(u, v);

  /// Rotation of [radians_] around X.
  factory Matrix4.rotationX(double radians) => new Matrix4.zero()
      .._storage44[15] = 1.0
      ..setRotationX(radians);

  /// Rotation of [radians_] around Y.
  factory Matrix4.rotationY(double radians) => new Matrix4.zero()
      .._storage44[15] = 1.0
      ..setRotationY(radians);

  /// Rotation of [radians_] around Z.
  factory Matrix4.rotationZ(double radians) => new Matrix4.zero()
      .._storage44[15] = 1.0
      ..setRotationZ(radians);

  /// Translation matrix.
  factory Matrix4.translation(Vector3 translation) => new Matrix4.zero()
      ..setIdentity()
      ..setTranslation3(translation);

  /// Translation matrix.
  factory Matrix4.translationValues(double x, double y, double z) =>
      new Matrix4.zero()
      ..setIdentity()
      ..setTranslation(x, y, z);

  /// Scale matrix.
  factory Matrix4.diagonal3(Vector3 scale) => new Matrix4.zero()
      .._storage44[15] = 1.0
      .._storage44[10] = scale._storage3[2]
      .._storage44[5] = scale._storage3[1]
      .._storage44[0] = scale._storage3[0];

  /// Scale matrix.
  factory Matrix4.diagonal3Values(double x, double y, double z) =>
      new Matrix4.zero()
      .._storage44[15] = 1.0
      .._storage44[10] = z
      .._storage44[5] = y
      .._storage44[0] = x;

  /// Constructs Matrix4 with given Float64List as [storage].
  Matrix4.fromFloat64List(this._storage44);

  /// Constructs Matrix4 with a [storage] that views given [buffer] starting at [offset].
  /// [offset] has to be multiple of [Float64List.BYTES_PER_ELEMENT].
  Matrix4.fromBuffer(ByteBuffer buffer, int offset)
      : _storage44 = new Float64List.view(buffer, offset, 16);

  /// Sets the diagonal to [arg].
  void splatDiagonal(double arg) {
    _storage44[0] = arg;
    _storage44[5] = arg;
    _storage44[10] = arg;
    _storage44[15] = arg;
  }

  /// Sets the matrix with specified values.
  void setValues(double arg0, double arg1, double arg2, double arg3, double
      arg4, double arg5, double arg6, double arg7, double arg8, double arg9, double
      arg10, double arg11, double arg12, double arg13, double arg14, double arg15) {
    _storage44[15] = arg15;
    _storage44[14] = arg14;
    _storage44[13] = arg13;
    _storage44[12] = arg12;
    _storage44[11] = arg11;
    _storage44[10] = arg10;
    _storage44[9] = arg9;
    _storage44[8] = arg8;
    _storage44[7] = arg7;
    _storage44[6] = arg6;
    _storage44[5] = arg5;
    _storage44[4] = arg4;
    _storage44[3] = arg3;
    _storage44[2] = arg2;
    _storage44[1] = arg1;
    _storage44[0] = arg0;
  }

  /// Sets the entire matrix to the column values.
  void setColumns(Vector4 arg0, Vector4 arg1, Vector4 arg2, Vector4 arg3) {
    final arg0Storage = arg0._storage4;
    final arg1Storage = arg1._storage4;
    final arg2Storage = arg2._storage4;
    final arg3Storage = arg3._storage4;
    _storage44[0] = arg0Storage[0];
    _storage44[1] = arg0Storage[1];
    _storage44[2] = arg0Storage[2];
    _storage44[3] = arg0Storage[3];
    _storage44[4] = arg1Storage[0];
    _storage44[5] = arg1Storage[1];
    _storage44[6] = arg1Storage[2];
    _storage44[7] = arg1Storage[3];
    _storage44[8] = arg2Storage[0];
    _storage44[9] = arg2Storage[1];
    _storage44[10] = arg2Storage[2];
    _storage44[11] = arg2Storage[3];
    _storage44[12] = arg3Storage[0];
    _storage44[13] = arg3Storage[1];
    _storage44[14] = arg3Storage[2];
    _storage44[15] = arg3Storage[3];
  }

  /// Sets the entire matrix to the matrix in [arg].
  void setFrom(Matrix4 arg) {
    final argStorage = arg._storage44;
    _storage44[15] = argStorage[15];
    _storage44[14] = argStorage[14];
    _storage44[13] = argStorage[13];
    _storage44[12] = argStorage[12];
    _storage44[11] = argStorage[11];
    _storage44[10] = argStorage[10];
    _storage44[9] = argStorage[9];
    _storage44[8] = argStorage[8];
    _storage44[7] = argStorage[7];
    _storage44[6] = argStorage[6];
    _storage44[5] = argStorage[5];
    _storage44[4] = argStorage[4];
    _storage44[3] = argStorage[3];
    _storage44[2] = argStorage[2];
    _storage44[1] = argStorage[1];
    _storage44[0] = argStorage[0];
  }

  /// Sets the matrix from translation [arg0] and rotation [arg1].
  void setFromTranslationRotation(Vector3 arg0, Quaternion arg1) {
    final arg1Storage = arg1._storage41;
    final x = arg1Storage[0];
    final y = arg1Storage[1];
    final z = arg1Storage[2];
    final w = arg1Storage[3];
    final x2 = x + x;
    final y2 = y + y;
    final z2 = z + z;
    final xx = x * x2;
    final xy = x * y2;
    final xz = x * z2;
    final yy = y * y2;
    final yz = y * z2;
    final zz = z * z2;
    final wx = w * x2;
    final wy = w * y2;
    final wz = w * z2;
    final arg0Storage = arg0._storage3;

    _storage44[0] = 1.0 - (yy + zz);
    _storage44[1] = xy + wz;
    _storage44[2] = xz - wy;
    _storage44[3] = 0.0;
    _storage44[4] = xy - wz;
    _storage44[5] = 1.0 - (xx + zz);
    _storage44[6] = yz + wx;
    _storage44[7] = 0.0;
    _storage44[8] = xz + wy;
    _storage44[9] = yz - wx;
    _storage44[10] = 1.0 - (xx + yy);
    _storage44[11] = 0.0;
    _storage44[12] = arg0Storage[0];
    _storage44[13] = arg0Storage[1];
    _storage44[14] = arg0Storage[2];
    _storage44[15] = 1.0;
  }

  /// Sets the upper 2x2 of the matrix to be [arg].
  void setUpper2x2(Matrix2 arg) {
    final argStorage = arg._storage22;
    _storage44[0] = argStorage[0];
    _storage44[1] = argStorage[1];
    _storage44[4] = argStorage[2];
    _storage44[5] = argStorage[3];
  }

  /// Sets the diagonal of the matrix to be [arg].
  void setDiagonal(Vector4 arg) {
    final argStorage = arg._storage4;
    _storage44[0] = argStorage[0];
    _storage44[5] = argStorage[1];
    _storage44[10] = argStorage[2];
    _storage44[15] = argStorage[3];
  }

  void setOuter(Vector4 u, Vector4 v) {
    final uStorage = u._storage4;
    final vStorage = v._storage4;
    _storage44[0] = uStorage[0] * vStorage[0];
    _storage44[1] = uStorage[0] * vStorage[1];
    _storage44[2] = uStorage[0] * vStorage[2];
    _storage44[3] = uStorage[0] * vStorage[3];
    _storage44[4] = uStorage[1] * vStorage[0];
    _storage44[5] = uStorage[1] * vStorage[1];
    _storage44[6] = uStorage[1] * vStorage[2];
    _storage44[7] = uStorage[1] * vStorage[3];
    _storage44[8] = uStorage[2] * vStorage[0];
    _storage44[9] = uStorage[2] * vStorage[1];
    _storage44[10] = uStorage[2] * vStorage[2];
    _storage44[11] = uStorage[2] * vStorage[3];
    _storage44[12] = uStorage[3] * vStorage[0];
    _storage44[13] = uStorage[3] * vStorage[1];
    _storage44[14] = uStorage[3] * vStorage[2];
    _storage44[15] = uStorage[3] * vStorage[3];
  }

  /// Returns a printable string
  String toString() => '[0] ${getRow(0)}\n[1] ${getRow(1)}\n'
      '[2] ${getRow(2)}\n[3] ${getRow(3)}\n';

  /// Dimension of the matrix.
  int get dimension => 4;

  /// Access the element of the matrix at the index [i].
  double operator [](int i) => _storage44[i];

  /// Sets the element of the matrix at the index [i].
  void operator []=(int i, double v) {
    _storage44[i] = v;
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
    final argStorage = arg._storage4;
    _storage44[index(row, 0)] = argStorage[0];
    _storage44[index(row, 1)] = argStorage[1];
    _storage44[index(row, 2)] = argStorage[2];
    _storage44[index(row, 3)] = argStorage[3];
  }

  /// Gets the [row] of the matrix
  Vector4 getRow(int row) {
    final r = new Vector4.zero();
    final rStorage = r._storage4;
    rStorage[0] = _storage44[index(row, 0)];
    rStorage[1] = _storage44[index(row, 1)];
    rStorage[2] = _storage44[index(row, 2)];
    rStorage[3] = _storage44[index(row, 3)];
    return r;
  }

  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, Vector4 arg) {
    final entry = column * 4;
    final argStorage = arg._storage4;
    _storage44[entry + 3] = argStorage[3];
    _storage44[entry + 2] = argStorage[2];
    _storage44[entry + 1] = argStorage[1];
    _storage44[entry + 0] = argStorage[0];
  }

  /// Gets the [column] of the matrix
  Vector4 getColumn(int column) {
    final r = new Vector4.zero();
    final entry = column * 4;
    final rStorage = r._storage4;
    rStorage[3] = _storage44[entry + 3];
    rStorage[2] = _storage44[entry + 2];
    rStorage[1] = _storage44[entry + 1];
    rStorage[0] = _storage44[entry + 0];
    return r;
  }

  /// Clone matrix.
  Matrix4 clone() => new Matrix4.copy(this);

  /// Copy into [arg].
  Matrix4 copyInto(Matrix4 arg) {
    final argStorage = arg._storage44;
    argStorage[0] = _storage44[0];
    argStorage[1] = _storage44[1];
    argStorage[2] = _storage44[2];
    argStorage[3] = _storage44[3];
    argStorage[4] = _storage44[4];
    argStorage[5] = _storage44[5];
    argStorage[6] = _storage44[6];
    argStorage[7] = _storage44[7];
    argStorage[8] = _storage44[8];
    argStorage[9] = _storage44[9];
    argStorage[10] = _storage44[10];
    argStorage[11] = _storage44[11];
    argStorage[12] = _storage44[12];
    argStorage[13] = _storage44[13];
    argStorage[14] = _storage44[14];
    argStorage[15] = _storage44[15];
    return arg;
  }

  /// Returns new matrix -this
  Matrix4 operator -() => clone()..negate();

  /// Returns a new vector or matrix by multiplying [this] with [arg].
  dynamic operator *(dynamic arg) {
    if (arg is double) {
      return scaled(arg);
    }
    if (arg is Vector4) {
      return transformed(arg);
    }
    if (arg is Vector3) {
      return transformed3(arg);
    }
    if (arg.dimension == 4) {
      return multiplied(arg);
    }
    throw new ArgumentError(arg);
  }

  /// Returns new matrix after component wise [this] + [arg]
  Matrix4 operator +(Matrix4 arg) => clone()..add(arg);

  /// Returns new matrix after component wise [this] - [arg]
  Matrix4 operator -(Matrix4 arg) => clone()..sub(arg);

  /// Translate this matrix by a [x],[y],[z] and a optional [w].
  void translate(double x, double y, double z, [double w = 1.0]) {
    final t1 = _storage44[0] * x + _storage44[4] * y + _storage44[8] * z +
        _storage44[12] * w;
    final t2 = _storage44[1] * x + _storage44[5] * y + _storage44[9] * z +
        _storage44[13] * w;
    final t3 = _storage44[2] * x + _storage44[6] * y + _storage44[10] * z +
        _storage44[14] * w;
    final t4 = _storage44[3] * x + _storage44[7] * y + _storage44[11] * z +
        _storage44[15] * w;
    _storage44[12] = t1;
    _storage44[13] = t2;
    _storage44[14] = t3;
    _storage44[15] = t4;
  }

  /// Translate this matrix by a [Vector3].
  void translate3(Vector3 arg) {
    final argStorage = arg._storage3;
    translate(argStorage[0], argStorage[1], argStorage[2]);
  }

  /// Translate this matrix by a [Vector4].
  void translate4(Vector4 arg) {
    final argStorage = arg._storage4;
    translate(argStorage[0], argStorage[1], argStorage[2], argStorage[3]);
  }

  /// Rotate this [angle] radians around [axis]
  void rotate(Vector3 axis, double angle) {
    final len = axis.length;
    final axisStorage = axis._storage3;
    final x = axisStorage[0] / len;
    final y = axisStorage[1] / len;
    final z = axisStorage[2] / len;
    final c = Math.cos(angle);
    final s = Math.sin(angle);
    final C = 1.0 - c;
    final m11 = x * x * C + c;
    final m12 = x * y * C - z * s;
    final m13 = x * z * C + y * s;
    final m21 = y * x * C + z * s;
    final m22 = y * y * C + c;
    final m23 = y * z * C - x * s;
    final m31 = z * x * C - y * s;
    final m32 = z * y * C + x * s;
    final m33 = z * z * C + c;
    final t1 = _storage44[0] * m11 + _storage44[4] * m21 + _storage44[8] * m31;
    final t2 = _storage44[1] * m11 + _storage44[5] * m21 + _storage44[9] * m31;
    final t3 = _storage44[2] * m11 + _storage44[6] * m21 + _storage44[10] * m31;
    final t4 = _storage44[3] * m11 + _storage44[7] * m21 + _storage44[11] * m31;
    final t5 = _storage44[0] * m12 + _storage44[4] * m22 + _storage44[8] * m32;
    final t6 = _storage44[1] * m12 + _storage44[5] * m22 + _storage44[9] * m32;
    final t7 = _storage44[2] * m12 + _storage44[6] * m22 + _storage44[10] * m32;
    final t8 = _storage44[3] * m12 + _storage44[7] * m22 + _storage44[11] * m32;
    final t9 = _storage44[0] * m13 + _storage44[4] * m23 + _storage44[8] * m33;
    final t10 = _storage44[1] * m13 + _storage44[5] * m23 + _storage44[9] * m33;
    final t11 = _storage44[2] * m13 + _storage44[6] * m23 + _storage44[10] * m33;
    final t12 = _storage44[3] * m13 + _storage44[7] * m23 + _storage44[11] * m33;
    _storage44[0] = t1;
    _storage44[1] = t2;
    _storage44[2] = t3;
    _storage44[3] = t4;
    _storage44[4] = t5;
    _storage44[5] = t6;
    _storage44[6] = t7;
    _storage44[7] = t8;
    _storage44[8] = t9;
    _storage44[9] = t10;
    _storage44[10] = t11;
    _storage44[11] = t12;
  }

  /// Rotate this [angle] radians around X
  void rotateX(double angle) {
    final cosAngle = Math.cos(angle);
    final sinAngle = Math.sin(angle);
    final t1 = _storage44[4] * cosAngle + _storage44[8] * sinAngle;
    final t2 = _storage44[5] * cosAngle + _storage44[9] * sinAngle;
    final t3 = _storage44[6] * cosAngle + _storage44[10] * sinAngle;
    final t4 = _storage44[7] * cosAngle + _storage44[11] * sinAngle;
    final t5 = _storage44[4] * -sinAngle + _storage44[8] * cosAngle;
    final t6 = _storage44[5] * -sinAngle + _storage44[9] * cosAngle;
    final t7 = _storage44[6] * -sinAngle + _storage44[10] * cosAngle;
    final t8 = _storage44[7] * -sinAngle + _storage44[11] * cosAngle;
    _storage44[4] = t1;
    _storage44[5] = t2;
    _storage44[6] = t3;
    _storage44[7] = t4;
    _storage44[8] = t5;
    _storage44[9] = t6;
    _storage44[10] = t7;
    _storage44[11] = t8;
  }

  /// Rotate this matrix [angle] radians around Y
  void rotateY(double angle) {
    final cosAngle = Math.cos(angle);
    final sinAngle = Math.sin(angle);
    final t1 = _storage44[0] * cosAngle + _storage44[8] * sinAngle;
    final t2 = _storage44[1] * cosAngle + _storage44[9] * sinAngle;
    final t3 = _storage44[2] * cosAngle + _storage44[10] * sinAngle;
    final t4 = _storage44[3] * cosAngle + _storage44[11] * sinAngle;
    final t5 = _storage44[0] * -sinAngle + _storage44[8] * cosAngle;
    final t6 = _storage44[1] * -sinAngle + _storage44[9] * cosAngle;
    final t7 = _storage44[2] * -sinAngle + _storage44[10] * cosAngle;
    final t8 = _storage44[3] * -sinAngle + _storage44[11] * cosAngle;
    _storage44[0] = t1;
    _storage44[1] = t2;
    _storage44[2] = t3;
    _storage44[3] = t4;
    _storage44[8] = t5;
    _storage44[9] = t6;
    _storage44[10] = t7;
    _storage44[11] = t8;
  }

  /// Rotate this matrix [angle] radians around Z
  void rotateZ(double angle) {
    final cosAngle = Math.cos(angle);
    final sinAngle = Math.sin(angle);
    final t1 = _storage44[0] * cosAngle + _storage44[4] * sinAngle;
    final t2 = _storage44[1] * cosAngle + _storage44[5] * sinAngle;
    final t3 = _storage44[2] * cosAngle + _storage44[6] * sinAngle;
    final t4 = _storage44[3] * cosAngle + _storage44[7] * sinAngle;
    final t5 = _storage44[0] * -sinAngle + _storage44[4] * cosAngle;
    final t6 = _storage44[1] * -sinAngle + _storage44[5] * cosAngle;
    final t7 = _storage44[2] * -sinAngle + _storage44[6] * cosAngle;
    final t8 = _storage44[3] * -sinAngle + _storage44[7] * cosAngle;
    _storage44[0] = t1;
    _storage44[1] = t2;
    _storage44[2] = t3;
    _storage44[3] = t4;
    _storage44[4] = t5;
    _storage44[5] = t6;
    _storage44[6] = t7;
    _storage44[7] = t8;
  }

  /// Scale this matrix by [x],[y],[z] and a optional [w].
  void scale(dynamic x, [double y = null, double z = null, double w = 1.0]) {
    final sx = x;
    final sy = y == null ? x : y;
    final sz = z == null ? x : z;
    final sw = w;

    _storage44[0] *= sx;
    _storage44[1] *= sx;
    _storage44[2] *= sx;
    _storage44[3] *= sx;
    _storage44[4] *= sy;
    _storage44[5] *= sy;
    _storage44[6] *= sy;
    _storage44[7] *= sy;
    _storage44[8] *= sz;
    _storage44[9] *= sz;
    _storage44[10] *= sz;
    _storage44[11] *= sz;
    _storage44[12] *= sw;
    _storage44[13] *= sw;
    _storage44[14] *= sw;
    _storage44[15] *= sw;
  }

  /// Scale this matrix by a [Vector3].
  void scale3(Vector3 arg) {
    final argStorage = arg._storage3;
    scale(argStorage[0], argStorage[1], argStorage[2]);
  }

  /// Scale this matrix by a [Vector4].
  void scale4(Vector4 arg) {
    final argStorage = arg._storage4;
    scale(argStorage[0], argStorage[1], argStorage[2], argStorage[3]);
  }

  /// Create a copy of [this] scaled by [x],[y],[z] and a optional [w].
  Matrix4 scaled(double x, [double y = null, double z = null, double w = 1.0])
      => clone()..scale(x, y, z, w);

  /// Create a copy of [this] scaled by a [Vector3].
  Matrix4 scaled3(Vector3 arg) => clone()..scale3(arg);

  /// Create a copy of [this] scaled by a [Vector4].
  Matrix4 scaled4(Vector4 arg) => clone()..scale4(arg);

  /// Zeros [this].
  void setZero() {
    _storage44[0] = 0.0;
    _storage44[1] = 0.0;
    _storage44[2] = 0.0;
    _storage44[3] = 0.0;
    _storage44[4] = 0.0;
    _storage44[5] = 0.0;
    _storage44[6] = 0.0;
    _storage44[7] = 0.0;
    _storage44[8] = 0.0;
    _storage44[9] = 0.0;
    _storage44[10] = 0.0;
    _storage44[11] = 0.0;
    _storage44[12] = 0.0;
    _storage44[13] = 0.0;
    _storage44[14] = 0.0;
    _storage44[15] = 0.0;
  }

  /// Makes [this] into the identity matrix.
  void setIdentity() {
    _storage44[0] = 1.0;
    _storage44[1] = 0.0;
    _storage44[2] = 0.0;
    _storage44[3] = 0.0;
    _storage44[4] = 0.0;
    _storage44[5] = 1.0;
    _storage44[6] = 0.0;
    _storage44[7] = 0.0;
    _storage44[8] = 0.0;
    _storage44[9] = 0.0;
    _storage44[10] = 1.0;
    _storage44[11] = 0.0;
    _storage44[12] = 0.0;
    _storage44[13] = 0.0;
    _storage44[14] = 0.0;
    _storage44[15] = 1.0;
  }

  /// Returns the tranpose of this.
  Matrix4 transposed() => clone()..transpose();

  // Transpose [this].
  void transpose() {
    var temp;
    temp = _storage44[4];
    _storage44[4] = _storage44[1];
    _storage44[1] = temp;
    temp = _storage44[8];
    _storage44[8] = _storage44[2];
    _storage44[2] = temp;
    temp = _storage44[12];
    _storage44[12] = _storage44[3];
    _storage44[3] = temp;
    temp = _storage44[9];
    _storage44[9] = _storage44[6];
    _storage44[6] = temp;
    temp = _storage44[13];
    _storage44[13] = _storage44[7];
    _storage44[7] = temp;
    temp = _storage44[14];
    _storage44[14] = _storage44[11];
    _storage44[11] = temp;
  }

  /// Returns the component wise absolute value of this.
  void absolute() {
    _storage44[0] = _storage44[0].abs();
    _storage44[1] = _storage44[1].abs();
    _storage44[2] = _storage44[2].abs();
    _storage44[3] = _storage44[3].abs();
    _storage44[4] = _storage44[4].abs();
    _storage44[5] = _storage44[5].abs();
    _storage44[6] = _storage44[6].abs();
    _storage44[7] = _storage44[7].abs();
    _storage44[8] = _storage44[8].abs();
    _storage44[9] = _storage44[9].abs();
    _storage44[10] = _storage44[10].abs();
    _storage44[11] = _storage44[11].abs();
    _storage44[12] = _storage44[12].abs();
    _storage44[13] = _storage44[13].abs();
    _storage44[14] = _storage44[14].abs();
    _storage44[15] = _storage44[15].abs();
  }

  /// Returns the determinant of this matrix.
  double determinant() {
    final det2_01_01 = _storage44[0] * _storage44[5] - _storage44[1] *
        _storage44[4];
    final det2_01_02 = _storage44[0] * _storage44[6] - _storage44[2] *
        _storage44[4];
    final det2_01_03 = _storage44[0] * _storage44[7] - _storage44[3] *
        _storage44[4];
    final det2_01_12 = _storage44[1] * _storage44[6] - _storage44[2] *
        _storage44[5];
    final det2_01_13 = _storage44[1] * _storage44[7] - _storage44[3] *
        _storage44[5];
    final det2_01_23 = _storage44[2] * _storage44[7] - _storage44[3] *
        _storage44[6];
    final det3_201_012 = _storage44[8] * det2_01_12 - _storage44[9] * det2_01_02
        + _storage44[10] * det2_01_01;
    final det3_201_013 = _storage44[8] * det2_01_13 - _storage44[9] * det2_01_03
        + _storage44[11] * det2_01_01;
    final det3_201_023 = _storage44[8] * det2_01_23 - _storage44[10] *
        det2_01_03 + _storage44[11] * det2_01_02;
    final det3_201_123 = _storage44[9] * det2_01_23 - _storage44[10] *
        det2_01_13 + _storage44[11] * det2_01_12;
    return -det3_201_123 * _storage44[12] + det3_201_023 * _storage44[13] -
        det3_201_013 * _storage44[14] + det3_201_012 * _storage44[15];
  }

  /// Returns the dot product of row [i] and [v].
  double dotRow(int i, Vector4 v) {
    final vStorage = v._storage4;
    return _storage44[i] * vStorage[0] + _storage44[4 + i] * vStorage[1] +
        _storage44[8 + i] * vStorage[2] + _storage44[12 + i] * vStorage[3];
  }

  /// Returns the dot product of column [j] and [v].
  double dotColumn(int j, Vector4 v) {
    final vStorage = v._storage4;
    return _storage44[j * 4] * vStorage[0] + _storage44[j * 4 + 1] * vStorage[1]
        + _storage44[j * 4 + 2] * vStorage[2] + _storage44[j * 4 + 3] * vStorage[3];
  }

  /// Returns the trace of the matrix. The trace of a matrix is the sum of the
  /// diagonal entries.
  double trace() {
    var t = 0.0;
    t += _storage44[0];
    t += _storage44[5];
    t += _storage44[10];
    t += _storage44[15];
    return t;
  }

  /// Returns infinity norm of the matrix. Used for numerical analysis.
  double infinityNorm() {
    var norm = 0.0;
    {
      var row_norm = 0.0;
      row_norm += _storage44[0].abs();
      row_norm += _storage44[1].abs();
      row_norm += _storage44[2].abs();
      row_norm += _storage44[3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      var row_norm = 0.0;
      row_norm += _storage44[4].abs();
      row_norm += _storage44[5].abs();
      row_norm += _storage44[6].abs();
      row_norm += _storage44[7].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      var row_norm = 0.0;
      row_norm += _storage44[8].abs();
      row_norm += _storage44[9].abs();
      row_norm += _storage44[10].abs();
      row_norm += _storage44[11].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      var row_norm = 0.0;
      row_norm += _storage44[12].abs();
      row_norm += _storage44[13].abs();
      row_norm += _storage44[14].abs();
      row_norm += _storage44[15].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }

  /// Returns relative error between [this] and [correct]
  double relativeError(Matrix4 correct) {
    final diff = correct - this;
    final correct_norm = correct.infinityNorm();
    final diff_norm = diff.infinityNorm();
    return diff_norm / correct_norm;
  }

  /// Returns absolute error between [this] and [correct]
  double absoluteError(Matrix4 correct) {
    final this_norm = infinityNorm();
    final correct_norm = correct.infinityNorm();
    final diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }

  /// Returns the translation vector from this homogeneous transformation matrix.
  Vector3 getTranslation() {
    final z = _storage44[14];
    final y = _storage44[13];
    final x = _storage44[12];
    return new Vector3(x, y, z);
  }

  /// Sets the translation vector in this homogeneous transformation matrix.
  void setTranslation3(Vector3 T) {
    final TStorage = T._storage3;
    final z = TStorage[2];
    final y = TStorage[1];
    final x = TStorage[0];
    _storage44[14] = z;
    _storage44[13] = y;
    _storage44[12] = x;
  }

  /// Sets the translation vector in this homogeneous transformation matrix.
  void setTranslation(double x, double y, double z) {
    _storage44[14] = z;
    _storage44[13] = y;
    _storage44[12] = x;
  }

  /// Returns the rotation matrix from this homogeneous transformation matrix.
  Matrix3 getRotation() {
    final r = new Matrix3.zero();
    final rStorage = r._storage33;
    rStorage[0] = _storage44[0];
    rStorage[1] = _storage44[1];
    rStorage[2] = _storage44[2];
    rStorage[3] = _storage44[4];
    rStorage[4] = _storage44[5];
    rStorage[5] = _storage44[6];
    rStorage[6] = _storage44[8];
    rStorage[7] = _storage44[9];
    rStorage[8] = _storage44[10];
    return r;
  }

  /// Sets the rotation matrix in this homogeneous transformation matrix.
  void setRotation(Matrix3 r) {
    final rStorage = r._storage33;
    _storage44[0] = rStorage[0];
    _storage44[1] = rStorage[1];
    _storage44[2] = rStorage[2];
    _storage44[4] = rStorage[3];
    _storage44[5] = rStorage[4];
    _storage44[6] = rStorage[5];
    _storage44[8] = rStorage[6];
    _storage44[9] = rStorage[7];
    _storage44[10] = rStorage[8];
  }

  /// Transposes just the upper 3x3 rotation matrix.
  void transposeRotation() {
    var temp;
    temp = _storage44[1];
    _storage44[1] = _storage44[4];
    _storage44[4] = temp;
    temp = _storage44[2];
    _storage44[2] = _storage44[8];
    _storage44[8] = temp;
    temp = _storage44[4];
    _storage44[4] = _storage44[1];
    _storage44[1] = temp;
    temp = _storage44[6];
    _storage44[6] = _storage44[9];
    _storage44[9] = temp;
    temp = _storage44[8];
    _storage44[8] = _storage44[2];
    _storage44[2] = temp;
    temp = _storage44[9];
    _storage44[9] = _storage44[6];
    _storage44[6] = temp;
  }

  /// Invert [this].
  double invert() => copyInverse(this);

  /// Set [this] matrix to be the inverse of [arg]
  double copyInverse(Matrix4 arg) {
    final argStorage = arg._storage44;
    final a00 = argStorage[0];
    final a01 = argStorage[1];
    final a02 = argStorage[2];
    final a03 = argStorage[3];
    final a10 = argStorage[4];
    final a11 = argStorage[5];
    final a12 = argStorage[6];
    final a13 = argStorage[7];
    final a20 = argStorage[8];
    final a21 = argStorage[9];
    final a22 = argStorage[10];
    final a23 = argStorage[11];
    final a30 = argStorage[12];
    final a31 = argStorage[13];
    final a32 = argStorage[14];
    final a33 = argStorage[15];
    final b00 = a00 * a11 - a01 * a10;
    final b01 = a00 * a12 - a02 * a10;
    final b02 = a00 * a13 - a03 * a10;
    final b03 = a01 * a12 - a02 * a11;
    final b04 = a01 * a13 - a03 * a11;
    final b05 = a02 * a13 - a03 * a12;
    final b06 = a20 * a31 - a21 * a30;
    final b07 = a20 * a32 - a22 * a30;
    final b08 = a20 * a33 - a23 * a30;
    final b09 = a21 * a32 - a22 * a31;
    final b10 = a21 * a33 - a23 * a31;
    final b11 = a22 * a33 - a23 * a32;
    final det = (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05
        * b06);
    if (det == 0.0) {
      setFrom(arg);
      return 0.0;
    }
    final invDet = 1.0 / det;
    _storage44[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;
    _storage44[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;
    _storage44[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;
    _storage44[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;
    _storage44[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;
    _storage44[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;
    _storage44[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;
    _storage44[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;
    _storage44[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;
    _storage44[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;
    _storage44[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;
    _storage44[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;
    _storage44[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;
    _storage44[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;
    _storage44[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;
    _storage44[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;
    return det;
  }

  /// Invert the rotation of [this] and return the determinant.
  double invertRotation() {
    final det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    final invDet = 1.0 / det;
    var ix = invDet * (_storage44[5] * _storage44[10] - _storage44[6] *
        _storage44[9]);
    var iy = invDet * (_storage44[2] * _storage44[9] - _storage44[1] *
        _storage44[10]);
    var iz = invDet * (_storage44[1] * _storage44[6] - _storage44[2] *
        _storage44[5]);
    var jx = invDet * (_storage44[6] * _storage44[8] - _storage44[4] *
        _storage44[10]);
    var jy = invDet * (_storage44[0] * _storage44[10] - _storage44[2] *
        _storage44[8]);
    var jz = invDet * (_storage44[2] * _storage44[4] - _storage44[0] *
        _storage44[6]);
    var kx = invDet * (_storage44[4] * _storage44[9] - _storage44[5] *
        _storage44[8]);
    var ky = invDet * (_storage44[1] * _storage44[8] - _storage44[0] *
        _storage44[9]);
    var kz = invDet * (_storage44[0] * _storage44[5] - _storage44[1] *
        _storage44[4]);
    _storage44[0] = ix;
    _storage44[1] = iy;
    _storage44[2] = iz;
    _storage44[4] = jx;
    _storage44[5] = jy;
    _storage44[6] = jz;
    _storage44[8] = kx;
    _storage44[9] = ky;
    _storage44[10] = kz;
    return det;
  }

  /// Sets the upper 3x3 to a rotation of [radians] around X
  void setRotationX(double radians) {
    final c = Math.cos(radians);
    final s = Math.sin(radians);
    _storage44[0] = 1.0;
    _storage44[1] = 0.0;
    _storage44[2] = 0.0;
    _storage44[4] = 0.0;
    _storage44[5] = c;
    _storage44[6] = s;
    _storage44[8] = 0.0;
    _storage44[9] = -s;
    _storage44[10] = c;
    _storage44[3] = 0.0;
    _storage44[7] = 0.0;
    _storage44[11] = 0.0;
  }

  /// Sets the upper 3x3 to a rotation of [radians] around Y
  void setRotationY(double radians) {
    final c = Math.cos(radians);
    final s = Math.sin(radians);
    _storage44[0] = c;
    _storage44[1] = 0.0;
    _storage44[2] = s;
    _storage44[4] = 0.0;
    _storage44[5] = 1.0;
    _storage44[6] = 0.0;
    _storage44[8] = -s;
    _storage44[9] = 0.0;
    _storage44[10] = c;
    _storage44[3] = 0.0;
    _storage44[7] = 0.0;
    _storage44[11] = 0.0;
  }

  /// Sets the upper 3x3 to a rotation of [radians] around Z
  void setRotationZ(double radians) {
    final c = Math.cos(radians);
    final s = Math.sin(radians);
    _storage44[0] = c;
    _storage44[1] = s;
    _storage44[2] = 0.0;
    _storage44[4] = -s;
    _storage44[5] = c;
    _storage44[6] = 0.0;
    _storage44[8] = 0.0;
    _storage44[9] = 0.0;
    _storage44[10] = 1.0;
    _storage44[3] = 0.0;
    _storage44[7] = 0.0;
    _storage44[11] = 0.0;
  }

  /// Converts into Adjugate matrix and scales by [scale]
  void scaleAdjoint(double scale) {
    // Adapted from code by Richard Carling.
    final a1 = _storage44[0];
    final b1 = _storage44[4];
    final c1 = _storage44[8];
    final d1 = _storage44[12];
    final a2 = _storage44[1];
    final b2 = _storage44[5];
    final c2 = _storage44[9];
    final d2 = _storage44[13];
    final a3 = _storage44[2];
    final b3 = _storage44[6];
    final c3 = _storage44[10];
    final d3 = _storage44[14];
    final a4 = _storage44[3];
    final b4 = _storage44[7];
    final c4 = _storage44[11];
    final d4 = _storage44[15];
    _storage44[0] = (b2 * (c3 * d4 - c4 * d3) - c2 * (b3 * d4 - b4 * d3) + d2 *
        (b3 * c4 - b4 * c3)) * scale;
    _storage44[1] = -(a2 * (c3 * d4 - c4 * d3) - c2 * (a3 * d4 - a4 * d3) + d2 *
        (a3 * c4 - a4 * c3)) * scale;
    _storage44[2] = (a2 * (b3 * d4 - b4 * d3) - b2 * (a3 * d4 - a4 * d3) + d2 *
        (a3 * b4 - a4 * b3)) * scale;
    _storage44[3] = -(a2 * (b3 * c4 - b4 * c3) - b2 * (a3 * c4 - a4 * c3) + c2 *
        (a3 * b4 - a4 * b3)) * scale;
    _storage44[4] = -(b1 * (c3 * d4 - c4 * d3) - c1 * (b3 * d4 - b4 * d3) + d1 *
        (b3 * c4 - b4 * c3)) * scale;
    _storage44[5] = (a1 * (c3 * d4 - c4 * d3) - c1 * (a3 * d4 - a4 * d3) + d1 *
        (a3 * c4 - a4 * c3)) * scale;
    _storage44[6] = -(a1 * (b3 * d4 - b4 * d3) - b1 * (a3 * d4 - a4 * d3) + d1 *
        (a3 * b4 - a4 * b3)) * scale;
    _storage44[7] = (a1 * (b3 * c4 - b4 * c3) - b1 * (a3 * c4 - a4 * c3) + c1 *
        (a3 * b4 - a4 * b3)) * scale;
    _storage44[8] = (b1 * (c2 * d4 - c4 * d2) - c1 * (b2 * d4 - b4 * d2) + d1 *
        (b2 * c4 - b4 * c2)) * scale;
    _storage44[9] = -(a1 * (c2 * d4 - c4 * d2) - c1 * (a2 * d4 - a4 * d2) + d1 *
        (a2 * c4 - a4 * c2)) * scale;
    _storage44[10] = (a1 * (b2 * d4 - b4 * d2) - b1 * (a2 * d4 - a4 * d2) + d1 *
        (a2 * b4 - a4 * b2)) * scale;
    _storage44[11] = -(a1 * (b2 * c4 - b4 * c2) - b1 * (a2 * c4 - a4 * c2) + c1
        * (a2 * b4 - a4 * b2)) * scale;
    _storage44[12] = -(b1 * (c2 * d3 - c3 * d2) - c1 * (b2 * d3 - b3 * d2) + d1
        * (b2 * c3 - b3 * c2)) * scale;
    _storage44[13] = (a1 * (c2 * d3 - c3 * d2) - c1 * (a2 * d3 - a3 * d2) + d1 *
        (a2 * c3 - a3 * c2)) * scale;
    _storage44[14] = -(a1 * (b2 * d3 - b3 * d2) - b1 * (a2 * d3 - a3 * d2) + d1
        * (a2 * b3 - a3 * b2)) * scale;
    _storage44[15] = (a1 * (b2 * c3 - b3 * c2) - b1 * (a2 * c3 - a3 * c2) + c1 *
        (a2 * b3 - a3 * b2)) * scale;
  }

  /// Rotates [arg] by the absolute rotation of [this]
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  Vector3 absoluteRotate(Vector3 arg) {
    final m00 = _storage44[0].abs();
    final m01 = _storage44[4].abs();
    final m02 = _storage44[8].abs();
    final m10 = _storage44[1].abs();
    final m11 = _storage44[5].abs();
    final m12 = _storage44[9].abs();
    final m20 = _storage44[2].abs();
    final m21 = _storage44[6].abs();
    final m22 = _storage44[10].abs();
    final argStorage = arg._storage3;
    final x = argStorage[0];
    final y = argStorage[1];
    final z = argStorage[2];
    argStorage[0] = x * m00 + y * m01 + z * m02 + 0.0 * 0.0;
    argStorage[1] = x * m10 + y * m11 + z * m12 + 0.0 * 0.0;
    argStorage[2] = x * m20 + y * m21 + z * m22 + 0.0 * 0.0;
    return arg;
  }

  /// Adds [o] to [this].
  void add(Matrix4 o) {
    final oStorage = o._storage44;
    _storage44[0] = _storage44[0] + oStorage[0];
    _storage44[1] = _storage44[1] + oStorage[1];
    _storage44[2] = _storage44[2] + oStorage[2];
    _storage44[3] = _storage44[3] + oStorage[3];
    _storage44[4] = _storage44[4] + oStorage[4];
    _storage44[5] = _storage44[5] + oStorage[5];
    _storage44[6] = _storage44[6] + oStorage[6];
    _storage44[7] = _storage44[7] + oStorage[7];
    _storage44[8] = _storage44[8] + oStorage[8];
    _storage44[9] = _storage44[9] + oStorage[9];
    _storage44[10] = _storage44[10] + oStorage[10];
    _storage44[11] = _storage44[11] + oStorage[11];
    _storage44[12] = _storage44[12] + oStorage[12];
    _storage44[13] = _storage44[13] + oStorage[13];
    _storage44[14] = _storage44[14] + oStorage[14];
    _storage44[15] = _storage44[15] + oStorage[15];
  }

  /// Subtracts [o] to [this].
  void sub(Matrix4 o) {
    final oStorage = o._storage44;
    _storage44[0] = _storage44[0] - oStorage[0];
    _storage44[1] = _storage44[1] - oStorage[1];
    _storage44[2] = _storage44[2] - oStorage[2];
    _storage44[3] = _storage44[3] - oStorage[3];
    _storage44[4] = _storage44[4] - oStorage[4];
    _storage44[5] = _storage44[5] - oStorage[5];
    _storage44[6] = _storage44[6] - oStorage[6];
    _storage44[7] = _storage44[7] - oStorage[7];
    _storage44[8] = _storage44[8] - oStorage[8];
    _storage44[9] = _storage44[9] - oStorage[9];
    _storage44[10] = _storage44[10] - oStorage[10];
    _storage44[11] = _storage44[11] - oStorage[11];
    _storage44[12] = _storage44[12] - oStorage[12];
    _storage44[13] = _storage44[13] - oStorage[13];
    _storage44[14] = _storage44[14] - oStorage[14];
    _storage44[15] = _storage44[15] - oStorage[15];
  }

  /// Negate [this].
  void negate() {
    _storage44[0] = -_storage44[0];
    _storage44[1] = -_storage44[1];
    _storage44[2] = -_storage44[2];
    _storage44[3] = -_storage44[3];
    _storage44[4] = -_storage44[4];
    _storage44[5] = -_storage44[5];
    _storage44[6] = -_storage44[6];
    _storage44[7] = -_storage44[7];
    _storage44[8] = -_storage44[8];
    _storage44[9] = -_storage44[9];
    _storage44[10] = -_storage44[10];
    _storage44[11] = -_storage44[11];
    _storage44[12] = -_storage44[12];
    _storage44[13] = -_storage44[13];
    _storage44[14] = -_storage44[14];
    _storage44[15] = -_storage44[15];
  }

  /// Multiply [this] by [arg].
  void multiply(Matrix4 arg) {
    final m00 = _storage44[0];
    final m01 = _storage44[4];
    final m02 = _storage44[8];
    final m03 = _storage44[12];
    final m10 = _storage44[1];
    final m11 = _storage44[5];
    final m12 = _storage44[9];
    final m13 = _storage44[13];
    final m20 = _storage44[2];
    final m21 = _storage44[6];
    final m22 = _storage44[10];
    final m23 = _storage44[14];
    final m30 = _storage44[3];
    final m31 = _storage44[7];
    final m32 = _storage44[11];
    final m33 = _storage44[15];
    final argStorage = arg._storage44;
    final n00 = argStorage[0];
    final n01 = argStorage[4];
    final n02 = argStorage[8];
    final n03 = argStorage[12];
    final n10 = argStorage[1];
    final n11 = argStorage[5];
    final n12 = argStorage[9];
    final n13 = argStorage[13];
    final n20 = argStorage[2];
    final n21 = argStorage[6];
    final n22 = argStorage[10];
    final n23 = argStorage[14];
    final n30 = argStorage[3];
    final n31 = argStorage[7];
    final n32 = argStorage[11];
    final n33 = argStorage[15];
    _storage44[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    _storage44[4] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    _storage44[8] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    _storage44[12] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    _storage44[1] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    _storage44[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    _storage44[9] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    _storage44[13] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    _storage44[2] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    _storage44[6] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    _storage44[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    _storage44[14] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    _storage44[3] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    _storage44[7] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    _storage44[11] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    _storage44[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
  }

  /// Multiply a copy of [this] with [arg].
  Matrix4 multiplied(Matrix4 arg) => clone()..multiply(arg);

  /// Multiply a transposed [this] with [arg].
  void transposeMultiply(Matrix4 arg) {
    final m00 = _storage44[0];
    final m01 = _storage44[1];
    final m02 = _storage44[2];
    final m03 = _storage44[3];
    final m10 = _storage44[4];
    final m11 = _storage44[5];
    final m12 = _storage44[6];
    final m13 = _storage44[7];
    final m20 = _storage44[8];
    final m21 = _storage44[9];
    final m22 = _storage44[10];
    final m23 = _storage44[11];
    final m30 = _storage44[12];
    final m31 = _storage44[13];
    final m32 = _storage44[14];
    final m33 = _storage44[15];
    final argStorage = arg._storage44;
    _storage44[0] = (m00 * argStorage[0]) + (m01 * argStorage[1]) + (m02 *
        argStorage[2]) + (m03 * argStorage[3]);
    _storage44[4] = (m00 * argStorage[4]) + (m01 * argStorage[5]) + (m02 *
        argStorage[6]) + (m03 * argStorage[7]);
    _storage44[8] = (m00 * argStorage[8]) + (m01 * argStorage[9]) + (m02 *
        argStorage[10]) + (m03 * argStorage[11]);
    _storage44[12] = (m00 * argStorage[12]) + (m01 * argStorage[13]) + (m02 *
        argStorage[14]) + (m03 * argStorage[15]);
    _storage44[1] = (m10 * argStorage[0]) + (m11 * argStorage[1]) + (m12 *
        argStorage[2]) + (m13 * argStorage[3]);
    _storage44[5] = (m10 * argStorage[4]) + (m11 * argStorage[5]) + (m12 *
        argStorage[6]) + (m13 * argStorage[7]);
    _storage44[9] = (m10 * argStorage[8]) + (m11 * argStorage[9]) + (m12 *
        argStorage[10]) + (m13 * argStorage[11]);
    _storage44[13] = (m10 * argStorage[12]) + (m11 * argStorage[13]) + (m12 *
        argStorage[14]) + (m13 * argStorage[15]);
    _storage44[2] = (m20 * argStorage[0]) + (m21 * argStorage[1]) + (m22 *
        argStorage[2]) + (m23 * argStorage[3]);
    _storage44[6] = (m20 * argStorage[4]) + (m21 * argStorage[5]) + (m22 *
        argStorage[6]) + (m23 * argStorage[7]);
    _storage44[10] = (m20 * argStorage[8]) + (m21 * argStorage[9]) + (m22 *
        argStorage[10]) + (m23 * argStorage[11]);
    _storage44[14] = (m20 * argStorage[12]) + (m21 * argStorage[13]) + (m22 *
        argStorage[14]) + (m23 * argStorage[15]);
    _storage44[3] = (m30 * argStorage[0]) + (m31 * argStorage[1]) + (m32 *
        argStorage[2]) + (m33 * argStorage[3]);
    _storage44[7] = (m30 * argStorage[4]) + (m31 * argStorage[5]) + (m32 *
        argStorage[6]) + (m33 * argStorage[7]);
    _storage44[11] = (m30 * argStorage[8]) + (m31 * argStorage[9]) + (m32 *
        argStorage[10]) + (m33 * argStorage[11]);
    _storage44[15] = (m30 * argStorage[12]) + (m31 * argStorage[13]) + (m32 *
        argStorage[14]) + (m33 * argStorage[15]);
  }

  /// Multiply [this] with a transposed [arg].
  void multiplyTranspose(Matrix4 arg) {
    final m00 = _storage44[0];
    final m01 = _storage44[4];
    final m02 = _storage44[8];
    final m03 = _storage44[12];
    final m10 = _storage44[1];
    final m11 = _storage44[5];
    final m12 = _storage44[9];
    final m13 = _storage44[13];
    final m20 = _storage44[2];
    final m21 = _storage44[6];
    final m22 = _storage44[10];
    final m23 = _storage44[14];
    final m30 = _storage44[3];
    final m31 = _storage44[7];
    final m32 = _storage44[11];
    final m33 = _storage44[15];
    final argStorage = arg._storage44;
    _storage44[0] = (m00 * argStorage[0]) + (m01 * argStorage[4]) + (m02 *
        argStorage[8]) + (m03 * argStorage[12]);
    _storage44[4] = (m00 * argStorage[1]) + (m01 * argStorage[5]) + (m02 *
        argStorage[9]) + (m03 * argStorage[13]);
    _storage44[8] = (m00 * argStorage[2]) + (m01 * argStorage[6]) + (m02 *
        argStorage[10]) + (m03 * argStorage[14]);
    _storage44[12] = (m00 * argStorage[3]) + (m01 * argStorage[7]) + (m02 *
        argStorage[11]) + (m03 * argStorage[15]);
    _storage44[1] = (m10 * argStorage[0]) + (m11 * argStorage[4]) + (m12 *
        argStorage[8]) + (m13 * argStorage[12]);
    _storage44[5] = (m10 * argStorage[1]) + (m11 * argStorage[5]) + (m12 *
        argStorage[9]) + (m13 * argStorage[13]);
    _storage44[9] = (m10 * argStorage[2]) + (m11 * argStorage[6]) + (m12 *
        argStorage[10]) + (m13 * argStorage[14]);
    _storage44[13] = (m10 * argStorage[3]) + (m11 * argStorage[7]) + (m12 *
        argStorage[11]) + (m13 * argStorage[15]);
    _storage44[2] = (m20 * argStorage[0]) + (m21 * argStorage[4]) + (m22 *
        argStorage[8]) + (m23 * argStorage[12]);
    _storage44[6] = (m20 * argStorage[1]) + (m21 * argStorage[5]) + (m22 *
        argStorage[9]) + (m23 * argStorage[13]);
    _storage44[10] = (m20 * argStorage[2]) + (m21 * argStorage[6]) + (m22 *
        argStorage[10]) + (m23 * argStorage[14]);
    _storage44[14] = (m20 * argStorage[3]) + (m21 * argStorage[7]) + (m22 *
        argStorage[11]) + (m23 * argStorage[15]);
    _storage44[3] = (m30 * argStorage[0]) + (m31 * argStorage[4]) + (m32 *
        argStorage[8]) + (m33 * argStorage[12]);
    _storage44[7] = (m30 * argStorage[1]) + (m31 * argStorage[5]) + (m32 *
        argStorage[9]) + (m33 * argStorage[13]);
    _storage44[11] = (m30 * argStorage[2]) + (m31 * argStorage[6]) + (m32 *
        argStorage[10]) + (m33 * argStorage[14]);
    _storage44[15] = (m30 * argStorage[3]) + (m31 * argStorage[7]) + (m32 *
        argStorage[11]) + (m33 * argStorage[15]);
  }

  /// Rotate [arg] of type [Vector3] using the rotation defined by [this].
  Vector3 rotate3(Vector3 arg) {
    final argStorage = arg._storage3;
    final x_ = (_storage44[0] * argStorage[0]) + (_storage44[4] * argStorage[1])
        + (_storage44[8] * argStorage[2]);
    final y_ = (_storage44[1] * argStorage[0]) + (_storage44[5] * argStorage[1])
        + (_storage44[9] * argStorage[2]);
    final z_ = (_storage44[2] * argStorage[0]) + (_storage44[6] * argStorage[1])
        + (_storage44[10] * argStorage[2]);
    argStorage[0] = x_;
    argStorage[1] = y_;
    argStorage[2] = z_;
    return arg;
  }

  /// Rotate a copy of [arg] of type [Vector3] using the rotation defined by
  /// [this]. If a [out] parameter is supplied, the copy is stored in [out].
  Vector3 rotated3(Vector3 arg, [Vector3 out = null]) {
    if (out == null) {
      out = new Vector3.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return rotate3(out);
  }

  /// Transform [arg] of type [Vector3] using the transformation defined by
  /// [this].
  Vector3 transform3(Vector3 arg) {
    final argStorage = arg._storage3;
    final x_ = (_storage44[0] * argStorage[0]) + (_storage44[4] * argStorage[1])
        + (_storage44[8] * argStorage[2]) + _storage44[12];
    final y_ = (_storage44[1] * argStorage[0]) + (_storage44[5] * argStorage[1])
        + (_storage44[9] * argStorage[2]) + _storage44[13];
    final z_ = (_storage44[2] * argStorage[0]) + (_storage44[6] * argStorage[1])
        + (_storage44[10] * argStorage[2]) + _storage44[14];
    argStorage[0] = x_;
    argStorage[1] = y_;
    argStorage[2] = z_;
    return arg;
  }

  /// Transform [arg] of type [Vector3] using the perspective transformation
  /// defined by [this].
  Vector3 perspectiveTransform(Vector3 arg) {
    final argStorage = arg._storage3;
    final x_ = (_storage44[0] * argStorage[0]) + (_storage44[4] *
        argStorage[1]) + (_storage44[8] * argStorage[2]) + _storage44[12];
    final y_ = (_storage44[1] * argStorage[0]) + (_storage44[5] *
        argStorage[1]) + (_storage44[9] * argStorage[2]) + _storage44[13];
    final z_ = (_storage44[2] * argStorage[0]) + (_storage44[6] *
        argStorage[1]) + (_storage44[10] * argStorage[2]) + _storage44[14];
    final w_ = (_storage44[3] * argStorage[0]) + (_storage44[7] *
        argStorage[1]) + (_storage44[11] * argStorage[2]) + _storage44[15];
    argStorage[0] = x_ / w_;
    argStorage[1] = y_ / w_;
    argStorage[2] = z_ / w_;
    return arg;
  }

  /// Transform a copy of [arg] of type [Vector3] using the transformation
  /// defined by [this]. If a [out] parameter is supplied, the copy is stored in
  /// [out].
  Vector3 transformed3(Vector3 arg, [Vector3 out = null]) {
    if (out == null) {
      out = new Vector3.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return transform3(out);
  }

  /// Transform [arg] of type [Vector4] using the transformation defined by
  /// [this].
  Vector4 transform(Vector4 arg) {
    final argStorage = arg._storage4;
    final x_ = (_storage44[0] * argStorage[0]) + (_storage44[4] *
        argStorage[1]) + (_storage44[8] * argStorage[2]) + (_storage44[12] *
        argStorage[3]);
    final y_ = (_storage44[1] * argStorage[0]) + (_storage44[5] *
        argStorage[1]) + (_storage44[9] * argStorage[2]) + (_storage44[13] *
        argStorage[3]);
    final z_ = (_storage44[2] * argStorage[0]) + (_storage44[6] *
        argStorage[1]) + (_storage44[10] * argStorage[2]) + (_storage44[14] *
        argStorage[3]);
    final w_ = (_storage44[3] * argStorage[0]) + (_storage44[7] *
        argStorage[1]) + (_storage44[11] * argStorage[2]) + (_storage44[15] *
        argStorage[3]);
    argStorage[0] = x_;
    argStorage[1] = y_;
    argStorage[2] = z_;
    argStorage[3] = w_;
    return arg;
  }

  /// Transform a copy of [arg] of type [Vector4] using the transformation
  /// defined by [this]. If a [out] parameter is supplied, the copy is stored in
  /// [out].
  Vector4 transformed(Vector4 arg, [Vector4 out = null]) {
    if (out == null) {
      out = new Vector4.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return transform(out);
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset = 0]) {
    final i = offset;
    array[i + 15] = _storage44[15];
    array[i + 14] = _storage44[14];
    array[i + 13] = _storage44[13];
    array[i + 12] = _storage44[12];
    array[i + 11] = _storage44[11];
    array[i + 10] = _storage44[10];
    array[i + 9] = _storage44[9];
    array[i + 8] = _storage44[8];
    array[i + 7] = _storage44[7];
    array[i + 6] = _storage44[6];
    array[i + 5] = _storage44[5];
    array[i + 4] = _storage44[4];
    array[i + 3] = _storage44[3];
    array[i + 2] = _storage44[2];
    array[i + 1] = _storage44[1];
    array[i + 0] = _storage44[0];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    final i = offset;
    _storage44[15] = array[i + 15];
    _storage44[14] = array[i + 14];
    _storage44[13] = array[i + 13];
    _storage44[12] = array[i + 12];
    _storage44[11] = array[i + 11];
    _storage44[10] = array[i + 10];
    _storage44[9] = array[i + 9];
    _storage44[8] = array[i + 8];
    _storage44[7] = array[i + 7];
    _storage44[6] = array[i + 6];
    _storage44[5] = array[i + 5];
    _storage44[4] = array[i + 4];
    _storage44[3] = array[i + 3];
    _storage44[2] = array[i + 2];
    _storage44[1] = array[i + 1];
    _storage44[0] = array[i + 0];
  }

  /// Access the right vector of [this].
  Vector3 get right {
    final x = _storage44[0];
    final y = _storage44[1];
    final z = _storage44[2];
    return new Vector3(x, y, z);
  }

  /// Access the up vector of [this].
  Vector3 get up {
    final x = _storage44[4];
    final y = _storage44[5];
    final z = _storage44[6];
    return new Vector3(x, y, z);
  }

  /// Access the forward vector of [this].
  Vector3 get forward {
    final x = _storage44[8];
    final y = _storage44[9];
    final z = _storage44[10];
    return new Vector3(x, y, z);
  }
}
