part of vector_math_test;

class PlaneTest extends BaseTest {

  Vector3 _v3(double x, double y, double z) {
    return new Vector3(x, y, z);
  }

  void testPlaneNormalize() {
    final Plane plane = new Plane.normalconstant(_v3(2.0, 0.0, 0.0), 2.0);

    plane.normalize();

    expect(plane.normal.x, equals(1.0));
    expect(plane.normal.y, equals(0.0));
    expect(plane.normal.z, equals(0.0));
    expect(plane.normal.length, equals(1.0));
    expect(plane.constant, equals(1.0));
  }

  void testPlaneDistanceToVector3() {
    final Plane plane = new Plane.normalconstant(_v3(2.0, 0.0, 0.0), -2.0);

    plane.normalize();

    expect(plane.distanceToVector3(_v3(4.0, 0.0, 0.0)), equals(3.0));
    expect(plane.distanceToVector3(_v3(1.0, 0.0, 0.0)), equals(0.0));
  }


  void run() {
    test('Plane Normalize', testPlaneNormalize);
    test('Plane DistanceToVector3', testPlaneDistanceToVector3);
  }
}
