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

part of vector_math_operations;

/// Static methods operating on 4x4 matrices packed column major into
/// Float32List.
class Matrix44Operations {
  /// Compute the determinant of the 4x4 [matrix] starting at [offset].
  static double determinant(Float32List matrix, int offset) {
    double m0 = matrix[0+offset];
    double m1 = matrix[1+offset];
    double m2 = matrix[2+offset];
    double m3 = matrix[3+offset];
    double m4 = matrix[4+offset];
    double m5 = matrix[5+offset];
    double m6 = matrix[6+offset];
    double m7 = matrix[7+offset];
    
    double det2_01_01 = m0 * m5 - m1 * m4;
    double det2_01_02 = m0 * m6 - m2 * m4;
    double det2_01_03 = m0 * m7 - m3 * m4;
    double det2_01_12 = m1 * m6 - m2 * m5;
    double det2_01_13 = m1 * m7 - m3 * m5;
    double det2_01_23 = m2 * m7 - m3 * m6;
    
    double m8 = matrix[8+offset];
    double m9 = matrix[9+offset];
    double m10 = matrix[10+offset];
    double m11 = matrix[11+offset];
    
    double det3_201_012 = m8 * det2_01_12 - m9 * det2_01_02 +
                          m10 * det2_01_01;
    double det3_201_013 = m8 * det2_01_13 - m9 * det2_01_03 +
                          m11 * det2_01_01;
    double det3_201_023 = m8 * det2_01_23 - m10 * det2_01_03 +
                          m11 * det2_01_02;
    double det3_201_123 = m9 * det2_01_23 - m10 * det2_01_13 +
                          m11 * det2_01_12;
    
    double m12 = matrix[12+offset];
    double m13 = matrix[13+offset];
    double m14 = matrix[14+offset];
    double m15 = matrix[15+offset];
    
    return -det3_201_123 * m12 + det3_201_023 * m13 -
            det3_201_013 * m14 + det3_201_012 * m15;
  }

  /// Compute the determinant of the upper 3x3 of the 4x4 [matrix] starting at
  /// [offset].
  static double determinant33(Float32List matrix, int offset) {
    double m0 = matrix[0+offset];
    double m1 = matrix[1+offset];
    double m2 = matrix[2+offset];
    double m4 = matrix[4+offset];
    double m5 = matrix[5+offset];
    double m6 = matrix[6+offset];
    double m8 = matrix[8+offset];
    double m9 = matrix[9+offset];
    double m10 = matrix[10+offset];
    double x = m0 * ((m5 * m10) - (m6 * m8));
    double y = m1 * ((m4 * m10) - (m6 * m8));
    double z = m2 * ((m4 * m9) - (m5 * m8));
    return x - y + z;
  }

  /// Compute the inverse of the 4x4 [matrix] starting at [offset].
  static double inverse(Float32List matrix, int offset) {
    double a00 = matrix[0];
    double a01 = matrix[1];
    double a02 = matrix[2];
    double a03 = matrix[3];
    double a10 = matrix[4];
    double a11 = matrix[5];
    double a12 = matrix[6];
    double a13 = matrix[7];
    double a20 = matrix[8];
    double a21 = matrix[9];
    double a22 = matrix[10];
    double a23 = matrix[11];
    double a30 = matrix[12];
    double a31 = matrix[13];
    double a32 = matrix[14];
    double a33 = matrix[15];
    double b00 = a00 * a11 - a01 * a10;
    double b01 = a00 * a12 - a02 * a10;
    double b02 = a00 * a13 - a03 * a10;
    double b03 = a01 * a12 - a02 * a11;
    double b04 = a01 * a13 - a03 * a11;
    double b05 = a02 * a13 - a03 * a12;
    double b06 = a20 * a31 - a21 * a30;
    double b07 = a20 * a32 - a22 * a30;
    double b08 = a20 * a33 - a23 * a30;
    double b09 = a21 * a32 - a22 * a31;
    double b10 = a21 * a33 - a23 * a31;
    double b11 = a22 * a33 - a23 * a32;
    double det = (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 +
                  b05 * b06);
    
    if (det == 0.0) { return det; }
    
    var invDet = 1.0 / det;
    
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
  static double inverse33(Float32List matrix, int offset) {
  }

  /// [out] = [A] * [B]; Starting at [outOffset], [aOffset], and [bOffset].
  static void multiply(Float32List out, int outOffset, Float32List A,
                       int aOffset, Float32List B, int bOffset) {
  }

  /// Perform a 4x4 transformation matrix inverse. Assumes the upper
  /// 3x3 is orthonormal (i.e. does not contain any scale).
  static void orthoInverse(Float32List matrix, int offset) {
  }

  /// Normalize the upper 3x3 of the 4x4 [matrix] starting at [offset].
  static void normalize33(Float32List matrix, int offset) {
  }

  /// Transform the 4D [vector] starting at [vectorOffset] by the 4x4 [matrix]
  /// starting at [matrixOffset]. Store result in [out] starting at [outOffset].
  static void transform4(Float32List out, int outOffset, Float32List matrix,
                         int matrixOffset, Float32List vector,
                         int vectorOffset) {
  }

  /// Transform the 3D [vector] starting at [vectorOffset] by the 4x4 [matrix]
  /// starting at [matrixOffset]. Store result in [out] starting at [outOffset].
  static void transform3(Float32List out, int outOffset, Float32List matrix,
                         int matrixOffset, Float32List vector,
                         int vectorOffset) {
  }

  /// Transpose the 4x4 [matrix] starting at [offset].
  static void transpose(Float32List matrix, int offset) {
  }

  /// Transpose the upper 3x3 of the 4x4 [matrix] starting at [offset].
  static void transpose33(Float32List matrix, int offset) {
  }
}