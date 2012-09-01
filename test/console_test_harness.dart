#import('../lib/vector_math_console.dart');
#import('dart:math', prefix:'Math');
#source('base_test.dart');
#source('test_quaternion.dart');
#source('test_matrix.dart');
#source('test_vector.dart');
#source('test_opengl_matrix.dart');
#source('test_builtin.dart');

void main() {
  {
    QuaternionTest qt = new QuaternionTest();
    qt.test();  
  }
  
  {
    MatrixTest mt = new MatrixTest();
    mt.test();
  }
  
  {
    VectorTest vt = new VectorTest();
    vt.test();
  }
  
  {
    OpenGLMatrixTest omt = new OpenGLMatrixTest();
    omt.test();
  }
  
  {
    BuiltinTest bt = new BuiltinTest();
    bt.test();
  }
  print('Finished testing');
}
