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
