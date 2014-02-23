part of vector_math_test;

class VectorTest extends BaseTest {


  void testVec3InstacinfFromFloat32List() {
    final Float32List float32List = new Float32List.fromList([1.0, 2.0, 3.0]);
    final Vector3 input = new Vector3.fromFloat32List(float32List);

    expect(input.x, equals(1.0));
    expect(input.y, equals(2.0));
    expect(input.z, equals(3.0));
  }

  void testVec3InstacingFromByteBuffer() {
    final Float32List float32List = new Float32List.fromList([1.0, 2.0, 3.0, 4.0]);
    final ByteBuffer buffer = float32List.buffer;
    final Vector3 zeroOffset = new Vector3.fromBuffer(buffer, 0);
    final Vector3 offsetVector = new Vector3.fromBuffer(buffer, Float32List.BYTES_PER_ELEMENT);

    expect(zeroOffset.x, equals(1.0));
    expect(zeroOffset.y, equals(2.0));
    expect(zeroOffset.z, equals(3.0));

    expect(offsetVector.x, equals(2.0));
    expect(offsetVector.y, equals(3.0));
    expect(offsetVector.z, equals(4.0));
  }


  void testVec2Add() {
    final Vector2 a = new Vector2(5.0, 7.0);
    final Vector2 b = new Vector2(3.0, 8.0);

    a.add(b);
    expect(a.x, equals(8.0));
    expect(a.y, equals(15.0));

    b.addScaled(a, 0.5);
    expect(b.x, equals(7.0));
    expect(b.y, equals(15.5));
  }

  void testVec3Add() {
    final Vector3 a = new Vector3(5.0, 7.0, 3.0);
    final Vector3 b = new Vector3(3.0, 8.0, 2.0);

    a.add(b);
    expect(a.x, equals(8.0));
    expect(a.y, equals(15.0));
    expect(a.z, equals(5.0));

    b.addScaled(a, 0.5);
    expect(b.x, equals(7.0));
    expect(b.y, equals(15.5));
    expect(b.z, equals(4.5));
  }

  void testVec4Add() {
    final Vector4 a = new Vector4(5.0, 7.0, 3.0, 10.0);
    final Vector4 b = new Vector4(3.0, 8.0, 2.0, 2.0);

    a.add(b);
    expect(a.x, equals(8.0));
    expect(a.y, equals(15.0));
    expect(a.z, equals(5.0));
    expect(a.w, equals(12.0));

    b.addScaled(a, 0.5);
    expect(b.x, equals(7.0));
    expect(b.y, equals(15.5));
    expect(b.z, equals(4.5));
    expect(b.w, equals(8.0));
  }

  void testVec2MinMax() {
    final Vector2 a = new Vector2(5.0, 7.0);
    final Vector2 b = new Vector2(3.0, 8.0);

    Vector2 result = new Vector2.zero();

    Vector2.min(a, b, result);
    expect(result.x, equals(3.0));
    expect(result.y, equals(7.0));

    Vector2.max(a, b, result);
    expect(result.x, equals(5.0));
    expect(result.y, equals(8.0));
  }

  void testVec3MinMax() {
    final Vector3 a = new Vector3(5.0, 7.0, -3.0);
    final Vector3 b = new Vector3(3.0, 8.0, 2.0);

    Vector3 result = new Vector3.zero();

    Vector3.min(a, b, result);
    expect(result.x, equals(3.0));
    expect(result.y, equals(7.0));
    expect(result.z, equals(-3.0));

    Vector3.max(a, b, result);
    expect(result.x, equals(5.0));
    expect(result.y, equals(8.0));
    expect(result.z, equals(2.0));
  }

  void testVec4MinMax() {
    final Vector4 a = new Vector4(5.0, 7.0, -3.0, 10.0);
    final Vector4 b = new Vector4(3.0, 8.0, 2.0, 2.0);

    Vector4 result = new Vector4.zero();

    Vector4.min(a, b, result);
    expect(result.x, equals(3.0));
    expect(result.y, equals(7.0));
    expect(result.z, equals(-3.0));
    expect(result.w, equals(2.0));

    Vector4.max(a, b, result);
    expect(result.x, equals(5.0));
    expect(result.y, equals(8.0));
    expect(result.z, equals(2.0));
    expect(result.w, equals(10.0));
  }

