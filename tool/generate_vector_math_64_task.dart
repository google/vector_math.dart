library generate_vector_math_64_task;

import 'dart:io';
import 'dart:async';
import 'package:hop/hop.dart';


Task createGenerateVectorMath64Task()
  => new Task((ctx) => generateVectorMath64());

Future generateVectorMath64() {
  final directory = new Directory('lib/src/vector_math_64/');
  final libraryFile = new File('lib/vector_math_64.dart');

  return Future.wait([
    directory.exists()
      .then((exists) => exists ? directory.delete(recursive: true) : null),
    libraryFile.exists().then((exists) => exists ? libraryFile.delete() : null)
  ]).then((_) => Future.wait([
    directory.create(recursive: true),
    _processFile('lib/vector_math.dart'),
    new Directory('lib/src/vector_math/').list()
      .toList().then((l) => Future.forEach(l, (f) => _processFile(f.path)))
  ]));
}

Future _processFile(String inputFilename) {
  final outputFilename = inputFilename.replaceAll('vector_math', 'vector_math_64');

  return new File(inputFilename).readAsString()
    .then((s) => _convertToVectorMath64(s))
    .then((s) => new File(outputFilename).writeAsString(s));
}

String _convertToVectorMath64(String input) {
  return input
    .replaceAll('vector_math', 'vector_math_64')
    .replaceAll('Float32List', 'Float64List');
}