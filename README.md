DartVectorMath
==============

## Introduction ##

A Vector Math library for game programming written in Dart.

* DartVectorMath is largely compatible with GLSL.
(Constructor syntax is only incompatibility that wouldn't be classified as a bug.)
* DartVectorMath offers all GLSL classes and utility functions.
* DartVectorMath offers more functionality than GLSL including a quaternion type.
* DartVectorMath is fully documented. See the docs/ directory.
* DartVectorMath GLSL getter and setter syntax (see Example)

## Status: Alpha ##
This code is alpha.

## Getting Started ##
Create a Dart project and add a **pubspec.yaml** file to it

```
dependencies:
  vectormath:
    git: https://github.com/johnmccutchan/DartVectorMath.git
```
and run **pub install** to install **vectormath** (including its dependencies). Now add import for **dart:io** projects

```
#import('package:vectormath/vector_math_console.dart');
```
or for **dart:html** based projects

```
#import('package:vectormath/vector_math_html.dart');
```

## Example ##

Using the GLSL getter and setter syntax.

```
void main() {
	vec3 x = new vec3(); // Zero vector
	vec4 y = new vec4(4.0); // Vector with 4.0 in all lanes
	x.zyx = y.xzz; // Sets z,y,x the values in x,z,z
}
``` 

## Supported data types ##

* vec2
* vec3
* vec4

* mat2x2
* mat2x3
* mat2x4

* mat3x2
* mat3x3
* mat3x4

* mat4x2
* mat4x3
* mat4x4

* quat