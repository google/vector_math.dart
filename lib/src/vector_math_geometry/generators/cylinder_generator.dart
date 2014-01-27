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

class CylinderGenerator extends GeometryGenerator {
  double _topRadius;
  double _bottomRadius;
  double _height;
  int _segments;

  int get vertexCount => ((_segments + 1) * 2) + (_segments * 2);
  int get indexCount => (_segments * 6) + ((_segments - 2) * 6);

  MeshGeometry createCylinder(num topRadius, num bottomRadius,
                              num height, {int segments: 16, flags: null, filters: null}) {
    _topRadius = topRadius.toDouble();
    _bottomRadius = bottomRadius.toDouble();
    _height = height.toDouble();
    _segments = segments;

    return createGeometry(flags: flags, filters: filters);
  }

  void generateIndices(Uint16List indices) {
    int i = 0;

    // Sides
    int base1 = 0;
    int base2 = _segments + 1;
    for (int x = 0; x < _segments; ++x) {
      indices[i++] = base1 + x;
      indices[i++] = base1 + x + 1;
      indices[i++] = base2 + x;

      indices[i++] = base1 + x + 1;
      indices[i++] = base2 + x + 1;
      indices[i++] = base2 + x;
    }

    // Top cap
    base1 = (_segments + 1) * 2;
    for (int x = 1; x < _segments - 1; ++x) {
      indices[i++] = base1;
      indices[i++] = base1 + x + 1;
      indices[i++] = base1 + x;
    }

    // Bottom cap
    base1 = (_segments + 1) * 2 + _segments;
    for (int x = 1; x < _segments - 1; ++x) {
      indices[i++] = base1;
      indices[i++] = base1 + x;
      indices[i++] = base1 + x + 1;
    }
  }

  void generateVertexPositions(Vector3List positions, Uint16List indices) {
    int i = 0;

    // Top
    for (int x = 0; x <= _segments; ++x) {
      double u = x / _segments;

      positions[i++] = new Vector3(
          _topRadius * Math.cos(u * Math.PI * 2.0),
          _height * 0.5,
          _topRadius * Math.sin(u * Math.PI * 2.0)
      );
    }

    // Bottom
    for (int x = 0; x <= _segments; ++x) {
      double u = x / _segments;

      positions[i++] = new Vector3(
          _bottomRadius * Math.cos(u * Math.PI * 2.0),
          _height * -0.5,
          _bottomRadius * Math.sin(u * Math.PI * 2.0)
      );
    }

    // Top cap
    for (int x = 0; x < _segments; ++x) {
      double u = x / _segments;

      positions[i++] = new Vector3(
          _topRadius * Math.cos(u * Math.PI * 2.0),
          _height * 0.5,
          _topRadius * Math.sin(u * Math.PI * 2.0)
      );
    }

    // Bottom cap
    for (int x = 0; x < _segments; ++x) {
      double u = x / _segments;

      positions[i++] = new Vector3(
          _bottomRadius * Math.cos(u * Math.PI * 2.0),
          _height * -0.5,
          _bottomRadius * Math.sin(u * Math.PI * 2.0)
      );
    }
  }

  void generateVertexTexCoords(Vector2List texCoords, Vector3List positions,
                          Uint16List indices) {
    int i = 0;

    // Cylinder top
    for (int x = 0; x <= _segments; ++x) {
      double u = 1.0 - (x / _segments);
      texCoords[i++] = new Vector2(u, 0.0);
    }

    // Cylinder bottom
    for (int x = 0; x <= _segments; ++x) {
      double u = 1.0 - (x / _segments);
      texCoords[i++] = new Vector2(u, 1.0);
    }

    // Top cap
    for (int x = 0; x < _segments; ++x) {
      double r = (x / _segments) * Math.PI * 2.0;
      texCoords[i++] = new Vector2(
          (Math.cos(r) * 0.5 + 0.5),
          (Math.sin(r) * 0.5 + 0.5)
      );
    }

    // Bottom cap
    for (int x = 0; x < _segments; ++x) {
      double r = (x / _segments) * Math.PI * 2.0;
      texCoords[i++] = new Vector2(
          (Math.cos(r) * 0.5 + 0.5),
          (Math.sin(r) * 0.5 + 0.5)
      );
    }
  }
}
