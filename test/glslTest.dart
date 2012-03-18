#import('dart:builtin');
#import('../lib/VectorMath/VectorMath.dart');

class glslTest {
  void test1() {
    mat4x4 projModelViewMatrix = new mat4x4();
    mat3x3 normalMatrix = new mat3x3(8.0);
    vec2 texCoord = new vec2();
    vec3 normal = new vec3(2.0);
    vec3 position = new vec3();
    vec3 temp = normalMatrix * normal;
    vec3 outnormal = normalMatrix * normal;
    print('$outnormal');
    vec4 glPosition = projModelViewMatrix * new vec4(position, 3.0);
    print('${glPosition.zzww}');
  }
}

void main() {
  glslTest test = new glslTest();
  test.test1();
}