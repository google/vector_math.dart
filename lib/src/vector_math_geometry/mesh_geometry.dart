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

part of vector_math_geometry;

class VertexAttrib {
  final String name;
  final String type;
  final int size;
  final int stride;
  final int offset;

  VertexAttrib(this.name, this.size, this.type, this.stride, this.offset);

  VectorList getView(Float32List buffer) {
    int viewOffset = offset ~/ buffer.elementSizeInBytes;
    int viewStride = stride ~/ buffer.elementSizeInBytes;
    switch(size) {
      case 2:
        return new Vector2List.view(buffer, viewOffset, viewStride);
      case 3:
        return new Vector3List.view(buffer, viewOffset, viewStride);
      case 4:
        return new Vector4List.view(buffer, viewOffset, viewStride);
    }
  }

  String get format {
    return '$type$size';
  }

  Map toJson() {
    return {
      'format': format,
      'name': name,
      'offset': offset,
      'stride': stride,
      'size': size,
      'type': type
    };
  }
}

class MeshGeometry {
  Float32List buffer;
  Uint16List indices;
  List<VertexAttrib> attribs = new List<VertexAttrib>();

  MeshGeometry() {}

  MeshGeometry.fromJson(Map json) {
    buffer = new Float32List.fromList(json["buffer"]);

    if (json.containsKey("indices")) {
      indices = new Uint16List.fromList(json["indices"]);
    }

    Map jsonAttribs = json["attribs"];
    for (String key in jsonAttribs.keys) {
      addAttrib(attribFromJson(key, jsonAttribs[key]));
    }
  }

  Map toJson() {
    Map r = {};
    r['attributes'] = attribs;
    r['indices'] = indices;
    r['vertices'] = buffer;
    return r;
  }

  static VertexAttrib attribFromJson(String name, Map json) {
    return new VertexAttrib(name,
                            json["size"],
                            json["format"],
                            json["stride"],
                            json["offset"]);
  }

  // Estimates the number of vertices contained in this mesh
  int get length {
    if (attribs == null || attribs.length == 0)
      return 0;
    VertexAttrib a = attribs[0];
    return buffer.lengthInBytes ~/ a.stride;
  }

  void addAttrib(VertexAttrib attrib) {
    attribs.add(attrib);
  }

  dynamic getViewForAttrib(String name) {
    for (VertexAttrib attrib in attribs) {
      if (attrib.name == name)
        return attrib.getView(buffer);
    }
    return null;
  }
}
