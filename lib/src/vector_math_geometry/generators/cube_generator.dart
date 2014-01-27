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

class CubeGenerator extends GeometryGenerator {
  double _width;
  double _height;
  double _depth;

  int get vertexCount => 24;
  int get indexCount => 36;

  MeshGeometry createCube(num width, num height, num depth,
                          {flags: null, filters: null}) {
    _width = width.toDouble();
    _height = height.toDouble();
    _depth = depth.toDouble();

    return createGeometry(flags: flags, filters: filters);
  }

  void generateIndices(Uint16List indices) {
    indices.setAll(0, [
      0, 1, 2, 0, 2, 3,
      4, 5, 6, 4, 6, 7,
      8, 9, 10, 8, 10, 11,
      12, 13, 14, 12, 14, 15,
      16, 17, 18, 16, 18, 19,
      20, 21, 22, 20, 22, 23
    ]);
  }

  void generateVertexPositions(Vector3List positions, Uint16List indices) {
    // Front
    positions[0] = new Vector3(_width, _height, _depth);
    positions[1] = new Vector3(-_width, _height, _depth);
    positions[2] = new Vector3(-_width, -_height, _depth);
    positions[3] = new Vector3(_width, -_height, _depth);

    // Back
    positions[4] = new Vector3(_width, -_height, -_depth);
    positions[5] = new Vector3(-_width, -_height, -_depth);
    positions[6] = new Vector3(-_width, _height, -_depth);
    positions[7] = new Vector3(_width, _height, -_depth);

    // Right
    positions[8] = new Vector3(_width, -_height, _depth);
    positions[9] = new Vector3(_width, -_height, -_depth);
    positions[10] = new Vector3(_width, _height, -_depth);
    positions[11] = new Vector3(_width, _height, _depth);

    // Left
    positions[12] = new Vector3(-_width, _height, _depth);
    positions[13] = new Vector3(-_width, _height, -_depth);
    positions[14] = new Vector3(-_width, -_height, -_depth);
    positions[15] = new Vector3(-_width, -_height, _depth);

    // Top
    positions[16] = new Vector3(_width, _height, _depth);
    positions[17] = new Vector3(_width, _height, -_depth);
    positions[18] = new Vector3(-_width, _height, -_depth);
    positions[19] = new Vector3(-_width, _height, _depth);

    // Bottom
    positions[20] = new Vector3(-_width, -_height, _depth);
    positions[21] = new Vector3(-_width, -_height, -_depth);
    positions[22] = new Vector3(_width, -_height, -_depth);
    positions[23] = new Vector3(_width, -_height, _depth);
  }

  void generateVertexTexCoords(Vector2List texCoords, Vector3List positions,
                          Uint16List indices) {
    // Front
    texCoords[0] = new Vector2(1.0, 0.0);
    texCoords[1] = new Vector2(0.0, 0.0);
    texCoords[2] = new Vector2(0.0, 1.0);
    texCoords[3] = new Vector2(1.0, 1.0);

    // Back
    texCoords[4] = new Vector2(0.0, 1.0);
    texCoords[5] = new Vector2(1.0, 1.0);
    texCoords[6] = new Vector2(1.0, 0.0);
    texCoords[7] = new Vector2(0.0, 0.0);

    // Right
    texCoords[8] = new Vector2(0.0, 1.0);
    texCoords[9] = new Vector2(1.0, 1.0);
    texCoords[10] = new Vector2(1.0, 0.0);
    texCoords[11] = new Vector2(0.0, 0.0);

    // Left
    texCoords[12] = new Vector2(1.0, 0.0);
    texCoords[13] = new Vector2(0.0, 0.0);
    texCoords[14] = new Vector2(0.0, 1.0);
    texCoords[15] = new Vector2(1.0, 1.0);

    // Top
    texCoords[16] = new Vector2(1.0, 1.0);
    texCoords[17] = new Vector2(1.0, 0.0);
    texCoords[18] = new Vector2(0.0, 0.0);
    texCoords[19] = new Vector2(0.0, 1.0);

    // Bottom
    texCoords[20] = new Vector2(0.0, 0.0);
    texCoords[21] = new Vector2(0.0, 1.0);
    texCoords[22] = new Vector2(1.0, 1.0);
    texCoords[23] = new Vector2(1.0, 0.0);
  }
}
