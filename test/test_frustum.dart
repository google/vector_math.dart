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

  void testFrustumCalculateCorners() {
    final Frustum frustum = new Frustum.matrix(
        makeFrustumMatrix(-1.0, 1.0, -1.0, 1.0, 1.0, 100.0));

    final c0 = new Vector3.zero();
    final c1 = new Vector3.zero();
    final c2 = new Vector3.zero();
    final c3 = new Vector3.zero();
    final c4 = new Vector3.zero();
    final c5 = new Vector3.zero();
    final c6 = new Vector3.zero();
    final c7 = new Vector3.zero();

    frustum.calculateCorners(c0, c1, c2, c3, c4, c5, c6, c7);

    relativeTest(c0.x, 100.0);
    relativeTest(c0.y, -100.0);
    relativeTest(c0.z, -100.0);
    relativeTest(c1.x, 100.0);
    relativeTest(c1.y, 100.0);
    relativeTest(c1.z, -100.0);
    relativeTest(c2.x, 1.0);
    relativeTest(c2.y, 1.0);
    relativeTest(c2.z, -1.0);
    relativeTest(c3.x, 1.0);
    relativeTest(c3.y, -1.0);
    relativeTest(c3.z, -1.0);
    relativeTest(c4.x, -100.0);
    relativeTest(c4.y, -100.0);
    relativeTest(c4.z, -100.0);
    relativeTest(c5.x, -100.0);
    relativeTest(c5.y, 100.0);
    relativeTest(c5.z, -100.0);
    relativeTest(c6.x, -1.0);
    relativeTest(c6.y, 1.0);
    relativeTest(c6.z, -1.0);
    relativeTest(c7.x, -1.0);
    relativeTest(c7.y, -1.0);
    relativeTest(c7.z, -1.0);
  }

  void run() {
    test('Frustum ContainsVector3', testFrustumContainsVector3);
    test('Frustum IntersectsWithSphere', testFrustumIntersectsWithSphere);
    test('Frustum CalculateCorners', testFrustumCalculateCorners);
  }
}
