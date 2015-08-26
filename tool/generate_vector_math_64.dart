// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
library generate_vector_math_64_task;

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

main() async {
  await generateVectorMath64();

  print('Generated vector_math_64');
}

Future generateVectorMath64() async {
  final directory = new Directory('lib/src/vector_math_64/');
  final libraryFile = new File('lib/vector_math_64.dart');

  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }

  if (await libraryFile.exists()) {
    await libraryFile.delete();
  }

  await directory.create(recursive: true);
  await _processFile('lib/vector_math.dart');

  await for (var f
      in new Directory('lib/src/vector_math/').list(recursive: true)) {
    if (f is File) {
      await _processFile(f.path);
    }
  }
}

Future _processFile(String inputFileName) async {
  final inputFile = new File(inputFileName);

  final input = await inputFile.readAsString();
  final output = _convertToVectorMath64(input);

  final outputFileName =
      inputFileName.replaceAll('vector_math', 'vector_math_64');
  var dir = new Directory(p.dirname(outputFileName));

  await dir.create(recursive: true);

  final outputFile = new File(outputFileName);
  await outputFile.writeAsString(output);
}

String _convertToVectorMath64(String input) {
  return input
      .replaceAll('vector_math', 'vector_math_64')
      .replaceAll('Float32List', 'Float64List');
}
