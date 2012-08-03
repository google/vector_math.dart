/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
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
/// Returns sine of [arg]. Return type matches the type of [arg]
Dynamic sin(Dynamic arg) {
  if (arg is num) {
    return Math.sin(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.sin(arg.x), Math.sin(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.sin(arg.x), Math.sin(arg.y), Math.sin(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.sin(arg.x), Math.sin(arg.y), Math.sin(arg.z), Math.sin(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns cosine of [arg]. Return type matches the type of [arg]
Dynamic cos(Dynamic arg) {
  if (arg is num) {
    return Math.cos(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.cos(arg.x), Math.cos(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.cos(arg.x), Math.cos(arg.y), Math.cos(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.cos(arg.x), Math.cos(arg.y), Math.cos(arg.z), Math.cos(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns tangent of [arg]. Return type matches the type of [arg]
Dynamic tan(Dynamic arg) {
  if (arg is num) {
    return Math.tan(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.tan(arg.x), Math.tan(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.tan(arg.x), Math.tan(arg.y), Math.tan(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.tan(arg.x), Math.tan(arg.y), Math.tan(arg.z), Math.tan(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc sine of [arg]. Return type matches the type of [arg]
Dynamic asin(Dynamic arg) {
  if (arg is num) {
    return Math.asin(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.asin(arg.x), Math.asin(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.asin(arg.x), Math.asin(arg.y), Math.asin(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.asin(arg.x), Math.asin(arg.y), Math.asin(arg.z), Math.asin(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc cosine of [arg]. Return type matches the type of [arg]
Dynamic acos(Dynamic arg) {
  if (arg is num) {
    return Math.acos(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.acos(arg.x), Math.acos(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.acos(arg.x), Math.acos(arg.y), Math.acos(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.acos(arg.x), Math.acos(arg.y), Math.acos(arg.z), Math.acos(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns hyperbolic sine of [arg]. Return type matches the type of [arg]
Dynamic sinh(Dynamic arg) {
  if (arg is num) {
    return Math.sinh(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.sinh(arg.x), Math.sinh(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.sinh(arg.x), Math.sinh(arg.y), Math.sinh(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.sinh(arg.x), Math.sinh(arg.y), Math.sinh(arg.z), Math.sinh(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns hyperbolic cosine of [arg]. Return type matches the type of [arg]
Dynamic cosh(Dynamic arg) {
  if (arg is num) {
    return Math.cosh(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.cosh(arg.x), Math.cosh(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.cosh(arg.x), Math.cosh(arg.y), Math.cosh(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.cosh(arg.x), Math.cosh(arg.y), Math.cosh(arg.z), Math.cosh(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns hyperbolic tangent of [arg]. Return type matches the type of [arg]
Dynamic tanh(Dynamic arg) {
  if (arg is num) {
    return Math.tanh(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.tanh(arg.x), Math.tanh(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.tanh(arg.x), Math.tanh(arg.y), Math.tanh(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.tanh(arg.x), Math.tanh(arg.y), Math.tanh(arg.z), Math.tanh(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc hyperbolic sine of [arg]. Return type matches the type of [arg]
Dynamic asinh(Dynamic arg) {
  if (arg is num) {
    return Math.asinh(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.asinh(arg.x), Math.asinh(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.asinh(arg.x), Math.asinh(arg.y), Math.asinh(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.asinh(arg.x), Math.asinh(arg.y), Math.asinh(arg.z), Math.asinh(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc hyperbolic cosine of [arg]. Return type matches the type of [arg]
Dynamic acosh(Dynamic arg) {
  if (arg is num) {
    return Math.acosh(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.acosh(arg.x), Math.acosh(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.acosh(arg.x), Math.acosh(arg.y), Math.acosh(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.acosh(arg.x), Math.acosh(arg.y), Math.acosh(arg.z), Math.acosh(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc hyperbolic tangent of [arg]. Return type matches the type of [arg]
Dynamic atanh(Dynamic arg) {
  if (arg is num) {
    return Math.atanh(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.atanh(arg.x), Math.atanh(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.atanh(arg.x), Math.atanh(arg.y), Math.atanh(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.atanh(arg.x), Math.atanh(arg.y), Math.atanh(arg.z), Math.atanh(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] converted from degrees to radians. Return types matches the type of [arg]
Dynamic radians(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.radians(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.radians(arg.x), _ScalerHelpers.radians(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.radians(arg.x), _ScalerHelpers.radians(arg.y), _ScalerHelpers.radians(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.radians(arg.x), _ScalerHelpers.radians(arg.y), _ScalerHelpers.radians(arg.z), _ScalerHelpers.radians(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] converted from radians to degrees. Return types matches the type of [arg]
Dynamic degrees(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.degrees(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.degrees(arg.x), _ScalerHelpers.degrees(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.degrees(arg.x), _ScalerHelpers.degrees(arg.y), _ScalerHelpers.degrees(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.degrees(arg.x), _ScalerHelpers.degrees(arg.y), _ScalerHelpers.degrees(arg.z), _ScalerHelpers.degrees(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
