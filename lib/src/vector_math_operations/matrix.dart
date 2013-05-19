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

class Matrix44Operations {
  /// Compute the determinant of the 4x4 [matrix] starting at [offset].
  static double determinant(Float32List matrix, int offset) {
  }
  
  /// Compute the inverse of the 4x4 [matrix] starting at [offset].
  static double inverse(Float32List matrix, int offset) {
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