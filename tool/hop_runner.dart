library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:bot/bot.dart';
import 'package:bot/hop.dart';
import 'package:bot/hop_tasks.dart';

import '../test/console_test_runner.dart' as console_runner;

void main() {
  //
  // Assert were being called from the proper location.
  //
  _assertKnownPath();

  //
  // Analyzer
  //
  addTask('analyze_lib', createDartAnalyzerTask(['lib/vector_math.dart']));

  //
  // Unit test
  //
  addTask('test', createUnitTestTask(console_runner.testCore));

  //
  // Doc generation
  //
  addTask('docs', getCompileDocsFunc('gh-pages', 'packages/', _getLibs));

  //
  // Hop away!
  //
  runHopCore();
}

void _assertKnownPath() {
  // since there is no way to determine the path of 'this' file
  // assume that Directory.current() is the root of the project.
  // So check for existance of /bin/hop_runner.dart
  final thisFile = new File('tool/hop_runner.dart');
  assert(thisFile.existsSync());
}

Future<List<String>> _getLibs() {
  final completer = new Completer<List<String>>();

  final lister = new Directory('lib').list();
  final libs = new List<String>();

  lister.onFile = (String file) {
    // DARTBUG: http://code.google.com/p/dart/issues/detail?id=8335
    // excluding html_enhanced_config
    final forbidden = ['html_enhanced_config'].mappedBy((n) => '$n.dart');
    if(file.endsWith('.dart') && forbidden.every((f) => !file.endsWith(f))) {
      libs.add(file);
    }
  };

  lister.onDone = (bool done) {
    if(done) {
      completer.complete(libs);
    } else {
      completer.completeError('did not finish');
    }
  };

  lister.onError = (error) {
    completer.completeError(error);
  };

  return completer.future;
}
