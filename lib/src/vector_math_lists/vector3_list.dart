// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
part of vector_math_lists;

/// A list of [Vector3].
class Vector3List extends VectorList<Vector3> {
  /// Create a new vector list with [length] elements. Optionally it is possible
  /// to specify an [offset] in the [buffer] and a [stride] between each vector.
  Vector3List(int length, [int offset = 0, int stride = 0])
      : super(length, 3, offset, stride);

  /// Create a new vector list from a list of vectors. Optionally it is possible
  /// to specify an [offset] in the [buffer] and a [stride] between each vector.
  Vector3List.fromList(List<Vector3> list, [int offset = 0, int stride = 0])
      : super.fromList(list, 3, offset, stride);

  /// Create a new vector list as a view of [buffer]. Optionally it is possible
  /// to specify a [offset] in the [buffer] and a [stride] between each vector.
  Vector3List.view(Float32List buffer, [int offset = 0, int stride = 0])
      : super.view(buffer, 3, offset, stride);

  @override
  Vector3 newVector() {
    return new Vector3.zero();
  }
}
