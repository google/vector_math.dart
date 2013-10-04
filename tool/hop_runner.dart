library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

import '../test/console_test_harness.dart' as console_test_harness;

void main() {
  //
  // Assert were being called from the proper location.
  //
  _assertKnownPath();

  //
  // Analyzer
  //
  addTask('analyze_lib', createAnalyzerTask(['lib/vector_math.dart']));

  //
  // Unit test
  //
  addTask('test', createUnitTestTask(console_test_harness.testCore));

  //
  // Doc generation
  //
  addTask('docs', createDartDocTask(_getLibs));

  //
  // Hop away!
  //
  runHop();
}

void _assertKnownPath() {
  // since there is no way to determine the path of 'this' file
  // assume that Directory.current() is the root of the project.
  // So check for existance of /bin/hop_runner.dart
  final thisFile = new File('tool/hop_runner.dart');
  assert(thisFile.existsSync());
}

Future<List<String>> _getLibs() {
  return new Directory('lib').list()
      .where((FileSystemEntity fse) => fse is File)
      .map((File file) => file.path)
      .toList();
}
