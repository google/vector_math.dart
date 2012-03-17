/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/

#import ('dart:builtin');
#import ('dart:io');

class MatrixGen {
  int rows;
  int cols;
  String get rowVecType() => 'vec$cols';
  String get colVecType() => 'vec$rows';
  String get matType() => 'mat${cols}x${rows}';
  int _indent;
  RandomAccessFile out;
  MatrixGen() {
    _indent = 0;
  }
  
  List<String> get matrixComponents() {
    List<String> r = new List<String>();
    for (int i = 0; i < cols; i++) {
      r.add('col$i');  
    }
    return r;
  }
  String matTypeTransposed() {
    return 'mat${rows}x${cols}';
  }
  
  void iPush() {
    _indent++;
  }
  void iPop() {
    _indent--;
    assert(_indent >= 0);
  }
  void iPrint(String s) {
    String indent = "";
    for (int i = 0; i < _indent; i++) {
      indent += '  ';
    }
    out.writeString('$indent$s\n');
    print('$indent$s');
  }
  
  void writeLicense() {
    iPrint('''/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/''');
  }
  
  void generatePrologue() {
    iPrint('class ${matType} {');
    iPush();
    for (int i = 0; i < cols; i++) {
      iPrint('$colVecType col$i;');  
    }
  }
  
  String joinStrings(List<String> elements, [String pre = '', String post = '', String joiner = ', ']) {
    bool first = true;
    String r = '';
    for (String e in elements) {
      r += first ? '${pre}${e}${post}' : '${joiner}${pre}${e}${post}';
      first = false;
    }
    return r;
  }
  
