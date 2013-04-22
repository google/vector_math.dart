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



/// Returns sine of [arg]. Return type matches the type of [arg]
dynamic sin(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.sin(arg);
  }
  if (arg is vec2) {
    double x = Math.sin(arg.x);
    double y = Math.sin(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.sin(arg.x);
    double y = Math.sin(arg.y);
    double z = Math.sin(arg.z);
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
    double x = Math.sin(arg.x);
    double y = Math.sin(arg.y);
    double z = Math.sin(arg.z);
    double w = Math.sin(arg.w);
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
/// Returns cosine of [arg]. Return type matches the type of [arg]
dynamic cos(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.cos(arg);
  }
  if (arg is vec2) {
    double x = Math.cos(arg.x);
    double y = Math.cos(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.cos(arg.x);
    double y = Math.cos(arg.y);
    double z = Math.cos(arg.z);
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
    double x = Math.cos(arg.x);
    double y = Math.cos(arg.y);
    double z = Math.cos(arg.z);
    double w = Math.cos(arg.w);
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
/// Returns tangent of [arg]. Return type matches the type of [arg]
dynamic tan(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.tan(arg);
  }
  if (arg is vec2) {
    double x = Math.tan(arg.x);
    double y = Math.tan(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.tan(arg.x);
    double y = Math.tan(arg.y);
    double z = Math.tan(arg.z);
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
    double x = Math.tan(arg.x);
    double y = Math.tan(arg.y);
    double z = Math.tan(arg.z);
    double w = Math.tan(arg.w);
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
/// Returns arc sine of [arg]. Return type matches the type of [arg]
dynamic asin(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.asin(arg);
  }
  if (arg is vec2) {
    double x = Math.asin(arg.x);
    double y = Math.asin(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.asin(arg.x);
    double y = Math.asin(arg.y);
    double z = Math.asin(arg.z);
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
    double x = Math.asin(arg.x);
    double y = Math.asin(arg.y);
    double z = Math.asin(arg.z);
    double w = Math.asin(arg.w);
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
/// Returns arc cosine of [arg]. Return type matches the type of [arg]
dynamic acos(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return Math.acos(arg);
  }
  if (arg is vec2) {
    double x = Math.acos(arg.x);
    double y = Math.acos(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = Math.acos(arg.x);
    double y = Math.acos(arg.y);
    double z = Math.acos(arg.z);
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
    double x = Math.acos(arg.x);
    double y = Math.acos(arg.y);
    double z = Math.acos(arg.z);
    double w = Math.acos(arg.w);
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
/// Returns [arg] converted from degrees to radians. Return types matches the type of [arg]
dynamic radians(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.radians(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.radians(arg.x);
    double y = _ScalerHelpers.radians(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.radians(arg.x);
    double y = _ScalerHelpers.radians(arg.y);
    double z = _ScalerHelpers.radians(arg.z);
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
    double x = _ScalerHelpers.radians(arg.x);
    double y = _ScalerHelpers.radians(arg.y);
    double z = _ScalerHelpers.radians(arg.z);
    double w = _ScalerHelpers.radians(arg.w);
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
/// Returns [arg] converted from radians to degrees. Return types matches the type of [arg]
dynamic degrees(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.degrees(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.degrees(arg.x);
    double y = _ScalerHelpers.degrees(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.degrees(arg.x);
    double y = _ScalerHelpers.degrees(arg.y);
    double z = _ScalerHelpers.degrees(arg.z);
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
    double x = _ScalerHelpers.degrees(arg.x);
    double y = _ScalerHelpers.degrees(arg.y);
    double z = _ScalerHelpers.degrees(arg.z);
    double w = _ScalerHelpers.degrees(arg.w);
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
