library test_quad_64;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math_64.dart';
import 'test_helpers.dart';

void testCopyNormalInto() {
  final quad = new Quad.points(new Vector3(1.0, 0.0, 1.0), new Vector3(0.0, 2.0, 1.0), new Vector3(1.0, 0.0, 0.0), new Vector3(0.0, 2.0, 0.0));
  final normal = new Vector3.zero();

  quad.copyNormalInto(normal);

  expect(normal.x, relativeEquals(-0.8944271802902222));
  expect(normal.y, relativeEquals(-0.4472135901451111));
  expect(normal.z, relativeEquals(0.0));
}

void testCopyTriangles() {
  final quad = new Quad.points(new Vector3(1.0, 0.0, 1.0), new Vector3(0.0, 2.0, 1.0), new Vector3(1.0, 0.0, 0.0), new Vector3(0.0, 2.0, 0.0));
  final t1 = new Triangle();
  final t2 = new Triangle();
  final normal = new Vector3.zero();
  final t1Normal = new Vector3.zero();
  final t2Normal = new Vector3.zero();

  quad.copyNormalInto(normal);

  quad.copyTriangles(t1, t2);
  t1.copyNormalInto(t1Normal);
  t2.copyNormalInto(t2Normal);

  expect(t1Normal, relativeEquals(normal));
  expect(t2Normal, relativeEquals(normal));
}

void main() {
  group('Quad', () {
    test('CopyNormalInto', testCopyNormalInto);
    test('CopyTriangles', testCopyTriangles);
  });
}
