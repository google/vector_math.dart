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
 
typedef void GenerateFunction(GeneratedFunctionDesc function, BuiltinGenerator bg);

class GeneratedFunctionDesc {
  String name;
  String scalarName;
  List<String> args;
  String typeArg;
  String docString;
  GenerateFunction custom;
  GeneratedFunctionDesc(this.name, this.scalarName, this.args, this.typeArg, [this.docString = '', this.custom = null]);
}

class BuiltinGenerator extends BaseGenerator {
  List<String> allTypes;
  
  BuiltinGenerator() : super() {
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
    String prologue = 'Dynamic ${function.name}(${makeArgsString(function.args)}, [Dynamic out=null]) {';
    iPrint(prologue);
    iPush();
    allTypes.forEach((type) {
      iPrint('if (${function.typeArg} is $type) {');
      iPush();
      if (type == 'num') {
        iPrint('return ${function.scalarName}(${expandArguments(function.args, '')});');
      } else {
        List<String> components = getComponents(type);
        iPrint('if (out == null) {');
        iPush();
        iPrint('out = new $type.zero();');
        iPop();
        iPrint('}');
        components.forEach((comp) {
            iPrint('out$comp = ${function.scalarName}(${expandArguments(function.args, comp)});');
        });
        iPrint('return out;');
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

void generateMix(GeneratedFunctionDesc function, BuiltinGenerator bg) {
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