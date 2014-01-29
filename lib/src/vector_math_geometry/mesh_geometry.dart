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

  VertexAttrib(this.name, this.size, this.type) :
    stride = 0,
    offset = 0;

  VertexAttrib.copy(VertexAttrib attrib) :
    name = attrib.name,
    size = attrib.size,
    type = attrib.type,
    stride = attrib.stride,
    offset = attrib.offset;

  VertexAttrib._internal(this.name, this.size, this.type, this.stride, this.offset);

  VertexAttrib._resetStrideOffset(VertexAttrib attrib, this.stride, this.offset) :
    name = attrib.name,
    size = attrib.size,
    type = attrib.type;

  VectorList getView(Float32List buffer) {
    int viewOffset = offset ~/ buffer.elementSizeInBytes;
    int viewStride = stride ~/ buffer.elementSizeInBytes;
    switch (size) {
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

  int get elementSize {
    switch(type) {
      case 'float':
      case 'int':
        return 4;
      case 'short':
        return 2;
      case 'byte':
        return 1;
      default:
        return 0;
    }
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
  final List<VertexAttrib> attribs;
  final int length;
  final int stride;

  factory MeshGeometry(int length, List<VertexAttrib> attributes) {
    int stride = 0;
    for (VertexAttrib a in attributes) {
      stride += a.elementSize * a.size;
    }
    int offset = 0;
    List<VertexAttrib> attribs = new List<VertexAttrib>();
    for (VertexAttrib a in attributes) {
      attribs.add(new VertexAttrib._resetStrideOffset(a, stride, offset));
      offset += a.elementSize * a.size;
    }

    return new MeshGeometry._internal(length, stride, attribs);
  }

  MeshGeometry._internal(int this.length, int this.stride, List<VertexAttrib> this.attribs, [Float32List externBuffer = null]) {
    if (externBuffer == null) {
      buffer = new Float32List((length * stride) ~/ Float32List.BYTES_PER_ELEMENT);
    } else {
      buffer = externBuffer;
    }
  }

  MeshGeometry.copy(MeshGeometry mesh) :
      stride = mesh.stride,
      length = mesh.length,
      attribs = mesh.attribs {
    // Copy the buffer
    buffer = new Float32List(mesh.buffer.length);
    buffer.setAll(0, mesh.buffer);

    // Copy the indices
    if (indices != null) {
      indices = new Uint16List(mesh.indices.length);
      indices.setAll(0, mesh.indices);
    }
  }

  int get triangleVertexCount => indices != null ? indices.length : length;

  factory MeshGeometry.fromJson(Map json) {
    Float32List buffer = new Float32List.fromList(json["buffer"]);

    Map jsonAttribs = json["attribs"];
    List<VertexAttrib> attribs;
    int stride = 0;
    for (String key in jsonAttribs.keys) {
      VertexAttrib attrib = attribFromJson(key, jsonAttribs[key]);
      attribs.add(attrib);
      if (stride == 0) {
        stride = attrib.stride;
      }
    }

    MeshGeometry mesh = new MeshGeometry._internal(buffer.lengthInBytes ~/ stride, stride, attribs, buffer);

    if (json.containsKey("indices")) {
      mesh.indices = new Uint16List.fromList(json["indices"]);
    }

    return mesh;
  }

  factory MeshGeometry.resetAttribs(MeshGeometry inputMesh, List<VertexAttrib> attributes) {
    MeshGeometry mesh = new MeshGeometry(inputMesh.length, attributes);
    mesh.indices = inputMesh.indices;

    // Copy over the attributes that were specified
    for (VertexAttrib attrib in mesh.attribs) {
      VertexAttrib inputAttrib = inputMesh.getAttrib(attrib.name);
      if (inputAttrib != null) {
        if (inputAttrib.size != attrib.size ||
            inputAttrib.type != attrib.type) {
          throw new Exception("Attributes size or type is mismatched: ${attrib.name}");
        }

        var inputView = inputAttrib.getView(inputMesh.buffer);
        var outputView = attrib.getView(mesh.buffer);
        outputView.copy(inputView);
      }
    }

    return mesh;
  }

  factory MeshGeometry.combine(List<MeshGeometry> meshes) {
    if (meshes == null || meshes.length < 2) {
      throw new Exception("Must provide at least two MeshGeometry instances to combine.");
    }

    // When combining meshes they must all have a matching set of VertexAttribs
    MeshGeometry firstMesh = meshes[0];
    int totalVerts = firstMesh.length;
    int totalIndices = firstMesh.indices != null ? firstMesh.indices.length : 0;
    for (int i = 1; i < meshes.length; ++i) {
      MeshGeometry srcMesh = meshes[i];
      if (!firstMesh.attribsAreCompatible(srcMesh)) {
        throw new Exception("All meshes must have identical attributes to combine.");
      }
      totalVerts += srcMesh.length;
      totalIndices += srcMesh.indices != null ? srcMesh.indices.length : 0;
    }

    MeshGeometry mesh = new MeshGeometry._internal(totalVerts, firstMesh.stride, firstMesh.attribs);

    if (totalIndices > 0) {
      mesh.indices = new Uint16List(totalIndices);
    }

    // Copy over the buffer data:
    int bufferOffset = 0;
    int indexOffset = 0;
    for (int i = 0; i < meshes.length; ++i) {
      MeshGeometry srcMesh = meshes[i];
      mesh.buffer.setAll(bufferOffset, srcMesh.buffer);

      if (totalIndices > 0) {
        for (int j = 0; j < srcMesh.indices.length; ++j) {
          mesh.indices[j + indexOffset] = srcMesh.indices[j] + bufferOffset;
        }
        indexOffset += srcMesh.indices.length;
      }

      bufferOffset += srcMesh.buffer.length;
    }


    return mesh;
  }

  Map toJson() {
    Map r = {};
    r['attributes'] = attribs;
    r['indices'] = indices;
    r['vertices'] = buffer;
    return r;
  }

  static VertexAttrib attribFromJson(String name, Map json) {
    return new VertexAttrib._internal(name,
                            json["size"],
                            json["type"],
                            json["stride"],
                            json["offset"]);
  }

  VertexAttrib getAttrib(String name) {
    for (VertexAttrib attrib in attribs) {
      if (attrib.name == name) return attrib;
    }
    return null;
  }

  dynamic getViewForAttrib(String name) {
    for (VertexAttrib attrib in attribs) {
      if (attrib.name == name) return attrib.getView(buffer);
    }
    return null;
  }

  bool attribsAreCompatible(MeshGeometry mesh) {
    if (mesh.attribs.length != attribs.length) {
      return false;
    }

    for (VertexAttrib attrib in attribs) {
      VertexAttrib otherAttrib = mesh.getAttrib(attrib.name);
      if (otherAttrib == null) {
        return false;
      }
      if (attrib.type != otherAttrib.type ||
          attrib.size != otherAttrib.size ||
          attrib.stride != otherAttrib.stride ||
          attrib.offset != otherAttrib.offset) {
        return false;
      }
    }

    if ((indices == null && mesh.indices != null) ||
        (indices != null && mesh.indices == null)) {
      return false;
    }

    return true;
  }
}
