library console_test_harness;

import 'package:unittest/unittest.dart';
import 'vector_math_test.dart';

void main() {
  groupSep = ' - ';

  group('Quaternion', () {
    QuaternionTest qt = new QuaternionTest();
    qt.run();
  });

  group('Matrix', () {
    MatrixTest mt = new MatrixTest();
    mt.run();
  });

  group('Vector', () {
    VectorTest vt = new VectorTest();
    vt.run();
  });

  group('OpenGL', () {
    OpenGLMatrixTest omt = new OpenGLMatrixTest();
    omt.run();
  });

  group('AABB', () {
    AabbTest at = new AabbTest();
    at.run();
  });

  group('Colors', () {
    ColorsTest ct = new ColorsTest();
    ct.run();
  });

  group('Utilities', () {
    var ut = new UtilitiesTest();
    ut.run();
  });

  group('Geometry', () {
    GeometryTest gt = new GeometryTest();
    gt.run();
  });

  group('Sphere', () {
    SphereTest st = new SphereTest();
    st.run();
  });

  group('Ray', () {
    RayTest rt = new RayTest();
    rt.run();
  });

  group('Triangle', () {
    TriangleTest tt = new TriangleTest();
    tt.run();
  });

  group('Plane', () {
    PlaneTest pt = new PlaneTest();
    pt.run();
  });

  group('Frustum', () {
    FrustumTest ft = new FrustumTest();
    ft.run();
  });

  group('Noise', () {
    NoiseTest nt = new NoiseTest();
    nt.run();
  });
}

