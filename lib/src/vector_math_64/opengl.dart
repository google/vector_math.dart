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

part of vector_math_64;

/**
 * Constructs an OpenGL view matrix in [viewMatrix].
 *
 * [cameraPosition] specifies the position of the camera.
 * [cameraFocusPosition] specifies the position the camera is focused on.
 * [upDirection] specifies the direction of the up vector (usually, +Y).
 */
void setViewMatrix(Matrix4 viewMatrix, Vector3 cameraPosition,
                   Vector3 cameraFocusPosition, Vector3 upDirection) {
  Vector3 z = cameraPosition - cameraFocusPosition;
  z.normalize();
  Vector3 x = upDirection.cross(z);
  x.normalize();
  Vector3 y = z.cross(x);
  y.normalize();
  viewMatrix.setZero();
  viewMatrix.setEntry(3, 3, 1.0);
  viewMatrix.setEntry(0, 0, x.x);
  viewMatrix.setEntry(1, 0, x.y);
  viewMatrix.setEntry(2, 0, x.z);
  viewMatrix.setEntry(0, 1, y.x);
  viewMatrix.setEntry(1, 1, y.y);
  viewMatrix.setEntry(2, 1, y.z);
  viewMatrix.setEntry(0, 2, z.x);
  viewMatrix.setEntry(1, 2, z.y);
  viewMatrix.setEntry(2, 2, z.z);
  viewMatrix.transpose();
  Vector3 rotatedEye = viewMatrix * -cameraPosition;
  viewMatrix.setEntry(0, 3, rotatedEye.x);
  viewMatrix.setEntry(1, 3, rotatedEye.y);
  viewMatrix.setEntry(2, 3, rotatedEye.z);
}

/**
 * Constructs a new OpenGL view matrix.
 *
 * [cameraPosition] specifies the position of the camera.
 * [cameraFocusPosition] specifies the position the camera is focused on.
 * [upDirection] specifies the direction of the up vector (usually, +Y).
 */
Matrix4 makeViewMatrix(Vector3 cameraPosition, Vector3 cameraFocusPosition,
                    Vector3 upDirection) {
  Matrix4 r = new Matrix4.zero();
  setViewMatrix(r, cameraPosition, cameraFocusPosition, upDirection);
  return r;
}

/**
 * Constructs an OpenGL perspective projection matrix in [perspectiveMatrix].
 *
 * [fovYRadians] specifies the field of view angle, in radians, in the y
 * direction.
 * [aspectRatio] specifies the aspect ratio that determines the field of view
 * in the x direction. The aspect ratio of x (width) to y (height).
 * [zNear] specifies the distance from the viewer to the near plane
 * (always positive).
 * [zFar] specifies the distance from the viewer to the far plane
 * (always positive).
 */
void setPerspectiveMatrix(Matrix4 perspectiveMatrix, num fovYRadians,
                          num aspectRatio, num zNear, num zFar) {
  double height = Math.tan(fovYRadians.toDouble() * 0.5) * zNear.toDouble();
  double width = height * aspectRatio.toDouble();
  setFrustumMatrix(perspectiveMatrix, -width, width, -height, height, zNear,
                   zFar);
}

/**
 * Constructs a new OpenGL perspective projection matrix.
 *
 * [fovYRadians] specifies the field of view angle, in radians, in the y
 * direction.
 * [aspectRatio] specifies the aspect ratio that determines the field of view
 * in the x direction. The aspect ratio of x (width) to y (height).
 * [zNear] specifies the distance from the viewer to the near plane
 * (always positive).
 * [zFar] specifies the distance from the viewer to the far plane
 * (always positive).
 */
Matrix4 makePerspectiveMatrix(num fovYRadians, num aspectRatio, num zNear,
                           num zFar) {
  double height = Math.tan(fovYRadians.toDouble() * 0.5) * zNear.toDouble();
  double width = height * aspectRatio.toDouble();
  return makeFrustumMatrix(-width, width, -height, height, zNear, zFar);
}

/**
 * Constructs an OpenGL perspective projection matrix in [perspectiveMatrix].
 *
 * [left], [right] specify the coordinates for the left and right vertical
 * clipping planes.
 * [bottom], [top] specify the coordinates for the bottom and top horizontal
 * clipping planes.
 * [near], [far] specify the coordinates to the near and far depth clipping
 * planes.
 */
