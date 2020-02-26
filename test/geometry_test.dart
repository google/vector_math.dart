// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.geometry_test;

import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_lists.dart';
import 'package:vector_math/vector_math_geometry.dart';

import 'test_utils.dart';

void testGenerateNormals() {
  final positions = Vector3List.fromList([
    Vector3(-1.0, 1.0, 1.0),
    Vector3(1.0, 1.0, 1.0),
    Vector3(1.0, 1.0, -1.0),
    Vector3(1.0, -1.0, 1.0),
  ]);

  final indices = Uint16List.fromList([0, 1, 2, 3, 2, 1]);

  var normals = Vector3List(positions.length);

  generateNormals(normals, positions, indices);

  relativeTest(normals[0], Vector3(0.0, 1.0, 0.0));
  relativeTest(normals[1], Vector3(0.70710, 0.70710, 0.0));
  relativeTest(normals[2], Vector3(0.70710, 0.70710, 0.0));
  relativeTest(normals[3], Vector3(1.0, 0.0, 0.0));
}

void testGenerateTangents() {
  final positions = Vector3List.fromList([
    Vector3(-1.0, 1.0, 1.0),
    Vector3(1.0, 1.0, 1.0),
    Vector3(1.0, 1.0, -1.0),
    Vector3(1.0, -1.0, 1.0),
  ]);

  final normals = Vector3List.fromList([
    Vector3(0.0, 1.0, 0.0),
    Vector3(0.70710, 0.70710, 0.0),
    Vector3(0.70710, 0.70710, 0.0),
    Vector3(1.0, 0.0, 0.0),
  ]);

  final texCoords = Vector2List.fromList([
    Vector2(-1.0, 1.0),
    Vector2(1.0, 1.0),
    Vector2(1.0, -1.0),
    Vector2(-1.0, 1.0),
  ]);

  final indices = Uint16List.fromList([0, 1, 2, 3, 2, 1]);

  var tangents = Vector4List(positions.length);

  generateTangents(tangents, positions, normals, texCoords, indices);

  relativeTest(tangents[0], Vector4(1.0, 0.0, 0.0, -1.0));
  relativeTest(tangents[1], Vector4(0.70710, 0.70710, 0.0, 1.0));
  relativeTest(tangents[2], Vector4(0.70710, 0.70710, 0.0, 1.0));
  relativeTest(tangents[3], Vector4(0.0, 1.0, 0.0, 1.0));
}

MeshGeometry filterUnitCube(GeometryFilter filter) {
  var generator = CubeGenerator();
  return generator.createCube(1.0, 1.0, 1.0, filters: [filter]);
}

void testTransformFilter() {
  var scaleMat = Matrix4.identity();
  scaleMat.scale(2.0, 2.0, 2.0);
  var filter = TransformFilter(scaleMat);
  var cube = filterUnitCube(filter);

  // Check to ensure all the vertices were properly scaled
  var positions = cube.getViewForAttrib('POSITION') as Vector3List;
  for (var i = 0; i < positions.length; ++i) {
    var position = positions[i];
    expect(position.storage[0].abs(), equals(2.0));
    expect(position.storage[1].abs(), equals(2.0));
    expect(position.storage[2].abs(), equals(2.0));
  }
}

void testFlatShadeFilter() {
  var filter = FlatShadeFilter();
  var cube = filterUnitCube(filter);

  // Flat shading removes indices and duplicates vertices
  expect(cube.indices, equals(null));
  expect(cube.length, equals(36));
}

void testBarycentricFilter() {
  var filter = BarycentricFilter();
  var cube = filterUnitCube(filter);

  // Generating barycentric coords removes indices and duplicates vertices
  expect(cube.indices, equals(null));
  expect(cube.length, equals(36));

  expect(cube.getViewForAttrib('BARYCENTRIC'), isNotNull);
}

void testColorFilter() {
  var filterColor = Vector4(1.0, 0.0, 0.0, 1.0);
  var filter = ColorFilter(filterColor);
  var cube = filterUnitCube(filter);

  // Ensure that the same color was applied to all vertices
  var colors = cube.getViewForAttrib('COLOR') as Vector4List;
  for (var i = 0; i < colors.length; ++i) {
    var color = colors[i];
    relativeTest(color, filterColor);
  }
}

void testCombineIndices() {
  // Combining two meshes should generate indices that are not out of range.
  var sphereGenerator = SphereGenerator();

  var sphere0 =
      sphereGenerator.createSphere(10.0, latSegments: 8, lonSegments: 8);
  var sphere1 =
      sphereGenerator.createSphere(10.0, latSegments: 8, lonSegments: 8);

  var combined = MeshGeometry.combine([sphere0, sphere1]);
  expect(combined.indices, everyElement(lessThan(combined.length)));
}

void main() {
  group('Geometry', () {
    group('Generators', () {
      test('normal generation', testGenerateNormals);
      test('tangent generation', testGenerateTangents);
      test('geometry combination', testCombineIndices);
    });
    group('Filters', () {
      test('transform filter', testTransformFilter);
      test('flat shade filter', testFlatShadeFilter);
      test('barycentric filter', testBarycentricFilter);
      test('color filter', testColorFilter);
    });
  });
}
