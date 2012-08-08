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
