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
/// Returns [x] raised to the exponent [y]. Supports vectors and numbers.
Dynamic pow(Dynamic x, Dynamic y) {
  if (x is num) {
    return Math.pow(x, y);
  }
  if (x is vec2) {
    return new vec2(Math.pow(x.x, y.x), Math.pow(x.y, y.y));
  }
  if (x is vec3) {
    return new vec3(Math.pow(x.x, y.x), Math.pow(x.y, y.y), Math.pow(x.z, y.z));
  }
  if (x is vec4) {
    return new vec4(Math.pow(x.x, y.x), Math.pow(x.y, y.y), Math.pow(x.z, y.z), Math.pow(x.w, y.w));
  }
  throw new IllegalArgumentException(x);
}
/// Returns *e* raised to the exponent [arg]. Supports vectors and numbers.
Dynamic exp(Dynamic arg) {
  if (arg is num) {
    return Math.exp(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.exp(arg.x), Math.exp(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.exp(arg.x), Math.exp(arg.y), Math.exp(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.exp(arg.x), Math.exp(arg.y), Math.exp(arg.z), Math.exp(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns the logarithm of [arg] base *e*. Supports vectors and numbers.
Dynamic log(Dynamic arg) {
  if (arg is num) {
    return Math.log(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.log(arg.x), Math.log(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.log(arg.x), Math.log(arg.y), Math.log(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.log(arg.x), Math.log(arg.y), Math.log(arg.z), Math.log(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns *2* raised to the exponent [arg]. Supports vectors and numbers.
Dynamic exp2(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.exp2(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.exp2(arg.x), ScalarMath.exp2(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.exp2(arg.x), ScalarMath.exp2(arg.y), ScalarMath.exp2(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.exp2(arg.x), ScalarMath.exp2(arg.y), ScalarMath.exp2(arg.z), ScalarMath.exp2(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns the logarithm of [arg] base *2*. Supports vectors and numbers.
Dynamic log2(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.log2(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.log2(arg.x), ScalarMath.log2(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.log2(arg.x), ScalarMath.log2(arg.y), ScalarMath.log2(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.log2(arg.x), ScalarMath.log2(arg.y), ScalarMath.log2(arg.z), ScalarMath.log2(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns the square root of [arg].
Dynamic sqrt(Dynamic arg) {
  if (arg is num) {
    return Math.sqrt(arg);
  }
  if (arg is vec2) {
    return new vec2(Math.sqrt(arg.x), Math.sqrt(arg.y));
  }
  if (arg is vec3) {
    return new vec3(Math.sqrt(arg.x), Math.sqrt(arg.y), Math.sqrt(arg.z));
  }
  if (arg is vec4) {
    return new vec4(Math.sqrt(arg.x), Math.sqrt(arg.y), Math.sqrt(arg.z), Math.sqrt(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns the inverse square root of [arg]. Supports vectors and numbers.
Dynamic inversesqrt(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.inversesqrt(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.inversesqrt(arg.x), ScalarMath.inversesqrt(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.inversesqrt(arg.x), ScalarMath.inversesqrt(arg.y), ScalarMath.inversesqrt(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.inversesqrt(arg.x), ScalarMath.inversesqrt(arg.y), ScalarMath.inversesqrt(arg.z), ScalarMath.inversesqrt(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
