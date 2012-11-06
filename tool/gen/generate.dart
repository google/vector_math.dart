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

library vector_math_generator;
import 'dart:io';

part 'base_generator.dart';
part 'builtin_generator.dart';
part 'vector_generator.dart';
part 'matrix_generator.dart';

String htmlBasePath = 'lib/src/html';
String consoleBasePath = 'lib/src/console';
String basePath = 'lib/src/common';

void generateBuiltin() {
  var f;
  var o;
  f = new File('${basePath}/trig_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    BuiltinGenerator bg = new BuiltinGenerator();
    bg.allTypes = ['double', 'vec2', 'vec3', 'vec4'];
    bg.out = opened;
    bg.generate([new GeneratedFunctionDesc('sin', 'Math.sin', ['arg'], 'arg', 'Returns sine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('cos', 'Math.cos', ['arg'], 'arg', 'Returns cosine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('tan', 'Math.tan', ['arg'], 'arg', 'Returns tangent of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('asin', 'Math.asin', ['arg'], 'arg', 'Returns arc sine of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('acos', 'Math.acos', ['arg'], 'arg', 'Returns arc cosine of [arg]. Return type matches the type of [arg]'),
                 //new GeneratedFunctionDesc('sinh', 'Math.sinh', ['arg'], 'arg', 'Returns hyperbolic sine of [arg]. Return type matches the type of [arg]'),
                 //new GeneratedFunctionDesc('cosh', 'Math.cosh', ['arg'], 'arg', 'Returns hyperbolic cosine of [arg]. Return type matches the type of [arg]'),
                 //new GeneratedFunctionDesc('tanh', 'Math.tanh', ['arg'], 'arg', 'Returns hyperbolic tangent of [arg]. Return type matches the type of [arg]'),
                 //new GeneratedFunctionDesc('asinh', 'Math.asinh', ['arg'], 'arg', 'Returns arc hyperbolic sine of [arg]. Return type matches the type of [arg]'),
                 //new GeneratedFunctionDesc('acosh', 'Math.acosh', ['arg'], 'arg', 'Returns arc hyperbolic cosine of [arg]. Return type matches the type of [arg]'),
                 //new GeneratedFunctionDesc('atanh', 'Math.atanh', ['arg'], 'arg', 'Returns arc hyperbolic tangent of [arg]. Return type matches the type of [arg]'),
                 new GeneratedFunctionDesc('radians', '_ScalerHelpers.radians', ['arg'], 'arg', 'Returns [arg] converted from degrees to radians. Return types matches the type of [arg]'),
                 new GeneratedFunctionDesc('degrees', '_ScalerHelpers.degrees', ['arg'], 'arg', 'Returns [arg] converted from radians to degrees. Return types matches the type of [arg]'),
                 ]);
    opened.closeSync();
  });

  f = new File('${basePath}/exponent_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    BuiltinGenerator bg = new BuiltinGenerator();
    bg.allTypes = ['double', 'vec2', 'vec3', 'vec4'];
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

  f = new File('${basePath}/common_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    BuiltinGenerator bg = new BuiltinGenerator();
    bg.allTypes = ['double', 'vec2', 'vec3', 'vec4'];
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

void generateVector() {
  var f;
  var o;

  f = new File('${htmlBasePath}/vec2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    VectorGenerator vg = new VectorGenerator();
    vg.floatArrayType = 'Float32Array';
    vg.allTypes = ['vec2', 'vec3', 'vec4'];
    vg.allTypesLength = [2,3,4];
    vg.vectorType = 'double';
    vg.vectorComponents = ['x','y'];
    vg.componentAliases = [ ['r','g'], ['s','t']];
    vg.generatedName = 'vec2';
    vg.vectorLen = 2;
    vg.out = opened;
    vg.generate();
    opened.closeSync();
  });

  f = new File('${htmlBasePath}/vec3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    VectorGenerator vg = new VectorGenerator();
    vg.floatArrayType = 'Float32Array';
    vg.allTypes = ['vec2', 'vec3', 'vec4'];
    vg.allTypesLength = [2,3,4];
    vg.vectorType = 'double';
    vg.vectorComponents = ['x','y', 'z'];
    vg.componentAliases = [ ['r','g', 'b'], ['s','t', 'p']];
    vg.generatedName = 'vec3';
    vg.vectorLen = 3;
    vg.out = opened;
    vg.generate();
    opened.closeSync();
  });

  f = new File('${htmlBasePath}/vec4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    VectorGenerator vg = new VectorGenerator();
    vg.floatArrayType = 'Float32Array';
    vg.allTypes = ['vec2', 'vec3', 'vec4'];
    vg.allTypesLength = [2,3,4];
    vg.vectorType = 'double';
    vg.vectorComponents = ['x','y', 'z', 'w'];
    vg.componentAliases = [ ['r','g', 'b', 'a'], ['s','t', 'p', 'q']];
    vg.generatedName = 'vec4';
    vg.vectorLen = 4;
    vg.out = opened;
    vg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/vec2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    VectorGenerator vg = new VectorGenerator();
    vg.floatArrayType = 'Float32List';
    vg.allTypes = ['vec2', 'vec3', 'vec4'];
    vg.allTypesLength = [2,3,4];
    vg.vectorType = 'double';
    vg.vectorComponents = ['x','y'];
    vg.componentAliases = [ ['r','g'], ['s','t']];
    vg.generatedName = 'vec2';
    vg.vectorLen = 2;
    vg.out = opened;
    vg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/vec3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    VectorGenerator vg = new VectorGenerator();
    vg.floatArrayType = 'Float32List';
    vg.allTypes = ['vec2', 'vec3', 'vec4'];
    vg.allTypesLength = [2,3,4];
    vg.vectorType = 'double';
    vg.vectorComponents = ['x','y', 'z'];
    vg.componentAliases = [ ['r','g', 'b'], ['s','t', 'p']];
    vg.generatedName = 'vec3';
    vg.vectorLen = 3;
    vg.out = opened;
    vg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/vec4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    VectorGenerator vg = new VectorGenerator();
    vg.floatArrayType = 'Float32List';
    vg.allTypes = ['vec2', 'vec3', 'vec4'];
    vg.allTypesLength = [2,3,4];
    vg.vectorType = 'double';
    vg.vectorComponents = ['x','y', 'z', 'w'];
    vg.componentAliases = [ ['r','g', 'b', 'a'], ['s','t', 'p', 'q']];
    vg.generatedName = 'vec4';
    vg.vectorLen = 4;
    vg.out = opened;
    vg.generate();
    opened.closeSync();
  });
}

void generateMatrix() {
  var f = null;
  var o;
  f = new File('${htmlBasePath}/mat2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.rows = 2;
    mg.cols = 2;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
  /*
  f = new File('${htmlBasePath}/matrix2x3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.cols = 2;
    mg.rows = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${htmlBasePath}/matrix2x4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.cols = 2;
    mg.rows = 4;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${htmlBasePath}/matrix3x2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.rows = 2;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
  */
  f = new File('${htmlBasePath}/mat3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.rows = 3;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
  /*
  f = new File('${htmlBasePath}/matrix3x4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.rows = 4;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${htmlBasePath}/matrix4x2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.rows = 2;
    mg.cols = 4;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${htmlBasePath}/matrix4x3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.cols = 4;
    mg.rows = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
*/
  f = new File('${htmlBasePath}/mat4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32Array';
    mg.rows = 4;
    mg.cols = 4;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/mat2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.rows = 2;
    mg.cols = 2;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
  /*
  f = new File('${consoleBasePath}/matrix2x3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.cols = 2;
    mg.rows = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/matrix2x4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.cols = 2;
    mg.rows = 4;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/matrix3x2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.rows = 2;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
  */
  f = new File('${consoleBasePath}/mat3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.rows = 3;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
  /*
  f = new File('${consoleBasePath}/matrix3x4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.rows = 4;
    mg.cols = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/matrix4x2_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.rows = 2;
    mg.cols = 4;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });

  f = new File('${consoleBasePath}/matrix4x3_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.cols = 4;
    mg.rows = 3;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
*/
  f = new File('${consoleBasePath}/mat4_gen.dart');
  o = f.open(FileMode.WRITE);
  o.then((opened) {
    MatrixGenerator mg = new MatrixGenerator();
    mg.floatArrayType = 'Float32List';
    mg.rows = 4;
    mg.cols = 4;
    mg.out = opened;
    mg.generate();
    opened.closeSync();
  });
}

void main() {
  print('Generating builtin functions');
  generateBuiltin();
  print('Generating vector types');
  generateVector();
  print('Generating matrix types');
  generateMatrix();
  print('Finished');
}
