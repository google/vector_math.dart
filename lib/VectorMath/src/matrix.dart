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

/** Returns an OpenGL LookAt matrix */
mat4x4 makeLookAt(vec3 eyePosition, vec3 lookAtPosition, vec3 upDirection) {
  vec3 z = lookAtPosition - eyePosition;
  z.normalize();
  vec3 x = upDirection.cross(z);
  x.normalize();
  vec3 y = z.cross(x);
  y.normalize();
  mat4x4 r = new mat4x4();
  r[0].xyz = x;
  r[1].xyz = y;
  r[2].xyz = z;
  r[3].w = 1.0;
  vec3 rotatedEye = r * eyePosition;
  r[3].xyz = rotatedEye;
  return r;
}

/** Returns an OpenGL perspective camera projection matrix */
mat4x4 makePerspective(num fov_y_radians, num aspect_ratio, num znear, num zfar) {
  num tan_fov = tan(fov_y_radians * 0.5);
  num height = 1.0/tan_fov;
  num width = height / aspect_ratio;
  num zf_sub_zn = zfar - znear;
  
  mat4x4 r = new mat4x4();
  r[0].x = width;
  r[1].y = height;
  r[2].z = zfar/zf_sub_zn;
  r[3].z = 1.0;
  r[3].w = 0.0;
  return r;
}

/** Returns an OpenGL orthographic camera projection matrix */ 
mat4x4 makeOrthographic(num left, num right, num bottom, num top, num znear, num zfar) {
  num rml = right - left;
  num rpl = right + left;
  num tmb = top - bottom;
  num tpb = top + bottom;
  num fmn = zfar - znear;
  num fpn = zfar + znear;
  
  mat4x4 r = new mat4x4();
  r[0].x = 2.0/rml;
  r[1].y = 2.0/tmb;
  r[2].z = 2.0/fmn;
  r[3].x = rpl/rml;
  r[3].y = tpb/tmb;
  r[3].z = fpn/fmn;
  r[3].w = 1.0;
  
  return r;
}

/** Returns a transformation matrix that transforms points onto the plane specified with [planeNormal] and [planePoint] */
mat4x4 makePlaneProjection(vec3 planeNormal, vec3 planePoint) {
  vec4 v = new vec4(planeNormal, 0.0);
  mat4x4 outer = new mat4x4.outer(v, v);
  mat4x4 r = new mat4x4();
  r = r - outer;
  vec3 scaledNormal = (planeNormal * dot(planePoint, planeNormal));
  vec4 T = new vec4(scaledNormal, 1.0);
  r.col3 = T;
  return r;
}

/** Returns a transformation matrix that transforms points by reflecting them in the plane specified with [planeNormal] and [planePoint] */
mat4x4 makePlaneReflection(vec3 planeNormal, vec3 planePoint) {
  vec4 v = new vec4(planeNormal, 0.0);
  mat4x4 outer = new mat4x4.outer(v,v);
  outer.selfScale(2.0);
  mat4x4 r = new mat4x4();
  r = r - outer;
  num scale = 2.0 * dot(planePoint, planeNormal);
  vec3 scaledNormal = (planeNormal * scale);
  vec4 T = new vec4(scaledNormal, 1.0);
  r.col3 = T;
  return r;
}