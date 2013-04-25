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
    return _ScalarHelpers.abs(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.abs(arg.x);
    double y = _ScalarHelpers.abs(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.abs(arg.x);
    double y = _ScalarHelpers.abs(arg.y);
    double z = _ScalarHelpers.abs(arg.z);
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
    double x = _ScalarHelpers.abs(arg.x);
    double y = _ScalarHelpers.abs(arg.y);
    double z = _ScalarHelpers.abs(arg.z);
    double w = _ScalarHelpers.abs(arg.w);
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
    return _ScalarHelpers.sign(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.sign(arg.x);
    double y = _ScalarHelpers.sign(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.sign(arg.x);
    double y = _ScalarHelpers.sign(arg.y);
    double z = _ScalarHelpers.sign(arg.z);
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
    double x = _ScalarHelpers.sign(arg.x);
    double y = _ScalarHelpers.sign(arg.y);
    double z = _ScalarHelpers.sign(arg.z);
    double w = _ScalarHelpers.sign(arg.w);
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
    return _ScalarHelpers.floor(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.floor(arg.x);
    double y = _ScalarHelpers.floor(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.floor(arg.x);
    double y = _ScalarHelpers.floor(arg.y);
    double z = _ScalarHelpers.floor(arg.z);
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
    double x = _ScalarHelpers.floor(arg.x);
    double y = _ScalarHelpers.floor(arg.y);
    double z = _ScalarHelpers.floor(arg.z);
    double w = _ScalarHelpers.floor(arg.w);
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
    return _ScalarHelpers.truncate(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.truncate(arg.x);
    double y = _ScalarHelpers.truncate(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.truncate(arg.x);
    double y = _ScalarHelpers.truncate(arg.y);
    double z = _ScalarHelpers.truncate(arg.z);
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
    double x = _ScalarHelpers.truncate(arg.x);
    double y = _ScalarHelpers.truncate(arg.y);
    double z = _ScalarHelpers.truncate(arg.z);
    double w = _ScalarHelpers.truncate(arg.w);
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
    return _ScalarHelpers.round(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.round(arg.x);
    double y = _ScalarHelpers.round(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.round(arg.x);
    double y = _ScalarHelpers.round(arg.y);
    double z = _ScalarHelpers.round(arg.z);
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
    double x = _ScalarHelpers.round(arg.x);
    double y = _ScalarHelpers.round(arg.y);
    double z = _ScalarHelpers.round(arg.z);
    double w = _ScalarHelpers.round(arg.w);
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
    return _ScalarHelpers.roundEven(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.roundEven(arg.x);
    double y = _ScalarHelpers.roundEven(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.roundEven(arg.x);
    double y = _ScalarHelpers.roundEven(arg.y);
    double z = _ScalarHelpers.roundEven(arg.z);
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
    double x = _ScalarHelpers.roundEven(arg.x);
    double y = _ScalarHelpers.roundEven(arg.y);
    double z = _ScalarHelpers.roundEven(arg.z);
    double w = _ScalarHelpers.roundEven(arg.w);
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
    return _ScalarHelpers.ceil(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.ceil(arg.x);
    double y = _ScalarHelpers.ceil(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.ceil(arg.x);
    double y = _ScalarHelpers.ceil(arg.y);
    double z = _ScalarHelpers.ceil(arg.z);
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
    double x = _ScalarHelpers.ceil(arg.x);
    double y = _ScalarHelpers.ceil(arg.y);
    double z = _ScalarHelpers.ceil(arg.z);
    double w = _ScalarHelpers.ceil(arg.w);
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
    return _ScalarHelpers.fract(arg);
  }
  if (arg is vec2) {
    double x = _ScalarHelpers.fract(arg.x);
    double y = _ScalarHelpers.fract(arg.y);
    if (out == null) {
      out = new vec2(x, y);
    } else {
      (out as vec2).storage[0] = x;
      (out as vec2).storage[1] = y;
    }
    return out;
  }
  if (arg is vec3) {
    double x = _ScalarHelpers.fract(arg.x);
    double y = _ScalarHelpers.fract(arg.y);
    double z = _ScalarHelpers.fract(arg.z);
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
    double x = _ScalarHelpers.fract(arg.x);
    double y = _ScalarHelpers.fract(arg.y);
    double z = _ScalarHelpers.fract(arg.z);
    double w = _ScalarHelpers.fract(arg.w);
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
    return _ScalarHelpers.mod(x, y);
  }
  if (x is vec2) {
    double x_ = _ScalarHelpers.mod(x.x, y.x);
    double y_ = _ScalarHelpers.mod(x.y, y.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalarHelpers.mod(x.x, y.x);
    double y_ = _ScalarHelpers.mod(x.y, y.y);
    double z_ = _ScalarHelpers.mod(x.z, y.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalarHelpers.mod(x.x, y.x);
    double y_ = _ScalarHelpers.mod(x.y, y.y);
    double z_ = _ScalarHelpers.mod(x.z, y.z);
    double w_ = _ScalarHelpers.mod(x.w, y.w);
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
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
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
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
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
    return _ScalarHelpers.clamp(x, min_, max_);
  }
  if (x is vec2) {
    double x_ = _ScalarHelpers.clamp(x.x, min_.x, max_.x);
    double y_ = _ScalarHelpers.clamp(x.y, min_.y, max_.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalarHelpers.clamp(x.x, min_.x, max_.x);
    double y_ = _ScalarHelpers.clamp(x.y, min_.y, max_.y);
    double z_ = _ScalarHelpers.clamp(x.z, min_.z, max_.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalarHelpers.clamp(x.x, min_.x, max_.x);
    double y_ = _ScalarHelpers.clamp(x.y, min_.y, max_.y);
    double z_ = _ScalarHelpers.clamp(x.z, min_.z, max_.z);
    double w_ = _ScalarHelpers.clamp(x.w, min_.w, max_.w);
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
  if (t is double) {
    if (x is double) {
      return _ScalarHelpers.mix(x, y, t);
    }
    if (x is vec2) {
      x = x as vec2;
      y = y as vec2;
      return new vec2(_ScalarHelpers.mix(x.x, y.x, t), _ScalarHelpers.mix(x.y, y.y, t));
    }
    if (x is vec3) {
      x = x as vec3;
      y = y as vec3;
      return new vec3(_ScalarHelpers.mix(x.x, y.x, t), _ScalarHelpers.mix(x.y, y.y, t), _ScalarHelpers.mix(x.z, y.z, t));
    }
    if (x is vec4) {
      x = x as vec4;
      y = y as vec4;
      return new vec4(_ScalarHelpers.mix(x.x, y.x, t), _ScalarHelpers.mix(x.y, y.y, t), _ScalarHelpers.mix(x.z, y.z, t), _ScalarHelpers.mix(x.w, y.w, t));
    }
    throw new ArgumentError(x);
  } else {
    if (x is double) {
      return _ScalarHelpers.mix(x, y, t);
    }
    if (x is vec2) {
      x = x as vec2;
      y = y as vec2;
      t = t as vec2;
      return new vec2(_ScalarHelpers.mix(x.x, y.x, t.x), _ScalarHelpers.mix(x.y, y.y, t.y));
    }
    if (x is vec3) {
      x = x as vec3;
      y = y as vec3;
      t = t as vec3;
      return new vec3(_ScalarHelpers.mix(x.x, y.x, t.x), _ScalarHelpers.mix(x.y, y.y, t.y), _ScalarHelpers.mix(x.z, y.z, t.z));
    }
    if (x is vec4) {
      x = x as vec4;
      y = y as vec4;
      t = t as vec4;
      return new vec4(_ScalarHelpers.mix(x.x, y.x, t.x), _ScalarHelpers.mix(x.y, y.y, t.y), _ScalarHelpers.mix(x.z, y.z, t.z), _ScalarHelpers.mix(x.w, y.w, t.w));
    }
    throw new ArgumentError('');
  }
}
/// Returns 0.0 if x < [y] and 1.0 otherwise.
dynamic step(dynamic x, dynamic y, [dynamic out=null]) {
  if (x is double) {
    return _ScalarHelpers.step(x, y);
  }
  if (x is vec2) {
    double x_ = _ScalarHelpers.step(x.x, y.x);
    double y_ = _ScalarHelpers.step(x.y, y.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalarHelpers.step(x.x, y.x);
    double y_ = _ScalarHelpers.step(x.y, y.y);
    double z_ = _ScalarHelpers.step(x.z, y.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalarHelpers.step(x.x, y.x);
    double y_ = _ScalarHelpers.step(x.y, y.y);
    double z_ = _ScalarHelpers.step(x.z, y.z);
    double w_ = _ScalarHelpers.step(x.w, y.w);
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
    return _ScalarHelpers.smoothstep(edge0, edge1, x);
  }
  if (x is vec2) {
    double x_ = _ScalarHelpers.smoothstep(edge0.x, edge1.x, x.x);
    double y_ = _ScalarHelpers.smoothstep(edge0.y, edge1.y, x.y);
    if (out == null) {
      out = new vec2(x_, y_);
    }
    (out as vec2).storage[0] = x_;
    (out as vec2).storage[1] = y_;
    return out;
  }
  if (x is vec3) {
    double x_ = _ScalarHelpers.smoothstep(edge0.x, edge1.x, x.x);
    double y_ = _ScalarHelpers.smoothstep(edge0.y, edge1.y, x.y);
    double z_ = _ScalarHelpers.smoothstep(edge0.z, edge1.z, x.z);
    if (out == null) {
      out = new vec3(x_, y_, z_);
    }
    (out as vec3).storage[0] = x_;
    (out as vec3).storage[1] = y_;
    (out as vec3).storage[2] = z_;
    return out;
  }
  if (x is vec4) {
    double x_ = _ScalarHelpers.smoothstep(edge0.x, edge1.x, x.x);
    double y_ = _ScalarHelpers.smoothstep(edge0.y, edge1.y, x.y);
    double z_ = _ScalarHelpers.smoothstep(edge0.z, edge1.z, x.z);
    double w_ = _ScalarHelpers.smoothstep(edge0.w, edge1.w, x.w);
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
