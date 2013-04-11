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

part of vector_math_generator;

class MatrixGenerator extends BaseGenerator {
  final int dimension;
  int get length => dimension*dimension;

  MatrixGenerator(this.dimension) : super() {
  }

  String get matType => 'mat${dimension}';
  String get vecType => 'vec$dimension';
  List<String> get matrixComponents {
    List<String> r = new List<String>();
    for (int i = 0; i < dimension; i++) {
      r.add('col$i');
    }
    return r;
  }

  String Access(int row, int col, [String pre = '_storage']) {
    int index = (col * dimension) + row;
    return '$pre[$index]';
  }

  String AccessV(int row, [String pre = '_storage']) {
    return '$pre[$row]';
  }

  void generatePrologue() {
    iPrint('\/\/\/ ${matType} is a column major matrix where each column is represented by [$vecType]. This matrix has $dimension columns and $dimension dimension.');
    iPrint('class ${matType} {');
    iPush();
    iPrint('final Float32List _storage = new Float32List($length);');
    iPrint('int index(int row, int col) => (col * $dimension) + row;');
    iPrint('double entry(int row, int col) => _storage[index(row, col)];');
    iPrint('setEntry(int row, int col, double v) { _storage[index(row, col)] = v; }');
  }

  void generateConstructors() {
    List<String> arguments = new List<String>(length);
    for (int i = 0; i < length; i++) {
      arguments[i] = 'arg$i';
    }
    List<String> columnArguments = new List<String>(dimension);
    for (int i = 0; i < dimension; i++) {
      columnArguments[i] = 'arg$i';
    }

    iPrint('\/\/\/ Constructs a new ${matType}.');
    iPrint('${matType}(${joinStrings(arguments, 'double ')}) {');
    iPush();
    iPrint('setRaw(${joinStrings(arguments, '')});');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Constructs a new ${matType} from columns.');
    iPrint('$matType.columns(${joinStrings(columnArguments, 'vec${dimension} ')}) {');
    iPush();
    iPrint('setColumns(${joinStrings(columnArguments, '')});');
    iPop();
    iPrint('}');

    // Outer product constructor
    iPrint('\/\/\/ Constructs a new [${matType}] from computing the outer product of [u] and [v].');
    iPrint('${matType}.outer(vec${dimension} u, vec${dimension} v) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('${Access(j, i)} = u.${AccessV(i)} * v.${AccessV(j)};');
      }
    }
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Constructs a new [${matType}] filled with zeros.');
    iPrint('${matType}.zero() {');
    iPush();
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Constructs a new identity [${matType}].');
    iPrint('${matType}.identity() {');
    iPush();
    iPrint('setIdentity();');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Constructs a new [${matType}] which is a copy of [other].');
    iPrint('${matType}.copy($matType other) {');
    iPush();
    iPrint('setMatrix(other);');
    iPop();
    iPrint('}');

    if (dimension == 2 && dimension == 2) {
      iPrint('\/\/\/ Constructs a new [${matType}] representing a rotation by [radians].');
      iPrint('${matType}.rotation(double radians_) {');
      iPush();
      iPrint('setRotation(radians_);');
      iPop();
      iPrint('}');
    }

    if ((dimension == 3 && dimension == 3) || (dimension == 4 && dimension == 4)) {
      iPrint('\/\/\/\/ Constructs a new [${matType}] representation a rotation of [radians] around the X axis');
      iPrint('${matType}.rotationX(double radians_) {');
      iPush();
      if (dimension == 4 && dimension == 4) {
        iPrint('${Access(3, 3)} = 1.0;');
      }
      iPrint('setRotationX(radians_);');
      iPop();
      iPrint('}');

      iPrint('\/\/\/\/ Constructs a new [${matType}] representation a rotation of [radians] around the Y axis');
      iPrint('${matType}.rotationY(double radians_) {');
      iPush();
      if (dimension == 4 && dimension == 4) {
        iPrint('${Access(3, 3)} = 1.0;');
      }
      iPrint('setRotationY(radians_);');
      iPop();
      iPrint('}');

      iPrint('\/\/\/\/ Constructs a new [${matType}] representation a rotation of [radians] around the Z axis');
      iPrint('${matType}.rotationZ(double radians_) {');
      iPush();
      if (dimension == 4 && dimension == 4) {
        iPrint('${Access(3, 3)} = 1.0;');
      }
      iPrint('setRotationZ(radians_);');
      iPop();
      iPrint('}');
    }

