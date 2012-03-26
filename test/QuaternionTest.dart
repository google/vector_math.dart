class QuaternionTest extends BaseTest {  
  void TestConjugate(List<quat> input, List<quat> expectedOutput) {
    assert(input.length == expectedOutput.length);
    print('Testing quaternion conjugate');
    for (int i = 0; i < input.length; i++) {
      quat output = input[i].conjugate();
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void TestQuatMatrixRoundTrip(List<quat> input) {
    print('Testing quaternion <-> matrix conversion');
    for (int i = 0; i < input.length; i++) {
      mat3x3 R = input[i].asRotationMatrix();
      quat output = new quat(R);
      RelativeTest(output, input[i]);
    }
  }
  
  void TestQuatMultiply(List<quat> inputA, List<quat> inputB, List<quat> expectedOutput) {
    assert((inputA.length == inputB.length) && (inputB.length == expectedOutput.length));
    print('Testing quaternion multiply');
    for (int i = 0; i < inputA.length; i++) {
      quat output = inputA[i] * inputB[i];
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void TestQuatVectorRotate(List<quat> inputA, List<vec3> inputB, List<vec3> expectedOutput) {
    assert((inputA.length == inputB.length) && (inputB.length == expectedOutput.length));
    print('Testing quaternion vector rotation');
    for (int i = 0; i < inputA.length; i++) {
      vec3 output = inputA[i].rotate(inputB[i]);
      RelativeTest(output, expectedOutput[i]);
    }
  }
  
  void Test() {
    {
      List<quat> input = new List<quat>();
      input.add(new quat());
      input.add(new quat(0.18260, 0.54770, 0.73030, 0.36510));
      input.add(new quat(0.9889, 0.0, 0.0, 0.14834));
      List<quat> expectedOutput = new List<quat>();
      expectedOutput.add(new quat(-0.0, -0.0, -0.0, 1.0));
      expectedOutput.add(new quat(-0.18260, -0.54770, -0.73030, 0.36510));
      expectedOutput.add(new quat(-0.9889, -0.0, -0.0, 0.1483));
      TestConjugate(input, expectedOutput);
    }
    {
      List<quat> input = new List<quat>();
      input.add(new quat().normalize());
      input.add(new quat(0.18260, 0.54770, 0.73030, 0.36510).normalize());
      input.add(new quat(0.9889, 0.0, 0.0, 0.14834).normalize());
      input.add(new quat(0.388127, 0.803418, -0.433317, -0.126429).normalize());
      input.add(new quat(1.0, 0.0, 0.0, 1.0).normalize());
      input.add(new quat(0.0, 1.0, 0.0, 1.0).normalize());
      input.add(new quat(0.0, 0.0, 1.0, 1.0).normalize());
      TestQuatMatrixRoundTrip(input);
    }
    {
      List<quat> inputA = new List<quat>();
      inputA.add(new quat(0.18260, 0.54770, 0.73030, 0.36510));
      inputA.add(new quat(0.9889, 0.0, 0.0, 0.14834));
      List<quat> inputB = new List<quat>();
      inputB.add(new quat(0.9889, 0.0, 0.0, 0.14834));
      inputB.add(new quat(0.18260, 0.54770, 0.73030, 0.36510));
      List<quat> expectedOutput = new List<quat>();
      expectedOutput.add(new quat(0.388127, 0.803418, -0.433317, -0.126429));
      expectedOutput.add(new quat(0.388127, -0.64097, 0.649924, -0.126429));
      TestQuatMultiply(inputA, inputB, expectedOutput);
    }
    {
      List<quat> inputA = new List<quat>();
      List<vec3> inputB = new List<vec3>();
      List<vec3> expectedOutput = new List<vec3>();
      
      inputA.add(new quat(0.0, 1.0, 0.0, 1.0).normalize());
      inputB.add(new vec3(1.0, 1.0, 1.0));
      expectedOutput.add(new vec3(-1.0, 1.0, 1.0));
      
      inputA.add(new quat().normalize());
      inputB.add(new vec3(1.0, 2.0, 3.0));
      expectedOutput.add(new vec3(1.0, 2.0, 3.0));
      
      inputA.add(new quat(0.18260, 0.54770, 0.73030, 0.36510).normalize());
      inputB.add(new vec3(1.0, 0.0, 0.0));
      expectedOutput.add(new vec3(-0.6667,-0.3333,0.6667));
      
      {
        inputA.add(new quat(1.0, 0.0, 0.0, 1.0).normalize());
        inputB.add(new vec3(1.0, 0.0, 0.0));
        expectedOutput.add(new vec3(1.0, 0.0, 0.0));
        
        inputA.add(new quat(1.0, 0.0, 0.0, 1.0).normalize());
        inputB.add(new vec3(0.0, 1.0, 0.0));
        expectedOutput.add(new vec3(0.0, 0.0, -1.0));
        
        inputA.add(new quat(1.0, 0.0, 0.0, 1.0).normalize());
        inputB.add(new vec3(0.0, 0.0, 1.0));
        expectedOutput.add(new vec3(0.0, 1.0, 0.0));  
      }
      
      {
        inputA.add(new quat(0.0, 1.0, 0.0, 1.0).normalize());
        inputB.add(new vec3(1.0, 0.0, 0.0));
        expectedOutput.add(new vec3(0.0, 0.0, 1.0));
        
        inputA.add(new quat(0.0, 1.0, 0.0, 1.0).normalize());
        inputB.add(new vec3(0.0, 1.0, 0.0));
        expectedOutput.add(new vec3(0.0, 1.0, 0.0));
        
        inputA.add(new quat(0.0, 1.0, 0.0, 1.0).normalize());
        inputB.add(new vec3(0.0, 0.0, 1.0));
        expectedOutput.add(new vec3(-1.0, 0.0, 0.0));
      }
      
      {
        inputA.add(new quat(0.0, 0.0, 1.0, 1.0).normalize());
        inputB.add(new vec3(1.0, 0.0, 0.0));
        expectedOutput.add(new vec3(0.0, -1.0, 0.0));
        
        inputA.add(new quat(0.0, 0.0, 1.0, 1.0).normalize());
        inputB.add(new vec3(0.0, 1.0, 0.0));
        expectedOutput.add(new vec3(1.0, 0.0, 0.0));
        
        inputA.add(new quat(0.0, 0.0, 1.0, 1.0).normalize());
        inputB.add(new vec3(0.0, 0.0, 1.0));
        expectedOutput.add(new vec3(0.0, 0.0, 1.0));
      }
      
      TestQuatVectorRotate(inputA, inputB, expectedOutput);
    }
    print('Quaterion testing finished.');
  }
}