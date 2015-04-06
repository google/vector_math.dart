// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_geometry;

class TransformFilter extends InplaceGeometryFilter {
  Matrix4 transform;
  List<VertexAttrib> get requires => [new VertexAttrib('POSITION', 3, 'float')];

  TransformFilter(Matrix4 this.transform);

  void filterInplace(MeshGeometry mesh) {
    Vector3List position = mesh.getViewForAttrib('POSITION');
    if (position != null) {
      for (int i = 0; i < position.length; ++i) {
        position[i] = transform * position[i];
      }
    }
  }
}