  void generateConstructors() {   
    iPrint('${matType}([${joinStrings(matrixComponents, 'Dynamic ', '_')}]) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      iPrint('col$i = new $colVecType();');
    }
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (i == j) {
          iPrint('col$i[$j] = 1.0;');  
        }
      }
    }
    
    iPrint('if (${joinStrings(matrixComponents, '', '_ is $colVecType', ' && ')}) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      iPrint('col$i = col${i}_;');
    }
    iPop();
    iPrint('}');
    
    iPop();
    iPrint('}');
  }
  
  void generateRowColProperties() {
    iPrint('num get rows() => $rows;');
    iPrint('num get cols() => $cols;');
    iPrint('num get length() => $cols;');
  }
  
  void generateRowGetterSetters() {
    for (int i = 0; i < rows; i++) {
      iPrint('$rowVecType get row$i() => getRow($i);');
    }
    for (int i = 0; i < rows; i++) {
      iPrint('set row$i($rowVecType arg) => setRow($i, arg);');
    }
  }
  
  void generateIndexOperator() {
    iPrint('$colVecType operator[](int column) {');
    iPush();
    iPrint('assert(column >= 0 && column < $cols);');
    iPrint('switch (column) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      iPrint('case $i: return col$i; break;');
    }
    iPop();
    iPrint('}');
    iPrint('throw new IllegalArgumentException(column);');
    iPop();
    iPrint('}');
  }
  
  void generateAssignIndexOperator() {
    iPrint('$colVecType operator[]=(int column, $colVecType arg) {');
    iPush();
    iPrint('assert(column >= 0 && column < $cols);');
    iPrint('switch (column) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      iPrint('case $i: col$i = arg; return col$i; break;');
    }
    iPop();
    iPrint('}');
    iPrint('throw new IllegalArgumentException(column);');
    iPop();
    iPrint('}');
  }
  
  void generateRowHelpers() {
    iPrint('void setRow(int row, $rowVecType arg) {');
    iPush();
    iPrint('assert(row >= 0 && row < $rows);');
    for (int i = 0; i < cols; i++) {
      iPrint('this[$i][row] = arg[$i];');
    }
    iPop();
    iPrint('}');
    
    iPrint('$rowVecType getRow(int row) {');
    iPush();
    iPrint('assert(row >= 0 && row < $rows);');
    iPrint('${rowVecType} r = new ${rowVecType}();');
    for (int i = 0; i < cols; i++) {
      iPrint('r[$i] = this[$i][row];');
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }
  
  void generateColumnHelpers() {
    iPrint('void setColumn(int column, $colVecType arg) {');
    iPush();
    iPrint('assert(column >= 0 && column < $cols);');
    iPrint('this[column] = arg;');
    iPop();
    iPrint('}');
    
    iPrint('$colVecType getColumn(int column) {');
    iPush();
    iPrint('assert(column >= 0 && column < $cols);');
    iPrint('return new ${colVecType}(this[column]);');
    iPop();
    iPrint('}');
  }
  
  void generateToString() {
    iPrint('String toString() {');
    iPush();
    iPrint('String s = \'\';');
    for (int i = 0; i < rows; i++) {
      iPrint('s += \'[$i] \${getRow($i)}\\n\';');
    }
    iPrint('return s;');
    iPop();
    iPrint('}');
  }
  
  void generateEpilogue() {
    iPop();
    iPrint('}');
  }
  
  void generateMatrixVectorMultiply() {
    iPrint('$colVecType r = new $colVecType();');
    for (int i = 0; i < rows; i++) {
      iPrint('r[$i] = dot(row$i, arg);');
    }
    iPrint('return r;');
  }
  
  void generateMatrixMatrixMultiply() {
    iPrint('Dynamic r = null;');
    iPrint('if (arg.rows == 2) {');
    iPush();
    iPrint('r = new mat${cols}x2();');
    iPop();
    iPrint('}');
    iPrint('if (arg.rows == 3) {');
    iPush();
    iPrint('r = new mat${cols}x3();');
    iPop();
    iPrint('}');
    iPrint('if (arg.rows == 4) {');
    iPush();
    iPrint('r = new mat${cols}x4();');
    iPop();
    iPrint('}');
    for (int i = 0; i < cols; i++) {
      iPrint('for (int j = 0; j < arg.rows; j++) {');
      iPush();
      iPrint('r[$i][j] = dot(this.getRow($i), arg.getColumn(j));');
      iPop();
      iPrint('}');  
    }
    iPrint('return r;');
  }
  
  void generateMatrixScale() {
    iPrint('${matType} r = new ${matType}();');
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        iPrint('r[$i][$j] = this[$i][$j] * arg;');
      }
    }
    iPrint('return r;');
  }
  
  void generateMult() {
    iPrint('Dynamic operator*(Dynamic arg) {');
    iPush();
    iPrint('if (arg is num) {');
    iPush();
    generateMatrixScale();
    iPop();
    iPrint('}');
    iPrint('if (arg is $rowVecType) {');
    iPush();
    generateMatrixVectorMultiply();
    iPop();
    iPrint('}');
    iPrint('if ($rows == arg.cols) {');
    iPush();
    generateMatrixMatrixMultiply();
    iPop();
    iPrint('}');
    iPrint('throw new IllegalArgumentException(arg);');
    iPop();
    iPrint('}');
  }
  
  void generateOp(String op) {
    iPrint('${matType} operator$op(${matType} arg) {');
    iPush();
    iPrint('${matType} r = new ${matType}();');
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        iPrint('r[$i][$j] = this[$i][$j] $op arg[$i][$j];');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }
  
  void generateTranspose() {
    iPrint('${matTypeTransposed()} transposed() {');
    iPush();
    iPrint('${matTypeTransposed()} r = new ${matTypeTransposed()}();');
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        iPrint('r[$j][$i] = this[$i][$j];');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }
  
  void generateAbsolute() {
    iPrint('${matType} absolute() {');
    iPush();
    iPrint('${matType} r = new ${matType}();');
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        iPrint('r[$i][$j] = this[$i][$j].abs();');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }
  
  void generateDeterminant() {
    if (matType == 'mat2x2') {
      iPrint('''num determinant() {
    return (this[0][0] * this[1][1]) - (this[0][1]*this[1][0]); 
  }''');
    }
    
    if (matType == 'mat3x3') {
      iPrint('''num determinant() {
        num x = this[0][0]*((this[2][2]*this[1][1])-(this[2][1]*this[1][2]));
        num y = this[1][0]*((this[2][2]*this[0][1])-(this[2][1]*this[0][2]));
        num z = this[2][0]*((this[1][2]*this[0][1])-(this[1][1]*this[0][2]));
        return x - y + z;
      }''');
    }
    
    if (matType == 'mat4x4') {
      iPrint('''num determinant() {
        num x = 0;
        num y = 0;
        num z = 0;
        num w = 0;
      }''');
    }
  }
  
  void generate() {
    writeLicense();
    generatePrologue();
    generateConstructors();
    generateRowColProperties();
    generateRowGetterSetters();
    generateIndexOperator();
    generateAssignIndexOperator();
    generateToString();
    generateRowHelpers();
    generateColumnHelpers();
    generateMult();
    generateOp('+');
    generateOp('-');
    generateTranspose();
    generateAbsolute();
    generateDeterminant();
    generateEpilogue();
  }
}

void main() {
  /*
  var d = new Directory("./");
  d.onFile = (file) {
    print('$file');
  };
  d.onDir = (dir) {
    print('$dir');
  };
  d.list();
  */
  var f = null;
  String basePath = 'lib/VectorMath/gen';
  f = new File('${basePath}/matrix2x2_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.rows = 2;
    mg.cols = 2;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
  
  f = new File('${basePath}/matrix2x3_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.cols = 2;
    mg.rows = 3;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
  
  f = new File('${basePath}/matrix2x4_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.cols = 2;
    mg.rows = 4;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
  
  f = new File('${basePath}/matrix3x2_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.rows = 2;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
  
  f = new File('${basePath}/matrix3x3_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.rows = 3;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
  
  f = new File('${basePath}/matrix3x4_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.rows = 4;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
  
  f = new File('${basePath}/matrix4x2_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.rows = 2;
    mg.cols = 4;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
  
  f = new File('${basePath}/matrix4x3_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.cols = 4;
    mg.rows = 3;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });

  f = new File('${basePath}/matrix4x4_gen.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    MatrixGen mg = new MatrixGen();
    mg.rows = 4;
    mg.cols = 4;
    mg.out = opened;
    mg.generate();
    opened.close(() {});
  });
}