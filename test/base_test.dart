part of vector_math_test;

class BaseTest {
  void testFailure(var output, var expectedOutput, num error) {
    print('FAILURE!!!');
    print('$output != $expectedOutput) : ${error}');
    assert(false);
  }

  void relativeTest(var output, var expectedOutput) {
    num error = relativeError(output, expectedOutput);
    if (error.abs() >= errorThreshold) {
      testFailure(output, expectedOutput, error);
    }
    expect(error >= errorThreshold, isFalse);
  }

  final num errorThreshold = 0.0005;

  dynamic makeMatrix(int rows, int cols) {
    if (rows != cols) {
      return null;
    }

    if (cols == 2) {
      return new mat2.zero();
    }
    if (cols == 3) {
      return new mat3.zero();
    }
    if (cols == 4) {
      return new mat4.zero();
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
        //m[i][j] = values[j*col_count+i];
      }
    }

    return m;
  }

  dynamic parseVector(String v) {
    v = v.trim();
    Pattern pattern = new RegExp('[\\s]+', multiLine: true, caseSensitive: false);
    List<String> rows = v.split(pattern);
    List<double> values = new List<double>();
    for (int i = 0; i < rows.length; i++) {
      rows[i] = rows[i].trim();
      if (rows[i].isEmpty) {
        continue;
      }
      values.add(double.parse(rows[i]));
    }

    dynamic r = null;
    if (values.length == 2) {
      r = new vec2(values[0], values[1]);
    } else if (values.length == 3) {
      r = new vec3(values[0], values[1], values[2]);
    } else if (values.length == 4) {
      r = new vec4(values[0], values[1], values[2], values[3]);
    }

    return r;
  }

}
