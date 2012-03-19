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
    iPrint('\/\/\/ ${matType} is a column major matrix where each column is represented by [$colVecType]. This matrix has $cols columns and $rows rows.');
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
    int numArguments = cols * rows;
    List<String> arguments = new List<String>(numArguments);
    for (int i = 0; i < numArguments; i++) {
      arguments[i] = 'arg$i';
    }
    List<String> columnArguments = new List<String>(cols);
    for (int i = 0; i < cols; i++) {
      columnArguments[i] = 'arg$i';
    }
    iPrint('\/\/\/ Constructs a new ${matType}. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.');
    iPrint('${matType}([${joinStrings(arguments, 'Dynamic ')}]) {');
    iPush();
    iPrint('//Initialize the matrix as the identity matrix');
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
    
    iPrint('if (${joinStrings(arguments, '', ' is num', ' && ')}) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        iPrint('col$i[$j] = arg${(i*rows)+j};');
      }
    }
    iPrint('return;');
    iPop();
    iPrint('}');
    
    iPrint('if (arg0 is num && ${joinStrings(arguments.getRange(1, numArguments-1), '', ' == null', ' && ')}) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (i == j) {
          iPrint('col$i[$j] = arg0;');  
        }
      }
    }
    iPrint('return;');
    iPop();
    iPrint('}');
    
    iPrint('if (${joinStrings(columnArguments, '', ' is vec${cols}', ' && ')}) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      iPrint('col$i = arg$i;');
    }
    iPrint('return;');
    iPop();
    iPrint('}');
    
    iPrint('if (arg0 is ${matType}) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      iPrint('col$i = arg0.col$i;');
    }
    iPrint('return;');
    iPop();
    iPrint('}');
    
    for (int i = cols; i >= 2; i--) {
      for (int j = rows; j >= 2; j--) {
        if (i == cols && j == rows) {
          continue;
        }
        iPrint('if (arg0 is mat${i}x${j}) {');
        iPush();
        for (int k = 0; k < i; k++) {
          for (int l = 0; l < j; l++) {
            iPrint('col$k[$l] = arg0.col$k[$l];');
          }
        }
        iPrint('return;');
        iPop();
        iPrint('}');
      }
    }
    
    int diagonals = rows < cols ? rows : cols;
    for (int i = 1; i < diagonals; i++) {
      iPrint('if (arg0 is vec${i+1} && ${joinStrings(arguments.getRange(1, numArguments-1), '', ' == null', ' && ')}) {');
      iPush();
      for (int j = 0; j < i+1; j++) {
        iPrint('col$j[$j] = arg0[$j];');
      }
      iPop();
      iPrint('}');
    }
    
    iPop();
    iPrint('}');
    
    // Outer product constructor
    iPrint('\/\/\/ Constructs a new ${matType} from computing the outer product of [u] and [v].');
    iPrint('${matType}.outer(vec${cols} u, vec${rows} v) {');
    iPush();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        iPrint('col$i[$j] = u[$i] * v[$j];');
      }
    }
    iPop();
    iPrint('}');
    
    iPrint('\/\/\/ Constructs a new ${matType} filled with zeros.');
    iPrint('${matType}.zero() {');
    iPush();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        iPrint('col$i[$j] = 0.0;');
      }
    }
    iPop();
    iPrint('}');
  }
  
  void generateRowColProperties() {
    iPrint('\/\/\/ Returns the number of rows in the matrix.');
    iPrint('num get rows() => $rows;');
    iPrint('\/\/\/ Returns the number of columns in the matrix.');
    iPrint('num get cols() => $cols;');
    iPrint('\/\/\/ Returns the number of columns in the matrix.');
    iPrint('num get length() => $cols;');
  }
  
  void generateRowGetterSetters() {
    for (int i = 0; i < rows; i++) {
      iPrint('\/\/\/ Returns row $i');
      iPrint('$rowVecType get row$i() => getRow($i);');
    }
    for (int i = 0; i < rows; i++) {
      iPrint('\/\/\/ Sets row $i to [arg]');
      iPrint('set row$i($rowVecType arg) => setRow($i, arg);');
    }
  }
  
  void generateIndexOperator() {
    iPrint('\/\/\/ Gets the [column] of the matrix');
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
    iPrint('\/\/\/ Assigns the [column] of the matrix [arg]');
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
    iPrint('\/\/\/ Assigns the [column] of the matrix [arg]');
    iPrint('void setRow(int row, $rowVecType arg) {');
    iPush();
    iPrint('assert(row >= 0 && row < $rows);');
    for (int i = 0; i < cols; i++) {
      iPrint('this[$i][row] = arg[$i];');
    }
    iPop();
    iPrint('}');
    
    iPrint('\/\/\/ Gets the [row] of the matrix');
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
    iPrint('\/\/\/ Assigns the [column] of the matrix [arg]');
    iPrint('void setColumn(int column, $colVecType arg) {');
    iPush();
    iPrint('assert(column >= 0 && column < $cols);');
    iPrint('this[column] = arg;');
    iPop();
    iPrint('}');
    
    iPrint('\/\/\/ Gets the [column] of the matrix');
    iPrint('$colVecType getColumn(int column) {');
    iPush();
    iPrint('assert(column >= 0 && column < $cols);');
    iPrint('return new ${colVecType}(this[column]);');
    iPop();
    iPrint('}');
  }
  
  void generateToString() {
    iPrint('\/\/\/ Returns a printable string');
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
    iPrint('\/\/\/ Returns a new vector or matrix by multiplying [this] with [arg].');
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
    iPrint('\/\/\/ Returns new matrix after component wise [this] $op [arg]');
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
  
  void generateNegate() {
    iPrint('\/\/\/ Returns new matrix -this');
    iPrint('${matType} operator negate() {');
    iPush();
    iPrint('${matType} r = new ${matType}();');
    for (int i = 0; i < cols; i++) {
      iPrint('r[$i] = -this[$i];');  
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }
  
  void generateTranspose() {
    iPrint('\/\/\/ Returns the tranpose of this.');
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
    iPrint('\/\/\/ Returns the component wise absolute value of this.');
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
      iPrint('\/\/\/ Returns the determinant of this matrix.');
      iPrint('''num determinant() {
    return (this[0][0] * this[1][1]) - (this[0][1]*this[1][0]); 
  }''');
    }
    
    if (matType == 'mat3x3') {
      iPrint('\/\/\/ Returns the determinant of this matrix.');
      iPrint('''num determinant() {
        num x = this[0][0]*((this[2][2]*this[1][1])-(this[2][1]*this[1][2]));
        num y = this[1][0]*((this[2][2]*this[0][1])-(this[2][1]*this[0][2]));
        num z = this[2][0]*((this[1][2]*this[0][1])-(this[1][1]*this[0][2]));
        return x - y + z;
      }''');
    }
    
    if (matType == 'mat4x4') {
      iPrint('\/\/\/ Returns the determinant of this matrix.');
      iPrint('''num determinant() {
          //2x2 sub-determinants
          num det2_01_01 = this[0][0] * this[1][1] - this[0][1] * this[1][0];
          num det2_01_02 = this[0][0] * this[1][2] - this[0][2] * this[1][0];
          num det2_01_03 = this[0][0] * this[1][3] - this[0][3] * this[1][0];
          num det2_01_12 = this[0][1] * this[1][2] - this[0][2] * this[1][1];
          num det2_01_13 = this[0][1] * this[1][3] - this[0][3] * this[1][1];
          num det2_01_23 = this[0][2] * this[1][3] - this[0][3] * this[1][2];
        
          //3x3 sub-determinants
          num det3_201_012 = this[2][0] * det2_01_12 - this[2][1] * det2_01_02 + this[2][2] * det2_01_01;
          num det3_201_013 = this[2][0] * det2_01_13 - this[2][1] * det2_01_03 + this[2][3] * det2_01_01;
          num det3_201_023 = this[2][0] * det2_01_23 - this[2][2] * det2_01_03 + this[2][3] * det2_01_02;
          num det3_201_123 = this[2][1] * det2_01_23 - this[2][2] * det2_01_13 + this[2][3] * det2_01_12;
        
          return ( - det3_201_123 * this[3][0] + det3_201_023 * this[3][1] - det3_201_013 * this[3][2] + det3_201_012 * this[3][3] );
      }''');
    }
  }
  
  void generateTrace() {
    if (rows == cols) {
      iPrint('\/\/\/ Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries');
      iPrint('num trace() {');
      iPush();
      iPrint('num t = 0.0;');
      for (int i = 0; i < cols; i++) {
        iPrint('t += this[$i][$i];');
      }
      iPrint('return t;');
      iPop();
      iPrint('}');
    }
  }
  
  void generateInfinityNorm() {
    iPrint('\/\/\/ Returns infinity norm of the matrix. Used for numerical analysis.');
    iPrint('num infinityNorm() {');
    iPush();
    iPrint('num norm = 0.0;');
    for (int i = 0; i < cols; i++) {
      iPrint('{');
      iPush();
      iPrint('num row_norm = 0.0;');
      for (int j = 0; j < rows; j++) {
        iPrint('row_norm += this[$i][$j].abs();');
      }
      iPrint('norm = row_norm > norm ? row_norm : norm;');
      iPop();
      iPrint('}');
    }
    iPrint('return norm;');
    iPop();
    iPrint('}');
  }
  
  void generateError() {
    iPrint('\/\/\/ Returns relative error between [this] and [correct]');
    iPrint('num relativeError($matType correct) {');
    iPush();
    iPrint('num this_norm = infinityNorm();');
    iPrint('num correct_norm = correct.infinityNorm();');
    iPrint('num diff_norm = (this_norm - correct_norm).abs();');
    iPrint('return diff_norm/correct_norm;');
    iPop();
    iPrint('}');
    iPrint('\/\/\/ Returns absolute error between [this] and [correct]');
    iPrint('num absoluteError($matType correct) {');
    iPush();
    iPrint('num this_norm = infinityNorm();');
    iPrint('num correct_norm = correct.infinityNorm();');
    iPrint('num diff_norm = (this_norm - correct_norm).abs();');
    iPrint('return diff_norm;');
    iPop();
    iPrint('}');
  } 
  
  void generateTranslate() {
    if (rows == 4 && cols == 4) {
      iPrint('\/\/\/ Returns the translation vector from this homogeneous transformation matrix.');
      iPrint('vec3 getTranslation() {');
      iPush();
      iPrint('return new vec3(col3.x, col3.y, col3.z);');
      iPop();
      iPrint('}');
      iPrint('\/\/\/ Sets the translation vector in this homogeneous transformation matrix.');
      iPrint('void setTranslation(vec3 T) {');
      iPush();
      iPrint('col3.xyz = T;');
      iPop();
      iPrint('}');
    }
  }
  
  void generateRotation() {
    if (rows == 4 && cols == 4) {
      iPrint('\/\/\/ Returns the rotation matrix from this homogeneous transformation matrix.');
      iPrint('mat3x3 getRotation() {');
      iPush();
      iPrint('mat3x3 r = new mat3x3();');
      iPrint('r.col0 = new vec3(this.col0.x,this.col0.y,this.col0.z);');
      iPrint('r.col1 = new vec3(this.col1.x,this.col1.y,this.col1.z);');
      iPrint('r.col2 = new vec3(this.col2.x,this.col2.y,this.col2.z);');
      iPrint('return r;');
      iPop();
      iPrint('}');
      
      iPrint('\/\/\/ Sets the rotation matrix in this homogeneous transformation matrix.');
      iPrint('void setRotation(mat3x3 rotation) {');
      iPush();
      iPrint('this.col0.xyz = rotation.col0;');
      iPrint('this.col1.xyz = rotation.col1;');
      iPrint('this.col2.xyz = rotation.col2;');
      iPop();
      iPrint('}');
      
      iPrint('\/\/\/ Transposes just the upper 3x3 rotation matrix.');
      iPrint('void transposeRotation() {');
      iPush();
      iPrint('num temp;');
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          iPrint('temp = this[$i][$j];');
          iPrint('this[$i][$j] = this[$j][$i];');
          iPrint('this[$j][$i] = temp;');
        }
      }
      iPop();
      iPrint('}');
    }
  }
  
  void generate() {
    writeLicense();
    generatePrologue();
    generateConstructors();
    generateToString();
    generateRowColProperties();
    generateIndexOperator();
    generateAssignIndexOperator();
    generateRowGetterSetters();
    generateRowHelpers();
    generateColumnHelpers();
    generateMult();
    generateOp('+');
    generateOp('-');
    generateNegate();
    generateTranspose();
    generateAbsolute();
    generateDeterminant();
    generateTrace();
    generateInfinityNorm();
    generateError();
    generateTranslate();
    generateRotation();
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