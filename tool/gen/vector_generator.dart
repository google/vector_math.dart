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

class VectorGenerator extends BaseGenerator {
  List<String> vectorComponents;
  int get vectorDimension {
    return vectorComponents != null ? vectorComponents.length : 0;
  }
  String vectorType;
  int vectorLen;
  List<int> vectorIndices;
  List<String> allTypes;
  List<int> allTypesLength;
  List<List<String>> componentAliases;
  String generatedName;

  VectorGenerator() : super() {
  }

  String accessorString(String component) {
    if (component == 'x' || component == 'r' || component == 's') {
      return '_storage[0]';
    } else if (component == 'y' || component == 'g' || component == 't') {
      return '_storage[1]';
    } else if (component == 'z' || component == 'b' || component == 'p') {
      return '_storage[2]';
    } else if (component == 'w' || component == 'a' || component == 'q') {
      return '_storage[3]';
    }
    throw new ArgumentError(component);
  }

  void generatePrologue() {
    iPrint('class $generatedName {');
    iPush();
    iPrint('final _storage = new Float32List(${vectorComponents.length});');
  }

  void generateAliases(bool getters) {
    for (List<String> ca in componentAliases) {
      for (int i = 0; i < ca.length; i++) {
        if (getters) {
          iPrint('$vectorType get ${ca[i]} => _storage[$i];');
        } else {
          iPrint('set ${ca[i]}($vectorType arg) => _storage[$i] = arg;');
        }
      }
    }
    for (int i = 0; i < vectorComponents.length; i++) {
      if (getters) {
        iPrint('$vectorType get ${vectorComponents[i]} => _storage[$i];');
      } else {
        iPrint('set ${vectorComponents[i]}($vectorType arg) => _storage[$i] = arg;');
      }
    }
  }

