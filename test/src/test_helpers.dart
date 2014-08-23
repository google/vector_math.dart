library test_helpers;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';

Matcher relativeEquals(expectedOutput, {double errorThreshold: 0.0005}) =>
    new _RelativeEqualsMatcher(expectedOutput, errorThreshold: errorThreshold);

Matcher absoluteEquals(expectedOutput, {double errorThreshold: 0.0005}) =>
    new _AbsoluteEqualsMatcher(expectedOutput, errorThreshold: errorThreshold);

class _RelativeEqualsMatcher extends Matcher {
  final double errorThreshold;
  final expectedOutput;

  _RelativeEqualsMatcher(this.expectedOutput, {this.errorThreshold: 0.0005});

  @override
  Description describe(Description description) =>
      description
        .addDescriptionOf(expectedOutput)
        .add(' (relative errorThreshold = $errorThreshold)');

  Description describeMismatch(item, Description mismatchDescription,
      Map matchState, bool verbose) {
    final error = relativeError(item, expectedOutput).abs();

    return mismatchDescription.replace('$item != $expectedOutput : relativeError = $error (errorThreshold = $errorThreshold)');
  }

  @override
  bool matches(item, Map matchState) =>
      !(relativeError(item, expectedOutput).abs() >= errorThreshold);
}

class _AbsoluteEqualsMatcher extends Matcher {
  final double errorThreshold;
  final expectedOutput;

  _AbsoluteEqualsMatcher(this.expectedOutput, {this.errorThreshold: 0.0005});

  @override
  Description describe(Description description) =>
      description
        .addDescriptionOf(expectedOutput)
        .add(' (absolute errorThreshold = $errorThreshold)');

  Description describeMismatch(item, Description mismatchDescription,
      Map matchState, bool verbose) {
    final error = absoluteError(item, expectedOutput).abs();

    return mismatchDescription.replace('$item != $expectedOutput : absoluteError = $error (errorThreshold = $errorThreshold)');
  }

  @override
  bool matches(item, Map matchState) =>
      !(absoluteError(item, expectedOutput).abs() >= errorThreshold);
}

dynamic makeMatrix(int rows, int cols) {
  if (rows != cols) {
    return null;
  }

  if (cols == 2) {
    return new Matrix2.zero();
  }
  if (cols == 3) {
    return new Matrix3.zero();
  }
  if (cols == 4) {
    return new Matrix4.zero();
  }

  return null;
}

dynamic parseMatrix(String input) {
  input = input.trim();
  List<String> rows = input.split("\n");
  List<double> values = new List<double>();
  int col_count = 0;
  for (int i = 0; i < rows.length; i++) {
    rows[i] = rows[i].trim();
    List<String> cols = rows[i].split(" ");
    for (int j = 0; j < cols.length; j++) {
      cols[j] = cols[j].trim();
    }

    for (int j = 0; j < cols.length; j++) {
      if (cols[j].isEmpty) {
        continue;
      }
      if (i == 0) {
        col_count++;
      }
      values.add(double.parse(cols[j]));
    }
  }

  dynamic m = makeMatrix(rows.length, col_count);
  for (int j = 0; j < rows.length; j++) {
    for (int i = 0; i < col_count; i++) {
      m[m.index(j,i)] = values[j*col_count+i];
    }
  }

  return m;
}
