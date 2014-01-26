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

class FlatShadeFilter extends GeometryFilter {
  List<VertexAttrib> get requires => [new VertexAttrib('POSITION', 3, 'float')];
  List<VertexAttrib> get generates => [new VertexAttrib('NORMAL', 3, 'float')];

  MeshGeometry filter(MeshGeometry mesh) {
    List<VertexAttrib> newAttribs = new List<VertexAttrib>.from(mesh.attribs, growable: true);

    if (mesh.getAttrib('NORMAL') == null) {
      newAttribs.add(new VertexAttrib('NORMAL', 3, 'float'));
    }

    MeshGeometry output = new MeshGeometry(mesh.triangleVertexCount, newAttribs);

    Vector3 p0 = new Vector3.zero(),
        p1 = new Vector3.zero(),
        p2 = new Vector3.zero(),
        norm = new Vector3.zero();

    Vector3List srcPosition = mesh.getViewForAttrib('POSITION');
    Vector3List destPosition = output.getViewForAttrib('POSITION');
    Vector3List normals = output.getViewForAttrib('NORMAL');

    List<VectorList> srcAttribs = new List<VectorList>();
    List<VectorList> destAttribs = new List<VectorList>();
    for (VertexAttrib attrib in mesh.attribs) {
      if (attrib.name == 'POSITION' || attrib.name == 'NORMAL') {
        continue;
      }

      srcAttribs.add(mesh.getViewForAttrib(attrib.name));
      destAttribs.add(output.getViewForAttrib(attrib.name));
    }

    for (int i = 0; i < output.length; i += 3) {
      int i0 = mesh.indices[i];
      int i1 = mesh.indices[i + 1];
      int i2 = mesh.indices[i + 2];

      srcPosition.load(i0, p0);
      srcPosition.load(i1, p1);
      srcPosition.load(i2, p2);

      destPosition[i] = p0;
      destPosition[i + 1] = p1;
      destPosition[i + 2] = p2;

      // Store the normalized cross product of p1 and p2 in p0.
      p1.sub(p0);
      p2.sub(p0);
      p1.crossInto(p2, p0).normalize();

      normals[i] = p0;
      normals[i + 1] = p0;
      normals[i + 2] = p0;

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
