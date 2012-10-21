vector_math
==============

## Introduction ##

A Vector math library for 2D and 3D applications.

## Features ##

* 2D,3D, and 4D vector and matrix types.
* Quaternion type for animating rotations.
* Syntax that is practically identical to GLSL the WebGL shader language.
	* Flexible getters and setters, for example, ```position.xwz = color.grb;```
	* Classes and utility functions to make using it feel more like GLSL
* Fully documented
* Well tested
* Heavily optimized

## Status: Beta ##

## Getting Started ##
Create a new Dart project and add the following to **pubspec.yaml**

```
dependencies:
  vector_math:
    git: https://github.com/johnmccutchan/DartVectorMath.git
```

Add the correct import to your project. 

If your project depends on **dart:io**:

```
#import('package:vector_math/vector_math_console.dart');
```


If your project depends on **dart:html**:

```
#import('package:vector_math/vector_math_browser.dart');
```

## Example ##

1\. Using the GLSL getter and setter syntax.

```
void main() {
	vec3 x = new vec3(); // Zero vector
	vec4 y = new vec4(4.0); // Vector with 4.0 in all lanes
	x.zyx = y.xzz; // Sets z,y,x the values in x,z,z
}
``` 

2\. Transforming a vector.


```
void main() {
	// Rotation of pi/2 degrees around the Y axis followed by a 
	// translation of (5.0, 2.0, 3.0).
	mat4 T = new mat4.rotationY(pi*0.5).translate(5.0, 2.0, 3.0);
	// A point.
	vec3 position = new vec3.raw(1.0, 1.0, 1.0);
	// Transform position by T.
	T.transform3(position);
}
```

3\. Invert a matrix

```
void main() {
	// Rotation of 90 degrees around the Y axis followed by a 
	// translation of (5.0, 2.0, 3.0).
	mat4 T = new mat4.rotationY(pi*0.5).translate(5.0, 2.0, 3.0);
	// Invert T.
	T.invert();
	// Invert just the rotation in T.
	T.invertRotation();
}
```

4\. Rotate a vector using a quaternion

```
void main() {
	// The X axis.
	vec3 axis = new vec3.raw(1.0, 0.0, 0.0);
	// 90 degrees.
	double angle = pi/2.0;
	// Quaternion encoding a 90 degree rotation along the X axis. 
	quat q = new quat.axisAngle(axis, angle);
	// A point.
	vec3 point = new vec3.raw(1.0, 1.0, 1.0);
	// Rotate point by q.
	q.rotate(point);
}
```