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

class _ScalerHelpers {
  static final _sqrtOneHalf = 0.707106781186548;
  static double degrees(double r) {
    return r * 180.0/Math.PI;
  }

  static double radians(double d) {
    return d * Math.PI/180.0;
  }

  static double clamp(double x, double _min, double _max) {
    return x < _min ? _min : x > _max ? _max : x;
  }

  static double mix(double x, double y, double t) {
    return x * (1.0-t) + y * (t);
  }

  static double step(double edge, double x) {
    if (x < edge) {
      return 0.0;
    }
    return 1.0;
  }

  static double smoothstep(double edge0, double edge1, double x) {
    double t = 0.0;
    t = clamp((x - edge0)/(edge1-edge0), 0.0, 1.0);
    return (t*t)*(3.0-2.0*t);
  }

  static double inversesqrt(double x) {
    return 1.0 / Math.sqrt(x);
  }

  static double abs(double x) {
    return x.abs();
  }

  static double ceil(double x) {
    return x.ceil();
  }

  static double floor(double x) {
    return x.floor();
  }

  static bool isnan(double x) {
    return x.isNaN;
  }

  static bool isInfinite(double x) {
    return x.isInfinite;
  }

  static double truncate(double x) {
    return x.truncate();
  }

  static double sign(double x) {
    if (x > 0) {
      return 1.0;
    } else if (x == 0.0) {
      return 0.0;
    } else {
      return -1.0;
    }
  }

  static double fract(double x) {
    return x - x.floor();
  }

  static double mod(double x, double y) {
    return x % y;
  }

  static double round(double x) {
    return x.round();
  }

  static double roundEven(double x) {
    if ( (floor(x)%2.0==0.0) && (fract(x)==0.5) )
      return _ScalerHelpers.round(x)-1;
    else
      return x.round();
  }

  static double exp2(double x) {
    return Math.pow(2, x);
  }

  static double log2(double x) {
    return Math.log(x) / Math.log(2);
  }
}