// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_geometry;

class SphereGenerator extends GeometryGenerator {
  double _radius;
  int _latSegments;
  int _lonSegments;

  @override
  int get vertexCount => (_lonSegments + 1) * (_latSegments + 1);

  @override
  int get indexCount => 6 * _lonSegments * _latSegments;

  MeshGeometry createSphere(num radius,
      {int latSegments: 16,
      int lonSegments: 16,
      GeometryGeneratorFlags flags,
      List<GeometryFilter> filters}) {
    _radius = radius.toDouble();
    _latSegments = latSegments;
    _lonSegments = lonSegments;

    return createGeometry(flags: flags, filters: filters);
  }

  @override
  void generateIndices(Uint16List indices) {
    int i = 0;
    for (int y = 0; y < _latSegments; ++y) {
      final int base1 = (_lonSegments + 1) * y;
      final int base2 = (_lonSegments + 1) * (y + 1);

      for (int x = 0; x < _lonSegments; ++x) {
        indices[i++] = base1 + x;
        indices[i++] = base1 + x + 1;
        indices[i++] = base2 + x;

        indices[i++] = base1 + x + 1;
        indices[i++] = base2 + x + 1;
        indices[i++] = base2 + x;
      }
    }
  }

  @override
  void generateVertexPositions(Vector3List positions, Uint16List indices) {
    int i = 0;
    for (int y = 0; y <= _latSegments; ++y) {
      final double v = y / _latSegments;
      final double sv = math.sin(v * math.pi);
      final double cv = math.cos(v * math.pi);

      for (int x = 0; x <= _lonSegments; ++x) {
        final double u = x / _lonSegments;

        positions[i++] = new Vector3(_radius * math.cos(u * math.pi * 2.0) * sv,
            _radius * cv, _radius * math.sin(u * math.pi * 2.0) * sv);
      }
    }
  }

  @override
  void generateVertexTexCoords(
      Vector2List texCoords, Vector3List positions, Uint16List indices) {
    int i = 0;
    for (int y = 0; y <= _latSegments; ++y) {
      final double v = y / _latSegments;

      for (int x = 0; x <= _lonSegments; ++x) {
        final double u = x / _lonSegments;
        texCoords[i++] = new Vector2(u, v);
      }
    }
  }

  @override
  void generateVertexNormals(
      Vector3List normals, Vector3List positions, Uint16List indices) {
    int i = 0;
    for (int y = 0; y <= _latSegments; ++y) {
      final double v = y / _latSegments;
      final double sv = math.sin(v * math.pi);
      final double cv = math.cos(v * math.pi);

      for (int x = 0; x <= _lonSegments; ++x) {
        final double u = x / _lonSegments;

        normals[i++] = new Vector3(math.cos(u * math.pi * 2.0) * sv, cv,
            math.sin(u * math.pi * 2.0) * sv);
      }
    }
  }
}
