library test_vector3;

import 'dart:math' as Math;
import 'dart:typed_data';
import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';
import 'test_helpers.dart';

void testAngleBetween() {
  final v0 = new Vector3(1.0, 0.0, 0.0);
  final v1 = new Vector3(0.0, 1.0, 0.0);

  expect(angleBetween(v0, v0), equals(0.0));
  expect(angleBetween(v0, v1), absoluteEquals(Math.PI / 2.0));
}

void testAngleBetweenSigned() {
  final v0 = new Vector3(1.0, 0.0, 0.0);
  final v1 = new Vector3(0.0, 1.0, 0.0);
  final n = new Vector3(0.0, 0.0, 1.0);

  expect(angleBetweenSigned(v0, v0, n), equals(0.0));
  expect(angleBetweenSigned(v0, v1, n), absoluteEquals(Math.PI / 2.0));
  expect(angleBetweenSigned(v1, v0, n), absoluteEquals(-Math.PI / 2.0));
}

void testInstacinfFromFloat32List() {
  final Float32List float32List = new Float32List.fromList([1.0, 2.0, 3.0]);
  final Vector3 input = new Vector3.fromFloat32List(float32List);

  expect(input.x, equals(1.0));
  expect(input.y, equals(2.0));
  expect(input.z, equals(3.0));
}

