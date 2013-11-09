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

/// Generate vertex normals based on a list of [positions] and [indices].
/// [normals] is assumed to be zeroed out, and much match [positions] in length.
/// [indices] is assumed to represent a triangle list.
void generateNormals(Vector3List normals, Vector3List positions,
                     Uint16List indices) {
  Vector3 p0 = new Vector3.zero(),
          p1 = new Vector3.zero(),
          p2 = new Vector3.zero(),
          norm = new Vector3.zero();

  // Loop through every polygon, find it's normal, and add that to the vertex
  // normals.
  for (int i = 0; i < indices.length; i+=3) {
    int i0 = indices[i], i1 = indices[i+1], i2 = indices[i+2];
    positions.load(i0, p0);
    positions.load(i1, p1);
    positions.load(i2, p2);

    p1.sub(p0);
    p2.sub(p0);

    // Store the normalized cross product of p1 and p2 in p0.
    p1.crossInto(p2, p0).normalize();

    // Add the face normal to each vertex normal.
    normals.load(i0, norm);
    normals[i0] = norm.add(p0);

    normals.load(i1, norm);
    normals[i1] = norm.add(p0);

    normals.load(i2, norm);
    normals[i2] = norm.add(p0);
  }

  // Loop through all the normals and normalize them.
  for (int i = 0; i < normals.length; ++i) {
    normals.load(i, norm);
    normals[i] = norm.normalize();
  }
}

/// Generate vertex tangents based on a list of [positions], [normals],
/// [texCoords] and [indices].
/// [tangents] is assumed to be zeroed out, and much match [positions],
/// [normals], and [texCoords] in length.
/// [indices] is assumed to represent a triangle list.
/// Tangents are returned as Vector4s. The X, Y, and Z component represent
/// the tangent and the W component represents the direction of the bitangent
/// which can be generated as:
/// vec4 bitangent = cross(normal, tangent.xyz) * tangent.w;
/// Derived from the granddaddy of all tangent generation functions:
/// http://www.terathon.com/code/tangent.html
void generateTangents(Vector4List tangents, Vector3List positions,
                      Vector3List normals, Vector2List texCoords,
                      Uint16List indices) {
  Vector3 p0 = new Vector3.zero(),
      p1 = new Vector3.zero(),
      p2 = new Vector3.zero(),
      n = new Vector3.zero(),
      t = new Vector3.zero(),
      udir = new Vector3.zero(),
      vdir = new Vector3.zero();

  Vector2 uv0 = new Vector2.zero(),
      uv1 = new Vector2.zero(),
      uv2 = new Vector2.zero();

  Vector4 tan = new Vector4.zero();

  Vector3List tan0 = new Vector3List(positions.length),
      tan1 = new Vector3List(positions.length);

  for (int i = 0; i < indices.length; i+=3) {
    int i0 = indices[i], i1 = indices[i+1], i2 = indices[i+2];
    positions.load(i0, p0);
    positions.load(i1, p1);
    positions.load(i2, p2);

    texCoords.load(i0, uv0);
    texCoords.load(i1, uv1);
    texCoords.load(i2, uv2);

    p1.sub(p0);
    p2.sub(p0);

    uv1.sub(uv0);
    uv2.sub(uv0);

    double r = 1.0 / (uv1.x * uv2.y - uv2.x * uv1.y);

    udir.setValues((uv2.y * p1.x - uv1.y * p2.x) * r,
        (uv2.y * p1.y - uv1.y * p2.y) * r,
        (uv2.y * p1.z - uv1.y * p2.z) * r);
    vdir.setValues((uv1.x * p2.x - uv2.x * p1.x) * r,
        (uv1.x * p2.y - uv2.x * p1.y) * r,
        (uv1.x * p2.z - uv2.x * p1.z) * r);

    tan0.load(i0, p0);
    tan0[i0] = p0.add(udir);
    tan0.load(i1, p0);
    tan0[i1] = p0.add(udir);
    tan0.load(i2, p0);
    tan0[i2] = p0.add(udir);

    tan1.load(i0, p0);
    tan1[i0] = p0.add(vdir);
    tan1.load(i1, p0);
    tan1[i1] = p0.add(vdir);
    tan1.load(i2, p0);
    tan1[i2] = p0.add(vdir);
  }

  for (int i = 0; i < tangents.length; ++i) {
    normals.load(i, n);
    tan0.load(i, t);

    p1.setFrom(n).scale(n.dot(t));
    p0.setFrom(t).sub(p1).normalize();

    tan1.load(i, p1);
    n.crossInto(t, p2);
    double sign = (p2.dot(p1) < 0.0) ? -1.0 : 1.0;

    tangents.load(i, tan);
    tangents[i] = tan.setValues(p0.x, p0.y, p0.z, sign);
  }
}

