part of vector_math_test;

class VectorTest extends BaseTest {

  void testVec2DotProduct() {
    final vec2 inputA = new vec2(0.417267069084370, 0.049654430325742);
    final vec2 inputB = new vec2(0.944787189721646, 0.490864092468080);
    final double expectedOutput = 0.418602158442475;
    relativeTest(dot2(inputA, inputB), expectedOutput);
    relativeTest(dot2(inputB, inputA), expectedOutput);
  }

  void testVec2CrossProduct() {
    final vec2 inputA = new vec2(0.417267069084370, 0.049654430325742);
    final vec2 inputB = new vec2(0.944787189721646, 0.490864092468080);
    double expectedOutputCross = inputA.x * inputB.y - inputA.y * inputB.x;
    var result;
    result = cross2(inputA, inputB);
    relativeTest(result, expectedOutputCross);
    result = new vec2.zero();
    cross2A(1.0, inputA, result);
    relativeTest(result, new vec2(-inputA.y,  inputA.x));
    cross2B(inputA, 1.0, result);
    relativeTest(result, new vec2( inputA.y, -inputA.x));
    cross2B(inputA, 1.0, result);
    relativeTest(result, new vec2( inputA.y, -inputA.x));
  }

  void testVec3DotProduct() {
    List<vec3> inputA = new List<vec3>();
    List<vec3> inputB = new List<vec3>();
    List<double> expectedOutput = new List<double>();
    inputA.add(parseVector('''0.417267069084370
   0.049654430325742
   0.902716109915281'''));
    inputB.add(parseVector('''0.944787189721646
   0.490864092468080
   0.489252638400019'''));
    expectedOutput.add(0.860258396944727);
    assert(inputA.length == inputB.length);
    assert(inputB.length == expectedOutput.length);
    for (int i = 0; i < inputA.length; i++) {
      double output1 = dot3(inputA[i], inputB[i]);
      double output2 = dot3(inputB[i], inputA[i]);
      relativeTest(output1, expectedOutput[i]);
      relativeTest(output2, expectedOutput[i]);
    }
  }
  void testVec3CrossProduct() {
    List<vec3> inputA = new List<vec3>();
    List<vec3> inputB = new List<vec3>();
    List<vec3> expectedOutput = new List<vec3>();

    inputA.add(parseVector('''0.417267069084370
   0.049654430325742
   0.902716109915281'''));
    inputB.add(parseVector('''0.944787189721646
   0.490864092468080
   0.489252638400019'''));
    expectedOutput.add(parseVector('''  -0.418817363004761
   0.648725602136344
   0.157908551498227'''));

    inputA.add(parseVector('''0.944787189721646
      0.490864092468080
      0.489252638400019'''));
    inputB.add(parseVector('''0.417267069084370
      0.049654430325742
      0.902716109915281'''));
    expectedOutput.add(parseVector(''' 0.418817363004761
  -0.648725602136344
  -0.157908551498227'''));

    assert(inputA.length == inputB.length);
    assert(inputB.length == expectedOutput.length);

    for (int i = 0; i < inputA.length; i++) {
      vec3 output = new vec3.zero();
      cross3(inputA[i], inputB[i], output);
      relativeTest(output, expectedOutput[i]);
    }

    {
      vec3 x = new vec3(1.0, 0.0, 0.0);
      vec3 y = new vec3(0.0, 1.0, 0.0);
      vec3 z = new vec3(0.0, 0.0, 1.0);
      vec3 output;

      output = x.cross(y);
      relativeTest(output, new vec3(0.0, 0.0, 1.0));
      output = y.cross(x);
      relativeTest(output, new vec3(0.0, 0.0, -1.0));

      output = x.cross(z);
      relativeTest(output, new vec3(0.0, -1.0, 0.0));
      output = z.cross(x);
      relativeTest(output, new vec3(0.0, 1.0, 0.0));

      output = y.cross(z);
      relativeTest(output, new vec3(1.0, 0.0, 0.0));
      output = z.cross(y);
      relativeTest(output, new vec3(-1.0, 0.0, 0.0));
    }
  }

