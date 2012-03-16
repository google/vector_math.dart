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
  num _x;
  num _y;
  num _z;
  num _w;
  
  quat() {
    _x = 0.0;
    _y = 0.0;
    _z = 0.0;
    _w = 0.0;
  }
  
  quat.zero() : _x = 0.0, _y = 0.0, _z = 0.0, _w = 0.0;
  
  quat.identity() : _x = 0.0, _y = 0.0, _z = 0.0, _w = 1;
  
  quat.copy(quat other) {
    _x = other._x;
    _y = other._y;
    _z = other._z;
    _w = other._w;
  }
  
  quat.raw(this._x, this._y, this._z, this._w);
  
  quat.axisAngle(vec3 axis, num radians) {
    
  }
  
  void setAxisAngle(vec3 axis, num radians) {
    
  }
  
  void setEuler(num yaw, num pitch, num roll) {
    
  }
  
  quat normalize() {
    return this;
  }
  
  quat conjugate() {
    return this;
  }
  
  quat invert() {
    return this;
  }
  
  quat normalized() {
    return (new quat.copy(this)).normalize();
  }
  
  quat conjugated() {
    return (new quat.copy(this)).conjugate();
  }
  
  quat inverted() {
    return (new quat.copy(this)).invert();
  }
  
  num get radians() {
    
  }
  
  vec3 get axis() {
    
  }
  
  num get length2() {
    
  }
  
  num get length() {
    
  }

  vec3 rotate(vec3 v) {
    vec3 o = new vec3(v);
    return o;
  }
  
  quat operator/(num scale) {
    
  }
  
  quat operator*(Dynamic other) {
    
  }
  
  quat operator+(quat other) {
    
  }
  
  quat operator-(quat other) {
    
  }
  
  quat operator negate() {
    
  }
  
  num operator[](int i) {
    
  }
  
  num operator[]=(int i, num arg) {
    
  }
}