void setFrustumMatrix(Matrix4 perspectiveMatrix, num left, num right, num bottom,
                      num top, num near, num far) {
  left = left.toDouble();
  right = right.toDouble();
  bottom = bottom.toDouble();
  top = top.toDouble();
  near = near.toDouble();
  far = far.toDouble();
  double two_near = 2.0 * near;
  double right_minus_left = right - left;
  double top_minus_bottom = top - bottom;
  double far_minus_near = far - near;
  Matrix4 view = perspectiveMatrix.setZero();
  view.setEntry(0, 0, two_near / right_minus_left);
  view.setEntry(1, 1, two_near / top_minus_bottom);
  view.setEntry(0, 2, (right + left) / right_minus_left);
  view.setEntry(1, 2, (top + bottom) / top_minus_bottom);
  view.setEntry(2, 2, -(far + near) / far_minus_near);
  view.setEntry(3, 2, -1.0);
  view.setEntry(2, 3, -(two_near * far) / far_minus_near);
}

/**
 * Constructs a new OpenGL perspective projection matrix.
 *
 * [left], [right] specify the coordinates for the left and right vertical
 * clipping planes.
 * [bottom], [top] specify the coordinates for the bottom and top horizontal
 * clipping planes.
 * [near], [far] specify the coordinates to the near and far depth clipping
 * planes.
 */
Matrix4 makeFrustumMatrix(num left, num right, num bottom, num top, num near,
                       num far) {
  Matrix4 view = new Matrix4.zero();
  setFrustumMatrix(view, left, right, bottom, top, near, far);
  return view;
}

/**
 * Constructs an OpenGL orthographic projection matrix in [orthographicMatrix].
 *
 * [left], [right] specify the coordinates for the left and right vertical
 * clipping planes.
 * [bottom], [top] specify the coordinates for the bottom and top horizontal
 * clipping planes.
 * [near], [far] specify the coordinates to the near and far depth clipping
 * planes.
 */
void setOrthographicMatrix(Matrix4 orthographicMatrix, num left, num right,
                           num bottom, num top, num near, num far) {
  left = left.toDouble();
  right = right.toDouble();
  bottom = bottom.toDouble();
  top = top.toDouble();
  near = near.toDouble();
  far = far.toDouble();
  double rml = right - left;
  double rpl = right + left;
  double tmb = top - bottom;
  double tpb = top + bottom;
  double fmn = far - near;
  double fpn = far + near;
  Matrix4 r = orthographicMatrix.setZero();
  r.setEntry(0, 0, 2.0/rml);
  r.setEntry(1, 1, 2.0/tmb);
  r.setEntry(2, 2, -2.0/fmn);
  r.setEntry(0, 3, -rpl/rml);
  r.setEntry(1, 3, -tpb/tmb);
  r.setEntry(2, 3, -fpn/fmn);
  r.setEntry(3, 3, 1.0);
}

/**
 * Constructs a new OpenGL orthographic projection matrix.
 *
 * [left], [right] specify the coordinates for the left and right vertical
 * clipping planes.
 * [bottom], [top] specify the coordinates for the bottom and top horizontal
 * clipping planes.
 * [near], [far] specify the coordinates to the near and far depth clipping
 * planes.
 */
Matrix4 makeOrthographicMatrix(num left, num right, num bottom, num top, num near,
                      num far) {
  Matrix4 r = new Matrix4.zero();
  setOrthographicMatrix(r, left, right, bottom, top, near, far);
  return r;
}

/**
 * Returns a transformation matrix that transforms points onto
 * the plane specified with [planeNormal] and [planePoint]
 */
Matrix4 makePlaneProjection(Vector3 planeNormal, Vector3 planePoint) {
  Vector4 v = new Vector4(planeNormal.storage[0],
                    planeNormal.storage[1],
                    planeNormal.storage[2],
                    0.0);
  Matrix4 outer = new Matrix4.outer(v, v);
  Matrix4 r = new Matrix4.zero();
  r = r - outer;
  Vector3 scaledNormal = (planeNormal.scaled(dot3(planePoint, planeNormal)));
  Vector4 T = new Vector4(scaledNormal.storage[0],
                    scaledNormal.storage[1],
                    scaledNormal.storage[2],
                    1.0);
  r.setColumn(3, T);
  return r;
}

