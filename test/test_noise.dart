part of vector_math_test;

class NoiseTest extends BaseTest {

  void testSimplexNoise() {
    final SimplexNoise noise = new SimplexNoise();

    List<double> values2D = new List<double>(10);
    List<double> values3D = new List<double>(10);

    // Cache several values at known coordinates
    for (var i = 0.0; i < values2D.length; ++i) {
      values2D[i] = noise.noise2D(i, i);
      values3D[i] = noise.noise3D(i, i, i);
    }

    // Ensure that querying those same coordinates repeats the cached value
    for (var i = 0.0; i < values2D.length; ++i) {
      expect(values2D[i], equals(noise.noise2D(i, i)));
      expect(values3D[i], equals(noise.noise3D(i, i, i)));
    }
  }

  void run() {
    test('Simplex Noise', testSimplexNoise);
  }
}
