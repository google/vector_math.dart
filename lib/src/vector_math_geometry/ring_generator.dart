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

class RingGenerator extends GeometryGenerator {
  double _innerRadius;
  double _outerRadius;
  int _segments;
  double _thetaStart;
  double _thetaLength;
  bool _stripTextureCoordinates;

  int get vertexCount => (_segments + 1) * 2;
  int get indexCount => (_segments) * 3 * 2;

  MeshGeometry createRing(double innerRadius,
                          double outerRadius,
                          {flags: null,
                           segments: 64,
                           thetaStart: 0.0,
                           thetaLength: Math.PI * 2.0,
                           stripTextureCoordinates: true}) {
    _innerRadius = innerRadius;
    _outerRadius = outerRadius;
    _segments = segments;
    _thetaStart = thetaStart;
    _thetaLength = thetaLength;
    _stripTextureCoordinates = stripTextureCoordinates;
    return _createGeometry(flags);
  }

  void _generatePositions(Vector3List positions, Uint16List indices) {
    Vector3 v = new Vector3.zero();
    int index = 0;
    for (int i = 0; i <= _segments; i++) {
      double percent = i / _segments;
      v.x = _innerRadius * Math.cos(_thetaStart + percent * _thetaLength);
      v.z = _innerRadius * Math.sin(_thetaStart + percent * _thetaLength);
      positions[index] = v;
      index++;
      v.x = _outerRadius * Math.cos(_thetaStart + percent * _thetaLength);
      v.z = _outerRadius * Math.sin(_thetaStart + percent * _thetaLength);
      positions[index] = v;
      index++;
    }
    assert(index == vertexCount);
  }

  void _generateTexCoords(Vector2List texCoords, Vector3List positions,
                          Uint16List indices) {
    if (_stripTextureCoordinates) {
      Vector2 v = new Vector2.zero();
      int index = 0;
      for (int i = 0; i <= _segments; i++) {
        double percent = i / _segments;
        v.x = 0.0;
        v.y = percent;
        texCoords[index] = v;
        index++;
        v.x = 1.0;
        v.y = percent;
        texCoords[index] = v;
        index++;
      }
    } else {
      Vector2 v = new Vector2.zero();
      int index = 0;
      for (int i = 0; i <= _segments; i++) {
        Vector3 position = positions[index];
        double x = (position.x / (_outerRadius + 1.0)) * 0.5;
        double y = (position.z / (_outerRadius + 1.0)) * 0.5;
        v.x = x + 0.5;
        v.y = y + 0.5;
        texCoords[index] = v;
        index++;
        position = positions[index];
        x = (position.x / (_outerRadius + 1.0)) * 0.5;
        y = (position.z / (_outerRadius + 1.0)) * 0.5;
        v.x = x + 0.5;
        v.y = y + 0.5;
        texCoords[index] = v;
        index++;
      }
      assert(index == vertexCount);
    }
  }

  void _generateIndices(Uint16List indices) {
    int index = 0;
    int length = _segments * 2;
    for (int i = 0; i < length; i += 2) {
      indices[index + 0] = i + 0;
      indices[index + 1] = i + 1;
      indices[index + 2] = i + 3;
      indices[index + 3] = i + 0;
      indices[index + 4] = i + 3;
      indices[index + 5] = i + 2;
      index += 6;
    }
    assert(index == indexCount);
  }
}