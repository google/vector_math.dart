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

part of vector_math_lists;

abstract class VectorList {
  final int _vectorLength;
  final int _offset;
  final int _stride;
  final int _length;
  final Float32List _buffer;

  int get length => _length;
  Float32List get buffer => _buffer;

  static int _listLength(int offset, int stride, int vectorLength, int length) {
    int width = stride == 0 ? vectorLength : stride;
    return offset + width * length;
  }

  VectorList(int length, int vectorLength, [int offset = 0, int stride = 0])
      : _vectorLength = vectorLength,
        _offset = offset,
        _stride = stride == 0 ? vectorLength : stride,
        _length = length,
        _buffer = new Float32List(
            VectorList._listLength(offset, stride, vectorLength, length)) {
    if (_stride < _vectorLength) {
      throw new ArgumentError('Stride cannot be smaller than the vector size.');
    }
  }

  VectorList.fromList(List list, int vectorLength,
                      [int offset=0, int stride=0])
      : _vectorLength = vectorLength,
        _offset = offset,
        _stride = stride == 0 ? vectorLength : stride,
        _length = list.length,
        _buffer = new Float32List(offset + list.length *
                                  (stride == 0 ? vectorLength : stride)) {
    if (_stride < _vectorLength) {
      throw new ArgumentError('Stride cannot be smaller than the vector size.');
    }
    for (int i = 0; i < _length; i++) {
      store(i, list[i]);
    }
  }

  VectorList.view(Float32List buffer, int vectorLength,
                  [int offset=0, int stride=0])
      : _vectorLength = vectorLength,
        _offset = offset,
        _stride = stride == 0 ? vectorLength : stride,
        _length = (buffer.length-offset) ~/
                  (stride == 0 ? vectorLength : stride),
        _buffer = buffer {
    if (_stride < _vectorLength) {
      throw new ArgumentError('Stride cannot be smaller than the vector size.');
    }
  }

  int _vectorIndexToBufferIndex(int index) {
    return _offset + _stride * index;
  }

  dynamic newVector();

  void load(int index, dynamic vector) {
    int bufferIndex = _vectorIndexToBufferIndex(index);
    for (int i = 0; i < _vectorLength; i++) {
      vector.storage[i] = _buffer[bufferIndex];
      bufferIndex++;
    }
  }

  void store(int index, dynamic vector) {
    int bufferIndex = _vectorIndexToBufferIndex(index);
    for (int i = 0; i < _vectorLength; i++) {
      _buffer[bufferIndex] = vector.storage[i];
      bufferIndex++;
    }
  }

  void copy(VectorList src, {int srcOffset: 0, int offset: 0, int count: 0}) {
    if (count == 0) {
      count = Math.min(length - offset, src.length - srcOffset);
    }
    int minVectorLength = Math.min(_vectorLength, src._vectorLength);
    for (int i = 0; i < count; i++) {
      int index = _vectorIndexToBufferIndex(i + offset);
      int srcIndex = src._vectorIndexToBufferIndex(i + srcOffset);
      for (int j = 0; j < minVectorLength; j++) {
        _buffer[index++] = src._buffer[srcIndex++];
      }
    }
  }

  dynamic operator [](int index) {
    var r = newVector();
    load(index, r);
    return r;
  }

  void operator []=(int index, dynamic v) {
    store(index, v);
  }
}

class Vector2List extends VectorList {

  Vector2List(int length, [int offset = 0, int stride = 0])
      : super(length, 2, offset, stride);

  Vector2List.fromList(List<Vector2> list, [int offset = 0, int stride = 0])
      : super.fromList(list, 2, offset, stride);

  Vector2List.view(Float32List buffer, [int offset = 0, int stride = 0])
      : super.view(buffer, 2, offset, stride);

  Vector2 newVector() {
    return new Vector2.zero();
  }
}

class Vector3List extends VectorList {

  Vector3List(int length, [int offset = 0, int stride = 0])
      : super(length, 3, offset, stride);

  Vector3List.fromList(List<Vector3> list, [int offset = 0, int stride = 0])
      : super.fromList(list, 3, offset, stride);

  Vector3List.view(Float32List buffer, [int offset = 0, int stride = 0])
      : super.view(buffer, 3, offset, stride);

  Vector3 newVector() {
    return new Vector3.zero();
  }
}

class Vector4List extends VectorList {

  Vector4List(int length, [int offset = 0, int stride = 0])
      : super(length, 4, offset, stride);

  Vector4List.fromList(List<Vector4> list, [int offset = 0, int stride = 0])
      : super.fromList(list, 4, offset, stride);

  Vector4List.view(Float32List buffer, [int offset = 0, int stride = 0])
      : super.view(buffer, 4, offset, stride);

  Vector4 newVector() {
    return new Vector4.zero();
  }
}
