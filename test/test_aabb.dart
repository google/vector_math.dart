part of vector_math_test;

class AabbTest extends BaseTest {

  void testAabb2Center() {
    final Aabb2 aabb = new Aabb2.minmax(_v(1.0,2.0), _v(8.0,16.0));
    final Vector2 center = aabb.center;

    expect(center.x, equals(4.5));
    expect(center.y, equals(9.0));
  }

  void testAabb2Contains() {
    final Aabb2 parent = new Aabb2.minmax(_v(1.0,1.0), _v(8.0,8.0));
    final Aabb2 child = new Aabb2.minmax(_v(2.0,2.0), _v(7.0,7.0));
    final Aabb2 cutting = new Aabb2.minmax(_v(0.0,0.0), _v(5.0,5.0));
    final Aabb2 outside = new Aabb2.minmax(_v(10.0,10.0), _v(20.0,20.0));
    final Aabb2 grandParent = new Aabb2.minmax(_v(0.0,0.0), _v(10.0,10.0));

    expect(parent.contains(child), isTrue);
    expect(parent.contains(parent), isFalse);
    expect(parent.contains(cutting), isFalse);
    expect(parent.contains(outside), isFalse);
    expect(parent.contains(grandParent), isFalse);
  }

  void testAabb2Intersection() {
    final Aabb2 parent = new Aabb2.minmax(_v(1.0,1.0), _v(8.0,8.0));
    final Aabb2 child = new Aabb2.minmax(_v(2.0,2.0), _v(7.0,7.0));
    final Aabb2 cutting = new Aabb2.minmax(_v(0.0,0.0), _v(5.0,5.0));
    final Aabb2 outside = new Aabb2.minmax(_v(10.0,10.0), _v(20.0,20.0));
    final Aabb2 grandParent = new Aabb2.minmax(_v(0.0,0.0), _v(10.0,10.0));

    final Aabb2 siblingOne = new Aabb2.minmax(_v(0.0,0.0), _v(3.0,3.0));
    final Aabb2 siblingTwo = new Aabb2.minmax(_v(3.0,0.0), _v(6.0,3.0));
    final Aabb2 siblingThree = new Aabb2.minmax(_v(3.0,3.0), _v(6.0,6.0));


    expect(parent.intersectsWith(child), isTrue);
    expect(child.intersectsWith(parent), isTrue);

    expect(parent.intersectsWith(parent), isTrue);

    expect(parent.intersectsWith(cutting), isTrue);
    expect(cutting.intersectsWith(parent), isTrue);

    expect(parent.intersectsWith(outside), isFalse);
    expect(outside.intersectsWith(parent), isFalse);

    expect(parent.intersectsWith(grandParent), isTrue);
    expect(grandParent.intersectsWith(parent), isTrue);

    expect(siblingOne.intersectsWith(siblingTwo), isTrue,
        reason: 'Touching edges are counted as intersection.');
    expect(siblingOne.intersectsWith(siblingThree), isTrue,
        reason: 'Touching corners are counted as intersection.');
  }

  void testAabb2Hull() {
    final Aabb2 a = new Aabb2.minmax(_v(1.0,1.0), _v(3.0,4.0));
    final Aabb2 b = new Aabb2.minmax(_v(3.0,2.0), _v(6.0,2.0));

    a.hull(b);

    expect(a.min.x, equals(1.0));
    expect(a.min.y, equals(1.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));
  }

