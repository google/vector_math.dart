part of vector_math_test;

class NoiseTest extends BaseTest {

  void testSimplexNoise() {
    final SimplexNoise noise = new SimplexNoise();

    List<double> values2D = new List<double>(10);
    List<double> values3D = new List<double>(10);

    // Cache several values at known coordinates
    for (int i = 0; i < values2D.length; ++i) {
      values2D[i] = noise.noise2D(i.toDouble(), i.toDouble());
      values3D[i] = noise.noise3D(i.toDouble(), i.toDouble(), i.toDouble());
    }

    // Ensure that querying those same coordinates repeats the cached value
    for (var i = 0; i < values2D.length; ++i) {
      expect(values2D[i], equals(noise.noise2D(i.toDouble(), i.toDouble())));
      expect(values3D[i], equals(
          noise.noise3D(i.toDouble(), i.toDouble(), i.toDouble())));
    }
  }

  void run() {
    test('Simplex Noise', testSimplexNoise);
  }
}
