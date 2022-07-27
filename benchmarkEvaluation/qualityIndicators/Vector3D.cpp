#include "Vector3D.h"
#include <cmath>
#include <stdexcept>
#include <iostream>

Vector3D::Vector3D(){
	x = 0.0f, y = 0.0f, z = 0.0f;
}

Vector3D::Vector3D(float x_, float y_, float z_) {
	x = x_, y = y_, z = z_;
}
Vector3D::Vector3D(const Vector3D& lvalue) {
	x = lvalue.x;
	y = lvalue.y;
	z = lvalue.z;
}
Vector3D::Vector3D(Vector3D&& rvalue) noexcept {
	x = rvalue.x;
	y = rvalue.y;
	z = rvalue.z;
}

Vector3D Vector3D::operator+(const Vector3D& rhs) const {
	Vector3D v;
	v.x = this->x + rhs.x;
	v.y = this->y + rhs.y;
	v.z = this->z + rhs.z;

	return v;
}

Vector3D &Vector3D::operator+=(const Vector3D& rhs) {
	this->x += rhs.x;
	this->y += rhs.y;
	this->z += rhs.z;

	return *this;
}
Vector3D Vector3D::operator-(const Vector3D& rhs) const {
	Vector3D v;
	v.x = this->x - rhs.x;
	v.y = this->y - rhs.y;
	v.z = this->z - rhs.z;

	return v;
}

Vector3D &Vector3D::operator-=(const Vector3D& rhs) {
	this->x -= rhs.x;
	this->y -= rhs.y;
	this->z -= rhs.z;

	return *this;
}
float &Vector3D::operator[](const int i) {

	switch (i) {
	case 0: return x;
	case 1: return y;
	case 2: return z;
	default: throw std::out_of_range("Vector3D only has 3 values!");
	}
}

float Vector3D::operator*(const Vector3D& rhs) const {
	return x*rhs.x + y * rhs.y + z * rhs.z;
}

Vector3D Vector3D::operator*(const float& rhs) const {
	return{ x*rhs, y*rhs, z*rhs };
}
Vector3D &Vector3D::operator*=(const float f) {
	this->x *= f;
	this->y *= f;
	this->z *= f;

	return *this;
}
Vector3D operator*(float f, const Vector3D &v) {
	return v * f;
}

std::ostream& operator<<(std::ostream& os, const Vector3D& v) {
	os << '(' << v.x << ',' << v.y << ',' << v.z << ')';
	return os;
}

Vector3D Vector3D::operator/(const float& rhs) const {
	return *this * (1 / rhs);
}


Vector3D operator/(const float f, const Vector3D& v) {
	return{ f / v.x, f / v.y, f / v.z };
}

void Vector3D::normalize() {
	auto mag = length();
	mag = mag != 0 ? 1.0f / mag : mag;
	*this *= mag;
}
Vector3D Vector3D::normalized() const {
	auto mag = length();
	mag = mag != 0 ? 1.0f / mag: mag;
	auto v = *this * mag;
	return v;
}
float Vector3D::length() const {
	return std::sqrt(lengthSquared());
}
float Vector3D::lengthSquared() const {
	return x*x + y*y + z*z;
}

float Vector3D::dotProduct(const Vector3D& v1, const Vector3D& v2) {
	return v1 * v2;
}

Vector3D Vector3D::crossProduct(const Vector3D& v1, const Vector3D& v2) {
	return{ v1.y*v2.z - v1.z*v2.y,
			v1.z*v2.x - v1.x*v2.z,
			v1.x*v2.y - v1.y*v2.x };
}

float Vector3D::tripleProduct(const Vector3D& v1, const Vector3D& v2, const Vector3D& v3) {
	return v1 * Vector3D::crossProduct(v2, v3);
}
