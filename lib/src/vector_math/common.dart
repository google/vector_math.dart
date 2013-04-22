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



/// Returns absolute value of [arg].
dynamic abs(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.abs(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.abs(arg.x);
    double y = _ScalerHelpers.abs(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.abs(arg.x);
    double y = _ScalerHelpers.abs(arg.y);
    double z = _ScalerHelpers.abs(arg.z);
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
    double x = _ScalerHelpers.abs(arg.x);
    double y = _ScalerHelpers.abs(arg.y);
    double z = _ScalerHelpers.abs(arg.z);
    double w = _ScalerHelpers.abs(arg.w);
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
/// Returns 1.0 or 0.0 or -1.0 depending on sign of [arg].
dynamic sign(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.sign(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.sign(arg.x);
    double y = _ScalerHelpers.sign(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.sign(arg.x);
    double y = _ScalerHelpers.sign(arg.y);
    double z = _ScalerHelpers.sign(arg.z);
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
    double x = _ScalerHelpers.sign(arg.x);
    double y = _ScalerHelpers.sign(arg.y);
    double z = _ScalerHelpers.sign(arg.z);
    double w = _ScalerHelpers.sign(arg.w);
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
/// Returns floor value of [arg].
dynamic floor(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.floor(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.floor(arg.x);
    double y = _ScalerHelpers.floor(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.floor(arg.x);
    double y = _ScalerHelpers.floor(arg.y);
    double z = _ScalerHelpers.floor(arg.z);
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
    double x = _ScalerHelpers.floor(arg.x);
    double y = _ScalerHelpers.floor(arg.y);
    double z = _ScalerHelpers.floor(arg.z);
    double w = _ScalerHelpers.floor(arg.w);
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
/// Returns [arg] truncated.
dynamic trunc(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.truncate(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.truncate(arg.x);
    double y = _ScalerHelpers.truncate(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.truncate(arg.x);
    double y = _ScalerHelpers.truncate(arg.y);
    double z = _ScalerHelpers.truncate(arg.z);
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
    double x = _ScalerHelpers.truncate(arg.x);
    double y = _ScalerHelpers.truncate(arg.y);
    double z = _ScalerHelpers.truncate(arg.z);
    double w = _ScalerHelpers.truncate(arg.w);
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
/// Returns [arg] rounded to nearest integer.
dynamic round(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.round(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.round(arg.x);
    double y = _ScalerHelpers.round(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.round(arg.x);
    double y = _ScalerHelpers.round(arg.y);
    double z = _ScalerHelpers.round(arg.z);
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
    double x = _ScalerHelpers.round(arg.x);
    double y = _ScalerHelpers.round(arg.y);
    double z = _ScalerHelpers.round(arg.z);
    double w = _ScalerHelpers.round(arg.w);
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
/// Returns [arg] rounded to nearest even integer.
dynamic roundEven(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.roundEven(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.roundEven(arg.x);
    double y = _ScalerHelpers.roundEven(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.roundEven(arg.x);
    double y = _ScalerHelpers.roundEven(arg.y);
    double z = _ScalerHelpers.roundEven(arg.z);
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
    double x = _ScalerHelpers.roundEven(arg.x);
    double y = _ScalerHelpers.roundEven(arg.y);
    double z = _ScalerHelpers.roundEven(arg.z);
    double w = _ScalerHelpers.roundEven(arg.w);
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
/// Returns ceiling of [arg]
dynamic ceil(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.ceil(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.ceil(arg.x);
    double y = _ScalerHelpers.ceil(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.ceil(arg.x);
    double y = _ScalerHelpers.ceil(arg.y);
    double z = _ScalerHelpers.ceil(arg.z);
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
    double x = _ScalerHelpers.ceil(arg.x);
    double y = _ScalerHelpers.ceil(arg.y);
    double z = _ScalerHelpers.ceil(arg.z);
    double w = _ScalerHelpers.ceil(arg.w);
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
/// Returns fraction of [arg]
dynamic fract(dynamic arg, [dynamic out=null]) {
  if (arg is double) {
    return _ScalerHelpers.fract(arg);
  }
  if (arg is vec2) {
    double x = _ScalerHelpers.fract(arg.x);
    double y = _ScalerHelpers.fract(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalerHelpers.fract(arg.x);
    double y = _ScalerHelpers.fract(arg.y);
    double z = _ScalerHelpers.fract(arg.z);
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
    double x = _ScalerHelpers.fract(arg.x);
    double y = _ScalerHelpers.fract(arg.y);
    double z = _ScalerHelpers.fract(arg.z);
    double w = _ScalerHelpers.fract(arg.w);
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
/// Returns [x] mod [y]
dynamic mod(dynamic x, dynamic y, [dynamic out=null]) {
  if (x is double) {
    return _ScalerHelpers.mod(x, y);
  }
  if (x is vec2) {
    double x_ = _ScalerHelpers.mod(x.x, y.x);
    double y_ = _ScalerHelpers.mod(x.y, y.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x;
    (out as vec2).storage[1] = y;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalerHelpers.mod(x.x, y.x);
    double y_ = _ScalerHelpers.mod(x.y, y.y);
    double z_ = _ScalerHelpers.mod(x.z, y.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalerHelpers.mod(x.x, y.x);
    double y_ = _ScalerHelpers.mod(x.y, y.y);
    double z_ = _ScalerHelpers.mod(x.z, y.z);
    double w_ = _ScalerHelpers.mod(x.w, y.w);
    if (out == null) {
      out = new vec4(x_, y_, z_, w_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    (out as vec4).storage[3] = w_;
    return out;
  }
  throw new ArgumentError(x);
}
/// Returns component wise minimum of [x] and [y]
dynamic min(dynamic x, dynamic y, [dynamic out=null]) {
  if (x is double) {
    return Math.min(x, y);
  }
  if (x is vec2) {
    double x_ = Math.min(x.x, y.x);
    double y_ = Math.min(x.y, y.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x;
    (out as vec2).storage[1] = y;
    return out;
  }
  if (x is vec3) {
    double x_ = Math.min(x.x, y.x);
    double y_ = Math.min(x.y, y.y);
    double z_ = Math.min(x.z, y.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = Math.min(x.x, y.x);
    double y_ = Math.min(x.y, y.y);
    double z_ = Math.min(x.z, y.z);
    double w_ = Math.min(x.w, y.w);
    if (out == null) {
      out = new vec4(x_, y_, z_, w_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    (out as vec4).storage[3] = w_;
    return out;
  }
  throw new ArgumentError(x);
}
/// Returns component wise maximum of [x] and [y]
dynamic max(dynamic x, dynamic y, [dynamic out=null]) {
  if (x is double) {
    return Math.max(x, y);
  }
  if (x is vec2) {
    double x_ = Math.max(x.x, y.x);
    double y_ = Math.max(x.y, y.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x;
    (out as vec2).storage[1] = y;
    return out;
  }
  if (x is vec3) {
    double x_ = Math.max(x.x, y.x);
    double y_ = Math.max(x.y, y.y);
    double z_ = Math.max(x.z, y.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = Math.max(x.x, y.x);
    double y_ = Math.max(x.y, y.y);
    double z_ = Math.max(x.z, y.z);
    double w_ = Math.max(x.w, y.w);
    if (out == null) {
      out = new vec4(x_, y_, z_, w_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    (out as vec4).storage[3] = w_;
    return out;
  }
  throw new ArgumentError(x);
}
/// Component wise clamp of [x] between [min_] and [max_]
dynamic clamp(dynamic x, dynamic min_, dynamic max_, [dynamic out=null]) {
  if (x is double) {
    return _ScalerHelpers.clamp(x, min_, max_);
  }
  if (x is vec2) {
    double x_ = _ScalerHelpers.clamp(x.x, min_.x, max_.x);
    double y_ = _ScalerHelpers.clamp(x.y, min_.y, max_.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalerHelpers.clamp(x.x, min_.x, max_.x);
    double y_ = _ScalerHelpers.clamp(x.y, min_.y, max_.y);
    double z_ = _ScalerHelpers.clamp(x.z, min_.z, max_.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalerHelpers.clamp(x.x, min_.x, max_.x);
    double y_ = _ScalerHelpers.clamp(x.y, min_.y, max_.y);
    double z_ = _ScalerHelpers.clamp(x.z, min_.z, max_.z);
    double w_ = _ScalerHelpers.clamp(x.w, min_.w, max_.w);
    if (out == null) {
      out = new vec4(x_, y_, z_, w_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    (out as vec4).storage[3] = w_;
    return out;
  }
  throw new ArgumentError(x);
}
/// Linear interpolation between [x] and [y] with [t]. [t] must be between 0.0 and 1.0.
dynamic mix(dynamic x, dynamic y, dynamic t) {
  if (t is num) {
      if (x is num) {
        return _ScalerHelpers.mix(x, y, t);
      }
      if (x is vec2) {
        x = x as vec2;
        return new vec2(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t));
      }
      if (x is vec3) {
        x = x as vec3;
        return new vec3(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t), _ScalerHelpers.mix(x.z, y.z, t));
      }
      if (x is vec4) {
        x = x as vec4;
        return new vec4(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t), _ScalerHelpers.mix(x.z, y.z, t), _ScalerHelpers.mix(x.w, y.w, t));
      }
      throw new ArgumentError(x);

  } else {
      if (x is num) {
        return _ScalerHelpers.mix(x, y, t);
      }
      if (x is vec2) {
        x = x as vec2;
        return new vec2(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y));
      }
      if (x is vec3) {
        x = x as vec3;
        return new vec3(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z));
      }
      if (x is vec4) {
        x = x as vec4;
        return new vec4(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z), _ScalerHelpers.mix(x.w, y.w, t.w));
      }
      throw new ArgumentError(x);

  }
}
/// Returns 0.0 if x < [y] and 1.0 otherwise.
dynamic step(dynamic x, dynamic y, [dynamic out=null]) {
  if (x is double) {
    return _ScalerHelpers.step(x, y);
  }
  if (x is vec2) {
    double x_ = _ScalerHelpers.step(x.x, y.x);
    double y_ = _ScalerHelpers.step(x.y, y.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalerHelpers.step(x.x, y.x);
    double y_ = _ScalerHelpers.step(x.y, y.y);
    double z_ = _ScalerHelpers.step(x.z, y.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalerHelpers.step(x.x, y.x);
    double y_ = _ScalerHelpers.step(x.y, y.y);
    double z_ = _ScalerHelpers.step(x.z, y.z);
    double w_ = _ScalerHelpers.step(x.w, y.w);
    if (out == null) {
      out = new vec4(x_, y_, z_, w_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    (out as vec4).storage[3] = w_;
    return out;
  }
  throw new ArgumentError(x);
}
/// Hermite intpolation between [edge0] and [edge1]. [edge0] < [x] < [edge1].
dynamic smoothstep(dynamic edge0, dynamic edge1, dynamic x, [dynamic out=null]) {
  if (x is double) {
    return _ScalerHelpers.smoothstep(edge0, edge1, x);
  }
  if (x is vec2) {
    double x_ = _ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x);
    double y_ = _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x);
    double y_ = _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y);
    double z_ = _ScalerHelpers.smoothstep(edge0.z, edge1.z, x.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x);
    double y_ = _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y);
    double z_ = _ScalerHelpers.smoothstep(edge0.z, edge1.z, x.z);
    double w_ = _ScalerHelpers.smoothstep(edge0.w, edge1.w, x.w);
    if (out == null) {
      out = new vec4(x_, y_, z_, w_);
    }
    (out as vec4).storage[0] = x_;
    (out as vec4).storage[1] = y_;
    (out as vec4).storage[2] = z_;
    (out as vec4).storage[3] = w_;
    return out;
  }
  throw new ArgumentError(x);
}
