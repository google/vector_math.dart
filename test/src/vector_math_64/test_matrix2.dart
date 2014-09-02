library test_matrix2_64;

import 'dart:math' as Math;
import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math_64.dart';
import 'test_helpers.dart';

void testAdjoint() {
  final input = new List<Matrix2>();
  final expectedOutput = new List<Matrix2>();

  input.add(parseMatrix('''0.830828627896291   0.549723608291140
                           0.585264091152724   0.917193663829810'''));
  expectedOutput.add(parseMatrix('''   0.917193663829810  -0.549723608291140
                                      -0.585264091152724   0.830828627896291'''));
  input.add(new Matrix2.identity());
  expectedOutput.add(new Matrix2.identity());

  assert(input.length == expectedOutput.length);

  for (int i = 0; i < input.length; i++) {
    var output = input[i].clone();
    output.scaleAdjoint(1.0);
    expect(output, relativeEquals(expectedOutput[i]));
  }
}

void testDeterminant() {
  final input = new List<Matrix2>();
  final expectedOutput = new List<double>();

  input.add(parseMatrix('''0.830828627896291   0.549723608291140
                           0.585264091152724   0.917193663829810'''));
  expectedOutput.add(0.440297265243183);

  assert(input.length == expectedOutput.length);

  for (int i = 0; i < input.length; i++) {
    double output = input[i].determinant();
    expect(output, relativeEquals(expectedOutput[i]));
  }
}

void testTransform() {
  var rot = new Matrix2.rotation(Math.PI / 4);
  final input = new Vector2(0.234245234259, 0.890723489233);

  final expected = new Vector2(rot.entry(0, 0) * input.x +
                               rot.entry(0, 1) * input.y,
                               rot.entry(1, 0) * input.x +
                               rot.entry(1, 1) * input.y);

  final transExpected = new Vector2(rot.entry(0, 0) * input.x +
                                    rot.entry(1, 0) * input.y,
                                    rot.entry(0, 1) * input.x +
                                    rot.entry(1, 1) * input.y);

  expect(rot.transformed(input), relativeEquals(expected));
  expect(rot.transposed().transformed(input), relativeEquals(transExpected));
}

void testInversion() {
  Matrix2 m = new Matrix2(4.0, 3.0,
                          3.0, 2.0);
  Matrix2 result = new Matrix2.zero();
  double det = result.copyInverse(m);
  expect(det, -1.0);
  expect(result.entry(0, 0), -2.0);
  expect(result.entry(1, 0), 3.0);
  expect(result.entry(0, 1), 3.0);
  expect(result.entry(1, 1), -4.0);
}

void testDot() {
  final Matrix2 matrix = new Matrix2(1.0, 2.0, 3.0, 4.0);

  final Vector2 v = new Vector2(3.0,4.0);

  expect(matrix.dotRow(0, v), equals(15.0));
  expect(matrix.dotRow(1, v), equals(22.0));
  expect(matrix.dotColumn(0, v), equals(11.0));
  expect(matrix.dotColumn(1, v), equals(25.0));
}

void testSolving() {
  final Matrix2 A = new Matrix2(2.0,2.0,8.0,20.0);
  final Vector2 b = new Vector2(20.0,64.0);
  final Vector2 result = new Vector2.zero();

  Matrix2.solve(A, result, b);

  final Vector2 backwards = A.transform(new Vector2.copy(result));

  expect(backwards.x, relativeEquals(b.x));
  expect(backwards.y, relativeEquals(b.y));
}

void main() {
  group('Matrix2', () {
    test('Determinant', testDeterminant);
    test('Adjoint', testAdjoint);
    test('transform', testTransform);
    test('inversion', testInversion);
    test('dot product', testDot);
    test('solving', testSolving);
  });
}
