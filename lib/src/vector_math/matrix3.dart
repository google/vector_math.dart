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

/// 3D Matrix.
/// Values are stored in column major order.
class Matrix3 {
  final Float32List storage = new Float32List(9);

  /// Solve [A] * [x] = [b].
  static void solve2(Matrix3 A, Vector2 x, Vector2 b) {
    final double a11 = A.entry(0, 0);
    final double a12 = A.entry(0, 1);
    final double a21 = A.entry(1, 0);
    final double a22 = A.entry(1, 1);
    final double bx = b.x - A.storage[6];
    final double by = b.y - A.storage[7];
    double det = a11 * a22 - a12 * a21;

    if (det != 0.0) {
      det = 1.0 / det;
    }

    x.x = det * (a22 * bx - a12 * by);
    x.y = det * (a11 * by - a21 * bx);
  }

  /// Solve [A] * [x] = [b].
  static void solve(Matrix3 A, Vector3 x, Vector3 b) {
    final double A0x = A.entry(0, 0);
    final double A0y = A.entry(1, 0);
    final double A0z = A.entry(2, 0);
    final double A1x = A.entry(0, 1);
    final double A1y = A.entry(1, 1);
    final double A1z = A.entry(2, 1);
    final double A2x = A.entry(0, 2);
    final double A2y = A.entry(1, 2);
    final double A2z = A.entry(2, 2);
    double rx, ry, rz;
    double det;

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
    final double x_ = det * (b.x * rx + b.y * ry + b.z * rz);

    // Column2 cross b
    rx = -(A2y * b.z - A2z * b.y);
    ry = -(A2z * b.x - A2x * b.z);
    rz = -(A2x * b.y - A2y * b.x);
    // Column0 dot -[Column2 cross b (Column3)]
    final double y_ = det * (A0x * rx + A0y * ry + A0z * rz);

    // b cross Column 1
    rx = -(b.y * A1z - b.z * A1y);
    ry = -(b.z * A1x - b.x * A1z);
    rz = -(b.x * A1y - b.y * A1x);
    // Column0 dot -[b cross Column 1]
    final double z_ = det * (A0x * rx + A0y * ry + A0z * rz);

    x.x = x_;
    x.y = y_;
    x.z = z_;
  }

  /// Return index in storage for [row], [col] value.
  int index(int row, int col) => (col * 3) + row;

  /// Value at [row], [col].
  double entry(int row, int col) => storage[index(row, col)];

  /// Set value at [row], [col] to be [v].
  setEntry(int row, int col, double v) { storage[index(row, col)] = v; }

