part of vector_math_test;

class OpenGLMatrixTest extends BaseTest {

  void testUnproject() {
    Vector3 position = new Vector3(0.0, 0.0, 0.0);
    Vector3 focusPosition = new Vector3(0.0, 0.0, -1.0);
    Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
    Matrix4 lookat = makeViewMatrix(position, focusPosition, upDirection);
    num n = 0.1;
    num f = 1000.0;
    num l = -10.0;
    num r = 10.0;
    num b = -10.0;
    num t = 10.0;
    Matrix4 frustum = makeFrustumMatrix(l, r, b, t, n, f);
    Matrix4 C = frustum * lookat;
    Vector3 re = new Vector3.zero();
    bool s;
    s = unproject(C, 0.0, 100.0, 0.0, 100.0, 50.0, 50.0, 1.0, re);
  }

  void testLookAt() {
    Vector3 eyePosition = new Vector3(0.0, 0.0, 0.0);
    Vector3 lookAtPosition = new Vector3(0.0, 0.0, -1.0);
    Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);

    Matrix4 lookat = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    assert(lookat.getColumn(0).w == 0.0);
    assert(lookat.getColumn(1).w == 0.0);
    assert(lookat.getColumn(2).w == 0.0);
    assert(lookat.getColumn(3).w == 1.0);

    relativeTest(lookat.getColumn(0), new Vector4(1.0, 0.0, 0.0, 0.0));
    relativeTest(lookat.getColumn(1), new Vector4(0.0, 1.0, 0.0, 0.0));
    relativeTest(lookat.getColumn(2), new Vector4(0.0, 0.0, 1.0, 0.0));
  }

  void testFrustumMatrix() {
    num n = 0.1;
    num f = 1000.0;
    num l = -1.0;
    num r = 1.0;
    num b = -1.0;
    num t = 1.0;
    Matrix4 frustum = makeFrustumMatrix(l, r, b, t, n, f);
    relativeTest(frustum.getColumn(0),
                 new Vector4(2*n/(r-l), 0.0, 0.0, 0.0));
    relativeTest(frustum.getColumn(1),
                 new Vector4(0.0, 2*n/(t-b), 0.0, 0.0));
    relativeTest(frustum.getColumn(2),
                 new Vector4((r+l)/(r-l), (t+b)/(t-b), -(f+n)/(f-n), -1.0));
    relativeTest(frustum.getColumn(3),
                 new Vector4(0.0, 0.0, -2.0*f*n/(f-n), 0.0));
  }

  void testOrthographicMatrix() {
    num n = 0.1;
    num f = 1000.0;
    num l = -1.0;
    num r = 1.0;
    num b = -1.0;
    num t = 1.0;
    Matrix4 ortho = makeOrthographicMatrix(l, r, b, t, n, f);
    relativeTest(ortho.getColumn(0), new Vector4(2 / (r - l), 0.0, 0.0, 0.0));
    relativeTest(ortho.getColumn(1), new Vector4(0.0, 2 / (t - b), 0.0, 0.0));
    relativeTest(ortho.getColumn(2), new Vector4(0.0, 0.0, -2 / (f - n), 0.0));
    relativeTest(ortho.getColumn(3), new Vector4(-(r + l) / (r - l), -(t + b) / (t - b), -(f + n) / (f - n), 1.0));
  }

  void run() {
    test('LookAt', testLookAt);
    test('Unproject', testUnproject);
    test('Frustum', testFrustumMatrix);
    test('Orthographic', testOrthographicMatrix);
  }
}
