/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/

part of vector_math;

/// Contains functions for converting between different color models and 
/// manipulating colors.
class Colors {
  static final _hexStringFullRegex = new RegExp(
    r'\#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})', caseSensitive: false);
  static final _hexStringSmallRegex = new RegExp(
    r'\#?([0-9a-f])([0-9a-f])([0-9a-f])', caseSensitive: false);

  /// Convert a color with [r], [g], [b] and [a] component between 0 and 255 to
  /// a color with values between 0.0 and 1.0 and store it in [result].
  static void fromRGBA(int r, int g, int b, int a, Vector4 result) {
    result.setValues(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
  }

  /// Convert the color as a string in the format '#FF0F00' or '#FF0' (with or 
  /// without a leading '#', case insensitive) to the corresponding color value 
  /// and store it in [result].
  static void fromHexString(String value, Vector4 result) {
    final fullMatch = _hexStringFullRegex.matchAsPrefix(value);

    if (fullMatch != null) {
      final r = int.parse(fullMatch[1], radix: 16);
      final g = int.parse(fullMatch[2], radix: 16);
      final b = int.parse(fullMatch[3], radix: 16);

      fromRGBA(r, g, b, 255, result);
      return;
    }

    final smallMatch = _hexStringSmallRegex.matchAsPrefix(value);

    if (smallMatch != null) {
      final r = int.parse(smallMatch[1] + smallMatch[1], radix: 16);
      final g = int.parse(smallMatch[2] + smallMatch[2], radix: 16);
      final b = int.parse(smallMatch[3] + smallMatch[3], radix: 16);

      fromRGBA(r, g, b, 255, result);
      return;
    }

    throw new FormatException('Could not parse hex color $value');
  }

  /// Convert a [input] color to a hex string without a leading '#'.
  static String toHexString(Vector4 input) {
    final color = (input.r * 255).floor() << 16 | (input.g * 255).floor() << 8 | 
      (input.b * 255).floor();

    return color.toRadixString(16);
  }

  /// Blend the [foreground] color over [background] color and store the color
  /// in [result].
  static void alphaBlend(Vector4 foreground, Vector4 background, Vector4 result) {
    result.a = foreground.a + (1.0 - foreground.a) * background.a;

    final factor = 1.0 / result.a;

    result.r = factor * (foreground.a * foreground.r + (1.0 - foreground.a) * 
      background.a * background.r);
    result.g = factor * (foreground.a * foreground.g + (1.0 - foreground.a) * 
      background.a * background.g);
    result.b = factor * (foreground.a * foreground.b + (1.0 - foreground.a) * 
      background.a * background.b);
  }

  /// Convert a [input] color to a gray scaled color and store it in [result].
  static void toGrayscale(Vector4 input, Vector4 result) {
    final value = 0.21 * input.r + 0.71 * input.g + 0.07 * input.b;

    result.r = value;
    result.g = value;
    result.b = value;
    result.a = input.a;
  }

  Colors._();
}