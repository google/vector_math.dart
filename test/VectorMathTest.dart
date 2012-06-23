#import('dart:builtin');
#import('../lib/VectorMath/VectorMath.dart');

#source('BaseTest.dart');
#source('QuaternionTest.dart');
#source('MatrixTest.dart');
#source('VectorTest.dart');
#source('OpenGLMatrixTest.dart');

void main() {
  {
    QuaternionTest qt = new QuaternionTest();
    qt.Test();  
  }
  
  {
    MatrixTest mt = new MatrixTest();
    mt.Test();
  }
  
  {
    VectorTest vt = new VectorTest();
    vt.Test();
  }
  
  {
    OpenGLMatrixTest omt = new OpenGLMatrixTest();
    omt.Test();
  }
  print('Finished testing');
}
