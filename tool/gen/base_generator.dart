/*

  VectorMath.dart

  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>

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

part of vector_math_generator;

void ListSwap(List<int> seq, int i, int j) {
  int temp = seq[i];
  seq[i] = seq[j];
  seq[j] = temp;
}

void ListReverse(List<int> seq, int first, int last) {
  while (first != last && first != --last) {
    ListSwap(seq, first++, last);
  }
}

bool ListNextPermutation(List<int> seq, int first, int last) {
  if (first == last) {
    return false;
  }
  if (first+1 == last) {
    return false;
  }
  int i = last-1;
  for (;;) {
    int ii = i--;
    if (seq[i] < seq[ii]) {
      int j = last;
      while (!(seq[i] < seq[--j])) {
        continue;
      }
      ListSwap(seq, i, j);
      ListReverse(seq, ii, last);
      return true;
    }
    if (i == first) {
      ListReverse(seq, first, last);
      return false;
    }
  }
}

List<String> PrintablePermutation(List<int> seq, List<String> components) {
  List<String> r = new List<String>(seq.length);
  for (int i = 0; i < seq.length; i++) {
    r[i] = components[seq[i]];
  }
  return r;
}


class BaseGenerator {
  int _indent;
  RandomAccessFile out;
  String floatArrayType = 'Float32Array';
  String numType = 'num';

  BaseGenerator() {
    _indent = 0;
    out = null;
  }

  void iPush() {
    _indent++;
  }
  void iPop() {
    _indent--;
    assert(_indent >= 0);
  }

  void iPrint(String s) {
    String indent = '';
    for (int i = 0; i < _indent; i++) {
      indent = '$indent  ';
    }
    out.writeStringSync('$indent$s\n');
    //print('$indent$s');
  }

  void writeLicense() {
    iPrint('''/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
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

*/''');
  }

  String joinStrings(List<String> elements, [String pre = '', String post = '', String joiner = ', ']) {
    bool first = true;
    String r = '';
    for (String e in elements) {
      var extra = first ? '${pre}${e}${post}' : '${joiner}${pre}${e}${post}';
      r = '$r$extra';
      first = false;
    }
    return r;
  }

}
