part of vector_math_test;

class VectorTest extends BaseTest {

  void testVec2DotProduct() {
    final Vector2 inputA = new Vector2(0.417267069084370, 0.049654430325742);
    final Vector2 inputB = new Vector2(0.944787189721646, 0.490864092468080);
    final double expectedOutput = 0.418602158442475;
    relativeTest(dot2(inputA, inputB), expectedOutput);
    relativeTest(dot2(inputB, inputA), expectedOutput);
  }

  void testVec2CrossProduct() {
    final Vector2 inputA = new Vector2(0.417267069084370, 0.049654430325742);
    final Vector2 inputB = new Vector2(0.944787189721646, 0.490864092468080);
    double expectedOutputCross = inputA.x * inputB.y - inputA.y * inputB.x;
    var result;
    result = cross2(inputA, inputB);
    relativeTest(result, expectedOutputCross);
    result = new Vector2.zero();
    cross2A(1.0, inputA, result);
    relativeTest(result, new Vector2(-inputA.y,  inputA.x));
    cross2B(inputA, 1.0, result);
    relativeTest(result, new Vector2( inputA.y, -inputA.x));
    cross2B(inputA, 1.0, result);
    relativeTest(result, new Vector2( inputA.y, -inputA.x));
  }

  void testVec3DotProduct() {
    List<Vector3> inputA = new List<Vector3>();
    List<Vector3> inputB = new List<Vector3>();
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
    List<Vector3> inputA = new List<Vector3>();
    List<Vector3> inputB = new List<Vector3>();
    List<Vector3> expectedOutput = new List<Vector3>();

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
      Vector3 output = new Vector3.zero();
      cross3(inputA[i], inputB[i], output);
      relativeTest(output, expectedOutput[i]);
    }

    {
      Vector3 x = new Vector3(1.0, 0.0, 0.0);
      Vector3 y = new Vector3(0.0, 1.0, 0.0);
      Vector3 z = new Vector3(0.0, 0.0, 1.0);
      Vector3 output;

      output = x.cross(y);
      relativeTest(output, new Vector3(0.0, 0.0, 1.0));
      output = y.cross(x);
      relativeTest(output, new Vector3(0.0, 0.0, -1.0));

      output = x.cross(z);
      relativeTest(output, new Vector3(0.0, -1.0, 0.0));
      output = z.cross(x);
      relativeTest(output, new Vector3(0.0, 1.0, 0.0));

      output = y.cross(z);
      relativeTest(output, new Vector3(1.0, 0.0, 0.0));
      output = z.cross(y);
      relativeTest(output, new Vector3(-1.0, 0.0, 0.0));
    }
  }

  void testDefaultConstructor() {
    var v = new Vector2(2.0, 4.0);
    expect(v.x, equals(2.0));
    expect(v.y, equals(4.0));
  }

  void testNegate() {
    var vec = new Vector3(1.0, 2.0, 3.0);
    vec.negate();
    expect(vec.x, equals(-1.0));
    expect(vec.y, equals(-2.0));
    expect(vec.z, equals(-3.0));
  }

  void testVec2Reflect() {
    var v = new Vector2(0.0, 5.0);
    v.reflect(new Vector2(0.0, -1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(-5.0));

    v = new Vector2(0.0, -5.0);
    v.reflect(new Vector2(0.0, 1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(5.0));

    v = new Vector2(3.0, 0.0);
    v.reflect(new Vector2(-1.0, 0.0));
    expect(v.x, equals(-3.0));
    expect(v.y, equals(0.0));

    v = new Vector2(-3.0, 0.0);
    v.reflect(new Vector2(1.0, 0.0));
    expect(v.x, equals(3.0));
    expect(v.y, equals(0.0));

    v = new Vector2(4.0, 4.0);
    v.reflect(new Vector2(-1.0, -1.0).normalized());
    relativeTest(v.x, -4.0);
    relativeTest(v.y, -4.0);

    v = new Vector2(-4.0, -4.0);
    v.reflect(new Vector2(1.0, 1.0).normalized());
    relativeTest(v.x, 4.0);
    relativeTest(v.y, 4.0);
  }

  void testVec3Reflect() {
    var v = new Vector3(5.0, 0.0, 0.0);
    v.reflect(new Vector3(-1.0, 0.0, 0.0));
    expect(v.x, equals(-5.0));
    expect(v.y, equals(0.0));
    expect(v.y, equals(0.0));

    v = new Vector3(0.0, 5.0, 0.0);
    v.reflect(new Vector3(0.0, -1.0, 0.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(-5.0));
    expect(v.z, equals(0.0));

    v = new Vector3(0.0, 0.0, 5.0);
    v.reflect(new Vector3(0.0, 0.0, -1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(0.0));
    expect(v.z, equals(-5.0));

    v = new Vector3(-5.0, 0.0, 0.0);
    v.reflect(new Vector3(1.0, 0.0, 0.0));
    expect(v.x, equals(5.0));
    expect(v.y, equals(0.0));
    expect(v.y, equals(0.0));

    v = new Vector3(0.0, -5.0, 0.0);
    v.reflect(new Vector3(0.0, 1.0, 0.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(5.0));
    expect(v.z, equals(0.0));

    v = new Vector3(0.0, 0.0, -5.0);
    v.reflect(new Vector3(0.0, 0.0, 1.0));
    expect(v.x, equals(0.0));
    expect(v.y, equals(0.0));
    expect(v.z, equals(5.0));

    v = new Vector3(4.0, 4.0, 4.0);
    v.reflect(new Vector3(-1.0, -1.0, -1.0).normalized());
    relativeTest(v.x, -4.0);
    relativeTest(v.y, -4.0);
    relativeTest(v.z, -4.0);

    v = new Vector3(-4.0, -4.0, -4.0);
    v.reflect(new Vector3(1.0, 1.0, 1.0).normalized());
    relativeTest(v.x, 4.0);
    relativeTest(v.y, 4.0);
    relativeTest(v.z, 4.0);

    v = new Vector3(10.0, 20.0, 2.0);
    v.reflect(new Vector3(-10.0, -20.0, -2.0).normalized());
    relativeTest(v.x, -10.0);
    relativeTest(v.y, -20.0);
    relativeTest(v.z, -2.0);
  }

  void run() {
    test('2D dot product', testVec2DotProduct);
    test('2D cross product', testVec2CrossProduct);
    test('2D reflect', testVec2Reflect);
    test('3D dot product', testVec3DotProduct);
    test('3D cross product', testVec3CrossProduct);
    test('3D reflect', testVec3Reflect);
    test('Constructor', testDefaultConstructor);
    test('Negate', testNegate);
  }
}
