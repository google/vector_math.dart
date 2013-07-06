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

  void testAabb2Overlaps() {
    final Aabb2 parent = new Aabb2.minmax(_v(1.0,1.0), _v(8.0,8.0));
    final Aabb2 child = new Aabb2.minmax(_v(2.0,2.0), _v(7.0,7.0));
    final Aabb2 cutting = new Aabb2.minmax(_v(0.0,0.0), _v(5.0,5.0));
    final Aabb2 outside = new Aabb2.minmax(_v(10.0,10.0), _v(20.0,20.0));
    final Aabb2 grandParent = new Aabb2.minmax(_v(0.0,0.0), _v(10.0,10.0));

    final Aabb2 siblingOne = new Aabb2.minmax(_v(0.0,0.0), _v(3.0,3.0));
    final Aabb2 siblingTwo = new Aabb2.minmax(_v(3.0,0.0), _v(6.0,3.0));
    final Aabb2 siblingThree = new Aabb2.minmax(_v(3.0,3.0), _v(6.0,6.0));


    expect(parent.overlaps(child), isTrue);
    expect(child.overlaps(parent), isTrue);

    expect(parent.overlaps(parent), isTrue);

    expect(parent.overlaps(cutting), isTrue);
    expect(cutting.overlaps(parent), isTrue);

    expect(parent.overlaps(outside), isFalse);
    expect(outside.overlaps(parent), isFalse);

    expect(parent.overlaps(grandParent), isTrue);
    expect(grandParent.overlaps(parent), isTrue);

    expect(siblingOne.overlaps(siblingTwo), isTrue,
        reason: 'Touching edges are counted as overlap.');
    expect(siblingOne.overlaps(siblingThree), isTrue,
        reason: 'Touching corners are counted as overlap.');
  }

  void testAabb2Combination() {
    final Aabb2 a = new Aabb2.minmax(_v(1.0,1.0), _v(3.0,4.0));
    final Aabb2 b = new Aabb2.minmax(_v(3.0,2.0), _v(6.0,2.0));

    final Aabb2 result = new Aabb2();
    result.setFromCombination(a, b);

    expect(result.min.x, equals(1.0));
    expect(result.min.y, equals(1.0));
    expect(result.max.x, equals(6.0));
    expect(result.max.y, equals(4.0));

    expect(result.contains(a), isTrue);
    expect(result.contains(b), isTrue);
  }

  Vector2 _v(double x, double y) {
    return new Vector2(x,y);
  }

  void run() {
    test('AABB2 Center', testAabb2Center);
    test('AABB2 Contains', testAabb2Contains);
    test('AABB2 Overlaps', testAabb2Overlaps);
    test('AABB2 Combination', testAabb2Combination);
  }
}
