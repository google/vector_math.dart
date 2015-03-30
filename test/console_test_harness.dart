library console_test_harness;

import 'package:unittest/unittest.dart';

import 'test_aabb.dart' as aabb;
import 'test_colors.dart' as colors;
import 'test_frustum.dart' as frustum;
import 'test_geometry.dart' as geometry;
import 'test_matrix.dart' as matrix;
import 'test_noise.dart' as noise;
import 'test_opengl_matrix.dart' as opengl_matrix;
import 'test_plane.dart' as plane;
import 'test_quaternion.dart' as quaternion;
import 'test_ray.dart' as ray;
import 'test_sphere.dart' as sphere;
import 'test_utilities.dart' as utilities;
import 'test_vector.dart' as vector;

void main() {
  groupSep = ' - ';

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
