part of vector_math_test;

class SphereTest extends BaseTest {

  Vector3 _v3(double x, double y, double z) {
    return new Vector3(x, y, z);
  }

  void testSphereContainsVector3() {
    final Sphere parent = new Sphere.centerRadius(_v3(1.0, 1.0, 1.0), 2.0);
    final Vector3 child = _v3(1.0, 1.0, 2.0);
    final Vector3 cutting = _v3(1.0, 3.0, 1.0);
    final Vector3 outside = _v3(-10.0, 10.0, 10.0);

    expect(parent.containsVector3(child), isTrue);
    expect(parent.containsVector3(cutting), isFalse);
    expect(parent.containsVector3(outside), isFalse);
  }

  void testSphereIntersectionVector3() {
    final Sphere parent = new Sphere.centerRadius(_v3(1.0, 1.0, 1.0), 2.0);
    final Vector3 child = _v3(1.0, 1.0, 2.0);
    final Vector3 cutting = _v3(1.0, 3.0, 1.0);
    final Vector3 outside = _v3(-10.0, 10.0, 10.0);

    expect(parent.intersectsWithVector3(child), isTrue);
    expect(parent.intersectsWithVector3(cutting), isTrue);
    expect(parent.intersectsWithVector3(outside), isFalse);
  }

  void testSphereIntersectionSphere() {
    final Sphere parent = new Sphere.centerRadius(_v3(1.0, 1.0, 1.0), 2.0);
    final Sphere child = new Sphere.centerRadius(_v3(1.0, 1.0, 2.0), 1.0);
    final Sphere cutting = new Sphere.centerRadius(_v3(1.0, 6.0, 1.0), 3.0);
    final Sphere outside = new Sphere.centerRadius(_v3(10.0, -1.0, 1.0), 1.0);

    expect(parent.intersectsWithSphere(child), isTrue);
    expect(parent.intersectsWithSphere(cutting), isTrue);
    expect(parent.intersectsWithSphere(outside), isFalse);
  }

  void run() {
    test('Sphere Contains Vector3', testSphereContainsVector3);
    test('Sphere Intersection Vector3', testSphereIntersectionVector3);
    test('Sphere Intersection Sphere', testSphereIntersectionSphere);
  }
}
