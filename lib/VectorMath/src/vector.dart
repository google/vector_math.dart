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

num dot(Dynamic x, Dynamic y) {
  return x.dot(y);
}

num length(Dynamic x) {
  return x.length();
}

num distance(Dynamic x, Dynamic y) {
  return length(x-y);
}

vec3 cross(vec3 x, vec3 y) {
  return x.cross(y);
}

Dynamic normalize(Dynamic x) {
  if (x is num) {
    return 1.0 * sign(x);
  }
  Dynamic r;
  if (x is vec2) {
    r = new vec2(x);
    r.normalize();
  }
  if (x is vec3) {
    r = new vec3(x);
    r.normalize();
  }
  if (x is vec4) {
    r = new vec4(x);
    r.normalize();
  }
  return r;
}