  void testVec2Mix() {
    final Vector2 a = new Vector2(5.0, 7.0);
    final Vector2 b = new Vector2(3.0, 8.0);

    Vector2 result = new Vector2.zero();

    Vector2.mix(a, b, 0.5, result);
    expect(result.x, equals(4.0));
    expect(result.y, equals(7.5));

    Vector2.mix(a, b, 0.0, result);
    expect(result.x, equals(5.0));
    expect(result.y, equals(7.0));

    Vector2.mix(a, b, 1.0, result);
    expect(result.x, equals(3.0));
    expect(result.y, equals(8.0));
  }

  void testVec3Mix() {
    final Vector3 a = new Vector3(5.0, 7.0, 3.0);
    final Vector3 b = new Vector3(3.0, 8.0, 2.0);

    Vector3 result = new Vector3.zero();

    Vector3.mix(a, b, 0.5, result);
    expect(result.x, equals(4.0));
    expect(result.y, equals(7.5));
    expect(result.z, equals(2.5));

    Vector3.mix(a, b, 0.0, result);
    expect(result.x, equals(5.0));
    expect(result.y, equals(7.0));
    expect(result.z, equals(3.0));

    Vector3.mix(a, b, 1.0, result);
    expect(result.x, equals(3.0));
    expect(result.y, equals(8.0));
    expect(result.z, equals(2.0));
  }

  void testVec4Mix() {
    final Vector4 a = new Vector4(5.0, 7.0, 3.0, 10.0);
    final Vector4 b = new Vector4(3.0, 8.0, 2.0, 2.0);

    Vector4 result = new Vector4.zero();

    Vector4.mix(a, b, 0.5, result);
    expect(result.x, equals(4.0));
    expect(result.y, equals(7.5));
    expect(result.z, equals(2.5));
    expect(result.w, equals(6.0));

    Vector4.mix(a, b, 0.0, result);
    expect(result.x, equals(5.0));
    expect(result.y, equals(7.0));
    expect(result.z, equals(3.0));
    expect(result.w, equals(10.0));

    Vector4.mix(a, b, 1.0, result);
    expect(result.x, equals(3.0));
    expect(result.y, equals(8.0));
    expect(result.z, equals(2.0));
    expect(result.w, equals(2.0));
  }

  void testVec2DotProduct() {
    final Vector2 inputA = new Vector2(0.417267069084370, 0.049654430325742);
    final Vector2 inputB = new Vector2(0.944787189721646, 0.490864092468080);
    final double expectedOutput = 0.418602158442475;
    relativeTest(dot2(inputA, inputB), expectedOutput);
    relativeTest(dot2(inputB, inputA), expectedOutput);
  }

  void testVec2Postmultiplication() {
    Matrix2 inputMatrix = new Matrix2.rotation(.2);
    Vector2 inputVector = new Vector2(1.0, 0.0);
    Matrix2 inputInv = new Matrix2.copy(inputMatrix);
    inputInv.invert();
    print("input $inputMatrix");
    print("input $inputInv");
    Vector2 resultOld = inputMatrix.transposed() * inputVector;
    Vector2 resultOldvInv = inputInv * inputVector;
    Vector2 resultNew = inputVector.postmultiply(inputMatrix);
    expect(resultNew.x, equals(resultOld.x));
    expect(resultNew.y, equals(resultOld.y));
    //matrix inversion can introduce a small error
    assert((resultNew-resultOldvInv).length < .00001);
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
    relativeTest(result, new Vector2(-inputA.y, inputA.x));
    cross2B(inputA, 1.0, result);
    relativeTest(result, new Vector2(inputA.y, -inputA.x));
    cross2B(inputA, 1.0, result);
    relativeTest(result, new Vector2(inputA.y, -inputA.x));
  }

