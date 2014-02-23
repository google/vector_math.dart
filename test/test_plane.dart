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

  void testPlaneIntersection() {
    final Plane plane1 = new Plane.normalconstant(_v3(1.0, 0.0, 0.0), -2.0);
    final Plane plane2 = new Plane.normalconstant(_v3(0.0, 1.0, 0.0), -3.0);
    final Plane plane3 = new Plane.normalconstant(_v3(0.0, 0.0, 1.0), -4.0);

    plane1.normalize();
    plane2.normalize();
    plane3.normalize();

    final point = new Vector3.zero();

    Plane.intersection(plane1, plane2, plane3, point);

    expect(point.x, equals(2.0));
    expect(point.y, equals(3.0));
    expect(point.z, equals(4.0));
  }


  void run() {
    test('Plane Normalize', testPlaneNormalize);
    test('Plane DistanceToVector3', testPlaneDistanceToVector3);
    test('Plane Intersection', testPlaneIntersection);
  }
}
