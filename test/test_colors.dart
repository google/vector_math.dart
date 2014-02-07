part of vector_math_test;

class ColorsTest extends BaseTest {

  void testToGrayscale() {
  	final input = new Vector4(0.0, 1.0, 0.5, 1.0);
  	final output = new Vector4.zero();

  	Colors.toGrayscale(input, output);
 	
 	relativeTest(output.x, 0.745);
 	relativeTest(output.y, 0.745);
 	relativeTest(output.z, 0.745);
 	expect(output.w, equals(1.0));
  }

  void testFromRGBA() {
  	final output = new Vector4.zero();

  	Colors.fromRGBA(100, 149, 23, 255, output);
 	
 	relativeTest(output.x, 0.3921);
 	relativeTest(output.y, 0.5843);
 	relativeTest(output.z, 0.09019);
 	expect(output.w, equals(1.0));
  }

  void run() {
    test('Colors From RGBA', testFromRGBA);
    test('Colors To Grayscale', testToGrayscale);
  }
}
