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

  void run() {
    test('normal generation', testGenerateNormals);
    test('tangent generation', testGenerateTangents);
  }
}