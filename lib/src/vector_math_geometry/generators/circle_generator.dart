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

  void generateVertexTexCoords(Vector2List texCoords, Vector3List positions,
                          Uint16List indices) {
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
