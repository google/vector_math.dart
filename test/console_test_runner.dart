library console_test_runner;

import 'dart:math' as Math;
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:vector_math/vector_math_console.dart';
import 'test_dump_render_tree.dart' as drt;
import 'console_test_harness.dart' as console;

part 'base_test.dart';
part 'test_quaternion.dart';
part 'test_matrix.dart';
part 'test_vector.dart';
part 'test_opengl_matrix.dart';
part 'test_builtin.dart';

main() {
  final config = new VMConfiguration();
  testCore(config);
}

void testCore(Configuration config) {
  configure(config);
  groupSep = ' - ';

  console.main();
  drt.main();
}
