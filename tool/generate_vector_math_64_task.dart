library generate_vector_math_64_task;

import 'dart:io';
import 'dart:async';
import 'package:hop/hop.dart';


Task createGenerateVectorMath64Task()
  => new Task((ctx) => generateVectorMath64()
  .then((_) => ctx.info('GENERATED vector_math_64')));

Future generateVectorMath64() {
  final testDirectory = new Directory('test/src/vector_math_64/');
  final libraryDirectory = new Directory('lib/src/vector_math_64/');
  final libraryFile = new File('lib/vector_math_64.dart');

  return Future.wait([
    libraryDirectory.exists()
      .then((exists) => exists ? libraryDirectory.delete(recursive: true) : null),
    testDirectory.exists()
      .then((exists) => exists ? testDirectory.delete(recursive: true) : null),
    libraryFile.exists().then((exists) => exists ? libraryFile.delete() : null)
  ])
  .then((_) => libraryDirectory.create(recursive: true))
  .then((_) => testDirectory.create(recursive: true))
  .then((_) => Future.wait([
    _processLibraryFile('lib/vector_math.dart'),
    new Directory('lib/src/vector_math/').list()
      .toList().then((l) => Future.forEach(l, (f) => _processLibraryFile(f.path))),
    new Directory('test/src/vector_math/').list()
      .toList().then((l) => Future.forEach(l, (f) => _processTestFile(f.path)))
  ]));
}

Future _processLibraryFile(String inputFilename) {
  final outputFilename = inputFilename.replaceAll('vector_math', 'vector_math_64');

  if (inputFilename.contains('packages')) {
    return new Future.value();
  }

  return new File(inputFilename).readAsString()
    .then((s) => _libraryConvertToVectorMath64(s))
    .then((s) => new File(outputFilename).writeAsString(s));
}

Future _processTestFile(String inputFilename) {
  final outputFilename = inputFilename.replaceAll('vector_math', 'vector_math_64');

  if (inputFilename.contains('packages')) {
    return new Future.value();
  }

  return new File(inputFilename).readAsString()
    .then((s) => _testConvertToVectorMath64(s))
    .then((s) => new File(outputFilename).writeAsString(s));
}

String _libraryConvertToVectorMath64(String input) {
  return input
    .replaceAll('vector_math', 'vector_math_64')
    .replaceAll('Float32List', 'Float64List');
}

String _testConvertToVectorMath64(String input) {
  return input
    .replaceAllMapped(new RegExp('library test_(.*);'), (m) {
      return 'library test_${m.group(1)}_64;';
    })
    .replaceAll('/vector_math.dart', '/vector_math_64.dart')
    .replaceAll('Float32List', 'Float64List');
}
