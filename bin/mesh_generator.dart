/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/

library vector_math_mesh_generator;

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
  MeshGeometry geometry = generator.createCylinder(topRadius, bottomRadius,
                                                   height);
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
