part of vector_math_test;

class TriangleTest extends BaseTest {
  void testTriangleCopyNormalInto() {
    final triangle = new Triangle.points(new Vector3(1.0, 0.0, 1.0), new Vector3(0.0, 2.0, 1.0), new Vector3(1.0, 2.0, 0.0));
    final normal = new Vector3.zero();

    triangle.copyNormalInto(normal);

    relativeTest(normal.x, -0.666666666);
    relativeTest(normal.y, -0.333333333);
    relativeTest(normal.z, -0.666666666);
  }

  void run() {
    test('Triangle CopyNormalInto', testTriangleCopyNormalInto);
  }
}
