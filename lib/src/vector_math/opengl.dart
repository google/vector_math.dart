// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of vector_math;

/// Constructs a rotation matrix in [rotationMatrix].
///
/// Sets [rotationMatrix] to a rotation matrix built from
/// [forwardDirection] and [upDirection]. The right direction is
/// constructed to be orthogonal to [forwardDirection] and
/// [upDirection].
///
/// [forwardDirection] specifies the direction of the forward vector.
/// [upDirection] specifies the direction of the up vector.
///
/// Use case is to build the per-model rotation matrix from vectors
/// [forwardDirection] and [upDirection]. See sample code below for
/// a context.
///
///     class Model {
///       Vector3 _center = new Vector3.zero();        // per-model translation
///       Vector3 _scale = new Vector3(1.0, 1.0, 1.0); // per-model scaling
///       Matrix4 _rotation = new Matrix4.identity();  // per-model rotation
///       Matrix4 _MV = new Matrix4.identity();        // per-model model-view
///
///       void updateModelViewUniform(RenderingContext gl, UniformLocation u_MV,
///         Vector3 camPosition, camFocusPosition, camUpDirection) {
///
///         // V = View (inverse of camera)
///         // T = Translation
///         // R = Rotation
///         // S = Scaling
///         setViewMatrix(_MV, camPosition, camFocusPosition, camUpDirection); // MV = V
///         _MV.translate(_center); // MV = V*T
///         _MV.multiply(_rotation); // MV = V*T*R
///         // _rotation is updated with setRotationMatrix(_rotation, forward, up);
///         _MV.scale(_scale); // MV = V*T*R*S
///
///         gl.uniformMatrix4fv(u_MV, false, _MV.storage);
///       }
///     }
void setRotationMatrix(
    Matrix4 rotationMatrix, Vector3 forwardDirection, Vector3 upDirection) {
  setModelMatrix(rotationMatrix, forwardDirection, upDirection, 0.0, 0.0, 0.0);
}

/// Constructs an OpenGL model matrix in [modelMatrix].
/// Model transformation is the inverse of the view transformation.
/// Model transformation is also known as "camera" transformation.
/// Model matrix is commonly used to compute a object location/orientation into
/// the full model-view stack.
///
/// [forwardDirection] specifies the direction of the forward vector.
/// [upDirection] specifies the direction of the up vector.
/// [tx],[ty],[tz] specifies the position of the object.
void setModelMatrix(Matrix4 modelMatrix, Vector3 forwardDirection,
    Vector3 upDirection, double tx, double ty, double tz) {
  Vector3 right = forwardDirection.cross(upDirection).normalize();
  Vector3 c1 = right;
  Vector3 c2 = upDirection;
  Vector3 c3 = -forwardDirection;
  modelMatrix.setValues(c1[0], c1[1], c1[2], 0.0, c2[0], c2[1], c2[2], 0.0,
      c3[0], c3[1], c3[2], 0.0, tx, ty, tz, 1.0);
}

/// Constructs an OpenGL view matrix in [viewMatrix].
/// View transformation is the inverse of the model transformation.
/// View matrix is commonly used to compute the camera location/orientation into
/// the full model-view stack.
///
/// [cameraPosition] specifies the position of the camera.
/// [cameraFocusPosition] specifies the position the camera is focused on.
/// [upDirection] specifies the direction of the up vector (usually, +Y).
void setViewMatrix(Matrix4 viewMatrix, Vector3 cameraPosition,
    Vector3 cameraFocusPosition, Vector3 upDirection) {
  Vector3 z = cameraPosition - cameraFocusPosition;
  z.normalize();
  Vector3 x = upDirection.cross(z);
  x.normalize();
  Vector3 y = z.cross(x);
  y.normalize();

  double rotatedEyeX = -x.dot(cameraPosition);
  double rotatedEyeY = -y.dot(cameraPosition);
  double rotatedEyeZ = -z.dot(cameraPosition);

  viewMatrix.setValues(x[0], y[0], z[0], 0.0, x[1], y[1], z[1], 0.0, x[2], y[2],
      z[2], 0.0, rotatedEyeX, rotatedEyeY, rotatedEyeZ, 1.0);
}

