#pragma once
#include <ostream>

/**
 * \brief Class to represent a 3-dimensional vector.
 * 
 * It offers common operations defined on a vector with 3 diminsions: dot product (in the following V1 * V2), 
 * cross product (V1 x V2), triple product (V1 * (V2 x V3)), normalize, length, and lengthsquared
 */
class Vector3D {
public:
	/**
	 * \brief Standard Constructor which initializes the vector with (0,0,0).
	 */
	Vector3D();

	/**
	 * \brief Constructor which initialies the vector with (x_,y_,z_).
	 * 
	 * \param x_ floating point value to initialize x
	 * \param y_ floating point value to initialize y
	 * \param z_ floating point value to initialize z
	 */
	Vector3D(float x_, float y_, float z_);
	/**
	 * \brief Copy Constructor. Copies the values from another Vector3D.
	 * \param lvalue reference to another Vector3D
	 */
	Vector3D(const Vector3D& lvalue);
	/**
	 * \brief Move Constructor. Moves the values from another Vector3D. 
	 * \param rvalue reference to another Vector3D
	 */
	Vector3D(Vector3D&& rvalue) noexcept;
	~Vector3D() = default;

	/**
	 * \brief Adds output stream capability with "<<" by converting the Vector into the string '(v.x,v.y,v.z)'.
	 * \param os reference to std::ostream
	 * \param v reference to Vector3D
	 * \return an reference to std::ostream
	 */
	friend std::ostream& operator <<(std::ostream& os, const Vector3D& v);

	/**
	 * \brief Default Copy Assignment operator.
	 * \param rhs reference to another Vector3D
	 * \return A reference to this Vector3D.
	 */
	Vector3D &operator=(const Vector3D &rhs) = default;
	/**
	 * \brief Default Move Assignment operator.
	 * \param rhs reference to another Vector3D
	 * \return A reference to this Vector3D.
	 */
	Vector3D &operator=(Vector3D &&rhs) = default;

	/**
	 * \brief Addition of two Vectors. V3 = V1 + V2. Operands will not be changed.
	 * \param rhs a reference to another Vector3D (V2).
	 * \return a Vector3D (V3).
	 */
	Vector3D operator+(const Vector3D &rhs) const;
	/**
	 * \brief Addition Assignment operator. V1 = V1 + V2. Operand V2 will not be changed.
	 * \param rhs a reference to another Vector3D.
	 * \return a reference to the changed Vector3D.
	 */
	Vector3D &operator+=(const Vector3D &rhs);

	/**
	 * \brief Subtraction of two Vectors. V3 = V1 - V2. Operands will not be changed.
	 * \param rhs a reference to another Vector3D (V2).
	 * \return a Vector3D (V3) representing the difference between V1 and V2.
	 */
	Vector3D operator-(const Vector3D &rhs) const;
	/**
	 * \brief Subtraction Assignment operator. V1 = V1 - V2. Operand V2 will not be changed.
	 * \param rhs a reference to another Vector3D.
	 * \return a reference to the changed Vector3D.
	 */
	Vector3D &operator-=(const Vector3D &rhs);

	/**
	 * \brief Get the i-th value of the Vector. 
	 * \param i an integer representing the i-th value.
	 * \throws std::out_of_range exception if value is larger than 2 or less than 0.
	 * \return a reference to the corresponding Vector value.
	 */
	float &operator[](const int i);
	/**
	 * \brief Dot product of two Vectors that results in a floating point number.
	 * \param rhs a reference to another Vector3D.
	 * \return a floating point number.
	 */
	float operator*(const Vector3D &rhs) const;

	/**
	 * \brief Scalar multiplication of the Vector. Operands will not be changed. V2 = V1 * f.
	 * \param rhs a scalar floating point number.
	 * \return a scaled Vector3D.
	 */
	Vector3D operator*(const float &rhs) const;
	/**
	 * \brief Scalar multiplication of the Vector. Original Vector will be modified. V1 = V1 * f.
	 * \param f floating point scaling factor.
	 * \return reference to the modified Vector3D.
	 */
	Vector3D &operator*=(const float f);

	/**
	 * \brief Scalar multiplication of the Vector. Operands will not be changed. V2 = f * V1.
	 * \param f floating point scaling factor.
	 * \param v reference to a Vector3D.
	 * \return a scaled Vector3D.
	 */
	friend Vector3D operator*(float f, const Vector3D& v);
	/**
	 * \brief Scalar division of the Vector. Operands will not be changed. V2 = V1 / f.
	 * \param rhs floating point scaling divisor.
	 * \return a scaled Vector3D.
	 */
	Vector3D operator/(const float &rhs) const;
	/**
	 * \brief Scalar division of the Vector. Operands will not be changed. V2 = f / V1. 
	 * \note Whether this function is valid or not depends on the viewpoint. In this implementation, a new Vector3D is created with (f/v.x, f/v.y, f/v.z).
	 * \param f floating point scaling factor.
	 * \param v reference to a Vector3D.
	 * \return a scaled Vector3D.
	 */
	friend Vector3D operator/(const float f, const Vector3D& v);

	/**
	 * \brief Scales the Vector to have a length of 1.
	 */
	void normalize();
	/**
	 * \brief Copies the Vector and normalizes the copy of the vector.
	 * \return a Vector3D with the same orientation but with the length of 1. 
	 */
	Vector3D normalized() const;
	/**
	 * \brief Calculates the length of the Vector: sqrt(x*x + y*y + z*z).
	 * \return a floating point number representing the length of the vector.
	 */
	float length() const;
	/**
	 * \brief Calculates the squared length of the Vector: x*x + y*y + z*z.
	 * \return a floating point number representing the squared length of the vector.
	 */
	float lengthSquared() const;

	/**
	 * \brief Calculates the dot product of two Vectors. f = V1 * V2.
	 * \param v1 The first Vector3D.
	 * \param v2 The second Vector3D.
	 * \return a floating point number representing the dot product of the two vectors.
	 */
	static float dotProduct(const Vector3D &v1, const Vector3D &v2);
	/**
	 * \brief Calculates the cross product of two Vectors. V = V1 x V2.
	 * \param v1 The first Vector3D.
	 * \param v2 The second Vector3D.
	 * \return a Vector3D representing the cross product of the two vectors.
	 */
	static Vector3D crossProduct(const Vector3D &v1, const Vector3D &v2);
	/**
	 * \brief Calculates the triple product of three Vectors. f = V1 * (V2 x V3).
	 * \param v1 The first Vector3D.
	 * \param v2 The second Vector3D.
	 * \param v3 The third Vector3D.
	 * \return a floating point number representing the triple product of the three vectors.
	 */
	static float tripleProduct(const Vector3D &v1, const Vector3D &v2, const Vector3D &v3);
	float x, y, z;
};

