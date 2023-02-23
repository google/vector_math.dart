// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of '../../vector_math_64.dart';

/// Returns relative error between [calculated] and [correct].
/// The type of [calculated] and [correct] must match and can
/// be any vector, matrix, or quaternion.
double relativeError(dynamic calculated, dynamic correct) {
  if (calculated is num && correct is num) {
    final diff = (calculated - correct).abs().toDouble();
    return diff / correct;
  }
  // ignore: avoid_dynamic_calls
  return calculated.relativeError(correct) as double;
}

/// Returns absolute error between [calculated] and [correct].
/// The type of [calculated] and [correct] must match and can
/// be any vector, matrix, or quaternion.
double absoluteError(dynamic calculated, dynamic correct) {
  if (calculated is num && correct is num) {
    final diff = (calculated - correct).abs().toDouble();
    return diff;
  }
  // ignore: avoid_dynamic_calls
  return calculated.absoluteError(correct) as double;
}
