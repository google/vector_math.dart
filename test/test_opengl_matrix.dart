
class OpenGLMatrixTest extends BaseTest {
  
  void testLookAt() {
    vec3 eyePosition = new vec3(1.0, 0.0, 0.0);
    vec3 lookAtPosition = new vec3(1.0, 0.0, 1.0);
    vec3 upDirection = new vec3(0.0, 1.0, 0.0);
    
    mat4x4 lookat = makeLookAt(eyePosition, lookAtPosition, upDirection);
    assert(lookat[0].w == 0.0);
    assert(lookat[1].w == 0.0);
    assert(lookat[2].w == 0.0);
    assert(lookat[3].w == 1.0);
    
    relativeTest(lookat[0].xyz, new vec3(1.0, 0.0, 0.0));
    relativeTest(lookat[1].xyz, new vec3(0.0, 1.0, 0.0));
    relativeTest(lookat[2].xyz, new vec3(0.0, 0.0, 1.0));
    relativeTest(lookat[3].xyz, new vec3(1.0, 0.0, 0.0));
  }
  
  void testFrustumMatrix() {
    num n = 0.1;
    num f = 1000.0;
    num l = -1.0;
    num r = 1.0;
    num b = -1.0;
    num t = 1.0;
    mat4x4 frustum = makeFrustum(l, r, b, t, n, f);
    relativeTest(frustum[0].xyzw, new vec4(2*n/(r-l), 0.0, 0.0, 0.0));
    relativeTest(frustum[1], new vec4(0.0, 2*n/(t-b), 0.0, 0.0));
    relativeTest(frustum[2], new vec4((r+l)/(r-l), (t+b)/(t-b), -(f+n)/(f-n), -1.0));
    relativeTest(frustum[3], new vec4(0.0, 0.0, -2.0*f*n/(f-n), 0.0));
  }
  
  void testOrthographicMatrix() {
    num n = 0.1;
    num f = 1000.0;
    num l = -1.0;
    num r = 1.0;
    num b = -1.0;
    num t = 1.0;
    mat4x4 ortho = makeOrthographic(l, r, b, t, n, f);
    relativeTest(ortho[0], new vec4(2/(r-l), 0, 0, 0));
    relativeTest(ortho[1], new vec4(0, 2/(t-b), 0, 0));
    relativeTest(ortho[2], new vec4(0, 0, -2/(f-n), 0));
    relativeTest(ortho[3], new vec4(-(r+l)/(r-l), -(t+b)/(t-b), -(f+n)/(f-n), 1.0));
  }
  
  void test() {
    print('Running OpenGL Matrix tests');
    testLookAt();
    testFrustumMatrix();
    testOrthographicMatrix();
  }
}