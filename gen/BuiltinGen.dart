#import ('dart:builtin');
#import ('dart:core');
#import ('dart:io');
 
class GeneratedFunctionDesc {
  String name;
  String scalarName;
  List<String> args;
  String typeArg;
  GeneratedFunctionDesc(this.name, this.scalarName, this.args, this.typeArg);
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
  
  List<String> getComponents(String typeName) {
    switch (typeName) {
    case 'num':
      return [''];
      break;
    case 'vec2':
      return ['.x', '.y'];
      break;
    case 'vec3':
      return ['.x', '.y', '.z'];
      break;
    case 'vec4':
      return ['.x', '.y', '.z', '.w'];
      break;
    }
    return [''];
  }
  
  String makeArgsString(List<String> args) {
    bool first = true;
    String code = '';
    args.forEach((arg) {
      code += first ? 'Dynamic $arg' : ', Dynamic $arg';
      first = false;
    });
    return code;
  }
  
  String expandArguments(List<String> arguments, String component) {
    bool first = true;
    String code = '';
    arguments.forEach((arg) {
      code += first ? '$arg$component' : ', $arg$component';
      first = false;
    });
    return code;
  }
  
  void generateFunction(GeneratedFunctionDesc function) {
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
            code += '${function.scalarName}(${expandArguments(function.args, comp)})';
          } else {
            code += ', ${function.scalarName}(${expandArguments(function.args, comp)})';
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
      generateFunction(f);
    });
  }
}


void main() {
  String basePath = 'lib/VectorMath/gen';
  var f;
  
  f = new File('${basePath}/trig.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    BuiltinGen bg = new BuiltinGen();
    bg.allTypes = ['num', 'vec2', 'vec3', 'vec4'];
    bg.out = opened;
    bg.generate([new GeneratedFunctionDesc('sin', 'Math.sin', ['arg'], 'arg'), 
                 new GeneratedFunctionDesc('cos', 'Math.cos', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('tan', 'Math.tan', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('asin', 'Math.asin', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('acos', 'Math.acos', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('sinh', 'Math.sinh', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('cosh', 'Math.cosh', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('tanh', 'Math.tanh', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('asinh', 'Math.asinh', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('acosh', 'Math.acosh', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('atanh', 'Math.atanh', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('radians', 'ScalarMath.radians', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('degrees', 'ScalarMath.degrees', ['arg'], 'arg'),
                 ]);
    opened.close(() {});
  });
  
  f = new File('${basePath}/exponent.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    BuiltinGen bg = new BuiltinGen();
    bg.allTypes = ['num', 'vec2', 'vec3', 'vec4'];
    bg.out = opened;
    bg.generate([new GeneratedFunctionDesc('pow', 'Math.pow', ['x','y'], 'x'),
                 new GeneratedFunctionDesc('exp', 'Math.exp', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('log', 'Math.log', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('exp2', 'ScalarMath.exp2', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('log2', 'ScalarMath.log2', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('sqrt', 'Math.sqrt', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('inversesqrt', 'ScalarMath.inversesqrt', ['arg'], 'arg'),
                 ]);
    opened.close(() {});
  });
  
  f = new File('${basePath}/common.dart');
  f.onError = (error) {
    print('$error');
  };
  f.open(FileMode.WRITE, (opened) {
    print('opened');
    BuiltinGen bg = new BuiltinGen();
    bg.allTypes = ['num', 'vec2', 'vec3', 'vec4'];
    bg.out = opened;
    bg.generate([new GeneratedFunctionDesc('abs', 'ScalarMath.abs', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('sign', 'ScalarMath.sign', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('floor', 'ScalarMath.floor', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('trunc', 'ScalarMath.truncate', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('round', 'ScalarMath.round', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('roundEven', 'ScalarMath.roundEven', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('ceil', 'ScalarMath.ceil', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('fract', 'ScalarMath.fract', ['arg'], 'arg'),
                 new GeneratedFunctionDesc('mod', 'ScalarMath.mod', ['x', 'y'], 'x'),
                 new GeneratedFunctionDesc('min', 'Math.min', ['x', 'y'], 'x'),
                 new GeneratedFunctionDesc('max', 'Math.max', ['x', 'y'], 'x'),
                 new GeneratedFunctionDesc('clamp', 'ScalarMath.clamp', ['x', 'min_', 'max_'], 'x'),
                 new GeneratedFunctionDesc('mix', 'ScalarMath.mix', ['x', 'y', 't'], 'x'),
                 new GeneratedFunctionDesc('step', 'ScalarMath.step', ['x', 'y'], 'x'),
                 new GeneratedFunctionDesc('smoothstep', 'ScalarMath.smoothstep', ['edge0', 'edge1', 'x'], 'x'),
                 ]);
    opened.close(() {});
  });
}