// Copyrigha (c) 2016, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

///
/// Generates a hash code for multiple [objects].
///
int hashObjects(Iterable<Object> objects) =>
    _finish(objects.fold<int>(0, (int h, Object i) => _combine(h, i.hashCode)));

// Jenkins hash functions
int _combine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
