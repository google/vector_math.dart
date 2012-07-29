#import('dart:builtin');
#import('../lib/vector_math_console.dart');

#source('BaseTest.dart');
#source('QuaternionTest.dart');
#source('MatrixTest.dart');
#source('VectorTest.dart');
#source('OpenGLMatrixTest.dart');
#source('BuiltinTest.dart');

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
