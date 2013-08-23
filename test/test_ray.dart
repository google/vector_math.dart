part of vector_math_test;

class RayTest extends BaseTest {

  Vector3 _v3(double x, double y, double z) {
    return new Vector3(x,y,z);
  }

  void testRayAt() {
    final Ray parent = new Ray.originDirection(_v3(1.0,1.0,1.0), _v3(-1.0,1.0,1.0));

    final Vector3 atOrigin = parent.at(0.0);
    final Vector3 atPositive = parent.at(1.0);
    final Vector3 atNegative = parent.at(-2.0);

    expect(atOrigin.x, equals(1.0));
    expect(atOrigin.y, equals(1.0));
    expect(atOrigin.z, equals(1.0));
    expect(atPositive.x, equals(0.0));
    expect(atPositive.y, equals(2.0));
    expect(atPositive.z, equals(2.0));
    expect(atNegative.x, equals(3.0));
    expect(atNegative.y, equals(-1.0));
    expect(atNegative.z, equals(-1.0));
  }

  void testRayIntersectionSphere() {
    final Ray parent = new Ray.originDirection(_v3(1.0,1.0,1.0), _v3(0.0,1.0,0.0));
    final Sphere inside = new Sphere.centerRadius(_v3(2.0,1.0,1.0), 2.0);
    final Sphere hitting = new Sphere.centerRadius(_v3(2.5,4.5,1.0), 2.0);
    final Sphere cutting = new Sphere.centerRadius(_v3(0.0,5.0,1.0), 1.0);
    final Sphere outside = new Sphere.centerRadius(_v3(-2.5,1.0,1.0), 1.0);
    final Sphere behind = new Sphere.centerRadius(_v3(1.0,-1.0,1.0), 1.0);

    expect(parent.intersectsWithSphere(inside), equals(Math.sqrt(3.0)));
    expect(parent.intersectsWithSphere(hitting), equals(3.5 - Math.sqrt(1.75)));
    expect(parent.intersectsWithSphere(cutting), equals(4.0));
    expect(parent.intersectsWithSphere(outside), equals(null));
    expect(parent.intersectsWithSphere(behind), equals(null));
  }

  void testRayIntersectionTriangle() {
    final Ray parent = new Ray.originDirection(_v3(1.0,1.0,1.0), _v3(0.0,1.0,0.0));
    final Triangle hitting = new Triangle.points(_v3(2.0,2.0,0.0), _v3(0.0,4.0,-1.0), _v3(0.0,4.0,3.0));
    final Triangle cutting = new Triangle.points(_v3(0.0,1.5,1.0), _v3(2.0,1.5,1.0), _v3(1.0,1.5,3.0));
    final Triangle outside = new Triangle.points(_v3(2.0,2.0,0.0), _v3(2.0,6.0,0.0), _v3(2.0,2.0,3.0));
    final Triangle behind = new Triangle.points(_v3(0.0,0.0,0.0), _v3(0.0,3.0,0.0), _v3(0.0,3.0,4.0));

    expect(parent.intersectsWithTriangle(hitting), equals(2.0));
    expect(parent.intersectsWithTriangle(cutting), equals(0.5));
    expect(parent.intersectsWithTriangle(outside), equals(null));
    expect(parent.intersectsWithTriangle(behind), equals(null));
  }

  void run() {
    test('Ray At', testRayAt);
    test('Ray Intersection Sphere', testRayIntersectionSphere);
    test('Ray Intersection Triangle', testRayIntersectionTriangle);
  }
}
