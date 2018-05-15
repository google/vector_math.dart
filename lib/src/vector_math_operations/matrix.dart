// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_operations;

/// Static methods operating on 4x4 matrices packed column major into a
/// Float32List.
class Matrix44Operations {
  /// Compute the determinant of the 4x4 [matrix] starting at [offset].
  static double determinant(Float32List matrix, int offset) {
    final double m0 = matrix[0 + offset];
    final double m1 = matrix[1 + offset];
    final double m2 = matrix[2 + offset];
    final double m3 = matrix[3 + offset];
    final double m4 = matrix[4 + offset];
    final double m5 = matrix[5 + offset];
    final double m6 = matrix[6 + offset];
    final double m7 = matrix[7 + offset];

    final double det2_01_01 = m0 * m5 - m1 * m4;
    final double det2_01_02 = m0 * m6 - m2 * m4;
    final double det2_01_03 = m0 * m7 - m3 * m4;
    final double det2_01_12 = m1 * m6 - m2 * m5;
    final double det2_01_13 = m1 * m7 - m3 * m5;
    final double det2_01_23 = m2 * m7 - m3 * m6;

    final double m8 = matrix[8 + offset];
    final double m9 = matrix[9 + offset];
    final double m10 = matrix[10 + offset];
    final double m11 = matrix[11 + offset];

    final double det3_201_012 =
        m8 * det2_01_12 - m9 * det2_01_02 + m10 * det2_01_01;
    final double det3_201_013 =
        m8 * det2_01_13 - m9 * det2_01_03 + m11 * det2_01_01;
    final double det3_201_023 =
        m8 * det2_01_23 - m10 * det2_01_03 + m11 * det2_01_02;
    final double det3_201_123 =
        m9 * det2_01_23 - m10 * det2_01_13 + m11 * det2_01_12;

    final double m12 = matrix[12 + offset];
    final double m13 = matrix[13 + offset];
    final double m14 = matrix[14 + offset];
    final double m15 = matrix[15 + offset];

    return -det3_201_123 * m12 +
        det3_201_023 * m13 -
        det3_201_013 * m14 +
        det3_201_012 * m15;
  }

  /// Compute the determinant of the upper 3x3 of the 4x4 [matrix] starting at
  /// [offset].
  static double determinant33(Float32List matrix, int offset) {
    final double m0 = matrix[0 + offset];
    final double m1 = matrix[1 + offset];
    final double m2 = matrix[2 + offset];
    final double m4 = matrix[4 + offset];
    final double m5 = matrix[5 + offset];
    final double m6 = matrix[6 + offset];
    final double m8 = matrix[8 + offset];
    final double m9 = matrix[9 + offset];
    final double m10 = matrix[10 + offset];
    final double x = m0 * ((m5 * m10) - (m6 * m8));
    final double y = m1 * ((m4 * m10) - (m6 * m8));
    final double z = m2 * ((m4 * m9) - (m5 * m8));
    return x - y + z;
  }