  void testVec2OrthogonalScale() {
    final Vector2 input = new Vector2(0.5, 0.75);
    final Vector2 output = new Vector2.zero();

    input.scaleOrthogonalInto(2.0, output);
    expect(output.x, equals(-1.5));
    expect(output.y, equals(1.0));

    input.scaleOrthogonalInto(-2.0, output);
    expect(output.x, equals(1.5));
    expect(output.y, equals(-1.0));

    expect(0.0, equals(input.dot(output)));
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

  void testVec3Postmultiplication(){
    Matrix3 inputMatrix = (new Matrix3.rotationX(.4))*(new Matrix3.rotationZ(.5));
    Vector3 inputVector = new Vector3(1.0,2.0,3.0);
    Matrix3 inputInv = new Matrix3.copy(inputMatrix);
    inputInv.invert();
    Vector3 resultOld = inputMatrix.transposed() * inputVector;
    Vector3 resultOldvInv = inputInv * inputVector;
    Vector3 resultNew = inputVector.postmultiply(inputMatrix);

    expect(resultNew.x, equals(resultOld.x));
    expect(resultNew.y, equals(resultOld.y));
    expect(resultNew.z, equals(resultOld.z));
    expect(resultNew.x, equals(resultOldvInv.x));
    expect(resultNew.y, equals(resultOldvInv.y));
    expect(resultNew.z, equals(resultOldvInv.z));
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

  void testVec2Constructor() {
    var v1 = new Vector2(2.0, 4.0);
    expect(v1.x, equals(2.0));
    expect(v1.y, equals(4.0));

    var v2 = new Vector2.all(2.0);
    expect(v2.x, equals(2.0));
    expect(v2.y, equals(2.0));
  }

  void testVec3Constructor() {
    var v1 = new Vector3(2.0, 4.0, -1.5);
    expect(v1.x, equals(2.0));
    expect(v1.y, equals(4.0));
    expect(v1.z, equals(-1.5));

    var v2 = new Vector3.all(2.0);
    expect(v2.x, equals(2.0));
    expect(v2.y, equals(2.0));
    expect(v2.z, equals(2.0));
  }

  void testVec4Constructor() {
    var v1 = new Vector4(2.0, 4.0, -1.5, 10.0);
    expect(v1.x, equals(2.0));
    expect(v1.y, equals(4.0));
    expect(v1.z, equals(-1.5));
    expect(v1.w, equals(10.0));

    var v2 = new Vector4.all(2.0);
    expect(v2.x, equals(2.0));
    expect(v2.y, equals(2.0));
    expect(v2.z, equals(2.0));
    expect(v2.w, equals(2.0));
  }

  void testNegate() {
    var vec1 = new Vector2(1.0, 2.0);
    vec1.negate();
    expect(vec1.x, equals(-1.0));
    expect(vec1.y, equals(-2.0));

    var vec2 = new Vector3(1.0, 2.0, 3.0);
    vec2.negate();
    expect(vec2.x, equals(-1.0));
    expect(vec2.y, equals(-2.0));
    expect(vec2.z, equals(-3.0));

    var vec3 = new Vector4(1.0, 2.0, 3.0, 4.0);
    vec3.negate();
    expect(vec3.x, equals(-1.0));
    expect(vec3.y, equals(-2.0));
    expect(vec3.z, equals(-3.0));
    expect(vec3.w, equals(-4.0));
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

  void testVec3Projection() {
    var v = new Vector3(1.0, 1.0, 1.0);
    var a = 2.0 / 3.0;
    var b = 1.0 / 3.0;
    var m = new Matrix4( a, b, -b, 0.0,
                         b, a,  b, 0.0,
                        -b, b,  a, 0.0,
                         0.0, 0.0,  0.0, 1.0);

    v.applyProjection(m);
    relativeTest(v.x, a);
    relativeTest(v.y, 4.0 / 3.0);
    relativeTest(v.z, a);
  }

  void testVec2DistanceTo() {
    var a = new Vector2(1.0, 1.0);
    var b = new Vector2(3.0, 1.0);
    var c = new Vector2(1.0, -1.0);

    expect(a.distanceTo(b), equals(2.0));
    expect(a.distanceTo(c), equals(2.0));
  }

  void testVec3DistanceTo() {
    var a = new Vector3(1.0, 1.0, 1.0);
    var b = new Vector3(1.0, 3.0, 1.0);
    var c = new Vector3(1.0, 1.0, -1.0);

    expect(a.distanceTo(b), equals(2.0));
    expect(a.distanceTo(c), equals(2.0));
  }

  void testVec4DistanceTo() {
    var a = new Vector4(1.0, 1.0, 1.0, 0.0);
    var b = new Vector4(1.0, 3.0, 1.0, 0.0);
    var c = new Vector4(1.0, 1.0, -1.0, 0.0);

    expect(a.distanceTo(b), equals(2.0));
    expect(a.distanceTo(c), equals(2.0));
  }

  void testVec2DistanceToSquared() {
    var a = new Vector2(1.0, 1.0);
    var b = new Vector2(3.0, 1.0);
    var c = new Vector2(1.0, -1.0);

    expect(a.distanceToSquared(b), equals(4.0));
    expect(a.distanceToSquared(c), equals(4.0));
  }

  void testVec3DistanceToSquared() {
    var a = new Vector3(1.0, 1.0, 1.0);
    var b = new Vector3(1.0, 3.0, 1.0);
    var c = new Vector3(1.0, 1.0, -1.0);

    expect(a.distanceToSquared(b), equals(4.0));
    expect(a.distanceToSquared(c), equals(4.0));
  }

  void testVec4DistanceToSquared() {
    var a = new Vector4(1.0, 1.0, 1.0, 0.0);
    var b = new Vector4(1.0, 3.0, 1.0, 0.0);
    var c = new Vector4(1.0, 1.0, -1.0, 0.0);

    expect(a.distanceToSquared(b), equals(4.0));
    expect(a.distanceToSquared(c), equals(4.0));
  }

  void testVec2List() {
    {
      Vector2List list = new Vector2List(10, 1);
      list[0] = new Vector2(1.0, 2.0);
      relativeTest(list[0].x, 1.0);
      relativeTest(list[0].y, 2.0);
      relativeTest(list.buffer[0], 0.0);  // unset
      relativeTest(list.buffer[1], 1.0);
      relativeTest(list.buffer[2], 2.0);
      relativeTest(list.buffer[3], 0.0);  // unset
    }
    {
      Float32List buffer = new Float32List(8);
      Vector2List list = new Vector2List.view(buffer, 1, 3);
      // The list length should be (8 - 1) ~/ 3 == 2.
      expect(list.length, 2);
      list[0] = new Vector2(1.0, 2.0);
      list[1] = new Vector2(3.0, 4.0);
      expect(buffer[0], 0.0);
      expect(buffer[1], 1.0);
      expect(buffer[2], 2.0);
      expect(buffer[3], 0.0);
      expect(buffer[4], 3.0);
      expect(buffer[5], 4.0);
      expect(buffer[6], 0.0);
      expect(buffer[7], 0.0);
    }
    {
      List<Vector2> input = new List<Vector2>(3);
      input[0] = new Vector2(1.0, 2.0);
      input[1] = new Vector2(3.0, 4.0);
      input[2] = new Vector2(5.0, 6.0);
      Vector2List list = new Vector2List.fromList(input, 2, 5);
      expect(list.buffer.length, 17);
      expect(list.buffer[0], 0.0);
      expect(list.buffer[1], 0.0);
      expect(list.buffer[2], 1.0);
      expect(list.buffer[3], 2.0);
      expect(list.buffer[4], 0.0);
      expect(list.buffer[5], 0.0);
      expect(list.buffer[6], 0.0);
      expect(list.buffer[7], 3.0);
      expect(list.buffer[8], 4.0);
      expect(list.buffer[9], 0.0);
      expect(list.buffer[10], 0.0);
      expect(list.buffer[11], 0.0);
      expect(list.buffer[12], 5.0);
      expect(list.buffer[13], 6.0);
      expect(list.buffer[14], 0.0);
      expect(list.buffer[15], 0.0);
      expect(list.buffer[16], 0.0);
    }
  }

  void run() {
    test('2D dot product', testVec2DotProduct);
    test('2D postmultiplication', testVec2Postmultiplication);
    test('2D cross product', testVec2CrossProduct);
    test('2D orhtogonal scale', testVec2OrthogonalScale);
    test('2D reflect', testVec2Reflect);
    test('3D dot product', testVec3DotProduct);
    test('3D postmultiplication', testVec3Postmultiplication);
    test('3D cross product', testVec3CrossProduct);
    test('3D reflect', testVec3Reflect);
    test('3D projection', testVec3Projection);
    test('Negate', testNegate);

    test('2D Constructor', testVec2Constructor);
    test('3D Constructor', testVec3Constructor);
    test('4D Constructor', testVec4Constructor);

    test('2D add', testVec2Add);
    test('3D add', testVec3Add);
    test('4D add', testVec4Add);

    test('2D min/max', testVec2MinMax);
    test('3D min/max', testVec3MinMax);
    test('4D min/max', testVec4MinMax);

    test('2D mix', testVec2Mix);
    test('3D mix', testVec3Mix);
    test('4D mix', testVec4Mix);

    test('2D distanceTo', testVec2DistanceTo);
    test('3D distanceTo', testVec3DistanceTo);
    test('4D distanceTo', testVec4DistanceTo);
    test('2D distanceToSquared', testVec2DistanceToSquared);
    test('3D distanceToSquared', testVec3DistanceToSquared);
    test('4D distanceToSquared', testVec4DistanceToSquared);

    test('3D instancing from Float32List', testVec3InstacinfFromFloat32List);
    test('3D instancing from ByteBuffer', testVec3InstacingFromByteBuffer);

    test('Vector2 list', testVec2List);
  }
}
