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

/// Returns the dot product between vectors [x] and [y]. The dimension of [x] and [y] must match.
num dot(Dynamic x, Dynamic y) {
  return x.dot(y);
}

/// Returns the length of vector [x]
num length(Dynamic x) {
  return x.length();
}

/// Returns the length squared of vector [x]
num length2(Dynamic x) {
  return x.length2();
}

/// Returns the distance between vectors [x] and [y]. The dimension of [x] and [y] must match.
num distance(Dynamic x, Dynamic y) {
  return length(x - y);
}

/// Returns the distance squared between vectors [x] and [y].
num distance2(Dynamic x, Dynamic y) {
  return length2(x - y);
}

/// Returns the cross product between [x] and [y]. [x] and [y] can be vec2, vec3 or num, but not all combinations are supported.
Dynamic cross(Dynamic x, Dynamic y) {
  if ((x is vec3 && y is vec3) ||
      (x is vec2 && y is vec2)) {
    return x.cross(y);
  } else if (x is num && y is vec2) {
    return new vec2(-x * y.y, x * y.x);
  } else if (x is vec2 && y is num) {
    return new vec2(y * x.y, -y * x.y);
  } else {
    assert(false);
  }
  return null;
}

/// Returns [x] normalized. Supports [num], [vec2], [vec3], and [vec4] input types. The return type will match the type of [x]
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

void buildPlaneVectors(final vec3 planeNormal, vec3 u, vec3 v) {
  if (planeNormal.z.abs() > _ScalerHelpers._sqrtOneHalf) {
    // choose u in y-z plane
    double a = planeNormal.y*planeNormal.y + planeNormal.z*planeNormal.z;
    double k = 1.0/Math.sqrt(a);
    u.x = 0.0;
    u.y = -planeNormal.z*k;
    u.z = planeNormal.y*k;
    v.x = a*k;
    v.y = -planeNormal[0]*(planeNormal[1]*k);
    v.z = planeNormal[0]*(-planeNormal[2]*k);
  } else {
    // choose u in x-y plane
    double a = planeNormal.x*planeNormal.x + planeNormal.y*planeNormal.y;
    double k = 1.0/Math.sqrt(a);
    u.x = -planeNormal[1]*k;
    u.y = planeNormal[0]*k;
    u.z = 0.0;
    v.x = -planeNormal[2]*(planeNormal[0]*k);
    v.y = planeNormal[2]*(-planeNormal[1]*k);
    v.z = a*k;
  }
}
