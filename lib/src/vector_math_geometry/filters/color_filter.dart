// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_geometry;

class ColorFilter extends GeometryFilter {
  Vector4 color;

  List<VertexAttrib> get generates => [new VertexAttrib('COLOR', 4, 'float')];

  ColorFilter(Vector4 this.color);

  MeshGeometry filter(MeshGeometry mesh) {
    MeshGeometry output;
    if (mesh.getAttrib('COLOR') == null) {
      List<VertexAttrib> attributes = new List<VertexAttrib>();
      attributes.addAll(mesh.attribs);
      attributes.add(new VertexAttrib('COLOR', 4, 'float'));
      output = new MeshGeometry.resetAttribs(mesh, attributes);
    } else {
      output = new MeshGeometry.copy(mesh);
    }

    Vector4List colors = output.getViewForAttrib('COLOR');
    for (int i = 0; i < colors.length; ++i) {
      colors[i] = color;
    }

    return output;
  }
}
