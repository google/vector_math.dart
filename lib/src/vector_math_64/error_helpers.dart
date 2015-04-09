// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_64;

/// Returns relative error between [calculated] and [correct].
/// The type of [calculated] and [correct] must match and can
/// be any vector, matrix, or quaternion.
double relativeError(calculated, correct) {
  if (calculated is num && correct is num) {
    double diff = (calculated - correct).abs();
    return diff / correct;
  }
  return calculated.relativeError(correct);
}

/// Returns absolute error between [calculated] and [correct].
/// The type of [calculated] and [correct] must match and can
/// be any vector, matrix, or quaternion.
double absoluteError(calculated, correct) {
  if (calculated is num && correct is num) {
    double diff = (calculated - correct).abs();
    return diff;
  }
  return calculated.absoluteError(correct);
}
