library test_utilities_64;

import 'dart:math' as Math;
import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math_64.dart';
import 'test_helpers.dart';

void testDegrees() {
  expect(degrees(Math.PI), relativeEquals(180.0));
}

void testRadians() {
  expect(radians(90.0), relativeEquals(Math.PI / 2.0));
}

void testMix() {
  expect(mix(2.5, 3.0, 1.0), relativeEquals(3.0));
  expect(mix(1.0, 3.0, 0.5), relativeEquals(2.0));
  expect(mix(2.5, 3.0, 0.0), relativeEquals(2.5));
  expect(mix(-1.0, 0.0, 2.0), relativeEquals(1.0));
}

void testSmoothStep() {
  expect(smoothStep(2.5, 3.0, 2.5), relativeEquals(0.0));
  expect(smoothStep(2.5, 3.0, 2.75), relativeEquals(0.5));
  expect(smoothStep(2.5, 3.0, 3.5), relativeEquals(1.0));
}

void testCatmullRom() {
  expect(catmullRom(2.5, 3.0, 1.0, 3.0, 1.0), relativeEquals(1.0));
  expect(catmullRom(1.0, 3.0, 1.0, 3.0, 0.5), relativeEquals(2.0));
  expect(catmullRom(2.5, 3.0, 1.0, 3.0, 0.0), relativeEquals(3.0));
  expect(catmullRom(-1.0, 0.0, 1.0, 0.0, 2.0), relativeEquals(-2.0));
}

void main() {
  group('Utilities', () {
    test('degrees', testDegrees);
    test('radians', testRadians);
    test('mix', testMix);
    test('smoothStep', testSmoothStep);
    test('catmullRom', testCatmullRom);
  });
}
