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
  final bool invertFaces;

  GeometryGeneratorFlags({this.texCoords: true,
                          this.normals: true,
                          this.tangents: true,
                          this.invertFaces: false});
}

abstract class GeometryGenerator {
  int get vertexCount;
  int get indexCount;

  MeshGeometry _createGeometry(GeometryGeneratorFlags flags) {
    MeshGeometry mesh = new MeshGeometry();

    if (flags == null)
      flags = new GeometryGeneratorFlags();

    int stride = 12; // Position
    if (flags.texCoords || flags.tangents)
      stride += 8;
    if (flags.normals)
      stride += 12;
    if (flags.tangents)
      stride += 16;

    VertexAttrib positionAttrib;
    VertexAttrib texCoordAttrib;
    VertexAttrib normalAttrib;
    VertexAttrib tangentAttrib;;

    Vector2List texCoordView;
    Vector3List positionView;
    Vector3List normalView;
    Vector4List tangentView;

    mesh.buffer = new Float32List(vertexCount * (stride~/4));
    mesh.indices = new Uint16List(indexCount);

    _generateIndices(mesh.indices);

    int offset = 0;

    positionAttrib = new VertexAttrib('POSITION', 3, 'float', stride, offset);
    mesh.addAttrib(positionAttrib);
    offset += 12;
    positionView = mesh.getViewForAttrib('POSITION');
    _generatePositions(positionView, mesh.indices);

    if (flags.texCoords || flags.tangents) {
      texCoordAttrib = new VertexAttrib('TEXCOORD0', 2, 'float', stride,
                                        offset);
      mesh.addAttrib(texCoordAttrib);
      offset += 8;
      texCoordView = mesh.getViewForAttrib('TEXCOORD0');
      _generateTexCoords(texCoordView, positionView, mesh.indices);
    }

    if (flags.normals) {
      normalAttrib = new VertexAttrib('NORMAL', 3, 'float', stride, offset);
      mesh.addAttrib(normalAttrib);
      offset += 12;
      normalView = mesh.getViewForAttrib('NORMAL');
      _generateNormals(normalView, positionView, mesh.indices);
    }

    if (flags.tangents) {
      tangentAttrib = new VertexAttrib('TANGENT', 4, 'float', stride, offset);
      mesh.addAttrib(tangentAttrib);
      offset += 16;
      tangentView = mesh.getViewForAttrib('TANGENT');
      _generateTangents(tangentView, positionView, normalView, texCoordView,
          mesh.indices);
    }

    if (flags.invertFaces) {
      _invertMeshFaces(mesh);
    }

    return mesh;
  }

  void _generateIndices(Uint16List indices);

  void _generatePositions(Vector3List positions, Uint16List indices);

  void _generateTexCoords(Vector2List texCoords, Vector3List positions,
                         Uint16List indices) {
    for (int i = 0; i < positions.length; ++i) {
      Vector3 p = positions[i];

      // These are TERRIBLE texture coords, but it's better than nothing.
      // Override this function and put better ones in place!
      texCoords[i] = new Vector2(p.x + p.z, p.y + p.z);
    }
  }

  void _generateNormals(Vector3List normals, Vector3List positions,
                       Uint16List indices) {
    generateNormals(normals, positions, indices);
  }

  void _generateTangents(Vector4List tangents, Vector3List positions,
                         Vector3List normals, Vector2List texCoords,
                        Uint16List indices) {
    generateTangents(tangents, positions, normals, texCoords, indices);
  }

  void _invertMeshFaces(MeshGeometry mesh) {
    // Swap all the triangle indices
    for (int i=0; i < mesh.indices.length; i += 3) {
      int tmp = mesh.indices[i];
      mesh.indices[i] = mesh.indices[i+2];
      mesh.indices[i+2] = tmp;
    }

    Vector3List normals = mesh.getViewForAttrib('NORMAL');
    if (normals != null) {
      for(int i=0; i < normals.length; ++i) {
        normals[i] = -normals[i];
      }
    }

    // TODO: Do the tangents need to be inverted? Maybe just the W component?
  }
}