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
    expect(parent.contains(parent), isTrue);
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

    expect(a.contains(a), isTrue);
    expect(a.contains(b), isTrue);
  }

  Vector2 _v(double x, double y) {
    return new Vector2(x,y);
  }

  void run() {
    test('AABB2 Center', testAabb2Center);
    test('AABB2 Contains', testAabb2Contains);
    test('AABB2 Intersection', testAabb2Intersection);
    test('AABB2 Hull', testAabb2Hull);
  }
}
