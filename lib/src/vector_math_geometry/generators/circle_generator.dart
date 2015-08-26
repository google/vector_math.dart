// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_geometry;

class CircleGenerator extends GeometryGenerator {
  double _radius;
  int _segments;
  double _thetaStart;
  double _thetaLength;

  int get vertexCount => _segments + 2;
  int get indexCount => (_segments) * 3;

  MeshGeometry createCircle(double radius,
      {flags: null,
      filters: null,
      segments: 64,
      thetaStart: 0.0,
      thetaLength: Math.PI * 2.0}) {
    _radius = radius;
    _segments = segments;
    _thetaStart = thetaStart;
    _thetaLength = thetaLength;
    return createGeometry(flags: flags, filters: filters);
  }

  void generateVertexPositions(Vector3List positions, Uint16List indices) {
    Vector3 v = new Vector3.zero();
    positions[0] = v;
    int index = 1;
    for (int i = 0; i <= _segments; i++) {
      double percent = i / _segments;
      v.x = _radius * Math.cos(_thetaStart + percent * _thetaLength);
      v.z = _radius * Math.sin(_thetaStart + percent * _thetaLength);
      positions[index] = v;
      index++;
    }
    assert(index == vertexCount);
  }

  void generateVertexTexCoords(
      Vector2List texCoords, Vector3List positions, Uint16List indices) {
    Vector2 v = new Vector2(0.5, 0.5);
    texCoords[0] = v;
    int index = 1;
    for (int i = 0; i <= _segments; i++) {
      Vector3 position = positions[index];
      double x = (position.x / (_radius + 1.0)) * 0.5;
      double y = (position.z / (_radius + 1.0)) * 0.5;
      v.x = x + 0.5;
      v.y = y + 0.5;
      texCoords[index] = v;
      index++;
    }
    assert(index == vertexCount);
  }

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
