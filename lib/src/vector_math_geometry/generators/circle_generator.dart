// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_geometry;

class CircleGenerator extends GeometryGenerator {
  double _radius;
  int _segments;
  double _thetaStart;
  double _thetaLength;

  @override
  int get vertexCount => _segments + 2;

  @override
  int get indexCount => (_segments) * 3;

  MeshGeometry createCircle(double radius,
      {GeometryGeneratorFlags flags,
      List<GeometryFilter> filters,
      int segments: 64,
      double thetaStart: 0.0,
      double thetaLength: math.pi * 2.0}) {
    _radius = radius;
    _segments = segments;
    _thetaStart = thetaStart;
    _thetaLength = thetaLength;
    return createGeometry(flags: flags, filters: filters);
  }

  @override
  void generateVertexPositions(Vector3List positions, Uint16List indices) {
    final Vector3 v = new Vector3.zero();
    positions[0] = v;
    int index = 1;
    for (int i = 0; i <= _segments; i++) {
      final double percent = i / _segments;
      v
        ..x = _radius * math.cos(_thetaStart + percent * _thetaLength)
        ..z = _radius * math.sin(_thetaStart + percent * _thetaLength);
      positions[index] = v;
      index++;
    }
    assert(index == vertexCount);
  }

  @override
  void generateVertexTexCoords(
      Vector2List texCoords, Vector3List positions, Uint16List indices) {
    final Vector2 v = new Vector2(0.5, 0.5);
    texCoords[0] = v;
    int index = 1;
    for (int i = 0; i <= _segments; i++) {
      final Vector3 position = positions[index];
      final double x = (position.x / (_radius + 1.0)) * 0.5;
      final double y = (position.z / (_radius + 1.0)) * 0.5;
      v
        ..x = x + 0.5
        ..y = y + 0.5;
      texCoords[index] = v;
      index++;
    }
    assert(index == vertexCount);
  }

  @override
  void generateIndices(Uint16List indices) {
    int index = 0;
    for (int i = 1; i <= _segments; i++) {
      indices[index] = i;
      indices[index + 1] = i + 1;
      indices[index + 2] = 0;
      index += 3;
    }
    assert(index == indexCount);
  }
}
