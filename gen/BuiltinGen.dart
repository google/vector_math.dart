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
#import ('dart:core');
#import ('dart:io');
 
typedef void GenerateFunction(GeneratedFunctionDesc function, BuiltinGen bg);

class GeneratedFunctionDesc {
  String name;
  String scalarName;
  List<String> args;
  String typeArg;
  String docString;
  GenerateFunction custom;
  GeneratedFunctionDesc(this.name, this.scalarName, this.args, this.typeArg, [this.docString = '', this.custom = null]);
}

class BuiltinGen {
  List<String> allTypes;
  int _indent;
  RandomAccessFile out;
  
  BuiltinGen() {
    _indent = 0;
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
      indent = '$indent  ';
    }
    out.writeStringSync('$indent$s\n');
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
  
  List<String> getComponents(String typeName) {
    switch (typeName) {
    case 'num':
      return [''];
    case 'vec2':
      return ['.x', '.y'];
    case 'vec3':
      return ['.x', '.y', '.z'];
    case 'vec4':
      return ['.x', '.y', '.z', '.w'];
    }
    return [''];
  }
  
  String makeArgsString(List<String> args) {
    bool first = true;
    String code = '';
    args.forEach((arg) {
      var extra =first ? 'Dynamic $arg' : ', Dynamic $arg'; 
      code = '$code$extra'; 
      first = false;
    });
    return code;
  }
  
  String expandArguments(List<String> arguments, String component) {
    bool first = true;
    String code = '';
    arguments.forEach((arg) {
      var extra = first ? '$arg$component' : ', $arg$component';
      code = '$code$extra';
      first = false;
    });
    return code;
  }
  
  void generateFunction(GeneratedFunctionDesc function) {
    iPrint('\/\/\/ ${function.docString}');
    String prologue = 'Dynamic ${function.name}(${makeArgsString(function.args)}) {';
    iPrint(prologue);
    iPush();
    allTypes.forEach((type) {
      iPrint('if (${function.typeArg} is $type) {');
      iPush();
      if (type == 'num') {
        iPrint('return ${function.scalarName}(${expandArguments(function.args, '')});');
      } else {
        List<String> components = getComponents(type);
        String code = 'return new $type(';
        bool first = true;
        components.forEach((comp) {
          if (first) {
            var extra ='${function.scalarName}(${expandArguments(function.args, comp)})'; 
            code = '$code$extra';
          } else {
            var extra = ', ${function.scalarName}(${expandArguments(function.args, comp)})';
            code = '$code$extra'; 
          }
          first = false;
        });
        iPrint('$code);');
      }
      iPop();
      iPrint('}');
    });
    iPrint('throw new IllegalArgumentException(${function.typeArg});');
    iPop();
    iPrint('}');
  }
  
  void generate(List<GeneratedFunctionDesc> functions) {
    writeLicense();
    functions.forEach((f) {
      if (f.custom != null) {
        f.custom(f, this);
      } else {
        generateFunction(f);
      }
    });
  }
}

void generateMix(GeneratedFunctionDesc function, BuiltinGen bg) {
  bg.iPrint('\/\/\/ ${function.docString}');
  String prologue = 'Dynamic ${function.name}(${bg.makeArgsString(function.args)}) {';
  bg.iPrint(prologue);
  bg.iPush();
  bg.iPrint('if (t is num) {');
  bg.iPush();
  bg.iPrint('''  if (x is num) {
        return _ScalerHelpers.mix(x, y, t);
      }
      if (x is vec2) {
        return new vec2(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x, y.y, t));
      }
      if (x is vec3) {
        return new vec3(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t), _ScalerHelpers.mix(x.z, y.z, t));
      }
      if (x is vec4) {
        return new vec4(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t), _ScalerHelpers.mix(x.z, y.z, t), _ScalerHelpers.mix(x.w, y.w, t));
      }
      throw new IllegalArgumentException(x);
''');
  bg.iPop();
  bg.iPrint('} else {');
  bg.iPush();
  bg.iPrint('''  if (x is num) {
        return _ScalerHelpers.mix(x, y, t);
      }
      if (x is vec2) {
        return new vec2(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y));
      }
      if (x is vec3) {
        return new vec3(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z));
      }
      if (x is vec4) {
        return new vec4(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z), _ScalerHelpers.mix(x.w, y.w, t.w));
      }
      throw new IllegalArgumentException(x);
''');
  bg.iPop();
  bg.iPrint('}');
  bg.iPop();
  bg.iPrint('}');
}