  void testAabb2HullPoint() {
    final Aabb2 a = new Aabb2.minmax(_v(1.0,1.0), _v(3.0,4.0));
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
    final Aabb2 input = new Aabb2.minmax(_v(1.0,1.0), _v(3.0,3.0));

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
    final Aabb2 input = new Aabb2.minmax(_v(1.0,1.0), _v(3.0,3.0));

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

  void testAabb3Center() {
    final Aabb3 aabb = new Aabb3.minmax(_v3(1.0,2.0, 4.0), _v3(8.0,16.0, 32.0));
    final Vector3 center = aabb.center;

    expect(center.x, equals(4.5));
    expect(center.y, equals(9.0));
    expect(center.z, equals(18.0));
  }

  void testAabb3Contains() {
    final Aabb3 parent = new Aabb3.minmax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Aabb3 child = new Aabb3.minmax(_v3(2.0,2.0,2.0), _v3(7.0,7.0,7.0));
    final Aabb3 cutting = new Aabb3.minmax(_v3(0.0,0.0,0.0), _v3(5.0,5.0,5.0));
    final Aabb3 outside = new Aabb3.minmax(_v3(10.0,10.0,10.0), _v3(20.0,20.0,20.0));
    final Aabb3 grandParent = new Aabb3.minmax(_v3(0.0,0.0,0.0), _v3(10.0,10.0,10.0));

    expect(parent.contains(child), isTrue);
    expect(parent.contains(parent), isFalse);
    expect(parent.contains(cutting), isFalse);
    expect(parent.contains(outside), isFalse);
    expect(parent.contains(grandParent), isFalse);
  }

  void testAabb3Intersection() {
    final Aabb3 parent = new Aabb3.minmax(_v3(1.0,1.0,1.0), _v3(8.0,8.0,8.0));
    final Aabb3 child = new Aabb3.minmax(_v3(2.0,2.0,2.0), _v3(7.0,7.0,7.0));
    final Aabb3 cutting = new Aabb3.minmax(_v3(0.0,0.0,0.0), _v3(5.0,5.0,5.0));
    final Aabb3 outside = new Aabb3.minmax(_v3(10.0,10.0,10.0), _v3(20.0,20.0,10.0));
    final Aabb3 grandParent = new Aabb3.minmax(_v3(0.0,0.0,0.0), _v3(10.0,10.0,10.0));

    final Aabb3 siblingOne = new Aabb3.minmax(_v3(0.0,0.0,0.0), _v3(3.0,3.0,3.0));
    final Aabb3 siblingTwo = new Aabb3.minmax(_v3(3.0,0.0,0.0), _v3(6.0,3.0,3.0));
    final Aabb3 siblingThree = new Aabb3.minmax(_v3(3.0,3.0,3.0), _v3(6.0,6.0,6.0));

    expect(parent.intersectsWith(child), isTrue);
    expect(child.intersectsWith(parent), isTrue);

    expect(parent.intersectsWith(parent), isTrue);

    expect(parent.intersectsWith(cutting), isTrue);
    expect(cutting.intersectsWith(parent), isTrue);

    expect(parent.intersectsWith(outside), isFalse);
    expect(outside.intersectsWith(parent), isFalse);

    expect(parent.intersectsWith(grandParent), isTrue);
    expect(grandParent.intersectsWith(parent), isTrue);

    expect(siblingOne.intersectsWith(siblingTwo), isTrue,
        reason: 'Touching edges are counted as intersection.');
    expect(siblingOne.intersectsWith(siblingThree), isTrue,
        reason: 'Touching corners are counted as intersection.');
  }

  void testAabb3Hull() {
    final Aabb3 a = new Aabb3.minmax(_v3(1.0,1.0,4.0), _v3(3.0,4.0,10.0));
    final Aabb3 b = new Aabb3.minmax(_v3(3.0,2.0,3.0), _v3(6.0,2.0,8.0));

    a.hull(b);

    expect(a.min.x, equals(1.0));
    expect(a.min.y, equals(1.0));
    expect(a.min.z, equals(3.0));
    expect(a.max.x, equals(6.0));
    expect(a.max.y, equals(4.0));
    expect(a.max.z, equals(10.0));
  }

  void testAabb3HullPoint() {
    final Aabb3 a = new Aabb3.minmax(_v3(1.0,1.0,4.0), _v3(3.0,4.0,10.0));
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
    test('AABB2 Contains', testAabb2Contains);
    test('AABB2 Intersection', testAabb2Intersection);
    test('AABB2 Hull', testAabb2Hull);
    test('AABB2 Hull Point', testAabb2HullPoint);
    test('AABB2 Rotate', testAabb2Rotate);
    test('AABB2 Transform', testAabb2Transform);


    test('AABB3 Center', testAabb3Center);
    test('AABB3 Contains', testAabb3Contains);
    test('AABB3 Intersection', testAabb3Intersection);
    test('AABB3 Hull', testAabb3Hull);
    test('AABB3 Hull Point', testAabb3HullPoint);

  }
}