  void generateDefaultConstructor() {
    iPrint('\/\/\/ Constructs a new [$generatedName] initialized with passed in values.');
    iPrint('$generatedName(${joinStrings(vectorComponents, 'double ', '_')}) {');
    iPush();
    iPrint('makeRaw(${joinStrings(vectorComponents, '', '_')});');
    iPop();
    iPrint('}');

    iPrint('/\/\/\/ Constructs a new [$generatedName] zero vector.');
    iPrint('$generatedName.zero() {');
    iPush();
    iPrint('makeZero();');
    iPop();
    iPrint('}');
    iPrint('\/\/\/ Make [this] the zero vector.');
    iPrint('$generatedName makeZero() {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = 0.0;');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Constructs a copy of [other].');
    iPrint('$generatedName.copy($generatedName other) {');
    iPush();
    iPrint('makeCopy(other);');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Make [this] a copy of [other] [other].');
    iPrint('$generatedName makeCopy($generatedName other) {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = other._storage[$i];');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Components of [this] are set to the passed in values.');
    iPrint('$generatedName makeRaw(${joinStrings(vectorComponents, 'double ',
                                     '_')}) {');
    iPush();
    int i = 0;
    for (String e in vectorComponents) {
      iPrint('_storage[$i] = ${e}_;');
      i++;
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Constructs a new [$generatedName] that is initialized with values from [array] starting at [offset].');
    iPrint('$generatedName.array(List<num> array, [int offset=0]) {');
    iPush();
    iPrint('int i = offset;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = array[i+${i}];');
    }
    iPop();
    iPrint('}');
  }

  void generateToString() {
    iPrint('''/// Returns a printable string''');
    String code = 'String toString() => \'';
    bool first = true;
    for (int i = 0; i < vectorLen; i++) {
      var extra = first ? '\${_storage[$i]}' : ',\${_storage[$i]}';
      code = '$code$extra';
      first = false;
    }
    code = '$code\';';
    iPrint(code);
  }

  void generateSplat() {
    iPrint('\/\/\/ Splats a scalar into all lanes of the vector.');
    iPrint('$generatedName splat(double arg) {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = arg;');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateOperator(String op) {
    iPrint('\/\/\/ Returns a new $generatedName from this $op [other]');
    String code = '$generatedName operator$op($generatedName other) => new $generatedName(';
    bool first = true;
    for (int i = 0; i < vectorLen; i++) {
      var extra = first ? '_storage[$i] $op other._storage[$i]' :
                          ', _storage[$i] $op other._storage[$i]';
      code = '$code$extra';
      first = false;
    }
    code = '$code);';
    iPrint(code);
  }

  void generateScaleOperator(String op) {
    bool isMultiply = op == '*';
    iPrint('\/\/\/ Returns a new $generatedName ${isMultiply ? 'scaled' : 'divided'} by [other]');
    iPrint('$generatedName operator$op(double scale) {');
    iPush();
    {
      if (isMultiply) {
        iPrint('var o = scale;');
      } else {
        iPrint('var o = 1.0 / scale;');
      }
      String code = 'return new $generatedName(';
      bool first = true;
      for (int i = 0; i < vectorLen; i++) {
        var extra = first ? '_storage[$i] * o' :', _storage[$i] * o';
        code = '$code$extra';
        first = false;
      }
      code = '$code);';
      iPrint(code);
    }
    iPop();
    iPrint('}');
  }

  void generateNegateOperator() {
    iPrint('\/\/\/ Returns a new $generatedName from -this');
    String op = '-';
    String code = '$generatedName operator-() => new $generatedName(';
    bool first = true;
    for (int i = 0; i < vectorLen; i++) {
      var extra = first ? '$op _storage[$i]' :', $op _storage[$i]';
      code = '$code$extra';
      first = false;
    }
    code = '$code);';
    iPrint(code);
  }

  void generateIndexOperator() {
    iPrint('\/\/\/ Returns a component from ${generatedName}. This is indexed as an array with [i]');
    iPrint('$vectorType operator[](int i) => _storage[i];');
  }

  void generateAssignIndexOperator() {
    iPrint('\/\/\/ Assigns a component in $generatedName the value in [v]. This is indexed as an array with [i]');
    iPrint('void operator[]=(int i, $vectorType v) { _storage[i] = v; }');
  }

  void generateSettersForType(String type, int len, String pre, int i, int j) {
    if (i == len) {
      iPrint('set $pre($type arg) {');
      iPush();
      int z = 0;
      for (String c in pre.split("")) {
        iPrint('${accessorString(c)} = arg.${accessorString(vectorComponents[z])};');
        z++;
      }
      iPop();
      iPrint('}');
      return;
    }
    if (j == len) {
      return;
    }
    List codeUnits = pre.codeUnits;
    for (int a = 0; a < vectorDimension; a++) {
      if (codeUnits.indexOf(vectorComponents[a].codeUnits[0]) != -1) {
        continue;
      }
      String property_name = '$pre${vectorComponents[a]}';
      generateSettersForType(type, len, property_name, i+1, 0);
    }
  }

  void generateSetters() {
    for (int i = 0; i < allTypes.length; i++) {
      var type = allTypes[i];
      var len = allTypesLength[i];
      generateSettersForType(type, len, '', 0, 0);
      if (type == generatedName) {
        break;
      }
    }
  }


  void generateGettersForType(String type, int len, String pre, int i, int j) {
    if (i == len) {
      String code = '$type get $pre => new $type(';
      bool first = true;
      pre.split("").forEach((c) {
        var extra = first ? '${accessorString(c)}' : ', ${accessorString(c)}';
        code = '$code$extra';
        first = false;
      });
      code = '$code);';
      iPrint(code);
      return;
    }
    if (j == len) {
      return;
    }
    for (int a = 0; a < vectorDimension; a++) {
      String property_name = '$pre${vectorComponents[a]}';
      generateGettersForType(type, len, property_name, i+1, 0);
    }
  }

  void generateGetters() {
    for (int i = 0; i < allTypes.length; i++) {
      var type = allTypes[i];
      var len = allTypesLength[i];
      generateGettersForType(type, len, '', 0, 0);
    }
  }

  void generateLength() {
    iPrint('\/\/\/ Returns length of this');
    iPrint('double get length {');
    iPush();
    iPrint('double sum = 0.0;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('sum += (_storage[$i] * _storage[$i]);');
    }
    iPrint('return Math.sqrt(sum);');
    iPop();
    iPrint('}');
  }

  void generateLength2() {
    iPrint('\/\/\/ Returns squared length of this');
    iPrint('double get length2 {');
    iPush();
    iPrint('double sum = 0.0;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('sum += (_storage[$i] * _storage[$i]);');
    }
    iPrint('return sum;');
    iPop();
    iPrint('}');
  }

  void generateNormalize() {
    iPrint('\/\/\/ Normalizes [this]. Returns [this].');
    iPrint('$generatedName normalize() {');
    iPush();
    iPrint('double l = length;');
    iPrint('if (l == 0.0) {');
    iPush();
    iPrint('return this;');
    iPop();
    iPrint('}');
    iPrint('l = 1.0 / l;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] *= l;');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Normalizes [this]. Returns length.');
    iPrint('double normalizeLength() {');
    iPush();
    iPrint('double l = length;');
    iPrint('if (l == 0.0) {');
    iPush();
    iPrint('return 0.0;');
    iPop();
    iPrint('}');
    iPrint('l = 1.0 / l;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] *= l;');
    }
    iPrint('return l;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Normalizes [this] returns new vector or optional [out]');
    iPrint('$generatedName normalized([$generatedName out = null]) {');
    iPush();
    iPrint('if (out == null) {');
    iPush();
    iPrint('out = new ${generatedName}(${joinStrings(vectorIndices,
                                                         '_storage[',
                                                         ']')});');
    iPop();
    iPrint('}');
    iPrint('double l = out.length;');
    iPrint('if (l == 0.0) {');
    iPush();
    iPrint('return out;');
    iPop();
    iPrint('}');
    iPrint('l = 1.0 / l;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('out._storage[$i] *= l;');
    }
    iPrint('return out;');
    iPop();
    iPrint('}');
  }

  void generateDot() {
    iPrint('\/\/\/ Returns the dot product of [this] and [other]');
    iPrint('double dot($generatedName other) {');
    iPush();
    iPrint('double sum = 0.0;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('sum += _storage[$i] * other._storage[$i];');
    }
    iPrint('return sum;');
    iPop();
    iPrint('}');
  }

  void generateCross() {
    iPrint('\/\/\/ Returns the cross product of [this] and [other], optionally pass in output storage [out]');
    if (generatedName == 'vec3') {
      iPrint('$generatedName cross($generatedName other, [$generatedName out=null]) {');
      iPush();
      iPrint('if (out == null) {');
      iPush();
      iPrint('out = new vec3.zero();');
      iPop();
      iPrint('}');
      iPrint('out._storage[0] = _storage[1] * other._storage[2] - _storage[2] * other._storage[1];');
      iPrint('out._storage[1] = _storage[2] * other._storage[0] - _storage[0] * other._storage[2];');
      iPrint('out._storage[2] = _storage[0] * other._storage[1] - _storage[1] * other._storage[0];');
      iPrint('return out;');
    } else if (generatedName == 'vec2') {
      iPrint('double cross($generatedName other) {');
      iPush();
      iPrint('return _storage[0] * other._storage[1] - _storage[1] * other._storage[0];');
    } else {
      assert(false);
    }
    iPop();
    iPrint('}');
  }

  void generateError() {
    iPrint('\/\/\/ Returns the relative error between [this] and [correct]');
    iPrint('double relativeError($generatedName correct) {');
    iPush();
    iPrint('double correct_norm = correct.length;');
    iPrint('double diff_norm = (this - correct).length;');
    iPrint('return diff_norm/correct_norm;');
    iPop();
    iPrint('}');

    iPrint('\/\/\/ Returns the absolute error between [this] and [correct]');
    iPrint('double absoluteError($generatedName correct) {');
    iPush();
    iPrint('return (this - correct).length;');
    iPop();
    iPrint('}');
  }

  void generateSelfScalarOp(String methodName, String op) {
    iPrint('$generatedName $methodName(double arg) {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = _storage[$i] $op arg;');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');

    iPrint('$generatedName scaled(num arg) {');
    iPush();
    iPrint('return clone().scale(arg);');
    iPop();
    iPrint('}');
  }

  void generateSelfOp(String methodName, String op) {
    iPrint('$generatedName $methodName($generatedName arg) {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = _storage[$i] $op arg._storage[$i];');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateSelfNegate() {
    iPrint('$generatedName negate() {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = -_storage[$i];');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateSelfAbsolute() {
    iPrint('$generatedName absolute() {');
    iPush();
    for (String c in vectorComponents) {
      for (int i = 0; i < vectorLen; i++) {
        iPrint('_storage[$i] = -_storage[$i].abs();');
      }
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateEpilogue() {
    iPop();
    iPrint('}');
  }

  void generateCopy() {

    iPrint('$generatedName clone() {');
    iPush();
    iPrint('return new $generatedName.copy(this);');
    iPop();
    iPrint('}');

    iPrint('$generatedName copyInto($generatedName arg) {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('arg._storage[$i] = _storage[$i];');
    }
    iPrint('return arg;');
    iPop();
    iPrint('}');

    iPrint('$generatedName copyFrom($generatedName arg) {');
    iPush();
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = arg._storage[$i];');
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateSetComponents() {
    iPrint('$generatedName setComponents(${joinStrings(vectorComponents, 'double ', '_')}) {');
    iPush();
    int i = 0;
    for (String c in vectorComponents) {
      iPrint('_storage[$i] = ${c}_;');
      i++;
    }
    iPrint('return this;');
    iPop();
    iPrint('}');
  }

  void generateBuffer() {
    iPrint('\/\/\/ Copies [this] into [array] starting at [offset].');
    iPrint('void copyIntoArray(List<num> array, [int offset=0]) {');
    iPush();
    iPrint('int i = offset;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('array[i+$i] = _storage[$i];');
    }
    iPop();
    iPrint('}');
    iPrint('\/\/\/ Copies elements from [array] into [this] starting at [offset].');
    iPrint('void copyFromArray(List<num> array, [int offset=0]) {');
    iPush();
    iPrint('int i = offset;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('_storage[$i] = array[i+$i];');
      iPrint('i++;');
    }
    iPop();
    iPrint('}');
  }

  void generateIsInfinite() {
    iPrint('\/\/\/ Returns true if any component is infinite.');
    iPrint('bool get isInfinite {');
    iPush();
    iPrint('bool is_infinite = false;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('is_infinite = is_infinite || _storage[$i].isInfinite;');
    }
    iPrint('return is_infinite;');
    iPop();
    iPrint('}');
  }

  void generateIsNaN() {
    iPrint('\/\/\/ Returns true if any component is NaN.');
    iPrint('bool get isNaN {');
    iPush();
    iPrint('bool is_nan = false;');
    for (int i = 0; i < vectorLen; i++) {
      iPrint('is_nan = is_nan || _storage[$i].isNaN;');
    }
    iPrint('return is_nan;');
    iPop();
    iPrint('}');
  }

  void generate() {
    writeLicense();
    generatePrologue();
    generateDefaultConstructor();
    generateSplat();
    generateToString();
    generateNegateOperator();
    generateOperator('-');
    generateOperator('+');
    generateScaleOperator('/');
    generateScaleOperator('*');
    generateIndexOperator();
    generateAssignIndexOperator();
    generateLength();
    generateLength2();
    generateNormalize();
    generateDot();
    if (generatedName == 'vec3' || generatedName == 'vec2') {
      generateCross();
    }
    generateError();
    generateSetters();
    generateIsInfinite();
    generateIsNaN();
    generateSelfOp('add', '+');
    generateSelfOp('sub', '-');
    generateSelfOp('multiply', '*');
    generateSelfOp('div', '/');
    generateSelfScalarOp('scale', '*');
    generateSelfNegate();
    generateSelfAbsolute();
    generateCopy();
    generateSetComponents();
    generateBuffer();
    generateAliases(false);
    {
      var backup = vectorComponents;
      for (List<String> ca in componentAliases) {
        vectorComponents = ca;
        generateSetters();
      }
      vectorComponents = backup;
    }
    generateGetters();
    generateAliases(true);
    {
      var backup = vectorComponents;
      for (List<String> ca in componentAliases) {
        vectorComponents = ca;
        generateGetters();
      }
      vectorComponents = backup;
    }
    generateEpilogue();
  }
}