/**
 * Returns a transformation matrix that transforms points by reflecting
 * them through the plane specified with [planeNormal] and [planePoint]
 */
Matrix4 makePlaneReflection(Vector3 planeNormal, Vector3 planePoint) {
  Vector4 v = new Vector4(planeNormal.storage[0],
                    planeNormal.storage[1],
                    planeNormal.storage[2],
                    0.0);
  Matrix4 outer = new Matrix4.outer(v,v);
  outer.scale(2.0);
  Matrix4 r = new Matrix4.zero();
  r = r - outer;
  double scale = 2.0 * dot3(planePoint, planeNormal);
  Vector3 scaledNormal = (planeNormal.scaled(scale));
  Vector4 T = new Vector4(scaledNormal.storage[0],
                    scaledNormal.storage[1],
                    scaledNormal.storage[2],
                    1.0);
  r.setColumn(3, T);
  return r;
}

/**
 * On success, Sets [pickWorld] to be the world space position of
 * the screen space [pickX], [pickY], and [pickZ].
 *
 * The viewport is specified by ([viewportX], [viewportWidth]) and
 * ([viewportY], [viewportHeight]).
 *
 * [cameraMatrix] includes both the projection and view transforms.
 *
 * [pickZ] is typically either 0.0 (near plane) or 1.0 (far plane).
 *
 * Returns false on error, for example, the mouse is not in the viewport
 *
 */
bool unproject(Matrix4 cameraMatrix, num viewportX, num viewportWidth,
               num viewportY, num viewportHeight,
               num pickX, num pickY, num pickZ,
               Vector3 pickWorld) {
  viewportX = viewportX.toDouble();
  viewportWidth = viewportWidth.toDouble();
  viewportY = viewportY.toDouble();
  viewportHeight = viewportHeight.toDouble();
  pickX = pickX.toDouble();
  pickY = pickY.toDouble();
  pickX = (pickX - viewportX);
  pickY = (pickY - viewportY);
  pickX = (2.0 * pickX / viewportWidth) - 1.0;
  pickY = (2.0 * pickY / viewportHeight) - 1.0;
  pickZ = (2.0 * pickZ) - 1.0;

  // Check if pick point is inside unit cube
  if (pickX < -1.0 || pickY < -1.0 || pickX > 1.0 || pickY > 1.0 ||
      pickZ < -1.0 || pickZ > 1.0) {
    return false;
  }

  // Copy camera matrix.
  Matrix4 invertedCameraMatrix = new Matrix4.copy(cameraMatrix);
  // Invert the camera matrix.
  invertedCameraMatrix.invert();
  // Determine intersection point.
  Vector4 v = new Vector4(pickX, pickY, pickZ, 1.0);
  invertedCameraMatrix.transform(v);
  if (v.w == 0.0) {
    return false;
  }
  double invW = 1.0 / v.w;
  pickWorld.x = v.x * invW;
  pickWorld.y = v.y * invW;
  pickWorld.z = v.z * invW;

  return true;
}

/**
 * On success, [rayNear] and [rayFar] are the points where
 * the screen space [pickX], [pickY] intersect with the near and far
 * planes respectively.
 *
 * The viewport is specified by ([viewportX], [viewportWidth]) and
 * ([viewportY], [viewportHeight]).
 *
 * [cameraMatrix] includes both the projection and view transforms.
 *
 * Returns false on error, for example, the mouse is not in the viewport
 *
 */
bool pickRay(Matrix4 cameraMatrix, num viewportX, num viewportWidth,
               num viewportY, num viewportHeight,
               num pickX, num pickY,
               Vector3 rayNear, Vector3 rayFar) {

  bool r;

  r = unproject(cameraMatrix, viewportX, viewportWidth, viewportY,
                viewportHeight, pickX, viewportHeight-pickY, 0.0, rayNear);
  if (!r) {
    return false;
  }

  r = unproject(cameraMatrix, viewportX, viewportWidth, viewportY,
                viewportHeight, pickX, viewportHeight-pickY, 1.0, rayFar);

  return r;
}