  /// New matrix with specified values.
  Matrix3(double arg0, double arg1, double arg2,
          double arg3, double arg4, double arg5,
          double arg6, double arg7, double arg8) {
    setValues(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
  }

  /// Constructs a new [Matrix3] filled with zeros.
  Matrix3.zero();

  /// Identity matrix.
  Matrix3.identity() {
    setIdentity();
  }

  /// Copes values from [other].
  Matrix3.copy(Matrix3 other) {
    setFrom(other);
  }

  /// Constructs a new mat3 from columns.
  Matrix3.columns(Vector3 arg0, Vector3 arg1, Vector3 arg2) {
    setColumns(arg0, arg1, arg2);
  }

  /// Outer product of [u] and [v].
  Matrix3.outer(Vector3 u, Vector3 v) {
    storage[0] = u.storage[0] * v.storage[0];
    storage[1] = u.storage[0] * v.storage[1];
    storage[2] = u.storage[0] * v.storage[2];
    storage[3] = u.storage[1] * v.storage[0];
    storage[4] = u.storage[1] * v.storage[1];
    storage[5] = u.storage[1] * v.storage[2];
    storage[6] = u.storage[2] * v.storage[0];
    storage[7] = u.storage[2] * v.storage[1];
    storage[8] = u.storage[2] * v.storage[2];
  }

  //// Rotation of [radians_] around X axis.
  Matrix3.rotationX(double radians_) {
    setRotationX(radians_);
  }

  //// Rotation of [radians_] around Y axis.
  Matrix3.rotationY(double radians_) {
    setRotationY(radians_);
  }

  //// Rotation of [radians_] around Z axis.
  Matrix3.rotationZ(double radians_) {
    setRotationZ(radians_);
  }

  /// Sets the matrix with specified values.
  Matrix3 setValues(double arg0, double arg1, double arg2,
                    double arg3, double arg4, double arg5,
                    double arg6, double arg7, double arg8) {
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
  Matrix3 setColumns(Vector3 arg0, Vector3 arg1, Vector3 arg2) {
    storage[0] = arg0.storage[0];
    storage[1] = arg0.storage[1];
    storage[2] = arg0.storage[2];
    storage[3] = arg1.storage[0];
    storage[4] = arg1.storage[1];
    storage[5] = arg1.storage[2];
    storage[6] = arg2.storage[0];
    storage[7] = arg2.storage[1];
    storage[8] = arg2.storage[2];
    return this;
  }

  /// Sets the entire matrix to the matrix in [arg].
  Matrix3 setFrom(Matrix3 arg) {
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

  /// Set the diagonal of the matrix.
  Matrix3 splatDiagonal(double arg) {
    storage[0] = arg;
    storage[4] = arg;
    storage[8] = arg;
    return this;
  }

  /// Set the diagonal of the matrix.
  Matrix3 setDiagonal(Vector3 arg) {
    storage[0] = arg.storage[0];
    storage[4] = arg.storage[1];
    storage[8] = arg.storage[2];
    return this;
  }

  /// Sets the upper 2x2 of the matrix to be [arg].
  Matrix3 setUpper2x2(Matrix2 arg) {
    storage[0] = storage[0];
    storage[1] = storage[1];
    storage[3] = storage[2];
    storage[4] = storage[3];
    return this;
  }

  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    s = '$s[2] ${getRow(2)}\n';
    return s;
  }
  /// Dimension of the matrix.
  int get dimension => 3;

  double operator [](int i) => storage[i];

  void operator[]=(int i, double v) { storage[i] = v; }

  /// Returns row 0
  Vector3 get row0 => getRow(0);

  /// Returns row 1
  Vector3 get row1 => getRow(1);

  /// Returns row 2
  Vector3 get row2 => getRow(2);

  /// Sets row 0 to [arg]
  set row0(Vector3 arg) => setRow(0, arg);

  /// Sets row 1 to [arg]
  set row1(Vector3 arg) => setRow(1, arg);

  /// Sets row 2 to [arg]
  set row2(Vector3 arg) => setRow(2, arg);

  /// Assigns the [row] of to [arg].
  void setRow(int row, Vector3 arg) {
    storage[index(row, 0)] = arg.storage[0];
    storage[index(row, 1)] = arg.storage[1];
    storage[index(row, 2)] = arg.storage[2];
  }

  /// Gets the [row] of the matrix
  Vector3 getRow(int row) {
    Vector3 r = new Vector3.zero();
    r.storage[0] = storage[index(row, 0)];
    r.storage[1] = storage[index(row, 1)];
    r.storage[2] = storage[index(row, 2)];
    return r;
  }

  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, Vector3 arg) {
    int entry = column * 3;
    storage[entry + 2] = arg.storage[2];
    storage[entry + 1] = arg.storage[1];
    storage[entry + 0] = arg.storage[0];
  }

  /// Gets the [column] of the matrix
  Vector3 getColumn(int column) {
    Vector3 r = new Vector3.zero();
    int entry = column * 3;
    r.storage[2] = storage[entry + 2];
    r.storage[1] = storage[entry + 1];
    r.storage[0] = storage[entry + 0];
    return r;
  }

  /// Clone of [this].
  Matrix3 clone() {
    return new Matrix3.copy(this);
  }

  /// Copy [this] into [arg].
  Matrix3 copyInto(Matrix3 arg) {
    arg.storage[0] = storage[0];
    arg.storage[1] = storage[1];
    arg.storage[2] = storage[2];
    arg.storage[3] = storage[3];
    arg.storage[4] = storage[4];
    arg.storage[5] = storage[5];
    arg.storage[6] = storage[6];
    arg.storage[7] = storage[7];
    arg.storage[8] = storage[8];
    return arg;
  }

  // TODO: Clean up functions below here.

  Matrix3 _mul_scale(double arg) {
    Matrix3 r = new Matrix3.zero();
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

  Matrix3 _mul_matrix(Matrix3 arg) {
    var r = new Matrix3.zero();
    r.storage[0] = (storage[0] * arg.storage[0]) +
                   (storage[3] * arg.storage[1]) +
                   (storage[6] * arg.storage[2]);
    r.storage[3] = (storage[0] * arg.storage[3]) +
                   (storage[3] * arg.storage[4]) +
                   (storage[6] * arg.storage[5]);
    r.storage[6] = (storage[0] * arg.storage[6]) +
                   (storage[3] * arg.storage[7]) +
                   (storage[6] * arg.storage[8]);
    r.storage[1] = (storage[1] * arg.storage[0]) +
                   (storage[4] * arg.storage[1]) +
                   (storage[7] * arg.storage[2]);
    r.storage[4] = (storage[1] * arg.storage[3]) +
                   (storage[4] * arg.storage[4]) +
                   (storage[7] * arg.storage[5]);
    r.storage[7] = (storage[1] * arg.storage[6]) +
                   (storage[4] * arg.storage[7]) +
                   (storage[7] * arg.storage[8]);
    r.storage[2] = (storage[2] * arg.storage[0]) +
                   (storage[5] * arg.storage[1]) +
                   (storage[8] * arg.storage[2]);
    r.storage[5] = (storage[2] * arg.storage[3]) +
                   (storage[5] * arg.storage[4]) +
                   (storage[8] * arg.storage[5]);
    r.storage[8] = (storage[2] * arg.storage[6]) +
                   (storage[5] * arg.storage[7]) +
                   (storage[8] * arg.storage[8]);
    return r;
  }

  Vector3 _mul_vector(Vector3 arg) {
    Vector3 r = new Vector3.zero();
    r.storage[2] = (storage[2] * arg.storage[0]) +
                   (storage[5] * arg.storage[1]) +
                   (storage[8] * arg.storage[2]);
    r.storage[1] = (storage[1] * arg.storage[0]) +
                   (storage[4] * arg.storage[1]) +
                   (storage[7] * arg.storage[2]);
    r.storage[0] = (storage[0] * arg.storage[0]) +
                   (storage[3] * arg.storage[1]) +
                   (storage[6] * arg.storage[2]);
    return r;
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  dynamic operator *(dynamic arg) {
    if (arg is double) {
      return _mul_scale(arg);
    }
    if (arg is Vector3) {
      return _mul_vector(arg);
    }
    if (3 == arg.dimension) {
      return _mul_matrix(arg);
    }
    throw new ArgumentError(arg);
  }

  /// Returns new matrix after component wise [this] + [arg]
  Matrix3 operator +(Matrix3 arg) {
    Matrix3 r = new Matrix3.zero();
    r.storage[0] = storage[0] + arg.storage[0];
    r.storage[1] = storage[1] + arg.storage[1];
    r.storage[2] = storage[2] + arg.storage[2];
    r.storage[3] = storage[3] + arg.storage[3];
    r.storage[4] = storage[4] + arg.storage[4];
    r.storage[5] = storage[5] + arg.storage[5];
    r.storage[6] = storage[6] + arg.storage[6];
    r.storage[7] = storage[7] + arg.storage[7];
    r.storage[8] = storage[8] + arg.storage[8];
    return r;
  }

  /// Returns new matrix after component wise [this] - [arg]
  Matrix3 operator -(Matrix3 arg) {
    Matrix3 r = new Matrix3.zero();
    r.storage[0] = storage[0] - arg.storage[0];
    r.storage[1] = storage[1] - arg.storage[1];
    r.storage[2] = storage[2] - arg.storage[2];
    r.storage[3] = storage[3] - arg.storage[3];
    r.storage[4] = storage[4] - arg.storage[4];
    r.storage[5] = storage[5] - arg.storage[5];
    r.storage[6] = storage[6] - arg.storage[6];
    r.storage[7] = storage[7] - arg.storage[7];
    r.storage[8] = storage[8] - arg.storage[8];
    return r;
  }

  /// Returns new matrix -this
  Matrix3 operator -() {
    Matrix3 r = new Matrix3.zero();
    r[0] = -storage[0];
    r[1] = -storage[1];
    r[2] = -storage[2];
    return r;
  }

  /// Zeros [this].
  Matrix3 setZero() {
    storage[0] = 0.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = 0.0;
    storage[5] = 0.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 0.0;
    return this;
  }

  /// Makes [this] into the identity matrix.
  Matrix3 setIdentity() {
    storage[0] = 1.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = 1.0;
    storage[5] = 0.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 1.0;
    return this;
  }

  /// Returns the tranpose of this.
  Matrix3 transposed() {
    Matrix3 r = new Matrix3.zero();
    r.storage[0] = storage[0];
    r.storage[1] = storage[3];
    r.storage[2] = storage[6];
    r.storage[3] = storage[1];
    r.storage[4] = storage[4];
    r.storage[5] = storage[7];
    r.storage[6] = storage[2];
    r.storage[7] = storage[5];
    r.storage[8] = storage[8];
    return r;
  }

  Matrix3 transpose() {
    double temp;
    temp = storage[3];
    storage[3] = storage[1];
    storage[1] = temp;
    temp = storage[6];
    storage[6] = storage[2];
    storage[2] = temp;
    temp = storage[7];
    storage[7] = storage[5];
    storage[5] = temp;
    return this;
  }

  /// Returns the component wise absolute value of this.
  Matrix3 absolute() {
    Matrix3 r = new Matrix3.zero();
    r.storage[0] = storage[0].abs();
    r.storage[1] = storage[1].abs();
    r.storage[2] = storage[2].abs();
    r.storage[3] = storage[3].abs();
    r.storage[4] = storage[4].abs();
    r.storage[5] = storage[5].abs();
    r.storage[6] = storage[6].abs();
    r.storage[7] = storage[7].abs();
    r.storage[8] = storage[8].abs();
    return r;
  }

  /// Returns the determinant of this matrix.
  double determinant() {
    double x = storage[0] *
               ((storage[4] * storage[8]) - (storage[5] * storage[7]));
    double y = storage[1] *
               ((storage[3] * storage[8]) - (storage[5] * storage[6]));
    double z = storage[2] *
               ((storage[3] * storage[7]) - (storage[4] * storage[6]));
    return x - y + z;
  }

  /// Returns the dot product of row [i] and [v].
  double dotRow(int i, Vector3 v) {
    return storage[i] * v.storage[0]
         + storage[3+i] * v.storage[1]
         + storage[6+i] * v.storage[2];
  }

  /// Returns the dot product of column [j] and [v].
  double dotColumn(int j, Vector3 v) {
    return storage[j*3] * v.storage[0]
         + storage[j*3+1] * v.storage[1]
         + storage[j*3+2] * v.storage[2];
  }

  /// Returns the trace of the matrix. The trace of a matrix is the sum of
  /// the diagonal entries.
  double trace() {
    double t = 0.0;
    t += storage[0];
    t += storage[4];
    t += storage[8];
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
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += storage[3].abs();
      row_norm += storage[4].abs();
      row_norm += storage[5].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      double row_norm = 0.0;
      row_norm += storage[6].abs();
      row_norm += storage[7].abs();
      row_norm += storage[8].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }

  /// Returns relative error between [this] and [correct]
  double relativeError(Matrix3 correct) {
    Matrix3 diff = correct - this;
    double correct_norm = correct.infinityNorm();
    double diff_norm = diff.infinityNorm();
    return diff_norm / correct_norm;
  }

  /// Returns absolute error between [this] and [correct]
  double absoluteError(Matrix3 correct) {
    double this_norm = infinityNorm();
    double correct_norm = correct.infinityNorm();
    double diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }

  /// Invert the matrix. Returns the determinant.
  double invert() {
    double det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    double invDet = 1.0 / det;
    double ix = invDet * (storage[4] * storage[8] - storage[5] * storage[7]);
    double iy = invDet * (storage[2] * storage[7] - storage[1] * storage[8]);
    double iz = invDet * (storage[1] * storage[5] - storage[2] * storage[4]);
    double jx = invDet * (storage[5] * storage[6] - storage[3] * storage[8]);
    double jy = invDet * (storage[0] * storage[8] - storage[2] * storage[6]);
    double jz = invDet * (storage[2] * storage[3] - storage[0] * storage[5]);
    double kx = invDet * (storage[3] * storage[7] - storage[4] * storage[6]);
    double ky = invDet * (storage[1] * storage[6] - storage[0] * storage[7]);
    double kz = invDet * (storage[0] * storage[4] - storage[1] * storage[3]);
    storage[0] = ix;
    storage[1] = iy;
    storage[2] = iz;
    storage[3] = jx;
    storage[4] = jy;
    storage[5] = jz;
    storage[6] = kx;
    storage[7] = ky;
    storage[8] = kz;
    return det;
  }

  /// Set this matrix to be the inverse of [arg]
  double copyInverse(Matrix3 arg) {
    double det = arg.determinant();
    if (det == 0.0) {
      setFrom(arg);
      return 0.0;
    }
    double invDet = 1.0 / det;
    double ix = invDet * (arg.storage[4] * arg.storage[8]
                        - arg.storage[5] * arg.storage[7]);
    double iy = invDet * (arg.storage[2] * arg.storage[7]
                        - arg.storage[1] * arg.storage[8]);
    double iz = invDet * (arg.storage[1] * arg.storage[5]
                        - arg.storage[2] * arg.storage[4]);
    double jx = invDet * (arg.storage[5] * arg.storage[6]
                        - arg.storage[3] * arg.storage[8]);
    double jy = invDet * (arg.storage[0] * arg.storage[8]
                        - arg.storage[2] * arg.storage[6]);
    double jz = invDet * (arg.storage[2] * arg.storage[3]
                        - arg.storage[0] * arg.storage[5]);
    double kx = invDet * (arg.storage[3] * arg.storage[7]
                        - arg.storage[4] * arg.storage[6]);
    double ky = invDet * (arg.storage[1] * arg.storage[6]
                        - arg.storage[0] * arg.storage[7]);
    double kz = invDet * (arg.storage[0] * arg.storage[4]
                        - arg.storage[1] * arg.storage[3]);
    storage[0] = ix;
    storage[1] = iy;
    storage[2] = iz;
    storage[3] = jx;
    storage[4] = jy;
    storage[5] = jz;
    storage[6] = kx;
    storage[7] = ky;
    storage[8] = kz;
    return det;
  }

  /// Turns the matrix into a rotation of [radians] around X
  void setRotationX(double radians) {
    double c = Math.cos(radians);
    double s = Math.sin(radians);
    storage[0] = 1.0;
    storage[1] = 0.0;
    storage[2] = 0.0;
    storage[3] = 0.0;
    storage[4] = c;
    storage[5] = s;
    storage[6] = 0.0;
    storage[7] = -s;
    storage[8] = c;
  }

  /// Turns the matrix into a rotation of [radians] around Y
  void setRotationY(double radians) {
    double c = Math.cos(radians);
    double s = Math.sin(radians);
    storage[0] = c;
    storage[1] = 0.0;
    storage[2] = s;
    storage[3] = 0.0;
    storage[4] = 1.0;
    storage[5] = 0.0;
    storage[6] = -s;
    storage[7] = 0.0;
    storage[8] = c;
  }

  /// Turns the matrix into a rotation of [radians] around Z
  void setRotationZ(double radians) {
    double c = Math.cos(radians);
    double s = Math.sin(radians);
    storage[0] = c;
    storage[1] = s;
    storage[2] = 0.0;
    storage[3] = -s;
    storage[4] = c;
    storage[5] = 0.0;
    storage[6] = 0.0;
    storage[7] = 0.0;
    storage[8] = 1.0;
  }

  /// Converts into Adjugate matrix and scales by [scale]
  Matrix3 scaleAdjoint(double scale) {
    double m00 = storage[0];
    double m01 = storage[3];
    double m02 = storage[6];
    double m10 = storage[1];
    double m11 = storage[4];
    double m12 = storage[7];
    double m20 = storage[2];
    double m21 = storage[5];
    double m22 = storage[8];
    storage[0] = (m11 * m22 - m12 * m21) * scale;
    storage[1] = (m12 * m20 - m10 * m22) * scale;
    storage[2] = (m10 * m21 - m11 * m20) * scale;
    storage[3] = (m02 * m21 - m01 * m22) * scale;
    storage[4] = (m00 * m22 - m02 * m20) * scale;
    storage[5] = (m01 * m20 - m00 * m21) * scale;
    storage[6] = (m01 * m12 - m02 * m11) * scale;
    storage[7] = (m02 * m10 - m00 * m12) * scale;
    storage[8] = (m00 * m11 - m01 * m10) * scale;
    return this;
  }

  /// Rotates [arg] by the absolute rotation of [this]
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  Vector3 absoluteRotate(Vector3 arg) {
    double m00 = storage[0].abs();
    double m01 = storage[3].abs();
    double m02 = storage[6].abs();
    double m10 = storage[1].abs();
    double m11 = storage[4].abs();
    double m12 = storage[7].abs();
    double m20 = storage[2].abs();
    double m21 = storage[5].abs();
    double m22 = storage[8].abs();
    double x = arg.x;
    double y = arg.y;
    double z = arg.z;
    arg.x = x * m00 + y * m01 + z * m02;
    arg.y = x * m10 + y * m11 + z * m12;
    arg.z = x * m20 + y * m21 + z * m22;
    return arg;
  }

  /// Rotates [arg] by the absolute rotation of [this]
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  Vector2 absoluteRotate2(Vector2 arg) {
    double m00 = storage[0].abs();
    double m01 = storage[3].abs();
    double m10 = storage[1].abs();
    double m11 = storage[4].abs();
    double x = arg.x;
    double y = arg.y;
    arg.x = x * m00 + y * m01;
    arg.y = x * m10 + y * m11;
    return arg;
  }

  /// Transforms [arg] with [this].
  Vector2 transform2(Vector2 arg) {
    double x_ =  (storage[0] * arg.storage[0]) + (storage[3] * arg.storage[1]) + storage[6];
    double y_ =  (storage[1] * arg.storage[0]) + (storage[4] * arg.storage[1]) + storage[7];
    arg.x = x_;
    arg.y = y_;
    return arg;
  }

  Matrix3 add(Matrix3 o) {
    storage[0] = storage[0] + o.storage[0];
    storage[1] = storage[1] + o.storage[1];
    storage[2] = storage[2] + o.storage[2];
    storage[3] = storage[3] + o.storage[3];
    storage[4] = storage[4] + o.storage[4];
    storage[5] = storage[5] + o.storage[5];
    storage[6] = storage[6] + o.storage[6];
    storage[7] = storage[7] + o.storage[7];
    storage[8] = storage[8] + o.storage[8];
    return this;
  }

  Matrix3 sub(Matrix3 o) {
    storage[0] = storage[0] - o.storage[0];
    storage[1] = storage[1] - o.storage[1];
    storage[2] = storage[2] - o.storage[2];
    storage[3] = storage[3] - o.storage[3];
    storage[4] = storage[4] - o.storage[4];
    storage[5] = storage[5] - o.storage[5];
    storage[6] = storage[6] - o.storage[6];
    storage[7] = storage[7] - o.storage[7];
    storage[8] = storage[8] - o.storage[8];
    return this;
  }

  Matrix3 negate() {
    storage[0] = -storage[0];
    storage[1] = -storage[1];
    storage[2] = -storage[2];
    storage[3] = -storage[3];
    storage[4] = -storage[4];
    storage[5] = -storage[5];
    storage[6] = -storage[6];
    storage[7] = -storage[7];
    storage[8] = -storage[8];
    return this;
  }

  Matrix3 multiply(Matrix3 arg) {
    final double m00 = storage[0];
    final double m01 = storage[3];
    final double m02 = storage[6];
    final double m10 = storage[1];
    final double m11 = storage[4];
    final double m12 = storage[7];
    final double m20 = storage[2];
    final double m21 = storage[5];
    final double m22 = storage[8];
    final double n00 = arg.storage[0];
    final double n01 = arg.storage[3];
    final double n02 = arg.storage[6];
    final double n10 = arg.storage[1];
    final double n11 = arg.storage[4];
    final double n12 = arg.storage[7];
    final double n20 = arg.storage[2];
    final double n21 = arg.storage[5];
    final double n22 = arg.storage[8];
    storage[0] =  (m00 * n00) + (m01 * n10) + (m02 * n20);
    storage[3] =  (m00 * n01) + (m01 * n11) + (m02 * n21);
    storage[6] =  (m00 * n02) + (m01 * n12) + (m02 * n22);
    storage[1] =  (m10 * n00) + (m11 * n10) + (m12 * n20);
    storage[4] =  (m10 * n01) + (m11 * n11) + (m12 * n21);
    storage[7] =  (m10 * n02) + (m11 * n12) + (m12 * n22);
    storage[2] =  (m20 * n00) + (m21 * n10) + (m22 * n20);
    storage[5] =  (m20 * n01) + (m21 * n11) + (m22 * n21);
    storage[8] =  (m20 * n02) + (m21 * n12) + (m22 * n22);
    return this;
  }

  Matrix3 transposeMultiply(Matrix3 arg) {
    double m00 = storage[0];
    double m01 = storage[1];
    double m02 = storage[2];
    double m10 = storage[3];
    double m11 = storage[4];
    double m12 = storage[5];
    double m20 = storage[6];
    double m21 = storage[7];
    double m22 = storage[8];
    storage[0] = (m00 * arg.storage[0]) + (m01 * arg.storage[1]) +
                 (m02 * arg.storage[2]);
    storage[3] = (m00 * arg.storage[3]) + (m01 * arg.storage[4]) +
                 (m02 * arg.storage[5]);
    storage[6] = (m00 * arg.storage[6]) + (m01 * arg.storage[7]) +
                 (m02 * arg.storage[8]);
    storage[1] = (m10 * arg.storage[0]) + (m11 * arg.storage[1]) +
                 (m12 * arg.storage[2]);
    storage[4] = (m10 * arg.storage[3]) + (m11 * arg.storage[4]) +
                 (m12 * arg.storage[5]);
    storage[7] = (m10 * arg.storage[6]) + (m11 * arg.storage[7]) +
                 (m12 * arg.storage[8]);
    storage[2] = (m20 * arg.storage[0]) + (m21 * arg.storage[1]) +
                 (m22 * arg.storage[2]);
    storage[5] = (m20 * arg.storage[3]) + (m21 * arg.storage[4]) +
                 (m22 * arg.storage[5]);
    storage[8] = (m20 * arg.storage[6]) + (m21 * arg.storage[7]) +
                 (m22 * arg.storage[8]);
    return this;
  }

  Matrix3 multiplyTranspose(Matrix3 arg) {
    double m00 = storage[0];
    double m01 = storage[3];
    double m02 = storage[6];
    double m10 = storage[1];
    double m11 = storage[4];
    double m12 = storage[7];
    double m20 = storage[2];
    double m21 = storage[5];
    double m22 = storage[8];
    storage[0] = (m00 * arg.storage[0]) + (m01 * arg.storage[3]) +
                 (m02 * arg.storage[6]);
    storage[3] = (m00 * arg.storage[1]) + (m01 * arg.storage[4]) +
                 (m02 * arg.storage[7]);
    storage[6] = (m00 * arg.storage[2]) + (m01 * arg.storage[5]) +
                 (m02 * arg.storage[8]);
    storage[1] = (m10 * arg.storage[0]) + (m11 * arg.storage[3]) +
                 (m12 * arg.storage[6]);
    storage[4] = (m10 * arg.storage[1]) + (m11 * arg.storage[4]) +
                 (m12 * arg.storage[7]);
    storage[7] = (m10 * arg.storage[2]) + (m11 * arg.storage[5]) +
                 (m12 * arg.storage[8]);
    storage[2] = (m20 * arg.storage[0]) + (m21 * arg.storage[3]) +
                 (m22 * arg.storage[6]);
    storage[5] = (m20 * arg.storage[1]) + (m21 * arg.storage[4]) +
                 (m22 * arg.storage[7]);
    storage[8] = (m20 * arg.storage[2]) + (m21 * arg.storage[5]) +
                 (m22 * arg.storage[8]);
    return this;
  }

  Vector3 transform(Vector3 arg) {
    double x_ = (storage[0] * arg.storage[0]) +
                (storage[3] * arg.storage[1]) +
                (storage[6] * arg.storage[2]);
    double y_ = (storage[1] * arg.storage[0]) +
                (storage[4] * arg.storage[1]) +
                (storage[7] * arg.storage[2]);
    double z_ = (storage[2] * arg.storage[0]) +
                (storage[5] * arg.storage[1]) +
                (storage[8] * arg.storage[2]);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }
  Vector3 transformed(Vector3 arg, [Vector3 out = null]) {
    if (out == null) {
      out = new Vector3.copy(arg);
    } else {
      out.setFrom(arg);
    }
    return transform(out);
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset=0]) {
    int i = offset;
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
  void copyFromArray(List<double> array, [int offset = 0]) {
    int i = offset;
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
    double x = storage[3];
    double y = storage[4];
    double z = storage[5];
    return new Vector3(x, y, z);
  }

  Vector3 get forward {
    double x = storage[6];
    double y = storage[7];
    double z = storage[8];
    return new Vector3(x, y, z);
  }
}