  /// Compute the inverse of the 4x4 [matrix] starting at [offset].
  static double inverse(Float32List matrix, int offset) {
    final double a00 = matrix[0];
    final double a01 = matrix[1];
    final double a02 = matrix[2];
    final double a03 = matrix[3];
    final double a10 = matrix[4];
    final double a11 = matrix[5];
    final double a12 = matrix[6];
    final double a13 = matrix[7];
    final double a20 = matrix[8];
    final double a21 = matrix[9];
    final double a22 = matrix[10];
    final double a23 = matrix[11];
    final double a30 = matrix[12];
    final double a31 = matrix[13];
    final double a32 = matrix[14];
    final double a33 = matrix[15];
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
    final double det =
        (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06);

    if (det == 0.0) {
      return det;
    }

    final double invDet = 1.0 / det;

    matrix[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;
    matrix[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;
    matrix[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;
    matrix[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;
    matrix[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;
    matrix[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;
    matrix[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;
    matrix[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;
    matrix[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;
    matrix[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;
    matrix[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;
    matrix[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;
    matrix[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;
    matrix[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;
    matrix[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;
    matrix[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;

    return det;
  }

  /// Compute the inverse of the upper 3x3 of the 4x4 [matrix] starting
  /// at [offset].
  static double inverse33(Float32List matrix, int offset) =>
      throw new UnimplementedError();

  /// [out] = [a] * [b]; Starting at [outOffset], [aOffset], and [bOffset].
  static void multiply(Float32List out, int outOffset, Float32List a,
      int aOffset, Float32List b, int bOffset) {
    final double a00 = a[aOffset++];
    final double a01 = a[aOffset++];
    final double a02 = a[aOffset++];
    final double a03 = a[aOffset++];
    final double a10 = a[aOffset++];
    final double a11 = a[aOffset++];
    final double a12 = a[aOffset++];
    final double a13 = a[aOffset++];
    final double a20 = a[aOffset++];
    final double a21 = a[aOffset++];
    final double a22 = a[aOffset++];
    final double a23 = a[aOffset++];
    final double a30 = a[aOffset++];
    final double a31 = a[aOffset++];
    final double a32 = a[aOffset++];
    final double a33 = a[aOffset++];

    double b0 = b[bOffset++];
    double b1 = b[bOffset++];
    double b2 = b[bOffset++];
    double b3 = b[bOffset++];
    out[outOffset++] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[outOffset++] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[outOffset++] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[outOffset++] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;

    b0 = b[bOffset++];
    b1 = b[bOffset++];
    b2 = b[bOffset++];
    b3 = b[bOffset++];
    out[outOffset++] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[outOffset++] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[outOffset++] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[outOffset++] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;

    b0 = b[bOffset++];
    b1 = b[bOffset++];
    b2 = b[bOffset++];
    b3 = b[bOffset++];
    out[outOffset++] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[outOffset++] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[outOffset++] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[outOffset++] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;

    b0 = b[bOffset++];
    b1 = b[bOffset++];
    b2 = b[bOffset++];
    b3 = b[bOffset++];
    out[outOffset++] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[outOffset++] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[outOffset++] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[outOffset++] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
  }

  /// Perform a 4x4 transformation matrix inverse. Assumes the upper
  /// 3x3 is orthonormal (i.e. does not contain any scale).
  static void orthoInverse(Float32List matrix, int offset) {}

  /// Normalize the upper 3x3 of the 4x4 [matrix] starting at [offset].
  static void normalize33(Float32List matrix, int offset) {}

  /// Transform the 4D [vector] starting at [vectorOffset] by the 4x4 [matrix]
  /// starting at [matrixOffset]. Store result in [out] starting at [outOffset].
  static void transform4(Float32List out, int outOffset, Float32List matrix,
      int matrixOffset, Float32List vector, int vectorOffset) {
    final double x = vector[vectorOffset++];
    final double y = vector[vectorOffset++];
    final double z = vector[vectorOffset++];
    final double w = vector[vectorOffset++];
    final double m0 = matrix[matrixOffset];
    final double m4 = matrix[4 + matrixOffset];
    final double m8 = matrix[8 + matrixOffset];
    final double m12 = matrix[12 + matrixOffset];
    out[outOffset++] = (m0 * x + m4 * y + m8 * z + m12 * w);
    final double m1 = matrix[1 + matrixOffset];
    final double m5 = matrix[5 + matrixOffset];
    final double m9 = matrix[9 + matrixOffset];
    final double m13 = matrix[13 + matrixOffset];
    out[outOffset++] = (m1 * x + m5 * y + m9 * z + m13 * w);
    final double m2 = matrix[2 + matrixOffset];
    final double m6 = matrix[6 + matrixOffset];
    final double m10 = matrix[10 + matrixOffset];
    final double m14 = matrix[14 + matrixOffset];
    out[outOffset++] = (m2 * x + m6 * y + m10 * z + m14 * w);
    final double m3 = matrix[3 + matrixOffset];
    final double m7 = matrix[7 + matrixOffset];
    final double m11 = matrix[11 + matrixOffset];
    final double m15 = matrix[15 + matrixOffset];
    out[outOffset++] = (m3 * x + m7 * y + m11 * z + m15 * w);
  }

  /// Transform the 3D [vector] starting at [vectorOffset] by the 4x4 [matrix]
  /// starting at [matrixOffset]. Store result in [out] starting at [outOffset].
  static void transform3(Float32List out, int outOffset, Float32List matrix,
      int matrixOffset, Float32List vector, int vectorOffset) {}

  /// Transpose the 4x4 [matrix] starting at [offset].
  static void transpose(Float32List matrix, int offset) {}

  /// Transpose the upper 3x3 of the 4x4 [matrix] starting at [offset].
  static void transpose33(Float32List matrix, int offset) {}

  static void zero(Float32List matrix, int offset) {
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;

    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;

    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;

    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
    matrix[offset++] = 0.0;
  }
}

/// Static methods operating on 4x4 matrices packed column major into a
/// Float32x4List.
class Matrix44SIMDOperations {
  /// [out] = [A] * [B]; Starting at [outOffset], [aOffset], and [bOffset].
  static void multiply(Float32x4List out, int outOffset, Float32x4List A,
      int aOffset, Float32x4List B, int bOffset) {
    final Float32x4 a0 = A[aOffset++];
    final Float32x4 a1 = A[aOffset++];
    final Float32x4 a2 = A[aOffset++];
    final Float32x4 a3 = A[aOffset++];
    final Float32x4 b0 = B[bOffset++];
    out[outOffset++] = b0.shuffle(Float32x4.xxxx) * a0 +
        b0.shuffle(Float32x4.yyyy) * a1 +
        b0.shuffle(Float32x4.zzzz) * a2 +
        b0.shuffle(Float32x4.wwww) * a3;
    final Float32x4 b1 = B[bOffset++];
    out[outOffset++] = b1.shuffle(Float32x4.xxxx) * a0 +
        b1.shuffle(Float32x4.yyyy) * a1 +
        b1.shuffle(Float32x4.zzzz) * a2 +
        b1.shuffle(Float32x4.wwww) * a3;
    final Float32x4 b2 = B[bOffset++];
    out[outOffset++] = b2.shuffle(Float32x4.xxxx) * a0 +
        b2.shuffle(Float32x4.yyyy) * a1 +
        b2.shuffle(Float32x4.zzzz) * a2 +
        b2.shuffle(Float32x4.wwww) * a3;
    final Float32x4 b3 = B[bOffset++];
    out[outOffset++] = b3.shuffle(Float32x4.xxxx) * a0 +
        b3.shuffle(Float32x4.yyyy) * a1 +
        b3.shuffle(Float32x4.zzzz) * a2 +
        b3.shuffle(Float32x4.wwww) * a3;
  }

  /// Transform the 4D [vector] starting at [vectorOffset] by the 4x4 [matrix]
  /// starting at [matrixOffset]. Store result in [out] starting at [outOffset].
  static void transform4(Float32x4List out, int outOffset, Float32x4List matrix,
      int matrixOffset, Float32x4List vector, int vectorOffset) {
    final Float32x4 v = vector[vectorOffset];
    final Float32x4 xxxx = v.shuffle(Float32x4.xxxx);
    Float32x4 z = new Float32x4.zero();
    z += xxxx * matrix[0 + matrixOffset];
    final Float32x4 yyyy = v.shuffle(Float32x4.yyyy);
    z += yyyy * matrix[1 + matrixOffset];
    final Float32x4 zzzz = v.shuffle(Float32x4.zzzz);
    z += zzzz * matrix[2 + matrixOffset];
    z += matrix[3 + matrixOffset];
    out[0 + outOffset] = z;
  }

  static void zero(Float32x4List matrix, int offset) {
    final Float32x4 z = new Float32x4.zero();
    matrix[offset++] = z;
    matrix[offset++] = z;
    matrix[offset++] = z;
    matrix[offset++] = z;
  }
}
