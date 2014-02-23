# vector_math

[![Build Status](https://drone.io/johnmccutchan/vector_math/status.png)](https://drone.io/johnmccutchan/vector_math/latest)

## Introduction

A Vector math library for 2D and 3D applications.

## Features

* 2D,3D, and 4D vector and matrix types.
* Quaternion type for animating rotations.
* Collision detection: AABB, rays, spheres, ...
* Flexible getters and setters, for example, ```position.xwz = color.grb;```.
* Fully documented.
* Well tested.
* Heavily optimized.


## Libraries using vector_math

* [Spectre](http://github.com/johnmccutchan/spectre)
* [Three.dart](https://github.com/threeDart/)
* [Box2D](https://github.com/dart-lang/dart-box2d)

## Getting Started

1\. Add the following to your project's **pubspec.yaml** and run ```pub get```.

```
dependencies:
  vector_math: any
```

If you want to stay on the latest developent version, add a dependency to the 
Git repository. You may also need to use it if another library uses the Git 
dependency.

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
import 'package:vector_math/vector_math.dart';

void main() {
	Vector3 x = new Vector3.zero(); // Zero vector
	Vector4 y = new Vector4.all(4.0); // Vector with 4.0 in all lanes
	x.zyx = y.xzz; // Sets z,y,x the values in x,z,z
}
``` 

2\. Transforming a vector.


```
import 'dart:math';
import 'package:vector_math/vector_math.dart';

void main() {
	// Rotation of PI/2 degrees around the Y axis followed by a 
	// translation of (5.0, 2.0, 3.0).
	Matrix4 T = new Matrix4.rotationY(PI*0.5).translate(5.0, 2.0, 3.0);
	// A point.
	Vector3 position = new Vector3(1.0, 1.0, 1.0);
	// Transform position by T.
	T.transform3(position);
}
```

3\. Invert a matrix

```
import 'dart:math';
import 'package:vector_math/vector_math.dart';

void main() {
	// Rotation of 90 degrees around the Y axis followed by a 
	// translation of (5.0, 2.0, 3.0).
	Matrix4 T = new Matrix4.rotationY(PI*0.5).translate(5.0, 2.0, 3.0);
	// Invert T.
	T.invert();
	// Invert just the rotation in T.
	T.invertRotation();
}
```

4\. Rotate a vector using a quaternion

```
import 'dart:math';
import 'package:vector_math/vector_math.dart';

void main() {
	// The X axis.
	Vector3 axis = new Vector3(1.0, 0.0, 0.0);
	// 90 degrees.
	double angle = PI/2.0;
	// Quaternion encoding a 90 degree rotation along the X axis. 
	Quaternion q = new Quaternion.axisAngle(axis, angle);
	// A point.
	Vector3 point = new Vector3(1.0, 1.0, 1.0);
	// Rotate point by q.
	q.rotate(point);
}
```

5\. Check if two axis aligned bounding boxes intersect

```
import 'package:vector_math/vector_math.dart';

void main() {
	// Define the first box with a minimum and a maximum.
	Aabb2 aabbOne = new Aabb2.minMax(new Vector2.zero(), new Vector2(4.0, 4.0));
	// Define the second box
	Aabb2 aabbTwo = new Aabb2.minMax(new Vector2(5.0, 5.0), new Vector2(6.0, 6.0));
	// Extend the second box to contain a point
	aabbTwo.hullPoint(new Vector2(3.0, 3.0));
	// Check if the two boxes intersect, returns true in this case.
	bool intersect = aabbOne.intersectsWithAabb2(aabbTwo);
}
```

6\. Check where a ray and a sphere intersect

```
import 'package:vector_math/vector_math.dart';

void main() {
	// Define a ray starting at the origin and going into positive x-direction.
	Ray ray = new Ray.originDirection(new Vector3.zero(), new Vector3(1.0, 0.0, 0.0));
	// Defines a sphere with the center (5.0 0.0 0.0) and a radius of 2.
	Sphere sphere = new Sphere.centerRadius(new Vector3(5.0, 0.0, 0.0), 2);
	// Checks if the ray intersect with the sphere and returns the distance of the 
	// intersection from the origin of the ray. Would return null if no intersection
	// is found.
	double distancFromOrigin = ray.intersectsWithSphere(sphere);
	// Evaluate the position of the intersection, in this case (3.0 0.0 0.0).
	Vector3 position = ray.at(distancFromOrigin);
}
```

7\. Work with colors

```
import 'package:vector_math/vector_math.dart';

void main() {
	// Access a build-in color, colors are stored in 4-dimensional vectors.
	Vector4 red = Colors.red;
	Vector4 gray = new Vector4.zero();
	// Convert the red color to a grayscaled color.
	Colors.toGrayscale(red, gray);
	// Parse a blue color from a hex string.
	Vector4 blue = new Vector4.zero();
	Colors.fromHexString('#0000FF', blue);
	// Convert the blue color from RGB to HSL.
	Colors.rgbToHsl(blue, blue);
	// Reduce the lightness of the color by 50%.
	blue.z *= 0.5;
	// Convert the HSL color back to RGB.
	Colors.hslToRgb(blue, blue);
}
```