    if (dimension == 4 && dimension == 4) {
      iPrint('\/\/\/ Constructs a new [${matType}] translation matrix from [translation]');
      iPrint('${matType}.translation(vec3 translation) {');
      iPush();
      iPrint('setIdentity();');
      iPrint('setTranslation(translation);');
      iPop();
      iPrint('}');

      iPrint('\/\/\/ Constructs a new [${matType}] translation from [x], [y], and [z]');
      iPrint('${matType}.translationRaw(double x, double y, double z) {');
      iPush();
      iPrint('setIdentity();');
      iPrint('setTranslationRaw(x, y, z);');
      iPop();
      iPrint('}');

      iPrint('\/\/\/\/ Constructs a new [${matType}] scale of [x], [y], and [z]');
      iPrint('${matType}.scaleVec(vec3 scale_) {');
      iPush();
      iPrint('_storage[15] = 1.0;');
      iPrint('_storage[10] = scale_._storage[2];');
      iPrint('_storage[5] = scale_._storage[1];');
      iPrint('_storage[0] = scale_._storage[0];');
      iPop();
      iPrint('}');


      iPrint('\/\/\/\/ Constructs a new [${matType}] representening a scale of [x], [y], and [z]');
      iPrint('${matType}.scaleRaw(double x, double y, double z) {');
      iPush();
      iPrint('_storage[15] = 1.0;');
      iPrint('_storage[10] = z;');
      iPrint('_storage[5] = y;');
      iPrint('_storage[0] = x;');
      iPop();
      iPrint('}');

    }
  }

  void generateSetters() {
    iPrint('\/\/\/ Sets the diagonal to [arg].');
    iPrint('$matType splatDiagonal(double arg) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        if (i == j) {
          iPrint('${Access(j, i)} = arg;');
        }
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    int numArguments = dimension * dimension;
    List<String> arguments = new List<String>(numArguments);
    for (int i = 0; i < numArguments; i++) {
      arguments[i] = 'arg$i';
    }
    iPrint('\/\/\/ Sets the entire matrix to the numeric values.');
    iPrint('$matType setRaw(${joinStrings(arguments, 'double ')}) {');
    iPush();
    for (int i = length-1; i >= 0; i--) {
      iPrint('_storage[$i] = arg$i;');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    List<String> columnArguments = new List<String>(dimension);
    for (int i = 0; i < dimension; i++) {
      columnArguments[i] = 'arg$i';
    }
    iPrint('\/\/\/ Sets the entire matrix to the column values.');
    iPrint('$matType setColumns(${joinStrings(columnArguments, 'vec${dimension} ')}) {');
    iPush();
    int j = 0;
    columnArguments.forEach((column) {
      for (int i = 0; i < dimension; i++) {
        iPrint('_storage[$j] = $column._storage[$i];');
        j++;
      }
    });
    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Sets the entire matrix to the matrix in [arg].');
    iPrint('$matType setMatrix($matType arg) {');
    iPush();
    for (int i = length-1; i >= 0; i--) {
      iPrint('_storage[$i] = arg._storage[$i];');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    if (dimension > 2) {
      iPrint('\/\/\/ Sets the upper 2x2 of the matrix to be [arg].');
      iPrint('$matType setUpper2x2(mat2 arg) {');
      iPush();
      for (int k = 0; k < 2; k++) {
        for (int l = 0; l < 2; l++) {
          iPrint('${Access(l, k)} = arg.${Access(l, k)};');
        }
      }
      iPrint('return this;');
      iPop();
      iPrint('}');
    }

    if (dimension == 4) {
      iPrint('\/\/\/ Sets the diagonal of the matrix to be [arg].');
      iPrint('$matType setDiagonal4(vec4 arg) {');
      iPush();
      iPrint('${Access(0, 0)} = arg.${AccessV(0)};');
      iPrint('${Access(1, 1)} = arg.${AccessV(1)};');
      iPrint('${Access(2, 2)} = arg.${AccessV(2)};');
      iPrint('${Access(3, 3)} = arg.${AccessV(3)};');
      iPrint('return this;');
      iPop();
      iPrint('}');
    }
    if (dimension >= 3) {
      iPrint('\/\/\/ Sets the diagonal of the matrix to be [arg].');
      iPrint('$matType setDiagonal3(vec3 arg) {');
      iPush();
      iPrint('${Access(0, 0)} = arg.${AccessV(0)};');
      iPrint('${Access(1, 1)} = arg.${AccessV(1)};');
      iPrint('${Access(2, 2)} = arg.${AccessV(2)};');
      iPrint('return this;');
      iPop();
      iPrint('}');
    }
    if (dimension >= 2) {
      iPrint('\/\/\/ Sets the diagonal of the matrix to be [arg].');
      iPrint('$matType setDiagonal2(vec2 arg) {');
      iPush();
      iPrint('${Access(0, 0)} = arg.${AccessV(0)};');
      iPrint('${Access(1, 1)} = arg.${AccessV(1)};');
      iPrint('return this;');
      iPop();
      iPrint('}');
    }
  }

  void generateRowColProperties() {
    iPrint('\/\/\/ Returns the dimension of the matrix.');
    iPrint('int get dimension => $dimension;');
    iPrint('\/\/\/ Returns the dimension of the matrix.');
    iPrint('int get length => $dimension;');
  }



  void generateRowGetterSetters() {
    for (int i = 0; i < dimension; i++) {
      iPrint('\/\/\/ Returns row $i');
      iPrint('$vecType get row$i => getRow($i);');
    }
    for (int i = 0; i < dimension; i++) {
      iPrint('\/\/\/ Sets row $i to [arg]');
      iPrint('set row$i($vecType arg) => setRow($i, arg);');
    }
  }

  void generateIndexOperator() {
    iPrint('\/\/\/ Gets element [i] from the matrix.');
    iPrint('double operator[](int i) {');
    iPush();
    iPrint('return _storage[i];');
    iPop();
    iPrint('}');
  }

  void generateAssignIndexOperator() {
    iPrint('\/\/\/ Sets element [i] in the matrix.');
    iPrint('void operator[]=(int i, double v) {');
    iPush();
    iPrint('_storage[i] = v;');
    iPop();
    iPrint('}');
  }

  void generateRowHelpers() {
    iPrint('\/\/\/ Assigns the [column] of the matrix [arg]');
    iPrint('void setRow(int row, $vecType arg) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      iPrint('_storage[index(row, $i)] = arg.${AccessV(i)};');
    }
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Gets the [row] of the matrix');
    iPrint('$vecType getRow(int row) {');
    iPush();
    iPrint('$vecType r = new $vecType.zero();');
    for (int i = 0; i < dimension; i++) {
      iPrint('r.${AccessV(i)} = _storage[index(row, $i)];');
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  void generateColumnHelpers() {
    iPrint('\/\/\/ Assigns the [column] of the matrix [arg]');
    iPrint('void setColumn(int column, $vecType arg) {');
    iPush();
    iPrint('int entry = column * $dimension;');
    for (int i = dimension-1; i >= 0; i--) {
      iPrint('_storage[entry+$i] = arg.${AccessV(i)};');
    }
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Gets the [column] of the matrix');
    iPrint('$vecType getColumn(int column) {');
    iPush();
    iPrint('$vecType r = new $vecType.zero();');
    iPrint('int entry = column * $dimension;');
    for (int i = dimension-1; i >= 0; i--) {
      iPrint('r.${AccessV(i)} = _storage[entry+$i];');
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  void generateToString() {
    iPrint('\/\/\/ Returns a printable string');
    iPrint('String toString() {');
    iPush();
    iPrint('String s = \'\';');
    for (int i = 0; i < dimension; i++) {
      iPrint('s = \'\$s[$i] \${getRow($i)}\\n\';');
    }
    iPrint('return s;');
    iPop();
    iPrint('}');
  }

  void generateEpilogue() {
    iPop();
    iPrint('}');
  }

  String generateInlineDot(String rowPrefix, int row, String col, int len) {
    String r = '';
    for (int i = 0; i < len; i++) {
      if (i != 0) {
        r = '$r +';
      }
      if (rowPrefix == '') {
        r = '$r (${Access(row, i)} * ${col}.${AccessV(i)})';
      } else {
        r = '$r (${rowPrefix}.${Access(row, i)} * ${col}.${AccessV(i)})';
      }

    }
    return r;
  }

  void generateMatrixVectorMultiply() {
    iPrint('$vecType _mul_vector($vecType arg) {');
    iPush();
    iPrint('$vecType r = new $vecType.zero();');
    for (int i = dimension-1; i >= 0; i--) {
      iPrint('r.${AccessV(i)} = ${generateInlineDot('', i, 'arg', dimension)};');
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  void generateMatrixVectorMultiply3() {
    iPrint('vec3 _mul_vector3(vec3 arg) {');
    iPush();
    iPrint('vec3 r = new vec3.zero();');
    for (int i = 0; i < 3; i++) {
      iPrint('r.${AccessV(i)} = ${generateInlineDot('', i, 'arg', 3)} + ${Access(i, 3)};');
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }


  String generateInlineDotM(String rowPrefix, String colPrefix, int srow, int scol, int len) {
    String r = '';
    if (rowPrefix != '') {
      rowPrefix = '${rowPrefix}.';
    }
    if (colPrefix != '') {
      colPrefix = '${colPrefix}.';
    }
    for (int i = 0; i < len; i++) {
      if (i != 0) {
        r = '$r +';
      }
      r = '$r (${rowPrefix}${Access(srow, i)} * ${colPrefix}${Access(i, scol)})';
    }
    return r;
  }

  void generateMatrixMatrixMultiply() {
    iPrint('${matType} _mul_matrix(${matType} arg) {');
    iPush();
    iPrint('var r = new ${matType}.zero();');
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('r.${Access(i, j)} = ${generateInlineDotM('', 'arg', i, j, dimension)};');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  void generateMatrixScale() {
    iPrint('${matType} _mul_scale(double arg) {');
    iPush();
    iPrint('${matType} r = new ${matType}.zero();');
    for (int i = dimension-1; i >= 0; i--) {
      for (int j = dimension-1; j >= 0; j--) {
        iPrint('r.${Access(j, i)} = ${Access(j, i)} * arg;');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  void generateMult() {
    generateMatrixScale();
    generateMatrixMatrixMultiply();
    generateMatrixVectorMultiply();
    if (matType == 'mat4') {
      generateMatrixVectorMultiply3();
    }
    iPrint('\/\/\/ Returns a new vector or matrix by multiplying [this] with [arg].');
    iPrint('dynamic operator*(dynamic arg) {');
    iPush();
    iPrint('if (arg is double) {');
    iPush();
    iPrint('return _mul_scale(arg);');
    iPop();
    iPrint('}');
    iPrint('if (arg is $vecType) {');
    iPush();
    iPrint('return _mul_vector(arg);');
    iPop();
    iPrint('}');
    if (matType == 'mat4') {
      iPrint('if (arg is vec3) {');
      iPush();
      iPrint('return _mul_vector3(arg);');
      iPop();
      iPrint('}');
    }
    iPrint('if ($dimension == arg.dimension) {');
    iPush();
    iPrint('return _mul_matrix(arg);');
    iPop();
    iPrint('}');
    iPrint('throw new ArgumentError(arg);');
    iPop();
    iPrint('}');
  }

  void generateConstructionSetters() {
    iPrint('\/\/\/ Zeros [this].');
    iPrint('${matType} setZero() {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('${Access(j, i)} = 0.0;');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Makes [this] into the identity matrix.');
    iPrint('${matType} setIdentity() {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        if (i == j) {
          iPrint('${Access(j, i)} = 1.0;');
        } else {
          iPrint('${Access(j, i)} = 0.0;');
        }
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }
  void generateOp(String op) {
    iPrint('\/\/\/ Returns new matrix after component wise [this] $op [arg]');
    iPrint('${matType} operator$op(${matType} arg) {');
    iPush();
    iPrint('${matType} r = new ${matType}.zero();');
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('r.${Access(j, i)} = ${Access(j, i)} $op arg.${Access(j, i)};');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  String generateInlineDotArgs(String aX, String aY, String aZ, String aW, String bX, String bY, String bZ, String bW) {
    return '$aX * $bX + $aY * $bY + $aZ * $bZ + $aW * $bW';
  }

  void generateInlineTranslate() {
    if (dimension != 4 || dimension != 4) {
      return;
    }
    iPrint('\/\/\/ Translate this matrix by a [vec3], [vec4], or x,y,z');
    iPrint('${matType} translate(dynamic x, [double y = 0.0, double z = 0.0]) {');
    iPush();
    iPrint('double tx;');
    iPrint('double ty;');
    iPrint('double tz;');
    iPrint('double tw = x is vec4 ? x.w : 1.0;');
    iPrint('if (x is vec3 || x is vec4) {');
    iPush();
    iPrint('tx = x.x;');
    iPrint('ty = x.y;');
    iPrint('tz = x.z;');
    iPop();
    iPrint('} else {');
    iPush();
    iPrint('tx = x;');
    iPrint('ty = y;');
    iPrint('tz = z;');
    iPop();
    iPrint('}');
    iPrint('var t1 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), 'tx', 'ty', 'tz', 'tw')};');
    iPrint('var t2 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), 'tx', 'ty', 'tz', 'tw')};');
    iPrint('var t3 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), 'tx', 'ty', 'tz', 'tw')};');
    iPrint('var t4 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), 'tx', 'ty', 'tz', 'tw')};');
    iPrint('${Access(0, 3)} = t1;');
    iPrint('${Access(1, 3)} = t2;');
    iPrint('${Access(2, 3)} = t3;');
    iPrint('${Access(3, 3)} = t4;');
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateInlineRotate() {
    if (dimension != 4 || dimension != 4) {
      return;
    }
    iPrint('\/\/\/ Rotate this [angle] radians around [axis]');
    iPrint('${matType} rotate(vec3 axis, double angle) {');
    iPush();

    // http://en.wikipedia.org/wiki/Rotation_matrix#Axis_and_angle
    iPrint('var len = axis.length;');
    iPrint('var x = axis.x/len;');
    iPrint('var y = axis.y/len;');
    iPrint('var z = axis.z/len;');
    iPrint('var c = cos(angle);');
    iPrint('var s = sin(angle);');
    iPrint('var C = 1.0 - c;');

    // row 1
    iPrint('var m11 = x * x * C + c;');
    iPrint('var m12 = x * y * C - z * s;');
    iPrint('var m13 = x * z * C + y * s;');

    // row 2
    iPrint('var m21 = y * x * C + z * s;');
    iPrint('var m22 = y * y * C + c;');
    iPrint('var m23 = y * z * C - x * s;');

    // row 3
    iPrint('var m31 = z * x * C - y * s;');
    iPrint('var m32 = z * y * C + x * s;');
    iPrint('var m33 = z * z * C + c;');

    iPrint('var t1 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), 'm11', 'm21', 'm31', '0.0')};');
    iPrint('var t2 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), 'm11', 'm21', 'm31', '0.0')};');
    iPrint('var t3 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), 'm11', 'm21', 'm31', '0.0')};');
    iPrint('var t4 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), 'm11', 'm21', 'm31', '0.0')};');

    iPrint('var t5 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), 'm12', 'm22', 'm32', '0.0')};');
    iPrint('var t6 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), 'm12', 'm22', 'm32', '0.0')};');
    iPrint('var t7 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), 'm12', 'm22', 'm32', '0.0')};');
    iPrint('var t8 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), 'm12', 'm22', 'm32', '0.0')};');

    iPrint('var t9 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), 'm13', 'm23', 'm33', '0.0')};');
    iPrint('var t10 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), 'm13', 'm23', 'm33', '0.0')};');
    iPrint('var t11 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), 'm13', 'm23', 'm33', '0.0')};');
    iPrint('var t12 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), 'm13', 'm23', 'm33', '0.0')};');

    iPrint('${Access(0, 0)} = t1;');
    iPrint('${Access(1, 0)} = t2;');
    iPrint('${Access(2, 0)} = t3;');
    iPrint('${Access(3, 0)} = t4;');

    iPrint('${Access(0, 1)} = t5;');
    iPrint('${Access(1, 1)} = t6;');
    iPrint('${Access(2, 1)} = t7;');
    iPrint('${Access(3, 1)} = t8;');

    iPrint('${Access(0, 2)} = t9;');
    iPrint('${Access(1, 2)} = t10;');
    iPrint('${Access(2, 2)} = t11;');
    iPrint('${Access(3, 2)} = t12;');

    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Rotate this [angle] radians around X');
    iPrint('${matType} rotateX(double angle) {');
    iPush();
    iPrint('double cosAngle = cos(angle);');
    iPrint('double sinAngle = sin(angle);');
    iPrint('var t1 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), '0.0', 'cosAngle', 'sinAngle', '0.0')};');
    iPrint('var t2 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), '0.0', 'cosAngle', 'sinAngle', '0.0')};');
    iPrint('var t3 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), '0.0', 'cosAngle', 'sinAngle', '0.0')};');
    iPrint('var t4 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), '0.0', 'cosAngle', 'sinAngle', '0.0')};');

    iPrint('var t5 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), '0.0', '-sinAngle', 'cosAngle', '0.0')};');
    iPrint('var t6 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), '0.0', '-sinAngle', 'cosAngle', '0.0')};');
    iPrint('var t7 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), '0.0', '-sinAngle', 'cosAngle', '0.0')};');
    iPrint('var t8 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), '0.0', '-sinAngle', 'cosAngle', '0.0')};');

    iPrint('${Access(0, 1)} = t1;');
    iPrint('${Access(1, 1)} = t2;');
    iPrint('${Access(2, 1)} = t3;');
    iPrint('${Access(3, 1)} = t4;');

    iPrint('${Access(0, 2)} = t5;');
    iPrint('${Access(1, 2)} = t6;');
    iPrint('${Access(2, 2)} = t7;');
    iPrint('${Access(3, 2)} = t8;');

    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Rotate this matrix [angle] radians around Y');
    iPrint('${matType} rotateY(double angle) {');
    iPush();
    iPrint('double cosAngle = cos(angle);');
    iPrint('double sinAngle = sin(angle);');
    iPrint('var t1 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), 'cosAngle', '0.0', 'sinAngle', '0.0')};');
    iPrint('var t2 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), 'cosAngle', '0.0', 'sinAngle', '0.0')};');
    iPrint('var t3 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), 'cosAngle', '0.0', 'sinAngle', '0.0')};');
    iPrint('var t4 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), 'cosAngle', '0.0', 'sinAngle', '0.0')};');

    iPrint('var t5 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), '-sinAngle', '0.0', 'cosAngle', '0.0')};');
    iPrint('var t6 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), '-sinAngle', '0.0', 'cosAngle', '0.0')};');
    iPrint('var t7 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), '-sinAngle', '0.0', 'cosAngle', '0.0')};');
    iPrint('var t8 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), '-sinAngle', '0.0', 'cosAngle', '0.0')};');

    iPrint('${Access(0, 0)} = t1;');
    iPrint('${Access(1, 0)} = t2;');
    iPrint('${Access(2, 0)} = t3;');
    iPrint('${Access(3, 0)} = t4;');

    iPrint('${Access(0, 2)} = t5;');
    iPrint('${Access(1, 2)} = t6;');
    iPrint('${Access(2, 2)} = t7;');
    iPrint('${Access(3, 2)} = t8;');

    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Rotate this matrix [angle] radians around Z');
    iPrint('${matType} rotateZ(double angle) {');
    iPush();
    iPrint('double cosAngle = cos(angle);');
    iPrint('double sinAngle = sin(angle);');
    iPrint('var t1 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), 'cosAngle', 'sinAngle', '0.0', '0.0')};');
    iPrint('var t2 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), 'cosAngle', 'sinAngle', '0.0', '0.0')};');
    iPrint('var t3 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), 'cosAngle', 'sinAngle', '0.0', '0.0')};');
    iPrint('var t4 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), 'cosAngle', 'sinAngle', '0.0', '0.0')};');

    iPrint('var t5 = ${generateInlineDotArgs(Access(0, 0), Access(0, 1), Access(0, 2), Access(0, 3), '-sinAngle', 'cosAngle', '0.0', '0.0')};');
    iPrint('var t6 = ${generateInlineDotArgs(Access(1, 0), Access(1, 1), Access(1, 2), Access(1, 3), '-sinAngle', 'cosAngle', '0.0', '0.0')};');
    iPrint('var t7 = ${generateInlineDotArgs(Access(2, 0), Access(2, 1), Access(2, 2), Access(2, 3), '-sinAngle', 'cosAngle', '0.0', '0.0')};');
    iPrint('var t8 = ${generateInlineDotArgs(Access(3, 0), Access(3, 1), Access(3, 2), Access(3, 3), '-sinAngle', 'cosAngle', '0.0', '0.0')};');

    iPrint('${Access(0, 0)} = t1;');
    iPrint('${Access(1, 0)} = t2;');
    iPrint('${Access(2, 0)} = t3;');
    iPrint('${Access(3, 0)} = t4;');

    iPrint('${Access(0, 1)} = t5;');
    iPrint('${Access(1, 1)} = t6;');
    iPrint('${Access(2, 1)} = t7;');
    iPrint('${Access(3, 1)} = t8;');

    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateInlineScale() {
    if (dimension != 4 || dimension != 4) {
      return;
    }
    iPrint('\/\/\/ Scale this matrix by a [vec3], [vec4], or x,y,z');
    iPrint('${matType} scale(dynamic x, [double y = null, double z = null]) {');
    iPush();
    iPrint('double sx;');
    iPrint('double sy;');
    iPrint('double sz;');
    iPrint('double sw = x is vec4 ? x.w : 1.0;');
    iPrint('if (x is vec3 || x is vec4) {');
    iPush();
    iPrint('sx = x.x;');
    iPrint('sy = x.y;');
    iPrint('sz = x.z;');
    iPop();
    iPrint('} else {');
    iPush();
    iPrint('sx = x;');
    iPrint('sy = y == null ? x : y.toDouble();');
    iPrint('sz = z == null ? x : z.toDouble();');
    iPop();
    iPrint('}');
    for (int i = 0; i < 4; i++) {
      String scalar;
      if (i == 0) {
        scalar = 'sx';
      } else if (i == 1) {
        scalar = 'sy';
      } else if (i == 2) {
        scalar = 'sz';
      } else if (i == 3) {
        scalar = 'sw';
      }
      for (int j = 0; j < 4; j++) {
        iPrint('${Access(j, i)} *= $scalar;');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateNegate() {
    iPrint('\/\/\/ Returns new matrix -this');
    iPrint('${matType} operator-() {');
    iPush();
    iPrint('${matType} r = new ${matType}.zero();');
    for (int i = 0; i < dimension; i++) {
      iPrint('r[$i] = -this[$i];');
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  void generateTranspose() {
    iPrint('\/\/\/ Returns the tranpose of this.');
    iPrint('$matType transposed() {');
    iPush();
    iPrint('$matType r = new $matType.zero();');
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('r.${Access(j, i)} = ${Access(i, j)};');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');

    iPrint('$matType transpose() {');
    iPush();
    iPrint('double temp;');
    for (int n = 0; n < dimension; n++) {
      for (int m = n+1; m < dimension; m++) {
        iPrint('temp = ${Access(n,m)};');
        iPrint('${Access(n,m)} = ${Access(m,n)};');
        iPrint('${Access(m,n)} = temp;');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateAbsolute() {
    iPrint('\/\/\/ Returns the component wise absolute value of this.');
    iPrint('${matType} absolute() {');
    iPush();
    iPrint('${matType} r = new ${matType}.zero();');
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('r.${Access(j, i)} = ${Access(j, i)}.abs();');
      }
    }
    iPrint('return r;');
    iPop();
    iPrint('}');
  }

  void generateDeterminant() {
    if (dimension == 2 && dimension == 2) {
      iPrint('\/\/\/ Returns the determinant of this matrix.');
      iPrint('double determinant() {');
      iPush();
      iPrint('return (_storage[0] * _storage[3]) - (_storage[1]*_storage[2]);');
      iPop();
      iPrint('}');
    }

    if (dimension == 3 && dimension == 3) {
      iPrint('\/\/\/ Returns the determinant of this matrix.');
      iPrint('double determinant() {');
      iPush();
      iPrint('double x = col0.x*((col1.y*col2.z)-(col1.z*col2.y));');
      iPrint('double y = col0.y*((col1.x*col2.z)-(col1.z*col2.x));');
      iPrint('double z = col0.z*((col1.x*col2.y)-(col1.y*col2.x));');
      iPrint('return x - y + z;');
      iPop();
      iPrint('}');
    }

    if (dimension == 4 && dimension == 4) {
      iPrint('\/\/\/ Returns the determinant of this matrix.');
      iPrint('double determinant() {');
      iPush();
      iPrint('double det2_01_01 = col0.x * col1.y - col0.y * col1.x;');
      iPrint('double det2_01_02 = col0.x * col1.z - col0.z * col1.x;');
      iPrint('double det2_01_03 = col0.x * col1.w - col0.w * col1.x;');
      iPrint('double det2_01_12 = col0.y * col1.z - col0.z * col1.y;');
      iPrint('double det2_01_13 = col0.y * col1.w - col0.w * col1.y;');
      iPrint('double det2_01_23 = col0.z * col1.w - col0.w * col1.z;');
      iPrint('double det3_201_012 = col2.x * det2_01_12 - col2.y * det2_01_02 + col2.z * det2_01_01;');
      iPrint('double det3_201_013 = col2.x * det2_01_13 - col2.y * det2_01_03 + col2.w * det2_01_01;');
      iPrint('double det3_201_023 = col2.x * det2_01_23 - col2.z * det2_01_03 + col2.w * det2_01_02;');
      iPrint('double det3_201_123 = col2.y * det2_01_23 - col2.z * det2_01_13 + col2.w * det2_01_12;');
      iPrint('return ( - det3_201_123 * col3.x + det3_201_023 * col3.y - det3_201_013 * col3.z + det3_201_012 * col3.w);');
      iPop();
      iPrint('}');
    }
  }

  void generateTrace() {
    if (dimension == dimension) {
      iPrint('\/\/\/ Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries');
      iPrint('double trace() {');
      iPush();
      iPrint('double t = 0.0;');
      for (int i = 0; i < dimension; i++) {
        iPrint('t += ${Access(i, i)};');
      }
      iPrint('return t;');
      iPop();
      iPrint('}');
    }
  }

  void generateInfinityNorm() {
    iPrint('\/\/\/ Returns infinity norm of the matrix. Used for numerical analysis.');
    iPrint('double infinityNorm() {');
    iPush();
    iPrint('double norm = 0.0;');
    for (int i = 0; i < dimension; i++) {
      iPrint('{');
      iPush();
      iPrint('double row_norm = 0.0;');
      for (int j = 0; j < dimension; j++) {
        iPrint('row_norm += ${Access(j, i)}.abs();');
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
    iPrint('double relativeError($matType correct) {');
    iPush();
    iPrint('$matType diff = correct - this;');
    iPrint('double correct_norm = correct.infinityNorm();');
    iPrint('double diff_norm = diff.infinityNorm();');
    iPrint('return diff_norm/correct_norm;');
    iPop();
    iPrint('}');
    iPrint('\/\/\/ Returns absolute error between [this] and [correct]');
    iPrint('double absoluteError($matType correct) {');
    iPush();
    iPrint('double this_norm = infinityNorm();');
    iPrint('double correct_norm = correct.infinityNorm();');
    iPrint('double diff_norm = (this_norm - correct_norm).abs();');
    iPrint('return diff_norm;');
    iPop();
    iPrint('}');
  }

  void generateTranslate() {
    if (dimension == 4 && dimension == 4) {
      iPrint('\/\/\/ Returns the translation vector from this homogeneous transformation matrix.');
      iPrint('vec3 getTranslation() {');
      iPush();
      iPrint('double z = _storage[14];');
      iPrint('double y = _storage[13];');
      iPrint('double x = _storage[12];');
      iPrint('return new vec3(x, y, z);');
      iPop();
      iPrint('}');
      iPrint('\/\/\/ Sets the translation vector in this homogeneous transformation matrix.');
      iPrint('void setTranslation(vec3 T) {');
      iPush();
      iPrint('double z = T._storage[2];');
      iPrint('double y = T._storage[1];');
      iPrint('double x = T._storage[0];');
      iPrint('_storage[14] = z;');
      iPrint('_storage[13] = y;');
      iPrint('_storage[12] = x;');
      iPop();
      iPrint('}');
      iPrint('\/\/\/ Sets the translation vector in this homogeneous transformation matrix.');
      iPrint('void setTranslationRaw(double x, double y, double z) {');
      iPush();
      iPrint('_storage[14] = z;');
      iPrint('_storage[13] = y;');
      iPrint('_storage[12] = x;');
      iPop();
      iPrint('}');
    }
  }

  void generateRotation() {
    if (dimension == 4 && dimension == 4) {
      iPrint('\/\/\/ Returns the rotation matrix from this homogeneous transformation matrix.');
      iPrint('mat3 getRotation() {');
      iPush();
      iPrint('mat3 r = new mat3.zero();');
      iPrint('r._storage[0] = _storage[0];');
      iPrint('r._storage[1] = _storage[1];');
      iPrint('r._storage[2] = _storage[2];');
      iPrint('r._storage[3] = _storage[4];');
      iPrint('r._storage[4] = _storage[5];');
      iPrint('r._storage[5] = _storage[6];');
      iPrint('r._storage[6] = _storage[8];');
      iPrint('r._storage[7] = _storage[9];');
      iPrint('r._storage[8] = _storage[10];');
      iPrint('return r;');
      iPop();
      iPrint('}');

      iPrint('\/\/\/ Sets the rotation matrix in this homogeneous transformation matrix.');
      iPrint('void setRotation(mat3 r) {');
      iPush();
      iPrint('_storage[0] = r._storage[0];');
      iPrint('_storage[1] = r._storage[1];');
      iPrint('_storage[2] = r._storage[2];');
      iPrint('_storage[4] = r._storage[3];');
      iPrint('_storage[5] = r._storage[4];');
      iPrint('_storage[6] = r._storage[5];');
      iPrint('_storage[8] = r._storage[6];');
      iPrint('_storage[9] = r._storage[7];');
      iPrint('_storage[10] = r._storage[8];');
      iPop();
      iPrint('}');

      iPrint('\/\/\/ Transposes just the upper 3x3 rotation matrix.');
      iPrint('mat4 transposeRotation() {');
      iPush();
      iPrint('double temp;');
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (i == j) {
            continue;
          }
          iPrint('temp = ${Access(j, i)};');
          iPrint('${Access(j, i)} = ${Access(i, j)};');
          iPrint('${Access(i, j)} = temp;');
        }
      }
      iPrint('return this;');
      iPop();
      iPrint('}');
    }
  }

  void generateInvert() {
    if (dimension == 2) {
      iPrint('\/\/\/ Invert the matrix. Returns the determinant.');
      iPrint('double invert() {');
      iPush();
      iPrint('double det = determinant();');
      iPrint('if (det == 0.0) {');
      iPush();
      iPrint('return 0.0;');
      iPop();
      iPrint('}');
      iPrint('double invDet = 1.0 / det;');
      iPrint('double temp = col0.x;');
      iPrint('col0.x = col1.y * invDet;');
      iPrint('col0.y = - col0.y * invDet;');
      iPrint('col1.x = - col1.x * invDet;');
      iPrint('col1.y = temp * invDet;');
      iPrint('return det;');
      iPop();
      iPrint('}');
    } else if (dimension == 3) {
      iPrint('/\/\/\ Invert the matrix. Returns the determinant.');
      iPrint('double invert() {');
      iPush();
      iPrint('double det = determinant();');
      iPrint('if (det == 0.0) {');
      iPush();
      iPrint('return 0.0;');
      iPop();
      iPrint('}');
      iPrint('double invDet = 1.0 / det;');
      iPrint('vec3 i = new vec3();');
      iPrint('vec3 j = new vec3();');
      iPrint('vec3 k = new vec3();');
      iPrint('i.x = invDet * (col1.y * col2.z - col1.z * col2.y);');
      iPrint('i.y = invDet * (col0.z * col2.y - col0.y * col2.z);');
      iPrint('i.z = invDet * (col0.y * col1.z - col0.z * col1.y);');
      iPrint('j.x = invDet * (col1.z * col2.x - col1.x * col2.z);');
      iPrint('j.y = invDet * (col0.x * col2.z - col0.z * col2.x);');
      iPrint('j.z = invDet * (col0.z * col1.x - col0.x * col1.z);');
      iPrint('k.x = invDet * (col1.x * col2.y - col1.y * col2.x);');
      iPrint('k.y = invDet * (col0.y * col2.x - col0.x * col2.y);');
      iPrint('k.z = invDet * (col0.x * col1.y - col0.y * col1.x);');
      iPrint('col0 = i;');
      iPrint('col1 = j;');
      iPrint('col2 = k;');
      iPrint('return det;');
      iPop();
      iPrint('}');
    } else if (dimension == 4) {
      iPrint('double invert() {');
      iPush();
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          iPrint('double a$i$j = ${Access(j, i)};');
        }
      }
      iPrint('var b00 = a00 * a11 - a01 * a10;');
      iPrint('var b01 = a00 * a12 - a02 * a10;');
      iPrint('var b02 = a00 * a13 - a03 * a10;');
      iPrint('var b03 = a01 * a12 - a02 * a11;');
      iPrint('var b04 = a01 * a13 - a03 * a11;');
      iPrint('var b05 = a02 * a13 - a03 * a12;');
      iPrint('var b06 = a20 * a31 - a21 * a30;');
      iPrint('var b07 = a20 * a32 - a22 * a30;');
      iPrint('var b08 = a20 * a33 - a23 * a30;');
      iPrint('var b09 = a21 * a32 - a22 * a31;');
      iPrint('var b10 = a21 * a33 - a23 * a31;');
      iPrint('var b11 = a22 * a33 - a23 * a32;');
      iPrint('var det = (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06);');
      iPrint('if (det == 0.0) { return det; }');
      iPrint('var invDet = 1.0 / det;');
      iPrint('${Access(0, 0)} = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;');
      iPrint('${Access(1, 0)} = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;');
      iPrint('${Access(2, 0)} = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;');
      iPrint('${Access(3, 0)} = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;');
      iPrint('${Access(0, 1)} = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;');
      iPrint('${Access(1, 1)} = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;');
      iPrint('${Access(2, 1)} = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;');
      iPrint('${Access(3, 1)} = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;');
      iPrint('${Access(0, 2)} = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;');
      iPrint('${Access(1, 2)} = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;');
      iPrint('${Access(2, 2)} = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;');
      iPrint('${Access(3, 2)} = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;');
      iPrint('${Access(0, 3)} = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;');
      iPrint('${Access(1, 3)} = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;');
      iPrint('${Access(2, 3)} = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;');
      iPrint('${Access(3, 3)} = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;');
      iPrint('return det;');
      iPop();
      iPrint('}');

      iPrint('double invertRotation() {');
      iPush();
      iPrint('double det = determinant();');
      iPrint('if (det == 0.0) {');
      iPush();
      iPrint('return 0.0;');
      iPop();
      iPrint('}');
      iPrint('double invDet = 1.0 / det;');
      iPrint('vec4 i = new vec4.zero();');
      iPrint('vec4 j = new vec4.zero();');
      iPrint('vec4 k = new vec4.zero();');
      iPrint('i.x = invDet * (col1.y * col2.z - col1.z * col2.y);');
      iPrint('i.y = invDet * (col0.z * col2.y - col0.y * col2.z);');
      iPrint('i.z = invDet * (col0.y * col1.z - col0.z * col1.y);');
      iPrint('j.x = invDet * (col1.z * col2.x - col1.x * col2.z);');
      iPrint('j.y = invDet * (col0.x * col2.z - col0.z * col2.x);');
      iPrint('j.z = invDet * (col0.z * col1.x - col0.x * col1.z);');
      iPrint('k.x = invDet * (col1.x * col2.y - col1.y * col2.x);');
      iPrint('k.y = invDet * (col0.y * col2.x - col0.x * col2.y);');
      iPrint('k.z = invDet * (col0.x * col1.y - col0.y * col1.x);');
      iPrint('col0 = i;');
      iPrint('col1 = j;');
      iPrint('col2 = k;');
      iPrint('return det;');
      iPop();
      iPrint('}');
    }
  }

  void generateSetRotation() {
    if (dimension == 2 && dimension == 2) {
      iPrint('\/\/\/ Turns the matrix into a rotation of [radians]');
      iPrint('void setRotation(num radians) {');
      iPush();
      iPrint('double radians_ = radians.toDouble();');
      iPrint('double c = Math.cos(radians_);');
      iPrint('double s = Math.sin(radians_);');
      iPrint('_storage[0] = c;');
      iPrint('_storage[1] = s;');
      iPrint('_storage[2] = -s;');
      iPrint('_storage[3] = c;');
      iPop();
      iPrint('}');
    }
    if (dimension == 3 && dimension == 3) {
      iPrint('\/\/\/ Turns the matrix into a rotation of [radians] around X');
      iPrint('void setRotationX(num radians) {');
      iPush();
      iPrint('double radians_ = radians.toDouble();');
      iPrint('double c = Math.cos(radians_);');
      iPrint('double s = Math.sin(radians_);');
      iPrint('_storage[0] = 1.0;');
      iPrint('_storage[1] = 0.0;');
      iPrint('_storage[2] = 0.0;');
      iPrint('_storage[3] = 0.0;');
      iPrint('_storage[4] = c;');
      iPrint('_storage[5] = s;');
      iPrint('_storage[6] = 0.0;');
      iPrint('_storage[7] = -s;');
      iPrint('_storage[8] = c;');
      iPop();
      iPrint('}');

      iPrint('\/\/\/ Turns the matrix into a rotation of [radians] around Y');
      iPrint('void setRotationY(num radians) {');
      iPush();
      iPrint('double radians_ = radians.toDouble();');
      iPrint('double c = Math.cos(radians_);');
      iPrint('double s = Math.sin(radians_);');
      iPrint('_storage[0] = c;');
      iPrint('_storage[1] = 0.0;');
      iPrint('_storage[2] = s;');
      iPrint('_storage[3] = 0.0;');
      iPrint('_storage[4] = 1.0;');
      iPrint('_storage[5] = 0.0;');
      iPrint('_storage[6] = -s;');
      iPrint('_storage[7] = 0.0;');
      iPrint('_storage[8] = c;');
      iPop();
      iPrint('}');

      iPrint('\/\/\/ Turns the matrix into a rotation of [radians] around Z');
      iPrint('void setRotationZ(num radians) {');
      iPush();
      iPrint('double radians_ = radians.toDouble();');
      iPrint('double c = Math.cos(radians_);');
      iPrint('double s = Math.sin(radians_);');
      iPrint('_storage[0] = c;');
      iPrint('_storage[1] = s;');
      iPrint('_storage[2] = 0.0;');
      iPrint('_storage[3] = -s;');
      iPrint('_storage[4] = c;');
      iPrint('_storage[5] = 0.0;');
      iPrint('_storage[6] = 0.0;');
      iPrint('_storage[7] = 0.0;');
      iPrint('_storage[8] = 1.0;');
      iPop();
      iPrint('}');
    }

    if (dimension == 4 && dimension == 4) {
      iPrint('\/\/\/ Sets the upper 3x3 to a rotation of [radians] around X');
      iPrint('void setRotationX(num radians) {');
      iPush();
      iPrint('double radians_ = radians.toDouble();');
      iPrint('double c = Math.cos(radians_);');
      iPrint('double s = Math.sin(radians_);');
      iPrint('_storage[0] = 1.0;');
      iPrint('_storage[1] = 0.0;');
      iPrint('_storage[2] = 0.0;');
      iPrint('_storage[4] = 0.0;');
      iPrint('_storage[5] = c;');
      iPrint('_storage[6] = s;');
      iPrint('_storage[8] = 0.0;');
      iPrint('_storage[9] = -s;');
      iPrint('_storage[10] = c;');
      iPrint('_storage[3] = 0.0;');
      iPrint('_storage[7] = 0.0;');
      iPrint('_storage[11] = 0.0;');
      iPop();
      iPrint('}');

      iPrint('\/\/\/ Sets the upper 3x3 to a rotation of [radians] around Y');
      iPrint('void setRotationY(num radians) {');
      iPush();
      iPrint('double radians_ = radians.toDouble();');
      iPrint('double c = Math.cos(radians_);');
      iPrint('double s = Math.sin(radians_);');
      iPrint('_storage[0] = c;');
      iPrint('_storage[1] = 0.0;');
      iPrint('_storage[2] = s;');
      iPrint('_storage[4] = 0.0;');
      iPrint('_storage[5] = 1.0;');
      iPrint('_storage[6] = 0.0;');
      iPrint('_storage[8] = -s;');
      iPrint('_storage[9] = 0.0;');
      iPrint('_storage[10] = c;');
      iPrint('_storage[3] = 0.0;');
      iPrint('_storage[7] = 0.0;');
      iPrint('_storage[11] = 0.0;');
      iPop();
      iPrint('}');

      iPrint('\/\/\/ Sets the upper 3x3 to a rotation of [radians] around Z');
      iPrint('void setRotationZ(num radians) {');
      iPush();
      iPrint('double radians_ = radians.toDouble();');
      iPrint('double c = Math.cos(radians_);');
      iPrint('double s = Math.sin(radians_);');
      iPrint('_storage[0] = c;');
      iPrint('_storage[1] = s;');
      iPrint('_storage[2] = 0.0;');
      iPrint('_storage[4] = -s;');
      iPrint('_storage[5] = c;');
      iPrint('_storage[6] = 0.0;');
      iPrint('_storage[8] = 0.0;');
      iPrint('_storage[9] = 0.0;');
      iPrint('_storage[10] = 1.0;');
      iPrint('_storage[3] = 0.0;');
      iPrint('_storage[7] = 0.0;');
      iPrint('_storage[11] = 0.0;');
      iPop();
      iPrint('}');
    }
  }

  String generateInlineDet2(String a, String b, String c, String d) {
    return '($a * $d - $b * $c)';
  }

  String generateInlineDet3(String a1, String a2, String a3, String b1, String b2, String b3, String c1, String c2, String c3) {
    return '($a1 * ${generateInlineDet2(b2, b3, c2, c3)} - $b1 * ${generateInlineDet2(a2, a3, c2, c3)} + $c1 * ${generateInlineDet2(a2, a3, b2, b3)})';
  }

  void generateAdjugate() {
    iPrint('\/\/\/ Converts into Adjugate matrix and scales by [scale]');
    if (dimension == 2) {
      iPrint('$matType scaleAdjoint(num scale) {');
      iPush();
      iPrint('double scale_ = scale.toDouble();');
      iPrint('double temp = ${Access(0, 0)};');
      iPrint('${Access(0, 0)} = ${Access(1,1)} * scale_;');
      iPrint('${Access(0, 1)} = - ${Access(0,1)} * scale_;');
      iPrint('${Access(1, 0)} = - ${Access(1, 0)} * scale_;');
      iPrint('${Access(1, 1)} = temp * scale_;');
      iPrint('return this;');
      iPop();
      iPrint('}');
    }

    if (dimension == 3) {
      iPrint('$matType scaleAdjoint(num scale) {');
      iPush();
      iPrint('double scale_ = scale.toDouble();');
      iPrint('double m00 = ${Access(0, 0)};');
      iPrint('double m01 = ${Access(0, 1)};');
      iPrint('double m02 = ${Access(0, 2)};');
      iPrint('double m10 = ${Access(1, 0)};');
      iPrint('double m11 = ${Access(1, 1)};');
      iPrint('double m12 = ${Access(1, 2)};');
      iPrint('double m20 = ${Access(2, 0)};');
      iPrint('double m21 = ${Access(2, 1)};');
      iPrint('double m22 = ${Access(2, 2)};');
      iPrint('${Access(0, 0)} = (m11 * m22 - m12 * m21) * scale_;');
      iPrint('${Access(1, 0)} = (m12 * m20 - m10 * m22) * scale_;');
      iPrint('${Access(2, 0)} = (m10 * m21 - m11 * m20) * scale_;');

      iPrint('${Access(0, 1)} = (m02 * m21 - m01 * m22) * scale_;');
      iPrint('${Access(1, 1)} = (m00 * m22 - m02 * m20) * scale_;');
      iPrint('${Access(2, 1)} = (m01 * m20 - m00 * m21) * scale_;');

      iPrint('${Access(0, 2)} = (m01 * m12 - m02 * m11) * scale_;');
      iPrint('${Access(1, 2)} = (m02 * m10 - m00 * m12) * scale_;');
      iPrint('${Access(2, 2)} = (m00 * m11 - m01 * m10) * scale_;');
      iPrint('return this;');
      iPop();
      iPrint('}');
    }

    if (dimension == 4) {
      iPrint('$matType scaleAdjoint(num scale) {');
      iPush();
      iPrint('double scale_ = scale.toDouble();');
      iPrint('\/\/ Adapted from code by Richard Carling.');
      iPrint('double a1 = ${Access(0,0)};');
      iPrint('double b1 = ${Access(0,1)};');
      iPrint('double c1 = ${Access(0,2)};');
      iPrint('double d1 = ${Access(0,3)};');

      iPrint('double a2 = ${Access(1,0)};');
      iPrint('double b2 = ${Access(1,1)};');
      iPrint('double c2 = ${Access(1,2)};');
      iPrint('double d2 = ${Access(1,3)};');

      iPrint('double a3 = ${Access(2,0)};');
      iPrint('double b3 = ${Access(2,1)};');
      iPrint('double c3 = ${Access(2,2)};');
      iPrint('double d3 = ${Access(2,3)};');

      iPrint('double a4 = ${Access(3,0)};');
      iPrint('double b4 = ${Access(3,1)};');
      iPrint('double c4 = ${Access(3,2)};');
      iPrint('double d4 = ${Access(3,3)};');

      iPrint('${Access(0,0)}  =   ${generateInlineDet3( 'b2', 'b3', 'b4', 'c2', 'c3', 'c4', 'd2', 'd3', 'd4')} * scale_;');
      iPrint('${Access(1,0)}  = - ${generateInlineDet3( 'a2', 'a3', 'a4', 'c2', 'c3', 'c4', 'd2', 'd3', 'd4')} * scale_;');
      iPrint('${Access(2,0)}  =   ${generateInlineDet3( 'a2', 'a3', 'a4', 'b2', 'b3', 'b4', 'd2', 'd3', 'd4')} * scale_;');
      iPrint('${Access(3,0)}  = - ${generateInlineDet3( 'a2', 'a3', 'a4', 'b2', 'b3', 'b4', 'c2', 'c3', 'c4')} * scale_;');

      iPrint('${Access(0,1)}  = - ${generateInlineDet3( 'b1', 'b3', 'b4', 'c1', 'c3', 'c4', 'd1', 'd3', 'd4')} * scale_;');
      iPrint('${Access(1,1)}  =   ${generateInlineDet3( 'a1', 'a3', 'a4', 'c1', 'c3', 'c4', 'd1', 'd3', 'd4')} * scale_;');
      iPrint('${Access(2,1)}  = - ${generateInlineDet3( 'a1', 'a3', 'a4', 'b1', 'b3', 'b4', 'd1', 'd3', 'd4')} * scale_;');
      iPrint('${Access(3,1)}  =   ${generateInlineDet3( 'a1', 'a3', 'a4', 'b1', 'b3', 'b4', 'c1', 'c3', 'c4')} * scale_;');

      iPrint('${Access(0,2)}  =   ${generateInlineDet3( 'b1', 'b2', 'b4', 'c1', 'c2', 'c4', 'd1', 'd2', 'd4')} * scale_;');
      iPrint('${Access(1,2)}  = - ${generateInlineDet3( 'a1', 'a2', 'a4', 'c1', 'c2', 'c4', 'd1', 'd2', 'd4')} * scale_;');
      iPrint('${Access(2,2)}  =   ${generateInlineDet3( 'a1', 'a2', 'a4', 'b1', 'b2', 'b4', 'd1', 'd2', 'd4')} * scale_;');
      iPrint('${Access(3,2)}  = - ${generateInlineDet3( 'a1', 'a2', 'a4', 'b1', 'b2', 'b4', 'c1', 'c2', 'c4')} * scale_;');

      iPrint('${Access(0,3)}  = - ${generateInlineDet3( 'b1', 'b2', 'b3', 'c1', 'c2', 'c3', 'd1', 'd2', 'd3')} * scale_;');
      iPrint('${Access(1,3)}  =   ${generateInlineDet3( 'a1', 'a2', 'a3', 'c1', 'c2', 'c3', 'd1', 'd2', 'd3')} * scale_;');
      iPrint('${Access(2,3)}  = - ${generateInlineDet3( 'a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'd1', 'd2', 'd3')} * scale_;');
      iPrint('${Access(3,3)}  =   ${generateInlineDet3( 'a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3')} * scale_;');
      iPrint('return this;');
      iPop();
      iPrint('}');
    }
  }

  void generateCopy() {
    iPrint('$matType clone() {');
    iPush();
    iPrint('return new $matType.copy(this);');
    iPop();
    iPrint('}');

    iPrint('$matType copyInto($matType arg) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('arg.${Access(j,i)} = ${Access(j,i)};');
      }
    }
    iPrint('return arg;');
    iPop();
    iPrint('}');

    iPrint('$matType copyFrom($matType arg) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('${Access(j,i)} = arg.${Access(j,i)};');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateSelfOp(String name, String op) {
    iPrint('$matType $name($matType o) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('${Access(j,i)} = ${Access(j,i)} $op o.${Access(j,i)};');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateSelfScalarOp(String name, String op) {
    iPrint('$matType $name(num o) {');
    iPush();
    iPrint('double o_ = o.toDouble();');
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('${Access(j,i)} = ${Access(j,i)} $op o_;');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateSelfNegate() {
    iPrint('$matType negate() {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('${Access(j,i)} = -${Access(j,i)};');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  generateSelfMultiplyMatrix() {
    iPrint('$matType multiply($matType arg) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('final double m$i$j = ${Access(i, j)};');
      }
    }
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('final double n$i$j = arg.${Access(i, j)};');
      }
    }
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        String r = '';
        for (int k = 0; k < dimension; k++) {
          if (k != 0) {
            r = '$r +';
          }
          r = '$r (m$i$k * n$k$j)';

        }
        iPrint('${Access(i, j)} = $r;');
      }

    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  generateSelfTransposeMultiplyMatrix() {
    iPrint('$matType transposeMultiply($matType arg) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('double m$i$j = ${Access(j, i)};');
      }
    }
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        String r = '';
        for (int k = 0; k < dimension; k++) {
          if (k != 0) {
            r = '$r +';
          }
          r = '$r (m$i$k * arg.${Access(k, j)})';

        }
        iPrint('${Access(i, j)} = $r;');
      }

    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  generateSelfMultiplyTransposeMatrix() {
    iPrint('$matType multiplyTranspose($matType arg) {');
    iPush();
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        iPrint('double m$i$j = ${Access(i, j)};');
      }
    }
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        String r = '';
        for (int k = 0; k < dimension; k++) {
          if (k != 0) {
            r = '$r +';
          }
          r = '$r (m$i$k * arg.${Access(j, k)})';

        }
        iPrint('${Access(i, j)} = $r;');
      }

    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }
  /*
  String generateInlineDot(String rowPrefix, int row, String col, int len) {
    String r = '';
    for (int i = 0; i < len; i++) {
      if (i != 0) {
        r = '$r +';
      }
      r = '$r (${rowPrefix}.${Access(row, i)} * ${col}.${AccessV(i)})';
    }
    return r;
  }
  */
  void generateTransforms() {
    if (dimension == 2) {
      iPrint('vec2 transform(vec2 arg) {');
      iPush();
      iPrint('double x_ = ${generateInlineDot('', 0, 'arg', 2)};');
      iPrint('double y_ = ${generateInlineDot('', 1, 'arg', 2)};');
      iPrint('arg.x = x_;');
      iPrint('arg.y = y_;');
      iPrint('return arg;');
      iPop();
      iPrint('}');
      iPrint('vec2 transformed(vec2 arg, [vec2 out=null]) {');
      iPush();
      iPrint('if (out == null) {');
      iPush();
      iPrint('out = new vec2.copy(arg);');
      iPop();
      iPrint('} else {');
      iPush();
      iPrint('out.copyFrom(arg);');
      iPop();
      iPrint('}');
      iPrint('return transform(out);');
      iPop();
      iPrint('}');
    }

    if (dimension == 3) {
      iPrint('vec3 transform(vec3 arg) {');
      iPush();
      iPrint('double x_ = ${generateInlineDot('', 0, 'arg', 3)};');
      iPrint('double y_ = ${generateInlineDot('', 1, 'arg', 3)};');
      iPrint('double z_ = ${generateInlineDot('', 2, 'arg', 3)};');
      iPrint('arg.x = x_;');
      iPrint('arg.y = y_;');
      iPrint('arg.z = z_;');
      iPrint('return arg;');
      iPop();
      iPrint('}');
      iPrint('vec3 transformed(vec3 arg, [vec3 out=null]) {');
      iPush();
      iPrint('if (out == null) {');
      iPush();
      iPrint('out = new vec3.copy(arg);');
      iPop();
      iPrint('} else {');
      iPush();
      iPrint('out.copyFrom(arg);');
      iPop();
      iPrint('}');
      iPrint('return transform(out);');
      iPop();
      iPrint('}');
    }

    if (dimension == 4) {
      iPrint('vec3 rotate3(vec3 arg) {');
      iPush();
      iPrint('double x_ = ${generateInlineDot('', 0, 'arg', 3)};');
      iPrint('double y_ = ${generateInlineDot('', 1, 'arg', 3)};');
      iPrint('double z_ = ${generateInlineDot('', 2, 'arg', 3)};');
      iPrint('arg.x = x_;');
      iPrint('arg.y = y_;');
      iPrint('arg.z = z_;');
      iPrint('return arg;');
      iPop();
      iPrint('}');
      iPrint('vec3 rotated3(vec3 arg, [vec3 out=null]) {');
      iPush();
      iPrint('if (out == null) {');
      iPush();
      iPrint('out = new vec3.copy(arg);');
      iPop();
      iPrint('} else {');
      iPush();
      iPrint('out.copyFrom(arg);');
      iPop();
      iPrint('}');
      iPrint('return rotate3(out);');
      iPop();
      iPrint('}');

      iPrint('vec3 transform3(vec3 arg) {');
      iPush();
      iPrint('double x_ = ${generateInlineDot('', 0, 'arg', 3)} + ${Access(0, 3)};');
      iPrint('double y_ = ${generateInlineDot('', 1, 'arg', 3)} + ${Access(1, 3)};');
      iPrint('double z_ = ${generateInlineDot('', 2, 'arg', 3)} + ${Access(2, 3)};');
      iPrint('arg.x = x_;');
      iPrint('arg.y = y_;');
      iPrint('arg.z = z_;');
      iPrint('return arg;');
      iPop();
      iPrint('}');
      iPrint('vec3 transformed3(vec3 arg, [vec3 out=null]) {');
      iPush();
      iPrint('if (out == null) {');
      iPush();
      iPrint('out = new vec3.copy(arg);');
      iPop();
      iPrint('} else {');
      iPush();
      iPrint('out.copyFrom(arg);');
      iPop();
      iPrint('}');
      iPrint('return transform3(out);');
      iPop();
      iPrint('}');

      iPrint('vec4 transform(vec4 arg) {');
      iPush();
      iPrint('double x_ = ${generateInlineDot('', 0, 'arg', 4)};');
      iPrint('double y_ = ${generateInlineDot('', 1, 'arg', 4)};');
      iPrint('double z_ = ${generateInlineDot('', 2, 'arg', 4)};');
      iPrint('double w_ = ${generateInlineDot('', 3, 'arg', 4)};');
      iPrint('arg.x = x_;');
      iPrint('arg.y = y_;');
      iPrint('arg.z = z_;');
      iPrint('arg.w = w_;');
      iPrint('return arg;');
      iPop();
      iPrint('}');
      iPrint('vec4 transformed(vec4 arg, [vec4 out=null]) {');
      iPush();
      iPrint('if (out == null) {');
      iPush();
      iPrint('out = new vec4.copy(arg);');
      iPop();
      iPrint('} else {');
      iPush();
      iPrint('out.copyFrom(arg);');
      iPop();
      iPrint('}');
      iPrint('return transform(out);');
      iPop();
      iPrint('}');
    }
  }

  void generateAbsoluteRotate() {
    if (dimension < 3 || dimension < 3) {
      return;
    }
    iPrint('\/\/\/ Rotates [arg] by the absolute rotation of [this]');
    iPrint('\/\/\/ Returns [arg].');
    iPrint('\/\/\/ Primarily used by AABB transformation code.');
    iPrint('vec3 absoluteRotate(vec3 arg) {');
    iPush();
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        iPrint('double m$i$j = ${Access(i, j)}.abs();');
      }
    }
    iPrint('double x = arg.x;');
    iPrint('double y = arg.y;');
    iPrint('double z = arg.z;');
    iPrint('arg.x = ${generateInlineDotArgs('x', 'y', 'z', '0.0', 'm00', 'm01', 'm02', '0.0')};');
    iPrint('arg.y = ${generateInlineDotArgs('x', 'y', 'z', '0.0', 'm10', 'm11', 'm12', '0.0')};');
    iPrint('arg.z = ${generateInlineDotArgs('x', 'y', 'z', '0.0', 'm20', 'm21', 'm22', '0.0')};');
    iPrint('return arg;');
    iPop();
    iPrint('}');
  }

  void generateBuffer() {
    iPrint('\/\/\/ Copies [this] into [array] starting at [offset].');
    iPrint('void copyIntoArray(List<num> array, [int offset=0]) {');
    iPush();
    iPrint('int i = offset;');
    for (int i = length-1; i >= 0; i--) {
      iPrint('array[i+$i] = _storage[$i];');
    }
    iPop();
    iPrint('}');
    iPrint('\/\/\/ Copies elements from [array] into [this] starting at [offset].');
    iPrint('void copyFromArray(List<num> array, [int offset=0]) {');
    iPush();
    iPrint('int i = offset;');
    for (int i = length-1; i >= 0; i--) {
      iPrint('_storage[$i] = array[i+$i];');
    }
    iPop();
    iPrint('}');
  }

  void generateRightUpForward() {
    if (dimension == 3 || dimension == 4) {
      iPrint('vec3 get right {');
      iPush();
      iPrint('double x = ${Access(0, 0)};');
      iPrint('double y = ${Access(1, 0)};');
      iPrint('double z = ${Access(2, 0)};');
      iPrint('return new vec3(x, y, z);');
      iPop();
      iPrint('}');

      iPrint('vec3 get up {');
      iPush();
      iPrint('double x = ${Access(0, 1)};');
      iPrint('double y = ${Access(1, 1)};');
      iPrint('double z = ${Access(2, 1)};');
      iPrint('return new vec3(x, y, z);');
      iPop();
      iPrint('}');

      iPrint('vec3 get forward {');
      iPush();
      iPrint('double x = ${Access(0, 2)};');
      iPrint('double y = ${Access(1, 2)};');
      iPrint('double z = ${Access(2, 2)};');
      iPrint('return new vec3(x, y, z);');
      iPop();
      iPrint('}');
    }
  }

  void generate() {
    writeLicense();
    generatePrologue();
    generateConstructors();
    generateSetters();
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
    generateInlineTranslate();
    generateInlineRotate();
    generateInlineScale();
    generateNegate();
    generateConstructionSetters();
    generateTranspose();
    generateAbsolute();
    generateDeterminant();
    generateTrace();
    generateInfinityNorm();
    generateError();
    generateTranslate();
    generateRotation();
    generateInvert();
    generateSetRotation();
    generateAdjugate();
    generateAbsoluteRotate();
    generateCopy();
    generateSelfOp('add', '+');
    generateSelfOp('sub', '-');
    generateSelfNegate();
    generateSelfMultiplyMatrix();
    generateSelfTransposeMultiplyMatrix();
    generateSelfMultiplyTransposeMatrix();
    generateTransforms();
    generateBuffer();
    generateRightUpForward();
    generateEpilogue();
  }
}