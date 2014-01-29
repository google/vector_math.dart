# vector_math

[![Build Status](https://drone.io/johnmccutchan/vector_math/status.png)](https://drone.io/johnmccutchan/vector_math/latest)

## Introduction

A Vector math library for 2D and 3D applications.

## Features

* 2D,3D, and 4D vector and matrix types.
* Quaternion type for animating rotations.
* Flexible getters and setters, for example, ```position.xwz = color.grb;```.
* Fully documented.
* Well tested.
* Heavily optimized.


## Libraries using vector_math

* [Spectre](http://github.com/johnmccutchan/spectre)
* [Three.dart](https://github.com/threeDart/)
* [Box2D](https://github.com/dart-lang/dart-box2d)

## Getting Started

1\. Add the following to your project's **pubspec.yaml** and run ```pub install```.

```
dependencies:
  vector_math:
    git: https://github.com/johnmccutchan/vector_math.git
```

2\. Add the correct import for your project. 

```
import 'package:vector_math/vector_math.dart';
```


## Documentation

Read the [docs](http://johnmccutchan.github.io/vector_math.html)

## Examples

1\. Using the GLSL getter and setter syntax.

```
void main() {
	Vector3 x = new Vector3.zero(); // Zero vector
	Vector4 y = new Vector4.splat(4.0); // Vector with 4.0 in all lanes
	x.zyx = y.xzz; // Sets z,y,x the values in x,z,z
}
``` 

2\. Transforming a vector.


```
void main() {
	// Rotation of pi/2 degrees around the Y axis followed by a 
	// translation of (5.0, 2.0, 3.0).
	Matrix4 T = new Matrix4.rotationY(pi*0.5).translate(5.0, 2.0, 3.0);
	// A point.
	Vector3 position = new Vector3(1.0, 1.0, 1.0);
	// Transform position by T.
	T.transform3(position);
}
```

3\. Invert a matrix

```
void main() {
	// Rotation of 90 degrees around the Y axis followed by a 
	// translation of (5.0, 2.0, 3.0).
	Matrix4 T = new Matrix4.rotationY(pi*0.5).translate(5.0, 2.0, 3.0);
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
	Vector3 axis = new Vector3(1.0, 0.0, 0.0);
	// 90 degrees.
	double angle = pi/2.0;
	// Quaternion encoding a 90 degree rotation along the X axis. 
	Quaternion q = new Quaternion.axisAngle(axis, angle);
	// A point.
	Vector3 point = new Vector3(1.0, 1.0, 1.0);
	// Rotate point by q.
	q.rotate(point);
}
```
