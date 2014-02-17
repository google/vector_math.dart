part of vector_math_test;

class AabbTest extends BaseTest {

  void testAabb2Center() {
    final Aabb2 aabb = new Aabb2.minMax(_v(1.0, 2.0), _v(8.0, 16.0));
    final Vector2 center = aabb.center;

    expect(center.x, equals(4.5));
    expect(center.y, equals(9.0));
  }

  void testAabb2ContainsAabb2() {
    final Aabb2 parent = new Aabb2.minMax(_v(1.0, 1.0), _v(8.0, 8.0));
    final Aabb2 child = new Aabb2.minMax(_v(2.0, 2.0), _v(7.0, 7.0));
    final Aabb2 cutting = new Aabb2.minMax(_v(0.0, 0.0), _v(5.0, 5.0));
    final Aabb2 outside = new Aabb2.minMax(_v(10.0, 10.0), _v(20.0, 20.0));
    final Aabb2 grandParent = new Aabb2.minMax(_v(0.0, 0.0), _v(10.0, 10.0));

    expect(parent.containsAabb2(child), isTrue);
    expect(parent.containsAabb2(parent), isFalse);
    expect(parent.containsAabb2(cutting), isFalse);
    expect(parent.containsAabb2(outside), isFalse);
    expect(parent.containsAabb2(grandParent), isFalse);
  }

  void testAabb2ContainsVector2() {
    final Aabb2 parent = new Aabb2.minMax(_v(1.0,1.0), _v(8.0,8.0));
    final Vector2 child = _v(2.0,2.0);
    final Vector2 cutting = _v(1.0,8.0);
    final Vector2 outside = _v(-1.0,0.0);

    expect(parent.containsVector2(child), isTrue);
    expect(parent.containsVector2(cutting), isFalse);
    expect(parent.containsVector2(outside), isFalse);
  }

  void testAabb2IntersectionAabb2() {
    final Aabb2 parent = new Aabb2.minMax(_v(1.0,1.0), _v(8.0,8.0));
    final Aabb2 child = new Aabb2.minMax(_v(2.0,2.0), _v(7.0,7.0));
    final Aabb2 cutting = new Aabb2.minMax(_v(0.0,0.0), _v(5.0,5.0));
    final Aabb2 outside = new Aabb2.minMax(_v(10.0,10.0), _v(20.0,20.0));
    final Aabb2 grandParent = new Aabb2.minMax(_v(0.0,0.0), _v(10.0,10.0));

    final Aabb2 siblingOne = new Aabb2.minMax(_v(0.0,0.0), _v(3.0,3.0));
    final Aabb2 siblingTwo = new Aabb2.minMax(_v(3.0,0.0), _v(6.0,3.0));
    final Aabb2 siblingThree = new Aabb2.minMax(_v(3.0,3.0), _v(6.0,6.0));


    expect(parent.intersectsWithAabb2(child), isTrue);
    expect(child.intersectsWithAabb2(parent), isTrue);

    expect(parent.intersectsWithAabb2(parent), isTrue);

    expect(parent.intersectsWithAabb2(cutting), isTrue);
    expect(cutting.intersectsWithAabb2(parent), isTrue);

    expect(parent.intersectsWithAabb2(outside), isFalse);
    expect(outside.intersectsWithAabb2(parent), isFalse);

    expect(parent.intersectsWithAabb2(grandParent), isTrue);
    expect(grandParent.intersectsWithAabb2(parent), isTrue);

    expect(siblingOne.intersectsWithAabb2(siblingTwo), isTrue,
        reason: 'Touching edges are counted as intersection.');
    expect(siblingOne.intersectsWithAabb2(siblingThree), isTrue,
        reason: 'Touching corners are counted as intersection.');
  }

  void testAabb2IntersectionVector2() {
    final Aabb2 parent = new Aabb2.minMax(_v(1.0,1.0), _v(8.0,8.0));
    final Vector2 child = _v(2.0,2.0);
    final Vector2 cutting = _v(1.0,8.0);
    final Vector2 outside = _v(-1.0,0.0);

    expect(parent.intersectsWithVector2(child), isTrue);
    expect(parent.intersectsWithVector2(cutting), isTrue);
    expect(parent.intersectsWithVector2(outside), isFalse);
  }

