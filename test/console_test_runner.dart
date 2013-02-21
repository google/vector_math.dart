library console_test_runner;

import 'dart:math' as Math;
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:vector_math/vector_math.dart';
import 'test_dump_render_tree.dart' as drt;
import 'console_test_harness.dart' as console;

import 'vector_math_test.dart';

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