  void testDefaultConstructor() {
    var v = new vec2(2.0, 4.0);
    expect(v.x, equals(2.0));
    expect(v.y, equals(4.0));
  }

  void testNegate() {
    var vec = new vec3(1.0, 2.0, 3.0);
    vec.negate();
    expect(vec.x, equals(-1.0));
    expect(vec.y, equals(-2.0));
    expect(vec.z, equals(-3.0));
  }
  
  void testVec2Reflect() {
    var v = new vec2(0.0, 5.0);
    v.reflect(new vec2(0.0, -1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(-5.0));
    
    v = new vec2(0.0, -5.0);
    v.reflect(new vec2(0.0, 1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(5.0));
    
    v = new vec2(3.0, 0.0);
    v.reflect(new vec2(-1.0, 0.0));
    expect(v.x, equals(-3.0));
    expect(v.y, equals(0.0));
    
    v = new vec2(-3.0, 0.0);
    v.reflect(new vec2(1.0, 0.0));
    expect(v.x, equals(3.0));
    expect(v.y, equals(0.0));

    v = new vec2(4.0, 4.0);
    v.reflect(new vec2(-1.0, -1.0).normalized());
    relativeTest(v.x, -4.0);
    relativeTest(v.y, -4.0);
    
    v = new vec2(-4.0, -4.0);
    v.reflect(new vec2(1.0, 1.0).normalized());
    relativeTest(v.x, 4.0);
    relativeTest(v.y, 4.0);
  }
  
  void testVec3Reflect() {
    var v = new vec3(5.0, 0.0, 0.0);
    v.reflect(new vec3(-1.0, 0.0, 0.0));
    expect(v.x, equals(-5.0));
    expect(v.y, equals(0.0));
    expect(v.y, equals(0.0));
    
    v = new vec3(0.0, 5.0, 0.0);
    v.reflect(new vec3(0.0, -1.0, 0.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(-5.0));
    expect(v.z, equals(0.0));
    
    v = new vec3(0.0, 0.0, 5.0);
    v.reflect(new vec3(0.0, 0.0, -1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(0.0));
    expect(v.z, equals(-5.0));
    
    v = new vec3(-5.0, 0.0, 0.0);
    v.reflect(new vec3(1.0, 0.0, 0.0));
    expect(v.x, equals(5.0));
    expect(v.y, equals(0.0));
    expect(v.y, equals(0.0));
    
    v = new vec3(0.0, -5.0, 0.0);
    v.reflect(new vec3(0.0, 1.0, 0.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(5.0));
    expect(v.z, equals(0.0));
    
    v = new vec3(0.0, 0.0, -5.0);
    v.reflect(new vec3(0.0, 0.0, 1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(0.0));
    expect(v.z, equals(5.0));

    v = new vec3(4.0, 4.0, 4.0);
    v.reflect(new vec3(-1.0, -1.0, -1.0).normalized());
    relativeTest(v.x, -4.0);
    relativeTest(v.y, -4.0);
    relativeTest(v.z, -4.0);
    
    v = new vec3(-4.0, -4.0, -4.0);
    v.reflect(new vec3(1.0, 1.0, 1.0).normalized());
    relativeTest(v.x, 4.0);
    relativeTest(v.y, 4.0);
    relativeTest(v.z, 4.0);
    
    v = new vec3(10.0, 20.0, 2.0);
    v.reflect(new vec3(-10.0, -20.0, -2.0).normalized());
    relativeTest(v.x, -10.0);
    relativeTest(v.y, -20.0);
    relativeTest(v.z, -2.0);
  }
  
  void test() {
    print('Running vector tests');
    testVec2DotProduct();
    testVec2CrossProduct();
    testVec2Reflect();
    testVec3DotProduct();
    testVec3CrossProduct();
    testVec3Reflect();
    testDefaultConstructor();
    testNegate();
  }
}
