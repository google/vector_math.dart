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

library vector_math_geometry;

import 'dart:typed_data';
import 'dart:math' as Math;

import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_lists.dart';

part 'src/vector_math_geometry/mesh_geometry.dart';

part 'src/vector_math_geometry/filters/barycentric_filter.dart';
part 'src/vector_math_geometry/filters/color_filter.dart';
part 'src/vector_math_geometry/filters/flat_shade_filter.dart';
part 'src/vector_math_geometry/filters/geometry_filter.dart';
part 'src/vector_math_geometry/filters/invert_filter.dart';
part 'src/vector_math_geometry/filters/transform_filter.dart';

part 'src/vector_math_geometry/generators/attribute_generators.dart';
part 'src/vector_math_geometry/generators/circle_generator.dart';
part 'src/vector_math_geometry/generators/cube_generator.dart';
part 'src/vector_math_geometry/generators/cylinder_generator.dart';
part 'src/vector_math_geometry/generators/geometry_generator.dart';
part 'src/vector_math_geometry/generators/sphere_generator.dart';
part 'src/vector_math_geometry/generators/ring_generator.dart';
