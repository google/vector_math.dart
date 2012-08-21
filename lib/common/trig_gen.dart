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
Dynamic sin(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.sin(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    out.x = Math.sin(arg.x);
    out.y = Math.sin(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = Math.sin(arg.x);
    out.y = Math.sin(arg.y);
    out.z = Math.sin(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    out.x = Math.sin(arg.x);
    out.y = Math.sin(arg.y);
    out.z = Math.sin(arg.z);
    out.w = Math.sin(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns cosine of [arg]. Return type matches the type of [arg]
Dynamic cos(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.cos(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    out.x = Math.cos(arg.x);
    out.y = Math.cos(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = Math.cos(arg.x);
    out.y = Math.cos(arg.y);
    out.z = Math.cos(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    out.x = Math.cos(arg.x);
    out.y = Math.cos(arg.y);
    out.z = Math.cos(arg.z);
    out.w = Math.cos(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns tangent of [arg]. Return type matches the type of [arg]
Dynamic tan(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.tan(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    out.x = Math.tan(arg.x);
    out.y = Math.tan(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = Math.tan(arg.x);
    out.y = Math.tan(arg.y);
    out.z = Math.tan(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    out.x = Math.tan(arg.x);
    out.y = Math.tan(arg.y);
    out.z = Math.tan(arg.z);
    out.w = Math.tan(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc sine of [arg]. Return type matches the type of [arg]
Dynamic asin(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.asin(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    out.x = Math.asin(arg.x);
    out.y = Math.asin(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = Math.asin(arg.x);
    out.y = Math.asin(arg.y);
    out.z = Math.asin(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    out.x = Math.asin(arg.x);
    out.y = Math.asin(arg.y);
    out.z = Math.asin(arg.z);
    out.w = Math.asin(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc cosine of [arg]. Return type matches the type of [arg]
Dynamic acos(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.acos(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    out.x = Math.acos(arg.x);
    out.y = Math.acos(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = Math.acos(arg.x);
    out.y = Math.acos(arg.y);
    out.z = Math.acos(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    out.x = Math.acos(arg.x);
    out.y = Math.acos(arg.y);
    out.z = Math.acos(arg.z);
    out.w = Math.acos(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] converted from degrees to radians. Return types matches the type of [arg]
Dynamic radians(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.radians(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    out.x = _ScalerHelpers.radians(arg.x);
    out.y = _ScalerHelpers.radians(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = _ScalerHelpers.radians(arg.x);
    out.y = _ScalerHelpers.radians(arg.y);
    out.z = _ScalerHelpers.radians(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    out.x = _ScalerHelpers.radians(arg.x);
    out.y = _ScalerHelpers.radians(arg.y);
    out.z = _ScalerHelpers.radians(arg.z);
    out.w = _ScalerHelpers.radians(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] converted from radians to degrees. Return types matches the type of [arg]
Dynamic degrees(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.degrees(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    out.x = _ScalerHelpers.degrees(arg.x);
    out.y = _ScalerHelpers.degrees(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = _ScalerHelpers.degrees(arg.x);
    out.y = _ScalerHelpers.degrees(arg.y);
    out.z = _ScalerHelpers.degrees(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    out.x = _ScalerHelpers.degrees(arg.x);
    out.y = _ScalerHelpers.degrees(arg.y);
    out.z = _ScalerHelpers.degrees(arg.z);
    out.w = _ScalerHelpers.degrees(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
