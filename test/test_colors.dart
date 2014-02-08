part of vector_math_test;

class ColorsTest extends BaseTest {

  void testToGrayscale() {
  	final input = new Vector4(0.0, 1.0, 0.5, 1.0);
  	final output = new Vector4.zero();

  	Colors.toGrayscale(input, output);
 	
 	relativeTest(output.r, 0.745);
 	relativeTest(output.g, 0.745);
 	relativeTest(output.b, 0.745);
 	expect(output.a, equals(1.0));
  }

  void testHexString() {
  	final color = new Vector4.zero();

  	Colors.fromHexString('#6495ED', color);

 	relativeTest(color.r, 0.3921);
 	relativeTest(color.g, 0.5843);
 	relativeTest(color.b, 0.9294);
 	relativeTest(color.a, 1.0);

 	expect(Colors.toHexString(color), equals('6495ed'));

  	Colors.fromHexString('#6495eD', color);

 	relativeTest(color.r, 0.3921);
 	relativeTest(color.g, 0.5843);
 	relativeTest(color.b, 0.9294);
 	relativeTest(color.a, 1.0);

 	expect(Colors.toHexString(color), equals('6495ed'));

  	Colors.fromHexString('6495eD', color);

 	relativeTest(color.r, 0.3921);
 	relativeTest(color.g, 0.5843);
 	relativeTest(color.b, 0.9294);
 	relativeTest(color.a, 1.0);

 	expect(Colors.toHexString(color), equals('6495ed'));

  	Colors.fromHexString('#F0F', color);

 	relativeTest(color.r, 1.0);
 	relativeTest(color.g, 0.0);
 	relativeTest(color.b, 1.0);
 	relativeTest(color.a, 1.0);

 	expect(Colors.toHexString(color), equals('ff00ff'));

 	expect(() => Colors.fromHexString('vector_math rules!', color), 
 		throwsA(new isInstanceOf<FormatException>()));
  }

  void testFromRgba() {
  	final output = new Vector4.zero();

  	Colors.fromRgba(100, 149, 237, 255, output);
 	
 	relativeTest(output.r, 0.3921);
 	relativeTest(output.g, 0.5843);
 	relativeTest(output.b, 0.9294);
 	expect(output.a, equals(1.0));
  }

  void testAlphaBlend() {
  	final output = new Vector4.zero();
  	final foreground1 = new Vector4(0.3921, 0.5843, 0.9294, 1.0);
  	final foreground2 = new Vector4(0.3921, 0.5843, 0.9294, 0.5);
  	final background1 = new Vector4(1.0, 0.0, 0.0, 1.0);
  	final background2 = new Vector4(1.0, 0.5, 0.0, 0.5);

  	Colors.alphaBlend(foreground1, background1, output);
 	
 	relativeTest(output.r, 0.3921);
 	relativeTest(output.g, 0.5843);
 	relativeTest(output.b, 0.9294);
 	expect(output.a, equals(1.0));

  	Colors.alphaBlend(foreground1, background2, output);

 	relativeTest(output.r, 0.3921);
 	relativeTest(output.g, 0.5843);
 	relativeTest(output.b, 0.9294);
 	expect(output.a, equals(1.0));

  	Colors.alphaBlend(foreground2, background1, output);

 	relativeTest(output.r, 0.6960);
 	relativeTest(output.g, 0.2921);
 	relativeTest(output.b, 0.4647);
 	expect(output.a, equals(1.0));

  	Colors.alphaBlend(foreground2, background2, output);

 	relativeTest(output.r, 0.5947);
 	relativeTest(output.g, 0.5561);
 	relativeTest(output.b, 0.6195);
 	expect(output.a, equals(0.75));
  }

  void testLinearGamma() {
  	final gamma = new Vector4.zero();
  	final linear = new Vector4.zero();
  	final foreground = new Vector4(0.3921, 0.5843, 0.9294, 1.0);

  	Colors.linearToGamma(foreground, gamma);
 	
 	relativeTest(gamma.r, 0.6534);
 	relativeTest(gamma.g, 0.7832);
 	relativeTest(gamma.b, 0.9672);
 	expect(gamma.a, equals(foreground.a));

  	Colors.gammaToLinear(gamma, linear);

 	relativeTest(linear.r, foreground.r);
 	relativeTest(linear.g, foreground.g);
 	relativeTest(linear.b, foreground.b);
 	expect(linear.a, equals(foreground.a));
  }

  void testRgbHsl() {
  	final hsl = new Vector4.zero();
  	final rgb = new Vector4.zero();
  	final input = new Vector4(0.3921, 0.5843, 0.9294, 1.0);

  	Colors.rgbToHsl(input, hsl);
 	
 	relativeTest(hsl.x, 0.6070);
 	relativeTest(hsl.y, 0.7920);
 	relativeTest(hsl.z, 0.6607);
 	expect(hsl.a, equals(input.a));

  	Colors.hslToRgb(hsl, rgb);

 	relativeTest(rgb.r, input.r);
 	relativeTest(rgb.g, input.g);
 	relativeTest(rgb.b, input.b);
 	expect(rgb.a, equals(input.a));
  }

  void testRgbHsv() {
  	final hsv = new Vector4.zero();
  	final rgb = new Vector4.zero();
  	final input = new Vector4(0.3921, 0.5843, 0.9294, 1.0);

  	Colors.rgbToHsv(input, hsv);
 	
 	relativeTest(hsv.x, 0.6070);
 	relativeTest(hsv.y, 0.5781);
 	relativeTest(hsv.z, 0.9294);
 	expect(hsv.a, equals(input.a));

  	Colors.hsvToRgb(hsv, rgb);

 	relativeTest(rgb.r, input.r);
 	relativeTest(rgb.g, input.g);
 	relativeTest(rgb.b, input.b);
 	expect(rgb.a, equals(input.a));
  }

  void run() {
    test('Colors From RGBA', testFromRgba);
    test('Colors Hex String', testHexString);
    test('Colors To Grayscale', testToGrayscale);
    test('Colors Alpha Blend', testAlphaBlend);
    test('Colors Linear/Gamma', testLinearGamma);
    test('Colors RGB/HSL', testRgbHsl);
    test('Colors RGB/HSV', testRgbHsv);
  }
}
