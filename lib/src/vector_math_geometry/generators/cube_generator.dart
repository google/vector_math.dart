// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_geometry;

class CubeGenerator extends GeometryGenerator {
  double _width;
  double _height;
  double _depth;

  @override
  int get vertexCount => 24;

  @override
  int get indexCount => 36;

  MeshGeometry createCube(num width, num height, num depth,
      {GeometryGeneratorFlags flags, List<GeometryFilter> filters}) {
    _width = width.toDouble();
    _height = height.toDouble();
    _depth = depth.toDouble();

    return createGeometry(flags: flags, filters: filters);
  }

  @override
  void generateIndices(Uint16List indices) {
    indices.setAll(0, <int>[
      0,
      1,
      2,
      0,
      2,
      3,
      4,
      5,
      6,
      4,
      6,
      7,
      8,
      9,
      10,
      8,
      10,
      11,
      12,
      13,
      14,
      12,
      14,
      15,
      16,
      17,
      18,
      16,
      18,
      19,
      20,
      21,
      22,
      20,
      22,
      23
    ]);
  }

  @override
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

  @override
  void generateVertexTexCoords(
      Vector2List texCoords, Vector3List positions, Uint16List indices) {
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
