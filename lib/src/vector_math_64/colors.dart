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

part of vector_math_64;

/// Contains functions for converting between different color models and 
/// manipulating colors. In addition to that, some known colors can be accessed
/// for fast prototyping.
class Colors {
  static final _hexStringFullRegex = new RegExp(
    r'\#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})(?:([0-9a-f]{2}))?', caseSensitive: false);
  static final _hexStringSmallRegex = new RegExp(
    r'\#?([0-9a-f])([0-9a-f])([0-9a-f])(?:([0-9a-f]))?', caseSensitive: false);

  /// Convert a color with [r], [g], [b] and [a] component between 0 and 255 to
  /// a color with values between 0.0 and 1.0 and store it in [result].
  static void fromRgba(int r, int g, int b, int a, Vector4 result) {
    result.setValues(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
  }

  /// Convert the color as a string in the format '#FF0F00', '#FFFF0F00', '#FF0'
  /// or '#FFF0' (with or without a leading '#', case insensitive) to the 
  /// corresponding color value and store it in [result]. The first group is 
  /// treated as the alpha channel if a [value] with four groups is passed.
  static void fromHexString(String value, Vector4 result) {
    final fullMatch = _hexStringFullRegex.matchAsPrefix(value);

    if (fullMatch != null) {
      if(fullMatch[4] == null) {
        final r = int.parse(fullMatch[1], radix: 16);
        final g = int.parse(fullMatch[2], radix: 16);
        final b = int.parse(fullMatch[3], radix: 16);

        fromRgba(r, g, b, 255, result);
        return;
      } else {
        final a = int.parse(fullMatch[1], radix: 16);
        final r = int.parse(fullMatch[2], radix: 16);
        final g = int.parse(fullMatch[3], radix: 16);
        final b = int.parse(fullMatch[4], radix: 16);

        fromRgba(r, g, b, a, result);
        return;
      }
    }

    final smallMatch = _hexStringSmallRegex.matchAsPrefix(value);

    if (smallMatch != null) {
      if(smallMatch[4] == null) {
        final r = int.parse(smallMatch[1] + smallMatch[1], radix: 16);
        final g = int.parse(smallMatch[2] + smallMatch[2], radix: 16);
        final b = int.parse(smallMatch[3] + smallMatch[3], radix: 16);

        fromRgba(r, g, b, 255, result);
        return;
      } else {
        final a = int.parse(smallMatch[1] + smallMatch[1], radix: 16);
        final r = int.parse(smallMatch[2] + smallMatch[2], radix: 16);
        final g = int.parse(smallMatch[3] + smallMatch[3], radix: 16);
        final b = int.parse(smallMatch[4] + smallMatch[4], radix: 16);

        fromRgba(r, g, b, a, result);
        return;
      }
    }

    throw new FormatException('Could not parse hex color $value');
  }

  /// Convert a [input] color to a hex string without a leading '#'. To include
  /// the alpha channel, set [alpha] to true, it is false by default.
  static String toHexString(Vector4 input, {bool alpha: false}) {
    var color = (input.r * 255).floor() << 16 | (input.g * 255).floor() << 8 | 
      (input.b * 255).floor();

    if(alpha) {
      color |= (input.a * 255).floor() << 24;
    }

    return color.toRadixString(16);
  }

  /// Blend the [foreground] color over [background] color and store the color
  /// in [result].
  static void alphaBlend(Vector4 foreground, Vector4 background, Vector4 result) {
    final a = foreground.a + (1.0 - foreground.a) * background.a;
    final factor = 1.0 / a;

    final r = factor * (foreground.a * foreground.r + (1.0 - foreground.a) * 
          background.a * background.r);
    final g = factor * (foreground.a * foreground.g + (1.0 - foreground.a) * 
          background.a * background.g);
    final b = factor * (foreground.a * foreground.b + (1.0 - foreground.a) * 
          background.a * background.b);

    result.setValues(r, g, b, a);
  }

  /// Convert a [input] color to a gray scaled color and store it in [result].
  static void toGrayscale(Vector4 input, Vector4 result) {
    final value = 0.21 * input.r + 0.71 * input.g + 0.07 * input.b;

    result
        ..r = value
        ..g = value
        ..b = value
        ..a = input.a;
  }

  /// Convert [linearColor] from linear space into gamma color space and store 
  /// the result in [gammaColor]. It is possible to specify a optional [gamma], 
  /// the default value is 2.2.
  static void linearToGamma(Vector4 linearColor, Vector4 gammaColor, 
    [double gamma = 2.2]) {
    final exponent = 1.0 / gamma;

    gammaColor
        ..r = Math.pow(linearColor.r, exponent)
        ..g = Math.pow(linearColor.g, exponent)
        ..b = Math.pow(linearColor.b, exponent)
        ..a = linearColor.a;
  }

  /// Convert [gammaColor] from gamma space into linear color space and store 
  /// the result in [linearColor]. It is possible to specify a optional [gamma], 
  /// the default value is 2.2.
  static void gammaToLinear(Vector4 gammaColor, Vector4 linearColor, 
    [double gamma = 2.2]) {
    linearColor
        ..r = Math.pow(gammaColor.r, gamma)
        ..g = Math.pow(gammaColor.g, gamma)
        ..b = Math.pow(gammaColor.b, gamma)
        ..a = gammaColor.a;
  }

  /// Convert [rgbColor] from rgb color model to the hue, saturation, and value
  /// (HSV) color model and store it in [hsvColor].
  static void rgbToHsv(Vector4 rgbColor, Vector4 hsvColor) {
    final max = Math.max(Math.max(rgbColor.r, rgbColor.g), rgbColor.b);
    final min = Math.min(Math.min(rgbColor.r, rgbColor.g), rgbColor.b);
    final d = max - min;
    final v = max;
    final s = max == 0.0 ? 0.0 : d / max;
    var h = 0.0;
 
    if (max != min) {
      if (max == rgbColor.r) {
        h = (rgbColor.g - rgbColor.b) / d + (rgbColor.g < rgbColor.b ? 
          6.0 : 0.0);
      } else if (max == rgbColor.g) {
        h = (rgbColor.b - rgbColor.r) / d + 2.0;
      } else {
        h = (rgbColor.r - rgbColor.g) / d + 4.0;
      }

      h /= 6.0;
    }

    hsvColor.setValues(h, s, v, rgbColor.a);
  }

  /// Convert [hsvColor] from hue, saturation, and value (HSV) color model to 
  /// the RGB color model and store it in [rgbColor].
  static void hsvToRgb(Vector4 hsvColor, Vector4 rgbColor) {
    final i = (hsvColor.x * 6.0).floor();
    final f = hsvColor.x * 6.0 - i.toDouble();
    final p = hsvColor.z * (1.0 - hsvColor.y);
    final q = hsvColor.z * (1.0 - f * hsvColor.y);
    final t = hsvColor.z * (1.0 - (1.0 - f) * hsvColor.y);
 
    switch (i % 6) {
      case 0: 
        rgbColor.setValues(hsvColor.z, t, p, hsvColor.a);
        break;
      case 1: 
        rgbColor.setValues(q, hsvColor.z, p, hsvColor.a);
        break;
      case 2: 
        rgbColor.setValues(p, hsvColor.z, t, hsvColor.a);
        break;
      case 3: 
        rgbColor.setValues(p, q, hsvColor.z, hsvColor.a);
        break;
      case 4: 
        rgbColor.setValues(t, p, hsvColor.z, hsvColor.a);
        break;
      case 5: 
        rgbColor.setValues(hsvColor.z, p, q, hsvColor.a);
        break;
    }
  }

  /// Convert [rgbColor] from rgb color model to the hue, saturation, and 
  /// lightness (HSL) color model and store it in [hslColor].
  static void rgbToHsl(Vector4 rgbColor, Vector4 hslColor) {
    final max = Math.max(Math.max(rgbColor.r, rgbColor.g), rgbColor.b);
    final min = Math.min(Math.min(rgbColor.r, rgbColor.g), rgbColor.b);
    final l = (max + min) / 2.0;
    var h = 0.0;
    var s = 0.0;

    if (max != min) {
      final d = max - min;

      s = l > 0.5 ? d / (2.0 - max - min) : d / (max + min);

      if (max == rgbColor.r) {
        h = (rgbColor.g - rgbColor.b) / d + (rgbColor.g < rgbColor.b ? 
          6.0 : 0.0);
      } else if (max == rgbColor.g) {
        h = (rgbColor.b - rgbColor.r) / d + 2.0;
      } else {
        h = (rgbColor.r - rgbColor.g) / d + 4.0;
      }

      h /= 6.0;
    }

    hslColor.setValues(h, s, l, rgbColor.a);
  }

  /// Convert [hslColor] from hue, saturation, and lightness (HSL) color model  
  /// to the RGB color model and store it in [rgbColor].
  static void hslToRgb(Vector4 hslColor, Vector4 rgbColor) {
    if (hslColor.y == 0.0) {
      rgbColor.setValues(hslColor.z, hslColor.z, hslColor.z, hslColor.a);
    } else {
      final q = hslColor.z < 0.5 ? hslColor.z * (1.0 + hslColor.y) : 
        hslColor.z + hslColor.y - hslColor.z * hslColor.y;
      final p = 2.0 * hslColor.z - q;

      final r = _hueToRgb(p, q, hslColor.x + 1.0 / 3.0);
      final g = _hueToRgb(p, q, hslColor.x);
      final b = _hueToRgb(p, q, hslColor.x - 1.0 / 3.0);

      rgbColor.setValues(r, g, b, hslColor.a);
    }
  }

  static double _hueToRgb(double p, double q, double t) {
    if (t < 0.0) {
      t += 1.0;
    } else if (t > 1.0) {
      t -= 1.0;
    }

    if (t < 1.0 / 6.0) {
      return p + (q - p) * 6.0 * t;
    } else if (t < 1.0 / 2.0) {
      return q;
    } else if (t < 2.0 / 3.0) {
      return p + (q - p) * (2.0 / 3.0 - t) * 6.0;
    } else {
      return p;    
    }
  }

  static Vector4 get transparent => new Vector4(255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 0.0 / 255.0);
  static Vector4 get aliceBlue => new Vector4(240.0 / 255.0, 248.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get antiqueWhite => new Vector4(250.0 / 255.0, 235.0 / 255.0, 215.0 / 255.0, 255.0 / 255.0);
  static Vector4 get aqua => new Vector4(0.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get aquamarine => new Vector4(127.0 / 255.0, 255.0 / 255.0, 212.0 / 255.0, 255.0 / 255.0);
  static Vector4 get azure => new Vector4(240.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get beige => new Vector4(245.0 / 255.0, 245.0 / 255.0, 220.0 / 255.0, 255.0 / 255.0);
  static Vector4 get bisque => new Vector4(255.0 / 255.0, 228.0 / 255.0, 196.0 / 255.0, 255.0 / 255.0);
  static Vector4 get black => new Vector4(0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get blanchedAlmond => new Vector4(255.0 / 255.0, 235.0 / 255.0, 205.0 / 255.0, 255.0 / 255.0);
  static Vector4 get blue => new Vector4(0.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get blueViolet => new Vector4(138.0 / 255.0, 43.0 / 255.0, 226.0 / 255.0, 255.0 / 255.0);
  static Vector4 get brown => new Vector4(165.0 / 255.0, 42.0 / 255.0, 42.0 / 255.0, 255.0 / 255.0);
  static Vector4 get burlyWood => new Vector4(222.0 / 255.0, 184.0 / 255.0, 135.0 / 255.0, 255.0 / 255.0);
  static Vector4 get cadetBlue => new Vector4(95.0 / 255.0, 158.0 / 255.0, 160.0 / 255.0, 255.0 / 255.0);
  static Vector4 get chartreuse => new Vector4(127.0 / 255.0, 255.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get chocolate => new Vector4(210.0 / 255.0, 105.0 / 255.0, 30.0 / 255.0, 255.0 / 255.0);
  static Vector4 get coral => new Vector4(255.0 / 255.0, 127.0 / 255.0, 80.0 / 255.0, 255.0 / 255.0);
  static Vector4 get cornflowerBlue => new Vector4(100.0 / 255.0, 149.0 / 255.0, 237.0 / 255.0, 255.0 / 255.0);
  static Vector4 get cornsilk => new Vector4(255.0 / 255.0, 248.0 / 255.0, 220.0 / 255.0, 255.0 / 255.0);
  static Vector4 get crimson => new Vector4(220.0 / 255.0, 20.0 / 255.0, 60.0 / 255.0, 255.0 / 255.0);
  static Vector4 get cyan => new Vector4(0.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkBlue => new Vector4(0.0 / 255.0, 0.0 / 255.0, 139.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkCyan => new Vector4(0.0 / 255.0, 139.0 / 255.0, 139.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkGoldenrod => new Vector4(184.0 / 255.0, 134.0 / 255.0, 11.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkGray => new Vector4(169.0 / 255.0, 169.0 / 255.0, 169.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkGreen => new Vector4(0.0 / 255.0, 100.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkKhaki => new Vector4(189.0 / 255.0, 183.0 / 255.0, 107.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkMagenta => new Vector4(139.0 / 255.0, 0.0 / 255.0, 139.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkOliveGreen => new Vector4(85.0 / 255.0, 107.0 / 255.0, 47.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkOrange => new Vector4(255.0 / 255.0, 140.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkOrchid => new Vector4(153.0 / 255.0, 50.0 / 255.0, 204.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkRed => new Vector4(139.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkSalmon => new Vector4(233.0 / 255.0, 150.0 / 255.0, 122.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkSeaGreen => new Vector4(143.0 / 255.0, 188.0 / 255.0, 139.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkSlateBlue => new Vector4(72.0 / 255.0, 61.0 / 255.0, 139.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkSlateGray => new Vector4(47.0 / 255.0, 79.0 / 255.0, 79.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkTurquoise => new Vector4(0.0 / 255.0, 206.0 / 255.0, 209.0 / 255.0, 255.0 / 255.0);
  static Vector4 get darkViolet => new Vector4(148.0 / 255.0, 0.0 / 255.0, 211.0 / 255.0, 255.0 / 255.0);
  static Vector4 get deepPink => new Vector4(255.0 / 255.0, 20.0 / 255.0, 147.0 / 255.0, 255.0 / 255.0);
  static Vector4 get deepSkyBlue => new Vector4(0.0 / 255.0, 191.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get dimGray => new Vector4(105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0, 255.0 / 255.0);
  static Vector4 get dodgerBlue => new Vector4(30.0 / 255.0, 144.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get firebrick => new Vector4(178.0 / 255.0, 34.0 / 255.0, 34.0 / 255.0, 255.0 / 255.0);
  static Vector4 get floralWhite => new Vector4(255.0 / 255.0, 250.0 / 255.0, 240.0 / 255.0, 255.0 / 255.0);
  static Vector4 get forestGreen => new Vector4(34.0 / 255.0, 139.0 / 255.0, 34.0 / 255.0, 255.0 / 255.0);
  static Vector4 get fuchsia => new Vector4(255.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get gainsboro => new Vector4(220.0 / 255.0, 220.0 / 255.0, 220.0 / 255.0, 255.0 / 255.0);
  static Vector4 get ghostWhite => new Vector4(248.0 / 255.0, 248.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get gold => new Vector4(255.0 / 255.0, 215.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get goldenrod => new Vector4(218.0 / 255.0, 165.0 / 255.0, 32.0 / 255.0, 255.0 / 255.0);
  static Vector4 get gray => new Vector4(128.0 / 255.0, 128.0 / 255.0, 128.0 / 255.0, 255.0 / 255.0);
  static Vector4 get green => new Vector4(0.0 / 255.0, 128.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get greenYellow => new Vector4(173.0 / 255.0, 255.0 / 255.0, 47.0 / 255.0, 255.0 / 255.0);
  static Vector4 get honeydew => new Vector4(240.0 / 255.0, 255.0 / 255.0, 240.0 / 255.0, 255.0 / 255.0);
  static Vector4 get hotPink => new Vector4(255.0 / 255.0, 105.0 / 255.0, 180.0 / 255.0, 255.0 / 255.0);
  static Vector4 get indianRed => new Vector4(205.0 / 255.0, 92.0 / 255.0, 92.0 / 255.0, 255.0 / 255.0);
  static Vector4 get indigo => new Vector4(75.0 / 255.0, 0.0 / 255.0, 130.0 / 255.0, 255.0 / 255.0);
  static Vector4 get ivory => new Vector4(255.0 / 255.0, 255.0 / 255.0, 240.0 / 255.0, 255.0 / 255.0);
  static Vector4 get khaki => new Vector4(240.0 / 255.0, 230.0 / 255.0, 140.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lavender => new Vector4(230.0 / 255.0, 230.0 / 255.0, 250.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lavenderBlush => new Vector4(255.0 / 255.0, 240.0 / 255.0, 245.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lawnGreen => new Vector4(124.0 / 255.0, 252.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lemonChiffon => new Vector4(255.0 / 255.0, 250.0 / 255.0, 205.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightBlue => new Vector4(173.0 / 255.0, 216.0 / 255.0, 230.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightCoral => new Vector4(240.0 / 255.0, 128.0 / 255.0, 128.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightCyan => new Vector4(224.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightGoldenrodYellow => new Vector4(250.0 / 255.0, 250.0 / 255.0, 210.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightGreen => new Vector4(144.0 / 255.0, 238.0 / 255.0, 144.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightGray => new Vector4(211.0 / 255.0, 211.0 / 255.0, 211.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightPink => new Vector4(255.0 / 255.0, 182.0 / 255.0, 193.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightSalmon => new Vector4(255.0 / 255.0, 160.0 / 255.0, 122.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightSeaGreen => new Vector4(32.0 / 255.0, 178.0 / 255.0, 170.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightSkyBlue => new Vector4(135.0 / 255.0, 206.0 / 255.0, 250.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightSlateGray => new Vector4(119.0 / 255.0, 136.0 / 255.0, 153.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightSteelBlue => new Vector4(176.0 / 255.0, 196.0 / 255.0, 222.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lightYellow => new Vector4(255.0 / 255.0, 255.0 / 255.0, 224.0 / 255.0, 255.0 / 255.0);
  static Vector4 get lime => new Vector4(0.0 / 255.0, 255.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get limeGreen => new Vector4(50.0 / 255.0, 205.0 / 255.0, 50.0 / 255.0, 255.0 / 255.0);
  static Vector4 get linen => new Vector4(250.0 / 255.0, 240.0 / 255.0, 230.0 / 255.0, 255.0 / 255.0);
  static Vector4 get magenta => new Vector4(255.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get maroon => new Vector4(128.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumAquamarine => new Vector4(102.0 / 255.0, 205.0 / 255.0, 170.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumBlue => new Vector4(0.0 / 255.0, 0.0 / 255.0, 205.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumOrchid => new Vector4(186.0 / 255.0, 85.0 / 255.0, 211.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumPurple => new Vector4(147.0 / 255.0, 112.0 / 255.0, 219.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumSeaGreen => new Vector4(60.0 / 255.0, 179.0 / 255.0, 113.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumSlateBlue => new Vector4(123.0 / 255.0, 104.0 / 255.0, 238.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumSpringGreen => new Vector4(0.0 / 255.0, 250.0 / 255.0, 154.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumTurquoise => new Vector4(72.0 / 255.0, 209.0 / 255.0, 204.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mediumVioletRed => new Vector4(199.0 / 255.0, 21.0 / 255.0, 133.0 / 255.0, 255.0 / 255.0);
  static Vector4 get midnightBlue => new Vector4(25.0 / 255.0, 25.0 / 255.0, 112.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mintCream => new Vector4(245.0 / 255.0, 255.0 / 255.0, 250.0 / 255.0, 255.0 / 255.0);
  static Vector4 get mistyRose => new Vector4(255.0 / 255.0, 228.0 / 255.0, 225.0 / 255.0, 255.0 / 255.0);
  static Vector4 get moccasin => new Vector4(255.0 / 255.0, 228.0 / 255.0, 181.0 / 255.0, 255.0 / 255.0);
  static Vector4 get navajoWhite => new Vector4(255.0 / 255.0, 222.0 / 255.0, 173.0 / 255.0, 255.0 / 255.0);
  static Vector4 get navy => new Vector4(0.0 / 255.0, 0.0 / 255.0, 128.0 / 255.0, 255.0 / 255.0);
  static Vector4 get oldLace => new Vector4(253.0 / 255.0, 245.0 / 255.0, 230.0 / 255.0, 255.0 / 255.0);
  static Vector4 get olive => new Vector4(128.0 / 255.0, 128.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get oliveDrab => new Vector4(107.0 / 255.0, 142.0 / 255.0, 35.0 / 255.0, 255.0 / 255.0);
  static Vector4 get orange => new Vector4(255.0 / 255.0, 165.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get orangeRed => new Vector4(255.0 / 255.0, 69.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get orchid => new Vector4(218.0 / 255.0, 112.0 / 255.0, 214.0 / 255.0, 255.0 / 255.0);
  static Vector4 get paleGoldenrod => new Vector4(238.0 / 255.0, 232.0 / 255.0, 170.0 / 255.0, 255.0 / 255.0);
  static Vector4 get paleGreen => new Vector4(152.0 / 255.0, 251.0 / 255.0, 152.0 / 255.0, 255.0 / 255.0);
  static Vector4 get paleTurquoise => new Vector4(175.0 / 255.0, 238.0 / 255.0, 238.0 / 255.0, 255.0 / 255.0);
  static Vector4 get paleVioletRed => new Vector4(219.0 / 255.0, 112.0 / 255.0, 147.0 / 255.0, 255.0 / 255.0);
  static Vector4 get papayaWhip => new Vector4(255.0 / 255.0, 239.0 / 255.0, 213.0 / 255.0, 255.0 / 255.0);
  static Vector4 get peachPuff => new Vector4(255.0 / 255.0, 218.0 / 255.0, 185.0 / 255.0, 255.0 / 255.0);
  static Vector4 get peru => new Vector4(205.0 / 255.0, 133.0 / 255.0, 63.0 / 255.0, 255.0 / 255.0);
  static Vector4 get pink => new Vector4(255.0 / 255.0, 192.0 / 255.0, 203.0 / 255.0, 255.0 / 255.0);
  static Vector4 get plum => new Vector4(221.0 / 255.0, 160.0 / 255.0, 221.0 / 255.0, 255.0 / 255.0);
  static Vector4 get powderBlue => new Vector4(176.0 / 255.0, 224.0 / 255.0, 230.0 / 255.0, 255.0 / 255.0);
  static Vector4 get purple => new Vector4(128.0 / 255.0, 0.0 / 255.0, 128.0 / 255.0, 255.0 / 255.0);
  static Vector4 get red => new Vector4(255.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get rosyBrown => new Vector4(188.0 / 255.0, 143.0 / 255.0, 143.0 / 255.0, 255.0 / 255.0);
  static Vector4 get royalBlue => new Vector4(65.0 / 255.0, 105.0 / 255.0, 225.0 / 255.0, 255.0 / 255.0);
  static Vector4 get saddleBrown => new Vector4(139.0 / 255.0, 69.0 / 255.0, 19.0 / 255.0, 255.0 / 255.0);
  static Vector4 get salmon => new Vector4(250.0 / 255.0, 128.0 / 255.0, 114.0 / 255.0, 255.0 / 255.0);
  static Vector4 get sandyBrown => new Vector4(244.0 / 255.0, 164.0 / 255.0, 96.0 / 255.0, 255.0 / 255.0);
  static Vector4 get seaGreen => new Vector4(46.0 / 255.0, 139.0 / 255.0, 87.0 / 255.0, 255.0 / 255.0);
  static Vector4 get seaShell => new Vector4(255.0 / 255.0, 245.0 / 255.0, 238.0 / 255.0, 255.0 / 255.0);
  static Vector4 get sienna => new Vector4(160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0, 255.0 / 255.0);
  static Vector4 get silver => new Vector4(192.0 / 255.0, 192.0 / 255.0, 192.0 / 255.0, 255.0 / 255.0);
  static Vector4 get skyBlue => new Vector4(135.0 / 255.0, 206.0 / 255.0, 235.0 / 255.0, 255.0 / 255.0);
  static Vector4 get slateBlue => new Vector4(106.0 / 255.0, 90.0 / 255.0, 205.0 / 255.0, 255.0 / 255.0);
  static Vector4 get slateGray => new Vector4(112.0 / 255.0, 128.0 / 255.0, 144.0 / 255.0, 255.0 / 255.0);
  static Vector4 get snow => new Vector4(255.0 / 255.0, 250.0 / 255.0, 250.0 / 255.0, 255.0 / 255.0);
  static Vector4 get springGreen => new Vector4(0.0 / 255.0, 255.0 / 255.0, 127.0 / 255.0, 255.0 / 255.0);
  static Vector4 get steelBlue => new Vector4(70.0 / 255.0, 130.0 / 255.0, 180.0 / 255.0, 255.0 / 255.0);
  static Vector4 get tan => new Vector4(210.0 / 255.0, 180.0 / 255.0, 140.0 / 255.0, 255.0 / 255.0);
  static Vector4 get teal => new Vector4(0.0 / 255.0, 128.0 / 255.0, 128.0 / 255.0, 255.0 / 255.0);
  static Vector4 get thistle => new Vector4(216.0 / 255.0, 191.0 / 255.0, 216.0 / 255.0, 255.0 / 255.0);
  static Vector4 get tomato => new Vector4(255.0 / 255.0, 99.0 / 255.0, 71.0 / 255.0, 255.0 / 255.0);
  static Vector4 get turquoise => new Vector4(64.0 / 255.0, 224.0 / 255.0, 208.0 / 255.0, 255.0 / 255.0);
  static Vector4 get violet => new Vector4(238.0 / 255.0, 130.0 / 255.0, 238.0 / 255.0, 255.0 / 255.0);
  static Vector4 get wheat => new Vector4(245.0 / 255.0, 222.0 / 255.0, 179.0 / 255.0, 255.0 / 255.0);
  static Vector4 get white => new Vector4(255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
  static Vector4 get whiteSmoke => new Vector4(245.0 / 255.0, 245.0 / 255.0, 245.0 / 255.0, 255.0 / 255.0);
  static Vector4 get yellow => new Vector4(255.0 / 255.0, 255.0 / 255.0, 0.0 / 255.0, 255.0 / 255.0);
  static Vector4 get yellowGreen => new Vector4(154.0 / 255.0, 205.0 / 255.0, 50.0 / 255.0, 255.0 / 255.0);


  Colors._();
}