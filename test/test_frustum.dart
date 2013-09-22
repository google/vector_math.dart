part of vector_math_test;

class FrustumTest extends BaseTest {

  Vector3 _v3(double x, double y, double z) {
    return new Vector3(x,y,z);
  }

  void testFrustumContainsVector3() {
    final Frustum frustum = new Frustum.matrix(
        makeFrustumMatrix(-1.0, 1.0, -1.0, 1.0, 1.0, 100.0));

    expect(frustum.containsVector3(_v3(0.0, 0.0, 0.0)), equals(false));
    expect(frustum.containsVector3(_v3(0.0, 0.0, -50.0)), equals(true));
    expect(frustum.containsVector3(_v3(0.0, 0.0, -1.001)), equals(true));
    expect(frustum.containsVector3(_v3(-1.0, -1.0, -1.001)), equals(true));
    expect(frustum.containsVector3(_v3(-1.1, -1.1, -1.001)), equals(false));
    expect(frustum.containsVector3(_v3(1.0, 1.0, -1.001)), equals(true));
    expect(frustum.containsVector3(_v3(1.1, 1.1, -1.001)), equals(false));
    expect(frustum.containsVector3(_v3(0.0, 0.0, -99.999)), equals(true));
    expect(frustum.containsVector3(_v3(-99.999, -99.999, -99.999)), equals(true));
    expect(frustum.containsVector3(_v3(-100.1, -100.1, -100.1)), equals(false));
    expect(frustum.containsVector3(_v3(99.999, 99.999, -99.999)), equals(true));
    expect(frustum.containsVector3(_v3(100.1, 100.1, -100.1)), equals(false));
    expect(frustum.containsVector3(_v3(0.0, 0.0, -101.0)), equals(false));
  }

  void testFrustumIntersectsWithSphere() {
    final Frustum frustum = new Frustum.matrix(
        makeFrustumMatrix(-1.0, 1.0, -1.0, 1.0, 1.0, 100.0));

    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, 0.0), 0.0)), equals(false));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, 0.0), 0.9)), equals(false));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, 0.0), 1.1)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, -50.0), 0.0)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, -1.001), 0.0)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(-1.0, -1.0, -1.001), 0.0)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(-1.1, -1.1, -1.001), 0.0)), equals(false));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(-1.1, -1.1, -1.001), 0.5)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(1.0, 1.0, -1.001), 0.0)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(1.1, 1.1, -1.001), 0.0)), equals(false));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(1.1, 1.1, -1.001), 0.5)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, -99.999), 0.5)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, -99.999), 0.0)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(-99.999, -99.999, -99.999), 0.0)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(-100.1, -100.1, -100.1), 0.0)), equals(false));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(-100.1, -100.1, -100.1), 0.5)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(99.999, 99.999, -99.999), 0.0)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(100.1, 100.1, -100.1), 0.0)), equals(false));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(100.1, 100.1, -100.1), 0.2)), equals(true));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, -101.0), 0.0)), equals(false));
    expect(frustum.intersectsWithSphere(new Sphere.centerRadius(_v3(0.0, 0.0, -101.0), 1.1)), equals(true));
  }

  void run() {
    test('Frustum ContainsVector3', testFrustumContainsVector3);
    test('Frustum IntersectsWithSphere', testFrustumIntersectsWithSphere);
  }
}
