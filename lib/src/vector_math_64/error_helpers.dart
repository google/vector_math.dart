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

/// Returns relative error between [calculated] and [correct].
/// The type of [calculated] and [correct] must match and can
/// be any vector, matrix, or quaternion.
double relativeError(dynamic calculated, dynamic correct) {
  if (calculated is double && correct is double) {
    double diff = (calculated - correct).abs();
    return diff / correct;
  }
  return calculated.relativeError(correct);
}

/// Returns absolute error between [calculated] and [correct].
/// The type of [calculated] and [correct] must match and can
/// be any vector, matrix, or quaternion.
double absoluteError(dynamic calculated, dynamic correct) {
  if (calculated is double && correct is double) {
    double diff = (calculated - correct).abs();
    return diff;
  }
  return calculated.absoluteError(correct);
}
