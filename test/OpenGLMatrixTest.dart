
class OpenGLMatrixTest extends BaseTest {
  
  void TestLookAt() {
    vec3 eyePosition = new vec3(1.0, 0.0, 0.0);
    vec3 lookAtPosition = new vec3(1.0, 0.0, 1.0);
    vec3 upDirection = new vec3(0.0, 1.0, 0.0);
    
    mat4x4 lookat = makeLookAt(eyePosition, lookAtPosition, upDirection);
    assert(lookat[0].w == 0.0);
    assert(lookat[1].w == 0.0);
    assert(lookat[2].w == 0.0);
    assert(lookat[3].w == 1.0);
    
    RelativeTest(lookat[0].xyz, new vec3(1.0, 0.0, 0.0));
    RelativeTest(lookat[1].xyz, new vec3(0.0, 1.0, 0.0));
    RelativeTest(lookat[2].xyz, new vec3(0.0, 0.0, 1.0));
    RelativeTest(lookat[3].xyz, new vec3(1.0, 0.0, 0.0));
  }
  
  void TestFrustumMatrix() {
    num n = 0.1;
    num f = 1000.0;
    num l = -1.0;
    num r = 1.0;
    num b = -1.0;
    num t = 1.0;
    mat4x4 frustum = makeFrustum(l, r, b, t, n, f);
    RelativeTest(frustum[0].xyzw, new vec4(2*n/(r-l), 0.0, 0.0, 0.0));
    RelativeTest(frustum[1], new vec4(0.0, 2*n/(t-b), 0.0, 0.0));
    RelativeTest(frustum[2], new vec4((r+l)/(r-l), (t+b)/(t-b), -(f+n)/(f-n), -1.0));
    RelativeTest(frustum[3], new vec4(0.0, 0.0, -2.0*f*n/(f-n), 0.0));
  }
  
  void TestOrthographicMatrix() {
    num n = 0.1;
    num f = 1000.0;
    num l = -1.0;
    num r = 1.0;
    num b = -1.0;
    num t = 1.0;
    mat4x4 ortho = makeOrthographic(l, r, b, t, n, f);
    RelativeTest(ortho[0], new vec4(2/(r-l), 0, 0, 0));
    RelativeTest(ortho[1], new vec4(0, 2/(t-b), 0, 0));
    RelativeTest(ortho[2], new vec4(0, 0, -2/(f-n), 0));
    RelativeTest(ortho[3], new vec4(-(r+l)/(r-l), -(t+b)/(t-b), -(f+n)/(f-n), 1.0));
  }
  
  void Test() {
    print('Testing OpenGL matrices');
    TestLookAt();
    TestFrustumMatrix();
    TestOrthographicMatrix();
  }
}