// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
part of vector_math_lists;

/// A list of [Vector4].
class Vector4List extends VectorList<Vector4> {
  /// Create a new vector list with [length] elements. Optionally it is possible
  /// to specify an [offset] in the [buffer] and a [stride] between each vector.
  Vector4List(int length, [int offset = 0, int stride = 0])
      : super(length, 4, offset, stride);

  /// Create a new vector list from a list of vectors. Optionally it is possible
  /// to specify an [offset] in the [buffer] and a [stride] between each vector.
  Vector4List.fromList(List<Vector4> list, [int offset = 0, int stride = 0])
      : super.fromList(list, 4, offset, stride);

  /// Create a new vector list as a view of [buffer]. Optionally it is possible
  /// to specify a [offset] in the [buffer] and a [stride] between each vector.
  Vector4List.view(Float32List buffer, [int offset = 0, int stride = 0])
      : super.view(buffer, 4, offset, stride);

  @override
  Vector4 newVector() {
    return new Vector4.zero();
  }
}