/// Constructs a new OpenGL view matrix.
///
/// [cameraPosition] specifies the position of the camera.
/// [cameraFocusPosition] specifies the position the camera is focused on.
/// [upDirection] specifies the direction of the up vector (usually, +Y).
Matrix4 makeViewMatrix(
    Vector3 cameraPosition, Vector3 cameraFocusPosition, Vector3 upDirection) {
  Matrix4 r = new Matrix4.zero();
  setViewMatrix(r, cameraPosition, cameraFocusPosition, upDirection);
  return r;
}

/// Constructs an OpenGL perspective projection matrix in [perspectiveMatrix].
///
/// [fovYRadians] specifies the field of view angle, in radians, in the y
/// direction.
/// [aspectRatio] specifies the aspect ratio that determines the field of view
/// in the x direction. The aspect ratio of x (width) to y (height).
/// [zNear] specifies the distance from the viewer to the near plane
/// (always positive).
/// [zFar] specifies the distance from the viewer to the far plane
/// (always positive).
void setPerspectiveMatrix(Matrix4 perspectiveMatrix, double fovYRadians,
    double aspectRatio, double zNear, double zFar) {
  double height = Math.tan(fovYRadians * 0.5) * zNear;
  double width = height * aspectRatio;
  setFrustumMatrix(
      perspectiveMatrix, -width, width, -height, height, zNear, zFar);
}

/// Constructs a new OpenGL perspective projection matrix.
///
/// [fovYRadians] specifies the field of view angle, in radians, in the y
/// direction.
/// [aspectRatio] specifies the aspect ratio that determines the field of view
/// in the x direction. The aspect ratio of x (width) to y (height).
/// [zNear] specifies the distance from the viewer to the near plane
/// (always positive).
/// [zFar] specifies the distance from the viewer to the far plane
/// (always positive).
Matrix4 makePerspectiveMatrix(
    double fovYRadians, double aspectRatio, double zNear, double zFar) {
  Matrix4 r = new Matrix4.zero();
  setPerspectiveMatrix(r, fovYRadians, aspectRatio, zNear, zFar);
  return r;
}

