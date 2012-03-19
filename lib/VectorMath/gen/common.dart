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
/// 
Dynamic abs(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.abs(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.abs(arg.x), ScalarMath.abs(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.abs(arg.x), ScalarMath.abs(arg.y), ScalarMath.abs(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.abs(arg.x), ScalarMath.abs(arg.y), ScalarMath.abs(arg.z), ScalarMath.abs(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic sign(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.sign(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.sign(arg.x), ScalarMath.sign(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.sign(arg.x), ScalarMath.sign(arg.y), ScalarMath.sign(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.sign(arg.x), ScalarMath.sign(arg.y), ScalarMath.sign(arg.z), ScalarMath.sign(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic floor(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.floor(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.floor(arg.x), ScalarMath.floor(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.floor(arg.x), ScalarMath.floor(arg.y), ScalarMath.floor(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.floor(arg.x), ScalarMath.floor(arg.y), ScalarMath.floor(arg.z), ScalarMath.floor(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic trunc(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.truncate(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.truncate(arg.x), ScalarMath.truncate(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.truncate(arg.x), ScalarMath.truncate(arg.y), ScalarMath.truncate(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.truncate(arg.x), ScalarMath.truncate(arg.y), ScalarMath.truncate(arg.z), ScalarMath.truncate(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic round(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.round(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.round(arg.x), ScalarMath.round(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.round(arg.x), ScalarMath.round(arg.y), ScalarMath.round(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.round(arg.x), ScalarMath.round(arg.y), ScalarMath.round(arg.z), ScalarMath.round(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic roundEven(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.roundEven(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.roundEven(arg.x), ScalarMath.roundEven(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.roundEven(arg.x), ScalarMath.roundEven(arg.y), ScalarMath.roundEven(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.roundEven(arg.x), ScalarMath.roundEven(arg.y), ScalarMath.roundEven(arg.z), ScalarMath.roundEven(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic ceil(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.ceil(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.ceil(arg.x), ScalarMath.ceil(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.ceil(arg.x), ScalarMath.ceil(arg.y), ScalarMath.ceil(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.ceil(arg.x), ScalarMath.ceil(arg.y), ScalarMath.ceil(arg.z), ScalarMath.ceil(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic fract(Dynamic arg) {
  if (arg is num) {
    return ScalarMath.fract(arg);
  }
  if (arg is vec2) {
    return new vec2(ScalarMath.fract(arg.x), ScalarMath.fract(arg.y));
  }
  if (arg is vec3) {
    return new vec3(ScalarMath.fract(arg.x), ScalarMath.fract(arg.y), ScalarMath.fract(arg.z));
  }
  if (arg is vec4) {
    return new vec4(ScalarMath.fract(arg.x), ScalarMath.fract(arg.y), ScalarMath.fract(arg.z), ScalarMath.fract(arg.w));
  }
  throw new IllegalArgumentException(arg);
}
/// 
Dynamic mod(Dynamic x, Dynamic y) {
  if (x is num) {
    return ScalarMath.mod(x, y);
  }
  if (x is vec2) {
    return new vec2(ScalarMath.mod(x.x, y.x), ScalarMath.mod(x.y, y.y));
  }
  if (x is vec3) {
    return new vec3(ScalarMath.mod(x.x, y.x), ScalarMath.mod(x.y, y.y), ScalarMath.mod(x.z, y.z));
  }
  if (x is vec4) {
    return new vec4(ScalarMath.mod(x.x, y.x), ScalarMath.mod(x.y, y.y), ScalarMath.mod(x.z, y.z), ScalarMath.mod(x.w, y.w));
  }
  throw new IllegalArgumentException(x);
}
/// 
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
/// 
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
/// 
Dynamic clamp(Dynamic x, Dynamic min_, Dynamic max_) {
  if (x is num) {
    return ScalarMath.clamp(x, min_, max_);
  }
  if (x is vec2) {
    return new vec2(ScalarMath.clamp(x.x, min_.x, max_.x), ScalarMath.clamp(x.y, min_.y, max_.y));
  }
  if (x is vec3) {
    return new vec3(ScalarMath.clamp(x.x, min_.x, max_.x), ScalarMath.clamp(x.y, min_.y, max_.y), ScalarMath.clamp(x.z, min_.z, max_.z));
  }
  if (x is vec4) {
    return new vec4(ScalarMath.clamp(x.x, min_.x, max_.x), ScalarMath.clamp(x.y, min_.y, max_.y), ScalarMath.clamp(x.z, min_.z, max_.z), ScalarMath.clamp(x.w, min_.w, max_.w));
  }
  throw new IllegalArgumentException(x);
}
/// 
Dynamic mix(Dynamic x, Dynamic y, Dynamic t) {
  if (x is num) {
    return ScalarMath.mix(x, y, t);
  }
  if (x is vec2) {
    return new vec2(ScalarMath.mix(x.x, y.x, t.x), ScalarMath.mix(x.y, y.y, t.y));
  }
  if (x is vec3) {
    return new vec3(ScalarMath.mix(x.x, y.x, t.x), ScalarMath.mix(x.y, y.y, t.y), ScalarMath.mix(x.z, y.z, t.z));
  }
  if (x is vec4) {
    return new vec4(ScalarMath.mix(x.x, y.x, t.x), ScalarMath.mix(x.y, y.y, t.y), ScalarMath.mix(x.z, y.z, t.z), ScalarMath.mix(x.w, y.w, t.w));
  }
  throw new IllegalArgumentException(x);
}
/// 
Dynamic step(Dynamic x, Dynamic y) {
  if (x is num) {
    return ScalarMath.step(x, y);
  }
  if (x is vec2) {
    return new vec2(ScalarMath.step(x.x, y.x), ScalarMath.step(x.y, y.y));
  }
  if (x is vec3) {
    return new vec3(ScalarMath.step(x.x, y.x), ScalarMath.step(x.y, y.y), ScalarMath.step(x.z, y.z));
  }
  if (x is vec4) {
    return new vec4(ScalarMath.step(x.x, y.x), ScalarMath.step(x.y, y.y), ScalarMath.step(x.z, y.z), ScalarMath.step(x.w, y.w));
  }
  throw new IllegalArgumentException(x);
}
/// 
Dynamic smoothstep(Dynamic edge0, Dynamic edge1, Dynamic x) {
  if (x is num) {
    return ScalarMath.smoothstep(edge0, edge1, x);
  }
  if (x is vec2) {
    return new vec2(ScalarMath.smoothstep(edge0.x, edge1.x, x.x), ScalarMath.smoothstep(edge0.y, edge1.y, x.y));
  }
  if (x is vec3) {
    return new vec3(ScalarMath.smoothstep(edge0.x, edge1.x, x.x), ScalarMath.smoothstep(edge0.y, edge1.y, x.y), ScalarMath.smoothstep(edge0.z, edge1.z, x.z));
  }
  if (x is vec4) {
    return new vec4(ScalarMath.smoothstep(edge0.x, edge1.x, x.x), ScalarMath.smoothstep(edge0.y, edge1.y, x.y), ScalarMath.smoothstep(edge0.z, edge1.z, x.z), ScalarMath.smoothstep(edge0.w, edge1.w, x.w));
  }
  throw new IllegalArgumentException(x);
}
