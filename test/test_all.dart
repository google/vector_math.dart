library console_test_harness;

import 'package:unittest/unittest.dart';

import 'aabb_test.dart' as aabb;
import 'colors_test.dart' as colors;
import 'frustum_test.dart' as frustum;
import 'geometry_test.dart' as geometry;
import 'matrix_test.dart' as matrix;
import 'noise_test.dart' as noise;
import 'opengl_matrix_test.dart' as opengl_matrix;
import 'plane_test.dart' as plane;
import 'quaternion_test.dart' as quaternion;
import 'ray_test.dart' as ray;
import 'sphere_test.dart' as sphere;
import 'utilities_test.dart' as utilities;
import 'vector_test.dart' as vector;

void main() {
  group('AABB', aabb.main);
  group('Colors', colors.main);
  group('Frustum', frustum.main);
  group('Geometry', geometry.main);
  group('Matrix', matrix.main);
  group('Noise', noise.main);
  group('OpenGL', opengl_matrix.main);
  group('Plane', plane.main);
  group('Quaternion', quaternion.main);
  group('Ray', ray.main);
  group('Sphere', sphere.main);
  group('Utilities', utilities.main);
  group('Vector', vector.main);
}
