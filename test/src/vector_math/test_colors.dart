library test_colors;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';
import '../test_helpers.dart';

void testToGrayscale() {
  final input = new Vector4(0.0, 1.0, 0.5, 1.0);
  final output = input.clone();

  Colors.toGrayscale(output, output);

  expect(output.r, relativeEquals(0.745));
  expect(output.g, relativeEquals(0.745));
  expect(output.b, relativeEquals(0.745));
  expect(output.a, equals(1.0));
}

void testHexString() {
  final color = new Vector4.zero();

  Colors.fromHexString('#6495ED', color);

  expect(color.r, relativeEquals(0.3921));
  expect(color.g, relativeEquals(0.5843));
  expect(color.b, relativeEquals(0.9294));
  expect(color.a, relativeEquals(1.0));

  expect(Colors.toHexString(color), equals('6495ed'));

  Colors.fromHexString('#6495eD', color);

  expect(color.r, relativeEquals(0.3921));
  expect(color.g, relativeEquals(0.5843));
  expect(color.b, relativeEquals(0.9294));
  expect(color.a, relativeEquals(1.0));

  expect(Colors.toHexString(color), equals('6495ed'));

  Colors.fromHexString('6495eD', color);

  expect(color.r, relativeEquals(0.3921));
  expect(color.g, relativeEquals(0.5843));
  expect(color.b, relativeEquals(0.9294));
  expect(color.a, relativeEquals(1.0));

  expect(Colors.toHexString(color), equals('6495ed'));

  Colors.fromHexString('#F0F', color);

  expect(color.r, relativeEquals(1.0));
  expect(color.g, relativeEquals(0.0));
  expect(color.b, relativeEquals(1.0));
  expect(color.a, relativeEquals(1.0));

  expect(Colors.toHexString(color), equals('ff00ff'));

  Colors.fromHexString('#88FF00fF', color);

  expect(color.r, relativeEquals(1.0));
  expect(color.g, relativeEquals(0.0));
  expect(color.b, relativeEquals(1.0));
  expect(color.a, relativeEquals(0.5333));

  expect(Colors.toHexString(color, alpha: true), equals('88ff00ff'));

  Colors.fromHexString('#8F0f', color);

  expect(color.r, relativeEquals(1.0));
  expect(color.g, relativeEquals(0.0));
  expect(color.b, relativeEquals(1.0));
  expect(color.a, relativeEquals(0.5333));

  expect(Colors.toHexString(color, alpha: true), equals('88ff00ff'));

  expect(() => Colors.fromHexString('vector_math rules!', color),
    throwsA(new isInstanceOf<FormatException>()));
}

void testFromRgba() {
  final output = new Vector4.zero();

  Colors.fromRgba(100, 149, 237, 255, output);

  expect(output.r, relativeEquals(0.3921));
  expect(output.g, relativeEquals(0.5843));
  expect(output.b, relativeEquals(0.9294));
  expect(output.a, equals(1.0));
}

void testAlphaBlend() {
  final output = new Vector4.zero();
  final foreground1 = new Vector4(0.3921, 0.5843, 0.9294, 1.0);
  final foreground2 = new Vector4(0.3921, 0.5843, 0.9294, 0.5);
  final background1 = new Vector4(1.0, 0.0, 0.0, 1.0);
  final background2 = new Vector4(1.0, 0.5, 0.0, 0.5);

  output.setFrom(foreground1);
  Colors.alphaBlend(output, background1, output);

  expect(output.r, relativeEquals(0.3921));
  expect(output.g, relativeEquals(0.5843));
  expect(output.b, relativeEquals(0.9294));
  expect(output.a, equals(1.0));

  output.setFrom(background2);
  Colors.alphaBlend(foreground1, output, output);

  expect(output.r, relativeEquals(0.3921));
  expect(output.g, relativeEquals(0.5843));
  expect(output.b, relativeEquals(0.9294));
  expect(output.a, equals(1.0));

  Colors.alphaBlend(foreground2, background1, output);

  expect(output.r, relativeEquals(0.6960));
  expect(output.g, relativeEquals(0.2921));
  expect(output.b, relativeEquals(0.4647));
  expect(output.a, equals(1.0));

  Colors.alphaBlend(foreground2, background2, output);

  expect(output.r, relativeEquals(0.5947));
  expect(output.g, relativeEquals(0.5561));
  expect(output.b, relativeEquals(0.6195));
  expect(output.a, equals(0.75));
}

