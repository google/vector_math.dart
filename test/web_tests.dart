library web_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'src/vector_math/test_quaternion.dart' as test_quaternion;
import 'src/vector_math/test_quad.dart' as test_quad;
import 'src/vector_math/test_matrix2.dart' as test_matrix2;
import 'src/vector_math/test_matrix3.dart' as test_matrix3;
import 'src/vector_math/test_matrix4.dart' as test_matrix4;
import 'src/vector_math/test_colors.dart' as test_colors;
import 'src/vector_math/test_noise.dart' as test_noise;
import 'src/vector_math/test_vector2.dart' as test_vector2;
import 'src/vector_math/test_vector3.dart' as test_vector3;
import 'src/vector_math/test_vector4.dart' as test_vector4;
import 'src/vector_math/test_aabb2.dart' as test_aabb2;
import 'src/vector_math/test_aabb3.dart' as test_aabb3;
import 'src/vector_math/test_obb3.dart' as test_obb3;
import 'src/vector_math/test_opengl.dart' as test_opengl;
import 'src/vector_math/test_utilities.dart' as test_utilities;
import 'src/vector_math/test_sphere.dart' as test_sphere;
import 'src/vector_math/test_ray.dart' as test_ray;
import 'src/vector_math/test_triangle.dart' as test_triangle;
import 'src/vector_math/test_plane.dart' as test_plane;
import 'src/vector_math/test_frustum.dart' as test_frustum;
import 'src/vector_math_64/test_quaternion.dart' as test_quaternion_64;
import 'src/vector_math_64/test_quad.dart' as test_quad_64;
import 'src/vector_math_64/test_matrix2.dart' as test_matrix2_64;
import 'src/vector_math_64/test_matrix3.dart' as test_matrix3_64;
import 'src/vector_math_64/test_matrix4.dart' as test_matrix4_64;
import 'src/vector_math_64/test_colors.dart' as test_colors_64;
import 'src/vector_math_64/test_noise.dart' as test_noise_64;
import 'src/vector_math_64/test_vector2.dart' as test_vector2_64;
import 'src/vector_math_64/test_vector3.dart' as test_vector3_64;
import 'src/vector_math_64/test_vector4.dart' as test_vector4_64;
import 'src/vector_math_64/test_aabb2.dart' as test_aabb2_64;
import 'src/vector_math_64/test_aabb3.dart' as test_aabb3_64;
import 'src/vector_math_64/test_obb3.dart' as test_obb3_64;
import 'src/vector_math_64/test_opengl.dart' as test_opengl_64;
import 'src/vector_math_64/test_utilities.dart' as test_utilities_64;
import 'src/vector_math_64/test_sphere.dart' as test_sphere_64;
import 'src/vector_math_64/test_ray.dart' as test_ray_64;
import 'src/vector_math_64/test_triangle.dart' as test_triangle_64;
import 'src/vector_math_64/test_plane.dart' as test_plane_64;
import 'src/vector_math_64/test_frustum.dart' as test_frustum_64;
import 'src/vector_math_geometry/test_geometry.dart' as test_geometry;
import 'src/vector_math_list/test_vector_list.dart' as test_vector_list;

/**
 * Allows to run tests in the browser.
 */
main() {
  useHtmlEnhancedConfiguration();
  groupSep = ' - ';

   group('vector_math', () {
     test_aabb2.main();
     test_aabb3.main();
     test_colors.main();
     test_frustum.main();
     test_matrix2.main();
     test_matrix3.main();
     test_matrix4.maib();
     test_noise.main();
     test_obb3.main();
     test_opengl.main();
     test_plane.main();
     test_quad.main();
     test_quaternion.main();
     test_ray.main();
     test_sphere.main();
     test_triangle.main();
     test_utilities.main();
     test_vector2.main();
     test_vector3.main();
     test_vector4.main();
   });

   group('vector_math_64', () {
     test_aabb2_64.main();
     test_aabb3_64.main();
     test_colors_64.main();
     test_frustum_64.main();
     test_matrix2_64.main();
     test_matrix3_64.main();
     test_matrix4_64.maib();
     test_noise_64.main();
     test_obb3_64.main();
     test_opengl_64.main();
     test_plane_64.main();
     test_quad_64.main();
     test_quaternion_64.main();
     test_ray_64.main();
     test_sphere_64.main();
     test_triangle_64.main();
     test_utilities_64.main();
     test_vector2_64.main();
     test_vector3_64.main();
     test_vector4_64.main();
   });

   group('vector_math_geometry', () {
     test_geometry.main();
   });

   group('vector_math_list', () {
     test_vector_list.main();
   });

   group('vector_math_operations', () {
   });
}
