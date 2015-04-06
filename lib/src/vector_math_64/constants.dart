// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math_64;

/// Constant factor to convert and angle from degrees to radians.
const double DEGREES_2_RADIANS = Math.PI / 180.0;
/// Constant factor to convert and angle from radians to degrees.
const double RADIANS_2_DEGREES = 180.0 / Math.PI;

/// DEPRECATED: Use DEGREES_2_RADIANS instead
@deprecated
const double degrees2radians = Math.PI / 180.0;
/// DEPRECATED: Use RADIANS_2_DEGREES instead
@deprecated
const double radians2degrees = 180.0 / Math.PI;
/// DEPRECATED: Use SQRT1_2 from dart:math instead
@deprecated
const double sqrtOneHalf = 0.70710678118;