void main() {
  String basePath = 'lib/VectorMath/gen';
  var f;
  var o;
  f = new File('${basePath}/trig.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    print('opened');
    BuiltinGen bg = new BuiltinGen();
    bg.allTypes = ['num', 'vec2', 'vec3', 'vec4'];
    bg.out = opened;
    bg.generate([new GeneratedFunctionDesc('sin', 'Math.sin', ['arg'], 'arg', 'Returns sine of [arg]. Return type matches the type of [arg]'), 
                 new GeneratedFunctionDesc('cos', 'Math.cos', ['arg'], 'arg', 'Returns cosine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('tan', 'Math.tan', ['arg'], 'arg', 'Returns tangent of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('asin', 'Math.asin', ['arg'], 'arg', 'Returns arc sine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('acos', 'Math.acos', ['arg'], 'arg', 'Returns arc cosine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('sinh', 'Math.sinh', ['arg'], 'arg', 'Returns hyperbolic sine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('cosh', 'Math.cosh', ['arg'], 'arg', 'Returns hyperbolic cosine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('tanh', 'Math.tanh', ['arg'], 'arg', 'Returns hyperbolic tangent of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('asinh', 'Math.asinh', ['arg'], 'arg', 'Returns arc hyperbolic sine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('acosh', 'Math.acosh', ['arg'], 'arg', 'Returns arc hyperbolic cosine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('atanh', 'Math.atanh', ['arg'], 'arg', 'Returns arc hyperbolic tangent of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('radians', '_ScalerHelpers.radians', ['arg'], 'arg', 'Returns [arg] converted from degrees to radians. Return types matches the type of [arg]'),
                 new GeneratedFunctionDesc('degrees', '_ScalerHelpers.degrees', ['arg'], 'arg', 'Returns [arg] converted from radians to degrees. Return types matches the type of [arg]'),
                 ]);
    opened.closeSync();
  });
  
  f = new File('${basePath}/exponent.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    print('opened');
    BuiltinGen bg = new BuiltinGen();
    bg.allTypes = ['num', 'vec2', 'vec3', 'vec4'];
    bg.out = opened;
    bg.generate([new GeneratedFunctionDesc('pow', 'Math.pow', ['x','y'], 'x', 'Returns [x] raised to the exponent [y]. Supports vectors and numbers.'),
                 new GeneratedFunctionDesc('exp', 'Math.exp', ['arg'], 'arg', 'Returns *e* raised to the exponent [arg]. Supports vectors and numbers.'),
                 new GeneratedFunctionDesc('log', 'Math.log', ['arg'], 'arg', 'Returns the logarithm of [arg] base *e*. Supports vectors and numbers.'),
                 new GeneratedFunctionDesc('exp2', '_ScalerHelpers.exp2', ['arg'], 'arg', 'Returns *2* raised to the exponent [arg]. Supports vectors and numbers.'),
                 new GeneratedFunctionDesc('log2', '_ScalerHelpers.log2', ['arg'], 'arg', 'Returns the logarithm of [arg] base *2*. Supports vectors and numbers.'),
                 new GeneratedFunctionDesc('sqrt', 'Math.sqrt', ['arg'], 'arg', 'Returns the square root of [arg].'),
                 new GeneratedFunctionDesc('inversesqrt', '_ScalerHelpers.inversesqrt', ['arg'], 'arg', 'Returns the inverse square root of [arg]. Supports vectors and numbers.'),
                 ]);
    opened.closeSync();
  });
  
  f = new File('${basePath}/common.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    print('opened');
    BuiltinGen bg = new BuiltinGen();
    bg.allTypes = ['num', 'vec2', 'vec3', 'vec4'];
    bg.out = opened;
    bg.generate([new GeneratedFunctionDesc('abs', '_ScalerHelpers.abs', ['arg'], 'arg', 'Returns absolute value of [arg].'),
                 new GeneratedFunctionDesc('sign', '_ScalerHelpers.sign', ['arg'], 'arg', 'Returns 1.0 or 0.0 or -1.0 depending on sign of [arg].'),
                 new GeneratedFunctionDesc('floor', '_ScalerHelpers.floor', ['arg'], 'arg', 'Returns floor value of [arg].'),
                 new GeneratedFunctionDesc('trunc', '_ScalerHelpers.truncate', ['arg'], 'arg', 'Returns [arg] truncated.'),
                 new GeneratedFunctionDesc('round', '_ScalerHelpers.round', ['arg'], 'arg', 'Returns [arg] rounded to nearest integer.'),
                 new GeneratedFunctionDesc('roundEven', '_ScalerHelpers.roundEven', ['arg'], 'arg', 'Returns [arg] rounded to nearest even integer.'),
                 new GeneratedFunctionDesc('ceil', '_ScalerHelpers.ceil', ['arg'], 'arg', 'Returns ceiling of [arg]'),
                 new GeneratedFunctionDesc('fract', '_ScalerHelpers.fract', ['arg'], 'arg', 'Returns fraction of [arg]'),
                 new GeneratedFunctionDesc('mod', '_ScalerHelpers.mod', ['x', 'y'], 'x', 'Returns [x] mod [y]'),
                 new GeneratedFunctionDesc('min', 'Math.min', ['x', 'y'], 'x', 'Returns component wise minimum of [x] and [y]'),
                 new GeneratedFunctionDesc('max', 'Math.max', ['x', 'y'], 'x', 'Returns component wise maximum of [x] and [y]'),
                 new GeneratedFunctionDesc('clamp', '_ScalerHelpers.clamp', ['x', 'min_', 'max_'], 'x', 'Component wise clamp of [x] between [min_] and [max_]'),
                 new GeneratedFunctionDesc('mix', '_ScalerHelpers.mix', ['x', 'y', 't'], 'x', 'Linear interpolation between [x] and [y] with [t]. [t] must be between 0.0 and 1.0.', generateMix),
                 new GeneratedFunctionDesc('step', '_ScalerHelpers.step', ['x', 'y'], 'x', 'Returns 0.0 if x < [y] and 1.0 otherwise.'),
                 new GeneratedFunctionDesc('smoothstep', '_ScalerHelpers.smoothstep', ['edge0', 'edge1', 'x'], 'x', 'Hermite intpolation between [edge0] and [edge1]. [edge0] < [x] < [edge1].'),
                 ]);
    opened.closeSync();
  });
}