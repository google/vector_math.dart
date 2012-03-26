class VectorTest extends BaseTest {

  void TestDotProduct() {
    List<Dynamic> inputA = new List<Dynamic>();
    List<Dynamic> inputB = new List<Dynamic>();
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
      double output1 = dot(inputA[i], inputB[i]);
      double output2 = dot(inputB[i], inputA[i]);
      RelativeTest(output1, expectedOutput[i]);
      RelativeTest(output2, expectedOutput[i]);
    }
  }
  void TestCrossProduct() {
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
      vec3 output = cross(inputA[i], inputB[i]);
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void Test() {
    TestCrossProduct();
    TestDotProduct();
  }
}
