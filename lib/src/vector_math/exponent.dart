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



/// Returns [x] raised to the exponent [y]. Supports vectors and numbers.
dynamic pow(dynamic x, dynamic y, [dynamic out=null]) {
  // TODO: should this check that y is the same type as x? or cast?
  if (x is double) {
    return Math.pow(x, y);
  }
  if (x is vec2) {
    double _x = Math.pow(x.x, y.x);
    double _y = Math.pow(x.y, y.y);
    if (out == null) {
      out = new vec2(_x, _y);
    }
    (out as vec2).storage[0] = _x;
    (out as vec2).storage[1] = _y;
    return out;
  }
  if (x is vec3) {
    double _x = Math.pow(x.x, y.x);
    double _y = Math.pow(x.y, y.y);
    double _z = Math.pow(x.z, y.z);
    if (out == null) {
      out = new vec3(_x, _y, _z);
    }
    (out as vec3).storage[0] = _x;
    (out as vec3).storage[1] = _y;
    (out as vec3).storage[2] = _z;
    return out;
  }
  if (x is vec4) {
    double _x = Math.pow(x.x, y.x);
    double _y = Math.pow(x.y, y.y);
    double _z = Math.pow(x.z, y.z);
    double _w = Math.pow(x.w, y.w);
    if (out == null) {
      out = new vec4(_x, _y, _z, _w);
    }
    (out as vec4).storage[0] = _x;
    (out as vec4).storage[1] = _y;
    (out as vec4).storage[2] = _z;
    (out as vec4).storage[3] = _w;
    return out;
  }
  throw new ArgumentError(x);
}
/// Returns *e* raised to the exponent [arg]. Supports vectors and numbers.
dynamic exp(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.exp(arg);
  }
  if (arg is vec2) {
    double x = Math.exp(arg.x);
    double y = Math.exp(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.exp(arg.x);
    double y = Math.exp(arg.y);
    double z = Math.exp(arg.z);
    if (out == null) {
      out = new vec3(x, y, z);
    } else {
      (out as vec3).storage[0] = x;
      (out as vec3).storage[1] = y;
      (out as vec3).storage[2] = z;
    }
    return out;
  }
  if (arg is vec4) {
    double x = Math.exp(arg.x);
    double y = Math.exp(arg.y);
    double z = Math.exp(arg.z);
    double w = Math.exp(arg.w);
    if (out == null) {
      out = new vec4(x, y, z, w);
    } else {
      (out as vec4).storage[0] = x;
      (out as vec4).storage[1] = y;
      (out as vec4).storage[2] = z;
      (out as vec4).storage[3] = w;
    }
    return out;
  }
  throw new ArgumentError(arg);
}
/// Returns the logarithm of [arg] base *e*. Supports vectors and numbers.
dynamic log(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.log(arg);
  }
  if (arg is vec2) {
    double x = Math.log(arg.x);
    double y = Math.log(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.log(arg.x);
    double y = Math.log(arg.y);
    double z = Math.log(arg.z);
    if (out == null) {
      out = new vec3(x, y, z);
    } else {
      (out as vec3).storage[0] = x;
      (out as vec3).storage[1] = y;
      (out as vec3).storage[2] = z;
    }
    return out;
  }
  if (arg is vec4) {
    double x = Math.log(arg.x);
    double y = Math.log(arg.y);
    double z = Math.log(arg.z);
    double w = Math.log(arg.w);
    if (out == null) {
      out = new vec4(x, y, z, w);
    } else {
      (out as vec4).storage[0] = x;
      (out as vec4).storage[1] = y;
      (out as vec4).storage[2] = z;
      (out as vec4).storage[3] = w;
    }
    return out;
  }
  throw new ArgumentError(arg);
}
/// Returns *2* raised to the exponent [arg]. Supports vectors and numbers.
dynamic exp2(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.exp2(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.exp2(arg.x);
    double y = _ScalerHelpers.exp2(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.exp2(arg.x);
    double y = _ScalerHelpers.exp2(arg.y);
    double z = _ScalerHelpers.exp2(arg.z);
    if (out == null) {
      out = new vec3(x, y, z);
    } else {
      (out as vec3).storage[0] = x;
      (out as vec3).storage[1] = y;
      (out as vec3).storage[2] = z;
    }
    return out;
  }
  if (arg is vec4) {
    double x = _ScalerHelpers.exp2(arg.x);
    double y = _ScalerHelpers.exp2(arg.y);
    double z = _ScalerHelpers.exp2(arg.z);
    double w = _ScalerHelpers.exp2(arg.w);
    if (out == null) {
      out = new vec4(x, y, z, w);
    } else {
      (out as vec4).storage[0] = x;
      (out as vec4).storage[1] = y;
      (out as vec4).storage[2] = z;
      (out as vec4).storage[3] = w;
    }
    return out;
  }
  throw new ArgumentError(arg);
}
/// Returns the logarithm of [arg] base *2*. Supports vectors and numbers.
dynamic log2(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.log2(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.log2(arg.x);
    double y = _ScalerHelpers.log2(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.log2(arg.x);
    double y = _ScalerHelpers.log2(arg.y);
    double z = _ScalerHelpers.log2(arg.z);
    if (out == null) {
      out = new vec3(x, y, z);
    } else {
      (out as vec3).storage[0] = x;
      (out as vec3).storage[1] = y;
      (out as vec3).storage[2] = z;
    }
    return out;
  }
  if (arg is vec4) {
    double x = _ScalerHelpers.log2(arg.x);
    double y = _ScalerHelpers.log2(arg.y);
    double z = _ScalerHelpers.log2(arg.z);
    double w = _ScalerHelpers.log2(arg.w);
    if (out == null) {
      out = new vec4(x, y, z, w);
    } else {
      (out as vec4).storage[0] = x;
      (out as vec4).storage[1] = y;
      (out as vec4).storage[2] = z;
      (out as vec4).storage[3] = w;
    }
    return out;
  }
  throw new ArgumentError(arg);
}
/// Returns the square root of [arg].
dynamic sqrt(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.sqrt(arg);
  }
  if (arg is vec2) {
    double x = Math.sqrt(arg.x);
    double y = Math.sqrt(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.sqrt(arg.x);
    double y = Math.sqrt(arg.y);
    double z = Math.sqrt(arg.z);
    if (out == null) {
      out = new vec3(x, y, z);
    } else {
      (out as vec3).storage[0] = x;
      (out as vec3).storage[1] = y;
      (out as vec3).storage[2] = z;
    }
    return out;
  }
  if (arg is vec4) {
    double x = Math.sqrt(arg.x);
    double y = Math.sqrt(arg.y);
    double z = Math.sqrt(arg.z);
    double w = Math.sqrt(arg.w);
    if (out == null) {
      out = new vec4(x, y, z, w);
    } else {
      (out as vec4).storage[0] = x;
      (out as vec4).storage[1] = y;
      (out as vec4).storage[2] = z;
      (out as vec4).storage[3] = w;
    }
    return out;
  }
  throw new ArgumentError(arg);
}
/// Returns the inverse square root of [arg]. Supports vectors and numbers.
dynamic inversesqrt(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.inversesqrt(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.inversesqrt(arg.x);
    double y = _ScalerHelpers.inversesqrt(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.inversesqrt(arg.x);
    double y = _ScalerHelpers.inversesqrt(arg.y);
    double z = _ScalerHelpers.inversesqrt(arg.z);
    if (out == null) {
      out = new vec3(x, y, z);
    } else {
      (out as vec3).storage[0] = x;
      (out as vec3).storage[1] = y;
      (out as vec3).storage[2] = z;
    }
    return out;
  }
  if (arg is vec4) {
    double x = _ScalerHelpers.inversesqrt(arg.x);
    double y = _ScalerHelpers.inversesqrt(arg.y);
    double z = _ScalerHelpers.inversesqrt(arg.z);
    double w = _ScalerHelpers.inversesqrt(arg.w);
    if (out == null) {
      out = new vec4(x, y, z, w);
    } else {
      (out as vec4).storage[0] = x;
      (out as vec4).storage[1] = y;
      (out as vec4).storage[2] = z;
      (out as vec4).storage[3] = w;
    }
    return out;
  }
  throw new ArgumentError(arg);
}
