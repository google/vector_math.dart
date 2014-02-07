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