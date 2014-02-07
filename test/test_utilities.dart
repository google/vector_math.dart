part of vector_math_test;

class UtilitiesTest extends BaseTest {

  void testDegrees() {
    relativeTest(degrees(Math.PI), 180.0);
  }

  void testRadians() {
    relativeTest(radians(90.0), Math.PI / 2.0);
  }

  void testMix() {
    relativeTest(mix(2.5, 3.0, 1.0), 3.0);
    relativeTest(mix(1.0, 3.0, 0.5), 2.0);
    relativeTest(mix(2.5, 3.0, 0.0), 2.5);
    relativeTest(mix(-1.0, 0.0, 2.0), 1.0);
  }

  void run() {
    test('degrees', testDegrees);
    test('radians', testRadians);
    test('mix', testMix);
  }
}
