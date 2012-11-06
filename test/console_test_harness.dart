library console_test_harness;
import 'package:vector_math/vector_math_console.dart';
import 'package:unittest/unittest.dart';
import 'dart:math' as Math;
part 'base_test.dart';
part 'test_quaternion.dart';
part 'test_matrix.dart';
part 'test_vector.dart';
part 'test_opengl_matrix.dart';
part 'test_builtin.dart';

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
