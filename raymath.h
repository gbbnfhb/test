#ifndef RAYMATH_H
#define RAYMATH_H

#include <stddef.h>
#include <math.h>
#include <float.h>

#ifdef __cplusplus
extern "C" {
#endif

//----------------------------------------------------------------------------------
// Defines and Macros
//----------------------------------------------------------------------------------
#ifndef PI
    #define PI 3.14159265358979323846f
#endif

#ifndef EPSILON
    #define EPSILON 0.000001f
#endif

#ifndef DEG2RAD
    #define DEG2RAD (PI/180.0f)
#endif

#ifndef RAD2DEG
    #define RAD2DEG (180.0f/PI)
#endif

// Get float vector for Matrix
#ifndef MatrixToFloat
    #define MatrixToFloat(mat) (MatrixToFloatV(mat).v)
#endif

// Get float vector for Vector3
#ifndef Vector3ToFloat
    #define Vector3ToFloat(vec) (Vector3ToFloatV(vec).v)
#endif

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
#if !defined(RL_VECTOR2_TYPE)
// Vector2 type
typedef struct Vector2 {
    float x;
    float y;
} Vector2;
#define RL_VECTOR2_TYPE
#endif

#if !defined(RL_VECTOR3_TYPE)
// Vector3 type
typedef struct Vector3 {
    float x;
    float y;
    float z;
} Vector3;
#define RL_VECTOR3_TYPE
#endif

#if !defined(RL_VECTOR4_TYPE)
// Vector4 type
typedef struct Vector4 {
    float x;
    float y;
    float z;
    float w;
} Vector4;
#define RL_VECTOR4_TYPE
#endif

#if !defined(RL_QUATERNION_TYPE)
// Quaternion type
typedef Vector4 Quaternion;
#define RL_QUATERNION_TYPE
#endif

#if !defined(RL_MATRIX_TYPE)
// Matrix type (OpenGL style 4x4 - right handed, column major)
typedef struct Matrix {
    float m0, m4, m8, m12;      // Matrix first row (4 components)
    float m1, m5, m9, m13;      // Matrix second row (4 components)
    float m2, m6, m10, m14;     // Matrix third row (4 components)
    float m3, m7, m11, m15;     // Matrix fourth row (4 components)
} Matrix;
#define RL_MATRIX_TYPE
#endif

// NOTE: Helper types to be used instead of array return types for *ToFloat functions
typedef struct float3 {
    float v[3];
} float3;

typedef struct float16 {
    float v[16];
} float16;

#include <math.h>       // Required for: sinf(), cosf(), tan(), atan2f(), sqrtf(), floor(), fminf(), fmaxf(), fabsf()

//----------------------------------------------------------------------------------
// Module Functions Definition - Utils math
//----------------------------------------------------------------------------------

// Vector2 functions
Vector2 Vector2Zero(void);
Vector2 Vector2One(void);
Vector2 Vector2Add(Vector2 v1, Vector2 v2);
Vector2 Vector2Subtract(Vector2 v1, Vector2 v2);
Vector2 Vector2Multiply(Vector2 v1, Vector2 v2);
Vector2 Vector2Divide(Vector2 v1, Vector2 v2);
float Vector2DotProduct(Vector2 v1, Vector2 v2);
float Vector2Length(Vector2 v);
float Vector2LengthSqr(Vector2 v);
float Vector2Distance(Vector2 v1, Vector2 v2);
float Vector2DistanceSqr(Vector2 v1, Vector2 v2);
Vector2 Vector2Negate(Vector2 v);
Vector2 Vector2Normalize(Vector2 v);
Vector2 Vector2Scale(Vector2 v, float scale);
Vector2 Vector2Lerp(Vector2 v1, Vector2 v2, float amount);
Vector2 Vector2Reflect(Vector2 v, Vector2 normal);
Vector2 Vector2Rotate(Vector2 v, float angle);
Vector2 Vector2MoveTowards(Vector2 v1, Vector2 v2, float maxDistance);

// Vector3 functions
Vector3 Vector3Zero(void);
Vector3 Vector3One(void);
Vector3 Vector3Add(Vector3 v1, Vector3 v2);
Vector3 Vector3Subtract(Vector3 v1, Vector3 v2);
Vector3 Vector3Multiply(Vector3 v1, Vector3 v2);
Vector3 Vector3CrossProduct(Vector3 v1, Vector3 v2);
Vector3 Vector3Perpendicular(Vector3 v);
Vector3 Vector3Divide(Vector3 v1, Vector3 v2);
float Vector3DotProduct(Vector3 v1, Vector3 v2);
float Vector3Length(Vector3 v);
float Vector3LengthSqr(Vector3 v);
float Vector3Distance(Vector3 v1, Vector3 v2);
float Vector3DistanceSqr(Vector3 v1, Vector3 v2);
Vector3 Vector3Negate(Vector3 v);
Vector3 Vector3Normalize(Vector3 v);
Vector3 Vector3Scale(Vector3 v, float scale);
Vector3 Vector3Lerp(Vector3 v1, Vector3 v2, float amount);
Vector3 Vector3Reflect(Vector3 v, Vector3 normal);
Vector3 Vector3Min(Vector3 v1, Vector3 v2);
Vector3 Vector3Max(Vector3 v1, Vector3 v2);
Vector3 Vector3Barycenter(Vector3 p, Vector3 a, Vector3 b, Vector3 c);
Vector3 Vector3Transform(Vector3 v, Matrix mat);
Vector3 Vector3RotateByQuaternion(Vector3 v, Quaternion q);
Vector3 Vector3RotateX(Vector3 v, float angle);
Vector3 Vector3RotateY(Vector3 v, float angle);
Vector3 Vector3RotateZ(Vector3 v, float angle);
Vector3 Vector3OrthoNormalize(Vector3 *v1, Vector3 *v2);
Vector3 Vector3MoveTowards(Vector3 v1, Vector3 v2, float maxDistance);
Vector3 Vector3RotateByAxisAngle(Vector3 v, Vector3 axis, float angle);
float Vector3Angle(Vector3 v1, Vector3 v2);
Vector3 Vector3Unproject(Vector3 source, Matrix projection, Matrix view);
Vector3 Vector3CubicHermite(Vector3 v1, Vector3 tangent1, Vector3 v2, Vector3 tangent2, float amount);

// Vector4 functions
Vector4 Vector4Zero(void);
Vector4 Vector4One(void);
Vector4 Vector4Add(Vector4 v1, Vector4 v2);
Vector4 Vector4Subtract(Vector4 v1, Vector4 v2);
Vector4 Vector4Multiply(Vector4 v1, Vector4 v2);
Vector4 Vector4Divide(Vector4 v1, Vector4 v2);
float Vector4DotProduct(Vector4 v1, Vector4 v2);
float Vector4Length(Vector4 v);
float Vector4LengthSqr(Vector4 v);
float Vector4Distance(Vector4 v1, Vector4 v2);
float Vector4DistanceSqr(Vector4 v1, Vector4 v2);
Vector4 Vector4Negate(Vector4 v);
Vector4 Vector4Normalize(Vector4 v);
Vector4 Vector4Scale(Vector4 v, float scale);
Vector4 Vector4Lerp(Vector4 v1, Vector4 v2, float amount);
Vector4 Vector4Transform(Vector4 v, Matrix mat);

// Matrix functions
Matrix MatrixIdentity(void);
Matrix MatrixAdd(Matrix left, Matrix right);
Matrix MatrixSubtract(Matrix left, Matrix right);
Matrix MatrixMultiply(Matrix left, Matrix right);
Matrix MatrixTranslate(float x, float y, float z);
Matrix MatrixRotate(Vector3 axis, float angle);
Matrix MatrixRotateX(float angle);
Matrix MatrixRotateY(float angle);
Matrix MatrixRotateZ(float angle);
Matrix MatrixRotateXYZ(Vector3 angle);
Matrix MatrixRotateZYX(Vector3 angle);
Matrix MatrixScale(float x, float y, float z);
Matrix MatrixFrustum(double left, double right, double bottom, double top, double near, double far);
Matrix MatrixPerspective(double fovy, double aspect, double near, double far);
Matrix MatrixOrtho(double left, double right, double bottom, double top, double near, double far);
Matrix MatrixLookAt(Vector3 eye, Vector3 target, Vector3 up);
Matrix MatrixTranspose(Matrix matrix);
Matrix MatrixInvert(Matrix matrix);
Matrix MatrixTrace(Matrix matrix);
Matrix MatrixDeterminant(Matrix matrix);
Matrix MatrixNormalize(Matrix matrix);
Vector3 MatrixGetForward(Matrix matrix);
Vector3 MatrixGetUp(Matrix matrix);
Vector3 MatrixGetRight(Matrix matrix);
float16 MatrixToFloatV(Matrix matrix);
void MatrixDecompose(Matrix mat, Vector3 *translation, Quaternion *rotation, Vector3 *scale);



// Quaternion functions
Quaternion QuaternionIdentity(void);
Quaternion QuaternionAdd(Quaternion q1, Quaternion q2);
Quaternion QuaternionSubtract(Quaternion q1, Quaternion q2);
Quaternion QuaternionMultiply(Quaternion q1, Quaternion q2);
Quaternion QuaternionScale(Quaternion q, float scale);
Quaternion QuaternionDivide(Quaternion q1, Quaternion q2);
float QuaternionLength(Quaternion q);
Quaternion QuaternionNormalize(Quaternion q);
Quaternion QuaternionInvert(Quaternion q);
Quaternion QuaternionLerp(Quaternion q1, Quaternion q2, float amount);
Quaternion QuaternionNlerp(Quaternion q1, Quaternion q2, float amount);
Quaternion QuaternionSlerp(Quaternion q1, Quaternion q2, float amount);
Quaternion QuaternionFromVector3ToVector3(Vector3 u, Vector3 v);
Quaternion QuaternionFromMatrix(Matrix mat);
Matrix QuaternionToMatrix(Quaternion q);
Vector3 QuaternionToAxisAngle(Quaternion q, Vector3 *outAxis);
Quaternion QuaternionFromAxisAngle(Vector3 axis, float angle);
Quaternion QuaternionFromEuler(float roll, float pitch, float yaw);
Vector3 QuaternionToEuler(Quaternion q);
Quaternion QuaternionTransform(Quaternion q, Matrix mat);
 Quaternion QuaternionCubicHermiteSpline(Quaternion q1, Quaternion outTangent1, Quaternion q2, Quaternion inTangent2, float t);
 
 
// Misc functions
float Clamp(float value, float min, float max);
float Lerp(float start, float end, float amount);
float Normalize(float value, float start, float end);
float Remap(float value, float inputStart, float inputEnd, float outputStart, float outputEnd);
float Wrap(float value, float min, float max);
int FloatEquals(float x, float y);

#ifdef __cplusplus
}
#endif

#endif // RAYMATH_H