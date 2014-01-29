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

class GeometryGeneratorFlags {
  final bool texCoords;
  final bool normals;
  final bool tangents;

  GeometryGeneratorFlags({this.texCoords: true,
                          this.normals: true,
                          this.tangents: true});
}

abstract class GeometryGenerator {
  int get vertexCount;
  int get indexCount;

  MeshGeometry createGeometry({GeometryGeneratorFlags flags: null, List filters: null}) {

    if (flags == null)
      flags = new GeometryGeneratorFlags();

    VertexAttrib positionAttrib;
    VertexAttrib texCoordAttrib;
    VertexAttrib normalAttrib;
    VertexAttrib tangentAttrib;

    Vector2List texCoordView;
    Vector3List positionView;
    Vector3List normalView;
    Vector4List tangentView;

    List<VertexAttrib> attribs = new List<VertexAttrib>();

    positionAttrib = new VertexAttrib('POSITION', 3, 'float');
    attribs.add(positionAttrib);

    if (flags.texCoords || flags.tangents) {
      texCoordAttrib = new VertexAttrib('TEXCOORD0', 2, 'float');
      attribs.add(texCoordAttrib);
    }

    if (flags.normals || flags.tangents) {
      normalAttrib = new VertexAttrib('NORMAL', 3, 'float');
      attribs.add(normalAttrib);
    }

    if (flags.tangents) {
      tangentAttrib = new VertexAttrib('TANGENT', 4, 'float');
      attribs.add(tangentAttrib);
    }

    MeshGeometry mesh = new MeshGeometry(vertexCount, attribs);

    mesh.indices = new Uint16List(indexCount);
    generateIndices(mesh.indices);

    positionView = mesh.getViewForAttrib('POSITION');
    generateVertexPositions(positionView, mesh.indices);

    if (flags.texCoords || flags.tangents) {
      texCoordView = mesh.getViewForAttrib('TEXCOORD0');
      generateVertexTexCoords(texCoordView, positionView, mesh.indices);
    }

    if (flags.normals || flags.tangents) {
      normalView = mesh.getViewForAttrib('NORMAL');
      generateVertexNormals(normalView, positionView, mesh.indices);
    }

    if (flags.tangents) {
      tangentView = mesh.getViewForAttrib('TANGENT');
      generateVertexTangents(tangentView, positionView, normalView, texCoordView,
          mesh.indices);
    }

    if (filters != null) {
      for (var filter in filters) {
        if (filter.inplace) {
          filter.filterInplace(mesh);
        } else {
          mesh = filter.filter(mesh);
        }
      }
    }

    return mesh;
  }

  void generateIndices(Uint16List indices);

  void generateVertexPositions(Vector3List positions, Uint16List indices);

  void generateVertexTexCoords(Vector2List texCoords, Vector3List positions,
                         Uint16List indices) {
    for (int i = 0; i < positions.length; ++i) {
      Vector3 p = positions[i];

      // These are TERRIBLE texture coords, but it's better than nothing.
      // Override this function and put better ones in place!
      texCoords[i] = new Vector2(p.x + p.z, p.y + p.z);
    }
  }

  void generateVertexNormals(Vector3List normals, Vector3List positions,
                       Uint16List indices) {
    generateNormals(normals, positions, indices);
  }

  void generateVertexTangents(Vector4List tangents, Vector3List positions,
                         Vector3List normals, Vector2List texCoords,
                        Uint16List indices) {
    generateTangents(tangents, positions, normals, texCoords, indices);
  }
}
