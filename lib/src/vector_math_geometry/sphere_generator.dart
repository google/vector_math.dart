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

class SphereGenerator extends GeometryGenerator {
  double _radius;
  int _latSegments;
  int _lonSegments;

  int get vertexCount => (_lonSegments + 1) * (_latSegments + 1);
  int get indexCount => 6 * _lonSegments * _latSegments;

  MeshGeometry createSphere(num radius, {int latSegments: 16,
                            int lonSegments: 16, flags: null}) {
    _radius = radius.toDouble();
    _latSegments = latSegments;
    _lonSegments = lonSegments;

    return _createGeometry(flags);
  }

  void _generateIndices(Uint16List indices) {
    int i = 0;
    for (int y = 0; y < _latSegments; ++y) {
      int base1 = (_lonSegments + 1) * y;
      int base2 = (_lonSegments + 1) * (y+1);

      for(int x = 0; x < _lonSegments; ++x) {
        indices[i++] = base1 + x;
        indices[i++] = base1 + x + 1;
        indices[i++] = base2 + x;

        indices[i++] = base1 + x + 1;
        indices[i++] = base2 + x + 1;
        indices[i++] = base2 + x;
      }
    }
  }

  void _generatePositions(Vector3List positions, Uint16List indices) {
    int i = 0;
    for (int y = 0; y <= _latSegments; ++y) {
      double v = y / _latSegments;
      double sv = Math.sin(v * Math.PI);
      double cv = Math.cos(v * Math.PI);

      for (int x = 0; x <= _lonSegments; ++x) {
        double u = x / _lonSegments;

        positions[i++] = new Vector3(
            _radius * Math.cos(u * Math.PI * 2.0) * sv,
            _radius * cv,
            _radius * Math.sin(u * Math.PI * 2.0) * sv
        );
      }
    }
  }

  void _generateTexCoords(Vector2List texCoords, Vector3List positions,
                          Uint16List indices) {
    int i = 0;
    for (int y = 0; y <= _latSegments; ++y) {
      double v = y / _latSegments;

      for (int x = 0; x <= _lonSegments; ++x) {
        double u = x / _lonSegments;
        texCoords[i++] = new Vector2(u, v);
      }
    }
  }

  void _generateNormals(Vector3List normals, Vector3List positions,
                        Uint16List indices) {
    int i = 0;
    for (int y = 0; y <= _latSegments; ++y) {
      double v = y / _latSegments;
      double sv = Math.sin(v * Math.PI);
      double cv = Math.cos(v * Math.PI);

      for (int x = 0; x <= _lonSegments; ++x) {
        double u = x / _lonSegments;

        normals[i++] = new Vector3(
            Math.cos(u * Math.PI * 2.0) * sv,
            cv,
            Math.sin(u * Math.PI * 2.0) * sv
        );
      }
    }
  }
}