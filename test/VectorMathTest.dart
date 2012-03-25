#import('dart:builtin');
#import('../lib/VectorMath/VectorMath.dart');
#source('QuaternionTest.dart');
#source('MatrixTest.dart');

void main() {
  /*
  var r = new Options();
  print('${r.script}');
  num test = 0.0;
  vec2 test2 = new vec2(3.0, 4.0);
  vec4 test4 = new vec4(0.0, Math.PI/2, Math.PI, Math.PI*3/2);
  var x = test4[2];
  x = 55;
  print("Hello World $test ($test2) ${test2[2]}");
  print('$test4');
  print('(${degrees(test4)}) (${sin(test4)})');
  test2[0] = 1;
  print('(${exp(test2)})');
  test2 = -test2;
  print('${normalize(test2)} $test2');
  vec3 test3 = new vec3(1.0, 0.0, 1.0);
  print('${normalize(test3)} $test3');
  print('${normalize(test3)} $test3');
  
  {
    mat4x4 m = new mat4x4();
    m = m * 5.0;
    print('$m');
    vec4 v = new vec4(99, 22, 11, 1.0);
    print('${m * v}');
  }
  {
    mat3x3 m = new mat3x3();
    print('det(m) = ${m.determinant()}');
    m = m * 5.0;
    print('2x det(m) = ${m.determinant()}');
  }
  */
 
  {
    QuaternionTest qt = new QuaternionTest();
    qt.Test();  
  }
  
  {
    MatrixTest mt = new MatrixTest();
    mt.Test();
  }
}
