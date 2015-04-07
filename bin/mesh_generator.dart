// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.mesh_generator;

import 'dart:convert';
import 'package:vector_math/vector_math_geometry.dart';

MeshGeometry generateCube(List<String> args) {
  if (args.length != 3) {
    return null;
  }
  num width = double.parse(args[0]);
  num height = double.parse(args[1]);
  num depth = double.parse(args[2]);
  var generator = new CubeGenerator();
  MeshGeometry geometry = generator.createCube(width, height, depth);
  return geometry;
}

MeshGeometry generateSphere(List<String> args) {
  if (args.length != 1) {
    return null;
  }
  num radius = double.parse(args[0]);
  var generator = new SphereGenerator();
  MeshGeometry geometry = generator.createSphere(radius);
  return geometry;
}

MeshGeometry generateCircle(List<String> args) {
  if (args.length != 1) {
    return null;
  }
  num radius = double.parse(args[0]);
  var generator = new CircleGenerator();
  MeshGeometry geometry = generator.createCircle(radius);
  return geometry;
}

MeshGeometry generateCylinder(List<String> args) {
  if (args.length != 3) {
    return null;
  }
  num topRadius = double.parse(args[0]);
  num bottomRadius = double.parse(args[1]);
  num height = double.parse(args[2]);
  var generator = new CylinderGenerator();
  MeshGeometry geometry =
      generator.createCylinder(topRadius, bottomRadius, height);
  return geometry;
}

MeshGeometry generateRing(List<String> args) {
  if (args.length != 2) {
    return null;
  }
  num innerRadius = double.parse(args[0]);
  num outerRadius = double.parse(args[1]);
  var generator = new RingGenerator();
  MeshGeometry geometry = generator.createRing(innerRadius, outerRadius);
  return geometry;
}

Map<String, Function> generators = {
  'cube': generateCube,
  'sphere': generateSphere,
  'circle': generateCircle,
  'cylinder': generateCylinder,
  'ring': generateRing
};

main(List<String> args_) {
  List<String> args = new List.from(args_, growable: true);

  if (args.length == 0) {
    print('mesh_generator.dart <type> [<arg0> ... <argN>]');
    print('');
    print('<type> = cube, sphere, cylinder');
    print('mesh_generator.dart cube width height depth');
    print('mesh_generator.dart sphere radius');
    print('mesh_generator.dart circle radius');
    print('mesh_generator.dart cylinder topRadius bottomRadius height');
    print('mesh_generator.dart ring innerRadius outerRadius');
    print('');
    return;
  }
  var type = args.removeAt(0);
  var generator = generators[type];
  if (generator == null) {
    print('Could not find generator for $type');
    return;
  }
  MeshGeometry geometry = generator(args);
  if (geometry == null) {
    print('Error generating geometry for $type');
    return;
  }
  print(JSON.encode(geometry));
}