  void testAabb2Hull() {
    final Aabb2 a = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,4.0));
    final Aabb2 b = new Aabb2.minMax(_v(3.0,2.0), _v(6.0,2.0));

    a.hull(b);

    expect(a.min.x, equals(1.0));
    expect(a.min.y, equals(1.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));
  }

  void testAabb2HullPoint() {
    final Aabb2 a = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,4.0));
    final Vector2 b = _v(6.0,2.0);

    a.hullPoint(b);

    expect(a.min.x, equals(1.0));
    expect(a.min.y, equals(1.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));

    final Vector2 c = _v(0.0,1.0);

    a.hullPoint(c);

    expect(a.min.x, equals(0.0));
    expect(a.min.y, equals(1.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));
  }

  void testAabb2Rotate() {
    final Matrix3 rotation = new Matrix3.rotationZ(Math.PI/4);
    final Aabb2 input = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,3.0));

    final Aabb2 result = input.rotate(rotation);

    relativeTest(result.min.x, 2-Math.sqrt(2));
    relativeTest(result.min.y, 2-Math.sqrt(2));
    relativeTest(result.max.x, 2+Math.sqrt(2));
    relativeTest(result.max.y, 2+Math.sqrt(2));
    relativeTest(result.center.x, 2.0);
    relativeTest(result.center.y, 2.0);
  }

  void testAabb2Transform() {
    final Matrix3 rotation = new Matrix3.rotationZ(Math.PI/4);
    final Aabb2 input = new Aabb2.minMax(_v(1.0,1.0), _v(3.0,3.0));

    final Aabb2 result = input.transform(rotation);
    final double newCenterY = Math.sqrt(8);

    relativeTest(result.min.x, -Math.sqrt(2));
    relativeTest(result.min.y, newCenterY-Math.sqrt(2));
    relativeTest(result.max.x, Math.sqrt(2));
    relativeTest(result.max.y, newCenterY+Math.sqrt(2));
    relativeTest(result.center.x, 0.0);
    relativeTest(result.center.y, newCenterY);
  }

  Vector2 _v(double x, double y) {
    return new Vector2(x,y);
  }

  Vector3 _v3(double x, double y, double z) {
    return new Vector3(x,y,z);
  }

  void testAabb3ByteBufferInstanciation() {
    final ByteBuffer buffer = new Float32List.fromList([1.0,2.0,3.0,4.0,5.0,6.0,7.0]).buffer;
    final Aabb3 aabb = new Aabb3.fromBuffer( buffer, 0);
    final Aabb3 aabbOffest = new Aabb3.fromBuffer( buffer, Float32List.BYTES_PER_ELEMENT);
    final Vector3 center = aabb.center;

    expect(aabb.min.x, equals(1.0));
    expect(aabb.min.y, equals(2.0));
    expect(aabb.min.z, equals(3.0));
    expect(aabb.max.x, equals(4.0));
    expect(aabb.max.y, equals(5.0));
    expect(aabb.max.z, equals(6.0));

    expect(aabbOffest.min.x, equals(2.0));
    expect(aabbOffest.min.y, equals(3.0));
    expect(aabbOffest.min.z, equals(4.0));
    expect(aabbOffest.max.x, equals(5.0));
    expect(aabbOffest.max.y, equals(6.0));
    expect(aabbOffest.max.z, equals(7.0));
  }

  void testAabb3Center() {
    final Aabb3 aabb = new Aabb3.minMax(_v3(1.0,2.0, 4.0), _v3(8.0,16.0, 32.0));
    final Vector3 center = aabb.center;

    expect(center.x, equals(4.5));
    expect(center.y, equals(9.0));
    expect(center.z, equals(18.0));
  }

  void testAabb3ContainsAabb3() {
    final Aabb3 parent = new Aabb3.minMax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Aabb3 child = new Aabb3.minMax(_v3(2.0,2.0,2.0), _v3(7.0,7.0,7.0));
    final Aabb3 cutting = new Aabb3.minMax(_v3(0.0,0.0,0.0), _v3(5.0,5.0,5.0));
    final Aabb3 outside = new Aabb3.minMax(_v3(10.0,10.0,10.0), _v3(20.0,20.0,20.0));
    final Aabb3 grandParent = new Aabb3.minMax(_v3(0.0,0.0,0.0), _v3(10.0,10.0,10.0));

    expect(parent.containsAabb3(child), isTrue);
    expect(parent.containsAabb3(parent), isFalse);
    expect(parent.containsAabb3(cutting), isFalse);
    expect(parent.containsAabb3(outside), isFalse);
    expect(parent.containsAabb3(grandParent), isFalse);
  }

  void testAabb3ContainsSphere() {
    final Aabb3 parent = new Aabb3.minMax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Sphere child = new Sphere.centerRadius(_v3(3.0, 3.0, 3.0), 1.5);
    final Sphere cutting = new Sphere.centerRadius(_v3(0.0,0.0,0.0), 6.0);
    final Sphere outside = new Sphere.centerRadius(_v3(-10.0,-10.0,-10.0), 5.0);

    expect(parent.containsSphere(child), isTrue);
    expect(parent.containsSphere(cutting), isFalse);
    expect(parent.containsSphere(outside), isFalse);
  }

  void testAabb3ContainsVector3() {
    final Aabb3 parent = new Aabb3.minMax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Vector3 child = _v3(7.0,7.0,7.0);
    final Vector3 cutting = _v3(1.0,2.0,1.0);
    final Vector3 outside = _v3(-10.0,10.0,10.0);

    expect(parent.containsVector3(child), isTrue);
    expect(parent.containsVector3(cutting), isFalse);
    expect(parent.containsVector3(outside), isFalse);
  }

  void testAabb3ContainsTriangle() {
    final Aabb3 parent = new Aabb3.minMax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Triangle child = new Triangle.points(_v3(2.0,2.0,2.0), _v3(3.0,3.0,3.0), _v3(4.0,4.0,4.0));
    final Triangle edge = new Triangle.points(_v3(1.0,1.0,1.0), _v3(3.0,3.0,3.0), _v3(4.0,4.0,4.0));
    final Triangle cutting = new Triangle.points(_v3(2.0,2.0,2.0), _v3(3.0,3.0,3.0), _v3(14.0,14.0,14.0));
    final Triangle outside = new Triangle.points(_v3(0.0,0.0,0.0), _v3(-3.0,-3.0,-3.0), _v3(-4.0,-4.0,-4.0));

    expect(parent.containsTriangle(child), isTrue);
    expect(parent.containsTriangle(edge), isFalse);
    expect(parent.containsTriangle(cutting), isFalse);
    expect(parent.containsTriangle(outside), isFalse);
  }

  void testAabb3IntersectionAabb3() {
    final Aabb3 parent = new Aabb3.minMax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Aabb3 child = new Aabb3.minMax(_v3(2.0,2.0,2.0), _v3(7.0,7.0,7.0));
    final Aabb3 cutting = new Aabb3.minMax(_v3(0.0,0.0,0.0), _v3(5.0,5.0,5.0));
    final Aabb3 outside = new Aabb3.minMax(_v3(10.0,10.0,10.0), _v3(20.0,20.0,10.0));
    final Aabb3 grandParent = new Aabb3.minMax(_v3(0.0,0.0,0.0), _v3(10.0,10.0,10.0));

    final Aabb3 siblingOne = new Aabb3.minMax(_v3(0.0,0.0,0.0), _v3(3.0,3.0,3.0));
    final Aabb3 siblingTwo = new Aabb3.minMax(_v3(3.0,0.0,0.0), _v3(6.0,3.0,3.0));
    final Aabb3 siblingThree = new Aabb3.minMax(_v3(3.0,3.0,3.0), _v3(6.0,6.0,6.0));

    expect(parent.intersectsWithAabb3(child), isTrue);
    expect(child.intersectsWithAabb3(parent), isTrue);

    expect(parent.intersectsWithAabb3(parent), isTrue);

    expect(parent.intersectsWithAabb3(cutting), isTrue);
    expect(cutting.intersectsWithAabb3(parent), isTrue);

    expect(parent.intersectsWithAabb3(outside), isFalse);
    expect(outside.intersectsWithAabb3(parent), isFalse);

    expect(parent.intersectsWithAabb3(grandParent), isTrue);
    expect(grandParent.intersectsWithAabb3(parent), isTrue);

    expect(siblingOne.intersectsWithAabb3(siblingTwo), isTrue,
        reason: 'Touching edges are counted as intersection.');
    expect(siblingOne.intersectsWithAabb3(siblingThree), isTrue,
        reason: 'Touching corners are counted as intersection.');
  }

  void testAabb3IntersectionSphere() {
    final Aabb3 parent = new Aabb3.minMax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Sphere child = new Sphere.centerRadius(_v3(3.0, 3.0, 3.0), 1.5);
    final Sphere cutting = new Sphere.centerRadius(_v3(0.0,0.0,0.0), 6.0);
    final Sphere outside = new Sphere.centerRadius(_v3(-10.0,-10.0,-10.0), 5.0);

    expect(parent.intersectsWithSphere(child), isTrue);
    expect(parent.intersectsWithSphere(cutting), isTrue);
    expect(parent.intersectsWithSphere(outside), isFalse);
  }

  void testAabb3IntersectionVector3() {
    final Aabb3 parent = new Aabb3.minMax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Vector3 child = _v3(7.0,7.0,7.0);
    final Vector3 cutting = _v3(1.0,2.0,1.0);
    final Vector3 outside = _v3(-10.0,10.0,10.0);

    expect(parent.intersectsWithVector3(child), isTrue);
    expect(parent.intersectsWithVector3(cutting), isTrue);
    expect(parent.intersectsWithVector3(outside), isFalse);
  }

  void testAabb3Hull() {
    final Aabb3 a = new Aabb3.minMax(_v3(1.0,1.0,4.0), _v3(3.0,4.0,10.0));
    final Aabb3 b = new Aabb3.minMax(_v3(3.0,2.0,3.0), _v3(6.0,2.0,8.0));

    a.hull(b);

    expect(a.min.x, equals(1.0));
    expect(a.min.y, equals(1.0));
    expect(a.min.z, equals(3.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));
    expect(a.max.z, equals(10.0));
  }

  void testAabb3HullPoint() {
    final Aabb3 a = new Aabb3.minMax(_v3(1.0,1.0,4.0), _v3(3.0,4.0,10.0));
    final Vector3 b = _v3(6.0,2.0,8.0);

    a.hullPoint(b);

    expect(a.min.x, equals(1.0));
    expect(a.min.y, equals(1.0));
    expect(a.min.z, equals(4.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));
    expect(a.max.z, equals(10.0));

    final Vector3 c = _v3(6.0,0.0,2.0);

    a.hullPoint(c);

    expect(a.min.x, equals(1.0));
    expect(a.min.y, equals(0.0));
    expect(a.min.z, equals(2.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));
    expect(a.max.z, equals(10.0));
  }

  void run() {
    test('AABB2 Center', testAabb2Center);
    test('AABB2 Contains Aabb2', testAabb2ContainsAabb2);
    test('AABB2 Contains Vector2', testAabb2ContainsVector2);
    test('AABB2 Intersection Aabb2', testAabb2IntersectionAabb2);
    test('AABB2 Intersection Vector2', testAabb2IntersectionVector2);
    test('AABB2 Hull', testAabb2Hull);
    test('AABB2 Hull Point', testAabb2HullPoint);
    test('AABB2 Rotate', testAabb2Rotate);
    test('AABB2 Transform', testAabb2Transform);

    test('AABB3 ByteBuffer instanciation', testAabb3ByteBufferInstanciation);
    test('AABB3 Center', testAabb3Center);
    test('AABB3 Contains Aabb3', testAabb3ContainsAabb3);
    test('AABB3 Contains Vector3', testAabb3ContainsVector3);
    test('AABB3 Contains Triangle', testAabb3ContainsTriangle);
    test('AABB3 Contains Sphere', testAabb3ContainsSphere);
    test('AABB3 Intersection Aabb3', testAabb3IntersectionAabb3);
    test('AABB3 Intersection Vector3', testAabb3IntersectionVector3);
    test('AABB3 Intersection Sphere', testAabb3IntersectionSphere);
    test('AABB3 Hull', testAabb3Hull);
    test('AABB3 Hull Point', testAabb3HullPoint);
  }
}
