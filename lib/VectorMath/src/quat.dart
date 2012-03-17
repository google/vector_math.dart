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

class quat {
  num x;
  num y;
  num z;
  num w;
  
  quat([Dynamic a, Dynamic b, Dynamic c, Dynamic d]) {
    x = 0.0;
    y = 0.0;
    z = 0.0;
    w = 1.0;
    
    if (a is num && b is num && c is num && d is num) {
      x = a;
      y = b;
      z = c;
      w = d;
      return;
    }
    
    if (a is vec3 && b is num) {
      setAxisAngle(a, b);
      return;
    }
    
    if (a is quat) {
      x = a._x;
      y = a._y;
      z = a._z;
      w = a._w;
    }
  }
  
  void setAxisAngle(vec3 axis, num radians) {
    num len = axis.length;
    if (len == 0.0) {
      return;
    }
    num halfSin = sin(radians * 0.5) / len;
    x = axis.x * halfSin;
    y = axis.y * halfSin;
    z = axis.z * halfSin;
    w = cos(radians * 0.5);
  }
  
  void setEuler(num yaw, num pitch, num roll) {
    num halfYaw = yaw * 0.5;  
    num halfPitch = pitch * 0.5;  
    num halfRoll = roll * 0.5;  
    num cosYaw = halfYaw;
    num sinYaw = halfYaw;
    num cosPitch = halfPitch;
    num sinPitch = halfPitch;
    num cosRoll = halfRoll;
    num sinRoll = halfRoll;
    x = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
    y = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
    z = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw;
    w = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw;
  }
  
  quat normalize() {
    return this;
  }
  
  quat conjugate() {
    return new quat(-x, -y, -z, w);
  }
  
  quat inverse() {
    return new quat(-x, -y, -z, w);
  }
  
  quat normalized() {
    return (new quat(this)).normalize();
  }
  
  quat conjugated() {
    return (new quat(this)).conjugate();
  }
  
  quat inverted() {
    return (new quat(this)).inverse();
  }
  
  num get radians() {
    return 2.0 * acos(w);
  }
  
  vec3 get axis() {
      num divisor = 1.0 - (w*w);
      return new vec3(x / divisor, y / divisor, z / divisor);
  }
  
  num get length2() {
    return (x*x) + (y*y) + (z*z) + (w*w);
  }
  
  num get length() {
    return sqrt(length2);
  }

  vec3 rotate(vec3 v) {
    vec3 o = new vec3(v);
    return o;
  }
  
  quat operator/(num scale) {
    return new quat(x / scale, y / scale, z / scale, w / scale);
  }
  
  quat operator*(Dynamic other) {
    if (other is num) {
      return new quat(x * other, y * other, z * other, w * other);
    }
    if (other is quat) {
      return new quat(w * other.x + x * other.w + y * other.z - z * other.y,
                      w * other.y + y * other.w + z * other.x() - x * other.z,
                      w * other.z + z * other.w + x * other.y() - y * other.x,
                      w * other.w - x * other.x - y * other.y - z * other.z);
    }
  }
  
  quat operator+(quat other) {
    return new quat(x + other.x, y + other.y, z + other.z, w + other.w);
  }
  
  quat operator-(quat other) {
    return new quat(x - other.x, y - other.y, z - other.z, w - other.w);
  }
  
  quat operator negate() {
    return new quat(-x, -y, -z, -w);
  }
  
  num operator[](int i) {
    assert(i >= 0 && i < 4);
    switch (i) {
    case 0: return x; break;
    case 1: return y; break;
    case 2: return z; break;
    case 3: return w; break;
    }
    return 0.0;
  }
  
  num operator[]=(int i, num arg) {
    assert(i >= 0 && i < 4);
    switch (i) {
    case 0: x = arg; return x; break;
    case 1: y = arg; return y; break;
    case 2: z = arg; return z; break;
    case 3: x = arg; return w; break;
    }
    return 0.0;
  }
}
