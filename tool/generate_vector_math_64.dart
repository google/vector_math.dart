// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
library generate_vector_math_64_task;

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

Future<Null> main() async {
  await generateVectorMath64();

  print('Generated vector_math_64');
}

Future<Null> generateVectorMath64() async {
  final Directory directory = new Directory('lib/src/vector_math_64/');
  final File libraryFile = new File('lib/vector_math_64.dart');

  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }

  if (libraryFile.existsSync()) {
    await libraryFile.delete();
  }

  await directory.create(recursive: true);
  await _processFile('lib/vector_math.dart');

  await for (FileSystemEntity f
      in new Directory('lib/src/vector_math/').list(recursive: true)) {
    if (f is File) {
      await _processFile(f.path);
    }
  }
}

Future<Null> _processFile(String inputFileName) async {
  final File inputFile = new File(inputFileName);

  final String input = await inputFile.readAsString();
  final String output = _convertToVectorMath64(input);

  final String outputFileName =
      inputFileName.replaceAll('vector_math', 'vector_math_64');
  final Directory dir = new Directory(p.dirname(outputFileName));

  await dir.create(recursive: true);

  final File outputFile = new File(outputFileName);
  await outputFile.writeAsString(output);
}

String _convertToVectorMath64(String input) => input
    .replaceAll('vector_math', 'vector_math_64')
    .replaceAll('Float32List', 'Float64List');
