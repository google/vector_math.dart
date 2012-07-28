class BaseTest {
  void TestFailure(var output, var expectedOutput, num error) {
    print('FAILURE!!!');
    print('$output != $expectedOutput) : ${error}');
    assert(false);
  }

  void RelativeTest(var output, var expectedOutput) {
    num error = relativeError(output, expectedOutput);
    //print('$output $expectedOutput $error');
    if (error >= errorThreshold) {
      TestFailure(output, expectedOutput, error);
    }
  }
  
  final num errorThreshold = 0.00005;
  
  Dynamic makeMatrix(int rows, int cols) {
    if (cols == 2) {
      if (rows == 2) {
        return new mat2x2();
      }
      if (rows == 3) {
        return new mat2x3();
      }
      if (rows == 4) {
        return new mat2x4();
      }
    }
    if (cols == 3) {
      if (rows == 2) {
        return new mat3x2();
      }
      if (rows == 3) {
        return new mat3x3();
      }
      if (rows == 4) {
        return new mat3x4();
      }
    }
    
    if (cols == 4) {
      if (rows == 2) {
        return new mat4x2();
      }
      if (rows == 3) {
        return new mat4x3();
      }
      if (rows == 4) {
        return new mat4x4();
      }
    }
    
    return null;
  }
  
  Dynamic parseMatrix(String input) {
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
        if (cols[j].isEmpty()) {
          continue;
        }
        if (i == 0) {
          col_count++;  
        }
        values.add(Math.parseDouble(cols[j]));
      }
    }
    
    Dynamic m = makeMatrix(rows.length, col_count);
    for (int j = 0; j < rows.length; j++) {
      for (int i = 0; i < col_count; i++) {;
        m[i][j] = values[j*col_count+i];
      }  
    }
    
    //print('$m');
    return m;
  }
  
  Dynamic parseVector(String v) {
    v = v.trim();
    Pattern pattern = new RegExp('[\\s]+', true, false);
    List<String> rows = v.split(pattern);
    List<double> values = new List<double>();
    for (int i = 0; i < rows.length; i++) {
      rows[i] = rows[i].trim();
      if (rows[i].isEmpty()) {
        continue;
      }
      values.add(Math.parseDouble(rows[i]));
    }
    
    Dynamic r = null;
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
