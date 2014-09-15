library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'package:hop_unittest/hop_unittest.dart';

import 'generate_vector_math_64_task.dart';
import '../test/console_test_harness.dart' as console_test_harness;

void main(List<String> args) {

  //
  // Analyzer
  //
  //TODO (fox32): Analyse all libraries
  addTask('analyze_lib', createAnalyzerTask(['lib/vector_math.dart']));

  //
  // Unit test
  //
  addTask('test', createUnitTestTask(console_test_harness.main));

  //
  // Doc generation
  //
  //TODO (fox32): Fix dartdoc generation in hop runner
  //addTask('docs', createDartDocTask(_getLibs));

  //
  // Vector Math 64 generation
  //
  addTask('generate_vector_math_64', createGenerateVectorMath64Task());

  //
  // Hop away!
  //
  runHop(args);
}

Future<List<String>> _getLibs() {
  return new Directory('lib').list()
      .where((FileSystemEntity fse) => fse is File)
      .map((File file) => file.path)
      .toList();
}
