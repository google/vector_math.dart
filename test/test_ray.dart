part of vector_math_test;

class RayTest extends BaseTest {

  Vector3 _v3(double x, double y, double z) {
    return new Vector3(x,y,z);
  }

  void testRayIntersectionSphere() {
    final Ray parent = new Ray.originDirection(_v3(1.0,1.0,1.0), _v3(0.0,1.0,0.0));
    final Sphere inside = new Sphere.centerRadius(_v3(2.0,1.0,1.0), 2.0);
    final Sphere hitting = new Sphere.centerRadius(_v3(2.5,4.5,1.0), 2.0);
    final Sphere cutting = new Sphere.centerRadius(_v3(0.0,5.0,1.0), 1.0);
    final Sphere outside = new Sphere.centerRadius(_v3(-2.5,1.0,1.0), 1.0);

    expect(parent.intersectsWithSphere(inside), equals(Math.sqrt(3.0)));
    expect(parent.intersectsWithSphere(hitting), equals(3.5 - Math.sqrt(1.75)));
    expect(parent.intersectsWithSphere(cutting), equals(4.0));
    expect(parent.intersectsWithSphere(outside), equals(null));
  }

  void run() {
    test('Ray Intersection Sphere', testRayIntersectionSphere);
  }
}
