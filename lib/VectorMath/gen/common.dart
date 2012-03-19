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
/// Returns absolute value of [arg].
Dynamic abs(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.abs(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.abs(arg.x), _ScalerHelpers.abs(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.abs(arg.x), _ScalerHelpers.abs(arg.y), _ScalerHelpers.abs(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.abs(arg.x), _ScalerHelpers.abs(arg.y), _ScalerHelpers.abs(arg.z), _ScalerHelpers.abs(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns 1.0 or 0.0 or -1.0 depending on sign of [arg].
Dynamic sign(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.sign(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.sign(arg.x), _ScalerHelpers.sign(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.sign(arg.x), _ScalerHelpers.sign(arg.y), _ScalerHelpers.sign(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.sign(arg.x), _ScalerHelpers.sign(arg.y), _ScalerHelpers.sign(arg.z), _ScalerHelpers.sign(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns floor value of [arg].
Dynamic floor(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.floor(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.floor(arg.x), _ScalerHelpers.floor(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.floor(arg.x), _ScalerHelpers.floor(arg.y), _ScalerHelpers.floor(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.floor(arg.x), _ScalerHelpers.floor(arg.y), _ScalerHelpers.floor(arg.z), _ScalerHelpers.floor(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] truncated.
Dynamic trunc(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.truncate(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.truncate(arg.x), _ScalerHelpers.truncate(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.truncate(arg.x), _ScalerHelpers.truncate(arg.y), _ScalerHelpers.truncate(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.truncate(arg.x), _ScalerHelpers.truncate(arg.y), _ScalerHelpers.truncate(arg.z), _ScalerHelpers.truncate(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] rounded to nearest integer.
Dynamic round(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.round(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.round(arg.x), _ScalerHelpers.round(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.round(arg.x), _ScalerHelpers.round(arg.y), _ScalerHelpers.round(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.round(arg.x), _ScalerHelpers.round(arg.y), _ScalerHelpers.round(arg.z), _ScalerHelpers.round(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] rounded to nearest even integer.
Dynamic roundEven(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.roundEven(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.roundEven(arg.x), _ScalerHelpers.roundEven(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.roundEven(arg.x), _ScalerHelpers.roundEven(arg.y), _ScalerHelpers.roundEven(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.roundEven(arg.x), _ScalerHelpers.roundEven(arg.y), _ScalerHelpers.roundEven(arg.z), _ScalerHelpers.roundEven(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns ceiling of [arg]
Dynamic ceil(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.ceil(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.ceil(arg.x), _ScalerHelpers.ceil(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.ceil(arg.x), _ScalerHelpers.ceil(arg.y), _ScalerHelpers.ceil(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.ceil(arg.x), _ScalerHelpers.ceil(arg.y), _ScalerHelpers.ceil(arg.z), _ScalerHelpers.ceil(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns fraction of [arg]
Dynamic fract(Dynamic arg) {
  if (arg is num) {
    return _ScalerHelpers.fract(arg);
  }
  if (arg is vec2) {
    return new vec2(_ScalerHelpers.fract(arg.x), _ScalerHelpers.fract(arg.y));
  }
  if (arg is vec3) {
    return new vec3(_ScalerHelpers.fract(arg.x), _ScalerHelpers.fract(arg.y), _ScalerHelpers.fract(arg.z));
  }
  if (arg is vec4) {
    return new vec4(_ScalerHelpers.fract(arg.x), _ScalerHelpers.fract(arg.y), _ScalerHelpers.fract(arg.z), _ScalerHelpers.fract(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [x] mod [y]
Dynamic mod(Dynamic x, Dynamic y) {
  if (x is num) {
    return _ScalerHelpers.mod(x, y);
  }
  if (x is vec2) {
    return new vec2(_ScalerHelpers.mod(x.x, y.x), _ScalerHelpers.mod(x.y, y.y));
  }
  if (x is vec3) {
    return new vec3(_ScalerHelpers.mod(x.x, y.x), _ScalerHelpers.mod(x.y, y.y), _ScalerHelpers.mod(x.z, y.z));
  }
  if (x is vec4) {
    return new vec4(_ScalerHelpers.mod(x.x, y.x), _ScalerHelpers.mod(x.y, y.y), _ScalerHelpers.mod(x.z, y.z), _ScalerHelpers.mod(x.w, y.w));
  }
  throw new IllegalArgumentException(x);
}
/// Returns component wise minimum of [x] and [y]
Dynamic min(Dynamic x, Dynamic y) {
  if (x is num) {
    return Math.min(x, y);
  }
  if (x is vec2) {
    return new vec2(Math.min(x.x, y.x), Math.min(x.y, y.y));
  }
  if (x is vec3) {
    return new vec3(Math.min(x.x, y.x), Math.min(x.y, y.y), Math.min(x.z, y.z));
  }
  if (x is vec4) {
    return new vec4(Math.min(x.x, y.x), Math.min(x.y, y.y), Math.min(x.z, y.z), Math.min(x.w, y.w));
  }
  throw new IllegalArgumentException(x);
}
/// Returns component wise maximum of [x] and [y]
Dynamic max(Dynamic x, Dynamic y) {
  if (x is num) {
    return Math.max(x, y);
  }
  if (x is vec2) {
    return new vec2(Math.max(x.x, y.x), Math.max(x.y, y.y));
  }
  if (x is vec3) {
    return new vec3(Math.max(x.x, y.x), Math.max(x.y, y.y), Math.max(x.z, y.z));
  }
  if (x is vec4) {
    return new vec4(Math.max(x.x, y.x), Math.max(x.y, y.y), Math.max(x.z, y.z), Math.max(x.w, y.w));
  }
  throw new IllegalArgumentException(x);
}
/// Component wise clamp of [x] between [min_] and [max_]
Dynamic clamp(Dynamic x, Dynamic min_, Dynamic max_) {
  if (x is num) {
    return _ScalerHelpers.clamp(x, min_, max_);
  }
  if (x is vec2) {
    return new vec2(_ScalerHelpers.clamp(x.x, min_.x, max_.x), _ScalerHelpers.clamp(x.y, min_.y, max_.y));
  }
  if (x is vec3) {
    return new vec3(_ScalerHelpers.clamp(x.x, min_.x, max_.x), _ScalerHelpers.clamp(x.y, min_.y, max_.y), _ScalerHelpers.clamp(x.z, min_.z, max_.z));
  }
  if (x is vec4) {
    return new vec4(_ScalerHelpers.clamp(x.x, min_.x, max_.x), _ScalerHelpers.clamp(x.y, min_.y, max_.y), _ScalerHelpers.clamp(x.z, min_.z, max_.z), _ScalerHelpers.clamp(x.w, min_.w, max_.w));
  }
  throw new IllegalArgumentException(x);
}
/// Linear interpolation between [x] and [y] with [t]. [t] must be between 0.0 and 1.0.
Dynamic mix(Dynamic x, Dynamic y, Dynamic t) {
  if (x is num) {
    return _ScalerHelpers.mix(x, y, t);
  }
  if (x is vec2) {
    return new vec2(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y));
  }
  if (x is vec3) {
    return new vec3(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z));
  }
  if (x is vec4) {
    return new vec4(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z), _ScalerHelpers.mix(x.w, y.w, t.w));
  }
  throw new IllegalArgumentException(x);
}
/// Returns 0.0 if x < [y] and 1.0 otherwise.
Dynamic step(Dynamic x, Dynamic y) {
  if (x is num) {
    return _ScalerHelpers.step(x, y);
  }
  if (x is vec2) {
    return new vec2(_ScalerHelpers.step(x.x, y.x), _ScalerHelpers.step(x.y, y.y));
  }
  if (x is vec3) {
    return new vec3(_ScalerHelpers.step(x.x, y.x), _ScalerHelpers.step(x.y, y.y), _ScalerHelpers.step(x.z, y.z));
  }
  if (x is vec4) {
    return new vec4(_ScalerHelpers.step(x.x, y.x), _ScalerHelpers.step(x.y, y.y), _ScalerHelpers.step(x.z, y.z), _ScalerHelpers.step(x.w, y.w));
  }
  throw new IllegalArgumentException(x);
}
/// Hermite intpolation between [edge0] and [edge1]. [edge0] < [x] < [edge1].
Dynamic smoothstep(Dynamic edge0, Dynamic edge1, Dynamic x) {
  if (x is num) {
    return _ScalerHelpers.smoothstep(edge0, edge1, x);
  }
  if (x is vec2) {
    return new vec2(_ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x), _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y));
  }
  if (x is vec3) {
    return new vec3(_ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x), _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y), _ScalerHelpers.smoothstep(edge0.z, edge1.z, x.z));
  }
  if (x is vec4) {
    return new vec4(_ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x), _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y), _ScalerHelpers.smoothstep(edge0.z, edge1.z, x.z), _ScalerHelpers.smoothstep(edge0.w, edge1.w, x.w));
  }
  throw new IllegalArgumentException(x);
}
