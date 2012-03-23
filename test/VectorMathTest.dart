#import('dart:builtin');
#import('../lib/VectorMath/VectorMath.dart');

class QuaternionTest {
  void TestFailure(var input, var output, var expectedOutput, num error) {
    print('FAILURE!!!');
    print('$input -> $output (true: $expectedOutput) : ${error}');
    assert(false);
  }

  void RelativeTest(var input, var output, var expectedOutput) {
    num error = relativeError(output, expectedOutput);
    if (error >= errorThreshold) {
      TestFailure(input, output, expectedOutput, error);
    }
  }
  
  final num errorThreshold = 0.0005;
  
  void TestConjugate(List<quat> input, List<quat> expectedOutput) {
    assert(input.length == expectedOutput.length);
    print('Testing quaternion conjugate');
    for (int i = 0; i < input.length; i++) {
      quat output = input[i].conjugate();
      RelativeTest(input[i], output, expectedOutput[i]);
    }
  }
  
  void TestQuatMatrixRoundTrip(List<quat> input) {
    print('Testing quaternion <-> matrix conversion');
    for (int i = 0; i < input.length; i++) {
      mat3x3 R = input[i].asRotationMatrix();
      quat output = new quat(R);
      RelativeTest(input[i], output, input[i]);
    }
  }
  
  void TestQuatMultiply(List<quat> inputA, List<quat> inputB, List<quat> expectedOutput) {
    assert((inputA.length == inputB.length) && (inputB.length == expectedOutput.length));
    print('Testing quaternion multiply');
    for (int i = 0; i < inputA.length; i++) {
      quat output = inputA[i] * inputB[i];
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
      input.add(new quat());
      input.add(new quat(0.18260, 0.54770, 0.73030, 0.36510));
      input.add(new quat(0.9889, 0.0, 0.0, 0.14834));
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
    print('Quaterion testing finished.');
  }
}

void main() {
  var r = new Options();
  print('${r.script}');
  num test = 0.0;
  vec2 test2 = new vec2(3.0, 4.0);
  vec4 test4 = new vec4(0.0, Math.PI/2, Math.PI, Math.PI*3/2);
  var x = test4[2];
  x = 55;
  print("Hello World $test ($test2) ${test2[2]}");
  print('$test4');
  print('(${degrees(test4)}) (${sin(test4)})');
  test2[0] = 1;
  print('(${exp(test2)})');
  test2 = -test2;
  print('${normalize(test2)} $test2');
  vec3 test3 = new vec3(1.0, 0.0, 1.0);
  print('${normalize(test3)} $test3');
  print('${normalize(test3)} $test3');
  
  {
    mat4x4 m = new mat4x4();
    m = m * 5.0;
    print('$m');
    vec4 v = new vec4(99, 22, 11, 1.0);
    print('${m * v}');
  }
  {
    mat3x3 m = new mat3x3();
    print('det(m) = ${m.determinant()}');
    m = m * 5.0;
    print('2x det(m) = ${m.determinant()}');
  }
  
  QuaternionTest qt = new QuaternionTest();
  
  qt.Test();
  {
    mat4x4 z = new mat4x4.identity();
  }
}
