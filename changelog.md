# Changelog - vector_math

## v 1.4.4 - Septembe 2014

- Updated dependencies.
- Moved benchmark code into `benchmark/`
- Updated `vector_math_64`.

## v 1.4.3 - February 2014

- Add color conversion routines (Contributed by Oliver Sand)
- More collision and geometry routines (Contributed by Oliver Sand)
- More tests (Contributed by Oliver Sand)
- v 1.4.3 pub release

## v 1.4.1 - January 2014

- Better mesh generators (contributed by Brandon Jones)
- Fix bug in ray v. triangle intersection test (contributed by @AMagill)

## v 1.4.0 - November 2013

- Add basic mesh generators (contributed by Brandon Jones)
- Add more collision detection objects (contributed by Oliver Sand)

## v 1.3.5 - July 2013

- Class names now start with upper case, following Dart style guide.
- Performance audit.
- New vector_math_operations library.
- New vector_math_lists library.
- Added Aabb2 and fleshed out Aabb3 (thanks to Laszlo Korte)
- Added Matrix solve methods (thanks to Laszlo Korte)
- Added Methods needed for Three.dart (thanks to Anders Forsell)

## v 1.1.0 - April 2013

- Large refactoring.

## v 0.9.7 - March 2013

- Refactor generated constructor code into small functions.
- Refactor generated operator* code into small functions.
- Fix typo in quaternion code.

## v 0.9.6 - March 2013

- Update to latest String library.
- Fix holding references in matrix constructor.
- Replace double type with num in rotationY, and rotationZ.

## v 0.9.5 - February 2013

- Remove remaining double type tests and replace them with num.
- Don't throw in the default matrix and vector constructors.

## v 0.9.4 - February 2013

- Remove unnecessary dart:scalarlist import.
- Now that dart2js is fixed, rename negate_ back to negate.
- Fix library imports in test suites.
- Flexible constructor fix added to the generator.
- Tested library under dart2js

## v 0.9.3 - February 2013

- Revert to using a single library!
- Public API reverted to taking nums instead of doubles.
- Fixed all warnings/errors introduced by M3.
- drone.io integrated tests.
- Fixed bug in rotation construction.
- Fixed bug in orthographic matrix construction.
- External contribution by fkleon fixing flexible constructors.
- External contribution by donny-dont adding a missing cast .toDouble().

## v 0.9.0 - October 2012

- Pub: Dart Vector Math now fully supports the pub package management system!
- API++: Minor changes to the API everywhere. The changes improve the aesthetics and performance of the library.
- Faster: Lots of performance tweaks resulting in the library getting faster and generating less garbage.
- 2D Cross Product: The Box2D Dart port requires a 2D cross product.
- Library Split: Two libraries, one for browser applications and console applications.

## v 0.8.5 - July 29 2012

- 33% faster matrix matrix multiply
- Fix generated operator[]=
- Fix OpenGL lookat and perspective matrix constructors
- Fix mat4x4 rotation constructors
- Fix mat4x4 multiplied with vector3 not applying translation
- Add utility methods for moving between Dart Vector Math types and Float32Array/Float32List types
- Add mat4x4 translation constructor
- Fixed buildPlaneVectors method
- Fix mat4x4 transformDirect3 not applying translation
- Add a new variant of mix() that takes the parameter t as a num or a vector
- Large code reorganization to make it fit the 'dartblanklib' template

## v 0.8.0 - June 10 2012

- Inverse of 2x2,3x3,4x4 matrices
- Inverse of upper 3x3 of a 4x4 matrix
- Added zero, copy and raw specialized (and branchless) vector constructors
- Added specialized copy matrix constructor
- Added specialized rotation matrix constructors for mat2x2, mat3x3, and mat4x4
- Added setRotation(num radians) to mat2x2
- Added setRotationAround[x,y,z](num radians) to mat3x3 and mat4x4
- Added buildPlaneVectors which constructs the spanning vectors given a plane normal
- Added Adjoint of 2x2,3x3, and 4x4 matrices
- Fixed many bugs in quaternion class
- Fixed adjoint matrix code generation
- Added selfAdd, selfSub, selfScale and selfNegate to matrix classes
- Added serialization support for Float32Array and Vectors/Matrices

## v 0.0.0 - March 20 2012

- Initial release
