part of vector_math_test;

class GeometryTest extends BaseTest {
  void testGenerateNormals() {
    final Vector3List positions = new Vector3List.fromList([
      new Vector3(-1.0, 1.0, 1.0),
      new Vector3(1.0, 1.0, 1.0),
      new Vector3(1.0, 1.0, -1.0),
      new Vector3(1.0, -1.0, 1.0),
    ]);

    final Uint16List indices = new Uint16List.fromList([
      0, 1, 2,
      3, 2, 1
    ]);

    Vector3List normals = new Vector3List(positions.length);

    generateNormals(normals, positions, indices);

    relativeTest(normals[0], new Vector3(0.0, 1.0, 0.0));
    relativeTest(normals[1], new Vector3(0.70710, 0.70710, 0.0));
    relativeTest(normals[2], new Vector3(0.70710, 0.70710, 0.0));
    relativeTest(normals[3], new Vector3(1.0, 0.0, 0.0));
  }

  void testGenerateTangents() {
    final Vector3List positions = new Vector3List.fromList([
      new Vector3(-1.0, 1.0, 1.0),
      new Vector3(1.0, 1.0, 1.0),
      new Vector3(1.0, 1.0, -1.0),
      new Vector3(1.0, -1.0, 1.0),
    ]);

    final Vector3List normals = new Vector3List.fromList([
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(0.70710, 0.70710, 0.0),
      new Vector3(0.70710, 0.70710, 0.0),
      new Vector3(1.0, 0.0, 0.0),
    ]);

    final Vector2List texCoords = new Vector2List.fromList([
      new Vector2(-1.0, 1.0),
      new Vector2(1.0, 1.0),
      new Vector2(1.0, -1.0),
      new Vector2(-1.0, 1.0),
    ]);

    final Uint16List indices = new Uint16List.fromList([
      0, 1, 2,
      3, 2, 1
    ]);

    Vector4List tangents = new Vector4List(positions.length);

    generateTangents(tangents, positions, normals, texCoords, indices);

    relativeTest(tangents[0], new Vector4(1.0, 0.0, 0.0, -1.0));
    relativeTest(tangents[1], new Vector4(0.70710, 0.70710, 0.0, 1.0));
    relativeTest(tangents[2], new Vector4(0.70710, 0.70710, 0.0, 1.0));
    relativeTest(tangents[3], new Vector4(0.0, 1.0, 0.0, 1.0));
  }

  MeshGeometry filterUnitCube(GeometryFilter filter) {
    CubeGenerator generator = new CubeGenerator();
    return generator.createCube(1.0, 1.0, 1.0, filters: [filter]);
  }

  void testTransformFilter() {
    Matrix4 scaleMat = new Matrix4.identity();
    scaleMat.scale(2.0, 2.0, 2.0);
    TransformFilter filter = new TransformFilter(scaleMat);
    MeshGeometry cube = filterUnitCube(filter);

    // Check to ensure all the vertices were properly scaled
    Vector3List positions = cube.getViewForAttrib("POSITION");
    for(int i = 0; i < positions.length; ++i) {
      Vector3 position = positions[i];
      expect(position.storage[0].abs(), equals(2.0));
      expect(position.storage[1].abs(), equals(2.0));
      expect(position.storage[2].abs(), equals(2.0));
    }
  }

  void testFlatShadeFilter() {
    FlatShadeFilter filter = new FlatShadeFilter();
    MeshGeometry cube = filterUnitCube(filter);

    // Flat shading removes indices and duplicates vertices
    expect(cube.indices, equals(null));
    expect(cube.length, equals(36));
  }

  void testBarycentricFilter() {
    BarycentricFilter filter = new BarycentricFilter();
    MeshGeometry cube = filterUnitCube(filter);

    // Generating barycentric coords removes indices and duplicates vertices
    expect(cube.indices, equals(null));
    expect(cube.length, equals(36));

    expect(cube.getViewForAttrib("BARYCENTRIC"), isNotNull);
  }

  void testColorFilter() {
    Vector4 filterColor = new Vector4(1.0, 0.0, 0.0, 1.0);
    ColorFilter filter = new ColorFilter(filterColor);
    MeshGeometry cube = filterUnitCube(filter);

    // Ensure that the same color was applied to all vertices
    Vector4List colors = cube.getViewForAttrib("COLOR");
    for(int i = 0; i < colors.length; ++i) {
      Vector4 color = colors[i];
      relativeTest(color, filterColor);
    }
  }

  void run() {
    // Attribute Generation tests
    test('normal generation', testGenerateNormals);
    test('tangent generation', testGenerateTangents);

    // Filter tests
    test('transform filter', testTransformFilter);
    test('flat shade filter', testFlatShadeFilter);
    test('barycentric filter', testBarycentricFilter);
    test('color filter', testColorFilter);
  }
}