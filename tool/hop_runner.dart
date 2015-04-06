// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

import 'generate_vector_math_64_task.dart';

void main(List<String> args) {

  //
  // Analyzer
  //
  addTask('analyze_lib', createAnalyzerTask(_getLibs));

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
  return new Directory('lib')
      .list()
      .where((FileSystemEntity fse) => fse is File)
      .map((File file) => file.path)
      .toList();
}