void testLinearGamma() {
  final gamma = new Vector4.zero();
  final linear = new Vector4.zero();
  final foreground = new Vector4(0.3921, 0.5843, 0.9294, 1.0);

  gamma.setFrom(foreground);
  Colors.linearToGamma(gamma, gamma);

  expect(gamma.r, relativeEquals(0.6534));
  expect(gamma.g, relativeEquals(0.7832));
  expect(gamma.b, relativeEquals(0.9672));
  expect(gamma.a, equals(foreground.a));

  linear.setFrom(gamma);
  Colors.gammaToLinear(linear, linear);

  expect(linear.r, relativeEquals(foreground.r));
  expect(linear.g, relativeEquals(foreground.g));
  expect(linear.b, relativeEquals(foreground.b));
  expect(linear.a, equals(foreground.a));
}

void testRgbHsl() {
  final hsl = new Vector4.zero();
  final rgb = new Vector4.zero();
  final input = new Vector4(0.3921, 0.5843, 0.9294, 1.0);

  hsl.setFrom(input);
  Colors.rgbToHsl(hsl, hsl);

  expect(hsl.x, relativeEquals(0.6070));
  expect(hsl.y, relativeEquals(0.7920));
  expect(hsl.z, relativeEquals(0.6607));
  expect(hsl.a, equals(input.a));

  rgb.setFrom(hsl);
  Colors.hslToRgb(rgb, rgb);

  expect(rgb.r, relativeEquals(input.r));
  expect(rgb.g, relativeEquals(input.g));
  expect(rgb.b, relativeEquals(input.b));
  expect(rgb.a, equals(input.a));

  void testRoundtrip(Vector4 input) {
    final result = input.clone();

    Colors.rgbToHsl(result, result);
    Colors.hslToRgb(result, result);

    expect(result.r, absoluteEquals(input.r));
    expect(result.g, absoluteEquals(input.g));
    expect(result.b, absoluteEquals(input.b));
    expect(result.a, equals(input.a));
  }

  testRoundtrip(Colors.red);
  testRoundtrip(Colors.green);
  testRoundtrip(Colors.blue);
  testRoundtrip(Colors.black);
  testRoundtrip(Colors.white);
  testRoundtrip(Colors.gray);
  testRoundtrip(Colors.yellow);
  testRoundtrip(Colors.fuchsia);
}

void testRgbHsv() {
  final hsv = new Vector4.zero();
  final rgb = new Vector4.zero();
  final input = new Vector4(0.3921, 0.5843, 0.9294, 1.0);

  hsv.setFrom(input);
  Colors.rgbToHsv(hsv, hsv);

  expect(hsv.x, relativeEquals(0.6070));
  expect(hsv.y, relativeEquals(0.5781));
  expect(hsv.z, relativeEquals(0.9294));
  expect(hsv.a, equals(input.a));

  rgb.setFrom(hsv);
  Colors.hsvToRgb(rgb, rgb);

  expect(rgb.r, relativeEquals(input.r));
  expect(rgb.g, relativeEquals(input.g));
  expect(rgb.b, relativeEquals(input.b));
  expect(rgb.a, equals(input.a));

  void testRoundtrip(Vector4 input) {
    final result = input.clone();

    Colors.rgbToHsv(result, result);
    Colors.hsvToRgb(result, result);

    expect(result.r, absoluteEquals(input.r));
    expect(result.g, absoluteEquals(input.g));
    expect(result.b, absoluteEquals(input.b));
    expect(result.a, equals(input.a));
  }

  testRoundtrip(Colors.red);
  testRoundtrip(Colors.green);
  testRoundtrip(Colors.blue);
  testRoundtrip(Colors.black);
  testRoundtrip(Colors.white);
  testRoundtrip(Colors.gray);
  testRoundtrip(Colors.yellow);
  testRoundtrip(Colors.fuchsia);
}

void main() {
  group('Colors', () {
    test('From RGBA', testFromRgba);
    test('Hex String', testHexString);
    test('To Grayscale', testToGrayscale);
    test('Alpha Blend', testAlphaBlend);
    test('Linear/Gamma', testLinearGamma);
    test('RGB/HSL', testRgbHsl);
    test('RGB/HSV', testRgbHsv);
  });
}