/// Constructs an OpenGL perspective projection matrix in [perspectiveMatrix].
///
/// [left], [right] specify the coordinates for the left and right vertical
/// clipping planes.
/// [bottom], [top] specify the coordinates for the bottom and top horizontal
/// clipping planes.
/// [near], [far] specify the coordinates to the near and far depth clipping
/// planes.
void setFrustumMatrix(Matrix4 perspectiveMatrix, double left, double right,
    double bottom, double top, double near, double far) {
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

/// Constructs a new OpenGL perspective projection matrix.
///
/// [left], [right] specify the coordinates for the left and right vertical
/// clipping planes.
/// [bottom], [top] specify the coordinates for the bottom and top horizontal
/// clipping planes.
/// [near], [far] specify the coordinates to the near and far depth clipping
/// planes.
Matrix4 makeFrustumMatrix(double left, double right, double bottom, double top,
    double near, double far) {
  Matrix4 view = new Matrix4.zero();
  setFrustumMatrix(view, left, right, bottom, top, near, far);
  return view;
}

/// Constructs an OpenGL orthographic projection matrix in [orthographicMatrix].
///
/// [left], [right] specify the coordinates for the left and right vertical
/// clipping planes.
/// [bottom], [top] specify the coordinates for the bottom and top horizontal
/// clipping planes.
/// [near], [far] specify the coordinates to the near and far depth clipping
/// planes.
void setOrthographicMatrix(Matrix4 orthographicMatrix, double left,
    double right, double bottom, double top, double near, double far) {
  double rml = right - left;
  double rpl = right + left;
  double tmb = top - bottom;
  double tpb = top + bottom;
  double fmn = far - near;
  double fpn = far + near;
  Matrix4 r = orthographicMatrix.setZero();
  r.setEntry(0, 0, 2.0 / rml);
  r.setEntry(1, 1, 2.0 / tmb);
  r.setEntry(2, 2, -2.0 / fmn);
  r.setEntry(0, 3, -rpl / rml);
  r.setEntry(1, 3, -tpb / tmb);
  r.setEntry(2, 3, -fpn / fmn);
  r.setEntry(3, 3, 1.0);
}

/// Constructs a new OpenGL orthographic projection matrix.
///
/// [left], [right] specify the coordinates for the left and right vertical
/// clipping planes.
/// [bottom], [top] specify the coordinates for the bottom and top horizontal
/// clipping planes.
/// [near], [far] specify the coordinates to the near and far depth clipping
/// planes.
Matrix4 makeOrthographicMatrix(double left, double right, double bottom,
    double top, double near, double far) {
  Matrix4 r = new Matrix4.zero();
  setOrthographicMatrix(r, left, right, bottom, top, near, far);
  return r;
}

/// Returns a transformation matrix that transforms points onto
/// the plane specified with [planeNormal] and [planePoint].
Matrix4 makePlaneProjection(Vector3 planeNormal, Vector3 planePoint) {
  Vector4 v = new Vector4(planeNormal.storage[0], planeNormal.storage[1],
      planeNormal.storage[2], 0.0);
  Matrix4 outer = new Matrix4.outer(v, v);
  Matrix4 r = new Matrix4.zero();
  r = r - outer;
  Vector3 scaledNormal = (planeNormal.scaled(dot3(planePoint, planeNormal)));
  Vector4 T = new Vector4(scaledNormal.storage[0], scaledNormal.storage[1],
      scaledNormal.storage[2], 1.0);
  r.setColumn(3, T);
  return r;
}

/// Returns a transformation matrix that transforms points by reflecting
/// them through the plane specified with [planeNormal] and [planePoint].
Matrix4 makePlaneReflection(Vector3 planeNormal, Vector3 planePoint) {
  Vector4 v = new Vector4(planeNormal.storage[0], planeNormal.storage[1],
      planeNormal.storage[2], 0.0);
  Matrix4 outer = new Matrix4.outer(v, v);
  outer.scale(2.0);
  Matrix4 r = new Matrix4.zero();
  r = r - outer;
  double scale = 2.0 * planePoint.dot(planeNormal);
  Vector3 scaledNormal = (planeNormal.scaled(scale));
  Vector4 T = new Vector4(scaledNormal.storage[0], scaledNormal.storage[1],
      scaledNormal.storage[2], 1.0);
  r.setColumn(3, T);
  return r;
}

/// On success, Sets [pickWorld] to be the world space position of
/// the screen space [pickX], [pickY], and [pickZ].
///
/// The viewport is specified by ([viewportX], [viewportWidth]) and
/// ([viewportY], [viewportHeight]).
///
/// [cameraMatrix] includes both the projection and view transforms.
///
/// [pickZ] is typically either 0.0 (near plane) or 1.0 (far plane).
///
/// Returns false on error, for example, the mouse is not in the viewport
bool unproject(
    Matrix4 cameraMatrix,
    num viewportX,
    num viewportWidth,
    num viewportY,
    num viewportHeight,
    num pickX,
    num pickY,
    num pickZ,
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
  if (pickX < -1.0 ||
      pickY < -1.0 ||
      pickX > 1.0 ||
      pickY > 1.0 ||
      pickZ < -1.0 ||
      pickZ > 1.0) {
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

/// On success, [rayNear] and [rayFar] are the points where
/// the screen space [pickX], [pickY] intersect with the near and far
/// planes respectively.
///
/// The viewport is specified by ([viewportX], [viewportWidth]) and
/// ([viewportY], [viewportHeight]).
///
/// [cameraMatrix] includes both the projection and view transforms.
///
/// Returns false on error, for example, the mouse is not in the viewport.
bool pickRay(
    Matrix4 cameraMatrix,
    num viewportX,
    num viewportWidth,
    num viewportY,
    num viewportHeight,
    num pickX,
    num pickY,
    Vector3 rayNear,
    Vector3 rayFar) {
  bool r;

  r = unproject(cameraMatrix, viewportX, viewportWidth, viewportY,
      viewportHeight, pickX, viewportHeight - pickY, 0.0, rayNear);
  if (!r) {
    return false;
  }

  r = unproject(cameraMatrix, viewportX, viewportWidth, viewportY,
      viewportHeight, pickX, viewportHeight - pickY, 1.0, rayFar);

  return r;
}
