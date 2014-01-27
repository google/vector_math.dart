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

part of vector_math_geometry;

class BarycentricFilter extends GeometryFilter {
  List<VertexAttrib> get generates => [new VertexAttrib('BARYCENTRIC', 3, 'float')];

  MeshGeometry filter(MeshGeometry mesh) {
    List<VertexAttrib> newAttribs = new List<VertexAttrib>.from(mesh.attribs, growable: true);

    if (mesh.getAttrib('BARYCENTRIC') == null) {
      newAttribs.add(new VertexAttrib('BARYCENTRIC', 3, 'float'));
    }

    MeshGeometry output = new MeshGeometry(mesh.triangleVertexCount, newAttribs);
    Vector3List barycentricCoords = output.getViewForAttrib('BARYCENTRIC');

    List<VectorList> srcAttribs = new List<VectorList>();
    List<VectorList> destAttribs = new List<VectorList>();
    for (VertexAttrib attrib in mesh.attribs) {
      if (attrib.name == 'BARYCENTRIC') {
        continue;
      }

      srcAttribs.add(mesh.getViewForAttrib(attrib.name));
      destAttribs.add(output.getViewForAttrib(attrib.name));
    }

    Vector3 b0 = new Vector3(1.0, 0.0, 0.0);
    Vector3 b1 = new Vector3(0.0, 1.0, 0.0);
    Vector3 b2 = new Vector3(0.0, 0.0, 1.0);

    int i0, i1, i2;

    for (int i = 0; i < output.length; i += 3) {
      if (mesh.indices != null) {
        i0 = mesh.indices[i];
        i1 = mesh.indices[i + 1];
        i2 = mesh.indices[i + 2];
      } else {
        i0 = i;
        i1 = i + 1;
        i2 = i + 2;
      }

      barycentricCoords[i] = b0;
      barycentricCoords[i + 1] = b1;
      barycentricCoords[i + 2] = b2;

      // Copy the remaining attributes over
      for (int j = 0; j < srcAttribs.length; ++j) {
        destAttribs[j][i] = srcAttribs[j][i0];
        destAttribs[j][i + 1] = srcAttribs[j][i1];
        destAttribs[j][i + 2] = srcAttribs[j][i2];
      }
    }

    return output;
  }
}
