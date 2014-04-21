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

    expect(c0.x, relativeEquals(100.0));
    expect(c0.y, relativeEquals(-100.0));
    expect(c0.z, relativeEquals(-100.0));
    expect(c1.x, relativeEquals(100.0));
    expect(c1.y, relativeEquals(100.0));
    expect(c1.z, relativeEquals(-100.0));
    expect(c2.x, relativeEquals(1.0));
    expect(c2.y, relativeEquals(1.0));
    expect(c2.z, relativeEquals(-1.0));
    expect(c3.x, relativeEquals(1.0));
    expect(c3.y, relativeEquals(-1.0));
    expect(c3.z, relativeEquals(-1.0));
    expect(c4.x, relativeEquals(-100.0));
    expect(c4.y, relativeEquals(-100.0));
    expect(c4.z, relativeEquals(-100.0));
    expect(c5.x, relativeEquals(-100.0));
    expect(c5.y, relativeEquals(100.0));
    expect(c5.z, relativeEquals(-100.0));
    expect(c6.x, relativeEquals(-1.0));
    expect(c6.y, relativeEquals(1.0));
    expect(c6.z, relativeEquals(-1.0));
    expect(c7.x, relativeEquals(-1.0));
    expect(c7.y, relativeEquals(-1.0));
    expect(c7.z, relativeEquals(-1.0));
  }

  void run() {
    test('Frustum ContainsVector3', testFrustumContainsVector3);
    test('Frustum IntersectsWithSphere', testFrustumIntersectsWithSphere);
    test('Frustum CalculateCorners', testFrustumCalculateCorners);
  }
}
