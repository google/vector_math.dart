part of vector_math_test;

class QuadTest extends BaseTest {
  void testQuadCopyNormalInto() {
    final quad = new Quad.points(new Vector3(1.0, 0.0, 1.0), new Vector3(0.0, 2.0, 1.0), new Vector3(1.0, 2.0, 0.0), new Vector3(0.0, 2.0, 0.0));
    final normal = new Vector3.zero();

    quad.copyNormalInto(normal);

    expect(normal.x, relativeEquals(-0.666666666));
    expect(normal.y, relativeEquals(-0.333333333));
    expect(normal.z, relativeEquals(-0.666666666));
  }

  void run() {
    test('Quad CopyNormalInto', testQuadCopyNormalInto);
  }
}
