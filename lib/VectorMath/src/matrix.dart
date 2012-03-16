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

class mat2x2 extends mat2x2Gen {
  mat2x2([Dynamic arg1, Dynamic arg2]) : super(arg1, arg2) {}
  
  num determinant() {
    return (this[0][0] * this[1][1]) - (this[0][1]*this[1][0]); 
  }
}

class mat2x3 extends mat2x3Gen {
  mat2x3([Dynamic arg1, Dynamic arg2]) : super(arg1, arg2) {}  
}

class mat2x4 extends mat2x4Gen {
  mat2x4([Dynamic arg1, Dynamic arg2]) : super(arg1, arg2) {}
}

class mat3x2 extends mat3x2Gen {
  mat3x2([Dynamic arg1, Dynamic arg2, Dynamic arg3]) : super(arg1, arg2, arg3) {}
}

class mat3x3 extends mat3x3Gen {
  mat3x3([Dynamic arg1, Dynamic arg2, Dynamic arg3]) : super(arg1, arg2, arg3) {}
  
  num determinant() {
    num x = this[0][0]*((this[2][2]*this[1][1])-(this[2][1]*this[1][2]));
    num y = this[1][0]*((this[2][2]*this[0][1])-(this[2][1]*this[0][2]));
    num z = this[2][0]*((this[1][2]*this[0][1])-(this[1][1]*this[0][2]));
    return x - y + z;
  }
}

class mat3x4 extends mat3x4Gen {
  mat3x4([Dynamic arg1, Dynamic arg2, Dynamic arg3]) : super(arg1, arg2, arg3) {}
}

class mat4x2 extends mat4x2Gen {
  mat4x2([Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4]) : super(arg1, arg2, arg3, arg4) {}
}

class mat4x3 extends mat4x3Gen {
  mat4x3([Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4]) : super(arg1, arg2, arg3, arg4) {}
}

class mat4x4 extends mat4x4Gen {
  mat4x4([Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4]) : super(arg1, arg2, arg3, arg4) {}
  num determinant() {
    throw "Unimplemented";
  }
}

Dynamic transpose(Dynamic r) {
  return null;
}