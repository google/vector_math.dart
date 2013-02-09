library test_dump_render_tree;

import 'dart:io';
import 'package:unittest/unittest.dart';

void main() {
  testRun();
}

void testCore(Configuration config) {
  configure(config);
  groupSep = ' - ';
  testRun();
}

void testRun() {
  final browserTests = ['test/browser_test_harness.html'];

  group('DumpRenderTree', () {
    browserTests.forEach((file) {
      test(file, () {
        _runDrt(file);
      });
    });
  });
}

void _runDrt(String htmlFile) {
  final allPassedRegExp = new RegExp('All \\d+ tests passed');

  final future = Process.run('DumpRenderTree', [htmlFile])
    .then((ProcessResult pr) {
      expect(pr.exitCode, 0);
      expect(pr.stdout, matches(allPassedRegExp));
    });

  expect(future, completes);
}
