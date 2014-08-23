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

/// A library containing different type of vector operation for use in games,
/// simulations or rendering.
///
/// The library contains Vector classes ([Vector2], [Vector3] and [Vector4]),
/// Matrices classes ([Matrix2], [Matrix3] and [Matrix4]) and collision
/// detection related classes ([Aabb2], [Aabb3], [Frustum], [Obb3], [Plane],
/// [Quad], [Ray], [Sphere] and [Triangle]).
///
/// In addition some utilities are avialable as color operations (See [Colors]
/// class), noise generators ([SimplexNoise]) and common OpenGL operations
/// (like [makeViewMatrix], [makePerspectiveMatrix] or [pickRay]).
///
/// There is also a [vector_math_64_64] library available that uses double precision
/// (64-bit) instead of single precision (32-bit) floating point numbers for
/// storage.
library vector_math_64;

import 'dart:typed_data';
import 'dart:math' as Math;

part 'src/vector_math_64/utilities.dart';
part 'src/vector_math_64/aabb2.dart';
part 'src/vector_math_64/aabb3.dart';
part 'src/vector_math_64/colors.dart';
part 'src/vector_math_64/constants.dart';
part 'src/vector_math_64/error_helpers.dart';
part 'src/vector_math_64/frustum.dart';
part 'src/vector_math_64/matrix2.dart';
part 'src/vector_math_64/matrix3.dart';
part 'src/vector_math_64/matrix4.dart';
part 'src/vector_math_64/noise.dart';
part 'src/vector_math_64/obb3.dart';
part 'src/vector_math_64/opengl.dart';
part 'src/vector_math_64/plane.dart';
part 'src/vector_math_64/quad.dart';
part 'src/vector_math_64/quaternion.dart';
part 'src/vector_math_64/ray.dart';
part 'src/vector_math_64/sphere.dart';
part 'src/vector_math_64/triangle.dart';
part 'src/vector_math_64/vector.dart';
part 'src/vector_math_64/vector2.dart';
part 'src/vector_math_64/vector3.dart';
part 'src/vector_math_64/vector4.dart';
