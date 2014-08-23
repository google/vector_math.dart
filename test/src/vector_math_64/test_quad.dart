library test_quad_64;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math_64.dart';
import 'test_helpers.dart';

void testCopyNormalInto() {
  final quad = new Quad.points(new Vector3(1.0, 0.0, 1.0), new Vector3(0.0, 2.0, 1.0), new Vector3(1.0, 2.0, 0.0), new Vector3(0.0, 2.0, 0.0));
  final normal = new Vector3.zero();

  quad.copyNormalInto(normal);

  expect(normal.x, relativeEquals(-0.666666666));
  expect(normal.y, relativeEquals(-0.333333333));
  expect(normal.z, relativeEquals(-0.666666666));
}

void main() {
  group('Quad', () {
    test('CopyNormalInto', testCopyNormalInto);
  });
}