void testInstacingFromByteBuffer() {
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

void testAdd() {
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

void testLength() {
  final Vector3 a = new Vector3(5.0, 7.0, 3.0);

  expect(a.length, relativeEquals(9.1104));
  expect(a.length2, relativeEquals(83.0));

  expect(a.normalize(), relativeEquals(9.1104));
  expect(a.x, relativeEquals(0.5488));
  expect(a.y, relativeEquals(0.7683));
  expect(a.z, relativeEquals(0.3292));
}

void testMinMax() {
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

void testMix() {
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

void testDotProduct() {
  List<Vector3> inputA = new List<Vector3>();
  List<Vector3> inputB = new List<Vector3>();
  List<double> expectedOutput = new List<double>();
  inputA.add(new Vector3(0.417267069084370, 0.049654430325742, 0.902716109915281));
  inputB.add(new Vector3(0.944787189721646, 0.490864092468080, 0.489252638400019));
  expectedOutput.add(0.860258396944727);
  assert(inputA.length == inputB.length);
  assert(inputB.length == expectedOutput.length);
  for (int i = 0; i < inputA.length; i++) {
    double output1 = dot3(inputA[i], inputB[i]);
    double output2 = dot3(inputB[i], inputA[i]);
    expect(output1, relativeEquals(expectedOutput[i]));
    expect(output2, relativeEquals(expectedOutput[i]));
  }
}

void testPostmultiplication(){
  Matrix3 inputMatrix = (new Matrix3.rotationX(.4))*(new Matrix3.rotationZ(.5));
  Vector3 inputVector = new Vector3(1.0,2.0,3.0);
  Matrix3 inputInv = new Matrix3.copy(inputMatrix);
  inputInv.invert();
  Vector3 resultOld = inputMatrix.transposed() * inputVector;
  Vector3 resultOldvInv = inputInv * inputVector;
  Vector3 resultNew = inputVector..postmultiply(inputMatrix);

  expect(resultNew.x, equals(resultOld.x));
  expect(resultNew.y, equals(resultOld.y));
  expect(resultNew.z, equals(resultOld.z));
  expect(resultNew.x, equals(resultOldvInv.x));
  expect(resultNew.y, equals(resultOldvInv.y));
  expect(resultNew.z, equals(resultOldvInv.z));
}

void testCrossProduct() {
  List<Vector3> inputA = new List<Vector3>();
  List<Vector3> inputB = new List<Vector3>();
  List<Vector3> expectedOutput = new List<Vector3>();

  inputA.add(new Vector3(0.417267069084370, 0.049654430325742, 0.902716109915281));
  inputB.add(new Vector3(0.944787189721646, 0.490864092468080, 0.489252638400019));
  expectedOutput.add(new Vector3(-0.418817363004761, 0.648725602136344, 0.157908551498227));

  inputA.add(new Vector3(0.944787189721646, 0.490864092468080, 0.489252638400019));
  inputB.add(new Vector3(0.417267069084370, 0.049654430325742, 0.902716109915281));
  expectedOutput.add(new Vector3(0.418817363004761, -0.648725602136344, -0.157908551498227));

  assert(inputA.length == inputB.length);
  assert(inputB.length == expectedOutput.length);

  for (int i = 0; i < inputA.length; i++) {
    Vector3 output = new Vector3.zero();
    cross3(inputA[i], inputB[i], output);
    expect(output, relativeEquals(expectedOutput[i]));
  }

  {
    Vector3 x = new Vector3(1.0, 0.0, 0.0);
    Vector3 y = new Vector3(0.0, 1.0, 0.0);
    Vector3 z = new Vector3(0.0, 0.0, 1.0);
    Vector3 output;

    output = x.cross(y);
    expect(output, relativeEquals(new Vector3(0.0, 0.0, 1.0)));
    output = y.cross(x);
    expect(output, relativeEquals(new Vector3(0.0, 0.0, -1.0)));

    output = x.cross(z);
    expect(output, relativeEquals(new Vector3(0.0, -1.0, 0.0)));
    output = z.cross(x);
    expect(output, relativeEquals(new Vector3(0.0, 1.0, 0.0)));

    output = y.cross(z);
    expect(output, relativeEquals(new Vector3(1.0, 0.0, 0.0)));
    output = z.cross(y);
    expect(output, relativeEquals(new Vector3(-1.0, 0.0, 0.0)));
  }
}

void testConstructor() {
  var v1 = new Vector3(2.0, 4.0, -1.5);
  expect(v1.x, equals(2.0));
  expect(v1.y, equals(4.0));
  expect(v1.z, equals(-1.5));

  var v2 = new Vector3.all(2.0);
  expect(v2.x, equals(2.0));
  expect(v2.y, equals(2.0));
  expect(v2.z, equals(2.0));
}

void testNegate() {
  var vec2 = new Vector3(1.0, 2.0, 3.0);
  vec2.negate();
  expect(vec2.x, equals(-1.0));
  expect(vec2.y, equals(-2.0));
  expect(vec2.z, equals(-3.0));
}

void testReflect() {
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
  expect(v.x, relativeEquals(-4.0));
  expect(v.y, relativeEquals(-4.0));
  expect(v.z, relativeEquals(-4.0));

  v = new Vector3(-4.0, -4.0, -4.0);
  v.reflect(new Vector3(1.0, 1.0, 1.0).normalized());
  expect(v.x, relativeEquals(4.0));
  expect(v.y, relativeEquals(4.0));
  expect(v.z, relativeEquals(4.0));

  v = new Vector3(10.0, 20.0, 2.0);
  v.reflect(new Vector3(-10.0, -20.0, -2.0).normalized());
  expect(v.x, relativeEquals(-10.0));
  expect(v.y, relativeEquals(-20.0));
  expect(v.z, relativeEquals(-2.0));
}

void testProjection() {
  var v = new Vector3(1.0, 1.0, 1.0);
  var a = 2.0 / 3.0;
  var b = 1.0 / 3.0;
  var m = new Matrix4( a, b, -b, 0.0,
                       b, a,  b, 0.0,
                      -b, b,  a, 0.0,
                       0.0, 0.0,  0.0, 1.0);

  v.applyProjection(m);
  expect(v.x, relativeEquals(a));
  expect(v.y, relativeEquals(4.0 / 3.0));
  expect(v.z, relativeEquals(a));
}

void testDistanceTo() {
  var a = new Vector3(1.0, 1.0, 1.0);
  var b = new Vector3(1.0, 3.0, 1.0);
  var c = new Vector3(1.0, 1.0, -1.0);

  expect(a.distanceTo(b), equals(2.0));
  expect(a.distanceTo(c), equals(2.0));
}

void testDistanceToSquared() {
  var a = new Vector3(1.0, 1.0, 1.0);
  var b = new Vector3(1.0, 3.0, 1.0);
  var c = new Vector3(1.0, 1.0, -1.0);

  expect(a.distanceToSquared(b), equals(4.0));
  expect(a.distanceToSquared(c), equals(4.0));
}

void main() {
  group('Vector3', () {
    test('angle between', testAngleBetween);
    test('angle between singed', testAngleBetweenSigned);
    test('dot product', testDotProduct);
    test('postmultiplication', testPostmultiplication);
    test('cross product', testCrossProduct);
    test('reflect', testReflect);
    test('projection', testProjection);
    test('Negate', testNegate);
    test('Constructor', testConstructor);
    test('add', testAdd);
    test('length', testLength);
    test('min/max', testMinMax);
    test('mix', testMix);
    test('distanceTo', testDistanceTo);
    test('distanceToSquared', testDistanceToSquared);
    test('instancing from Float32List', testInstacinfFromFloat32List);
    test('instancing from ByteBuffer', testInstacingFromByteBuffer);
  });
}
