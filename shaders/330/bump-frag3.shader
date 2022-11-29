#version 330

#define PI 3.1415926535897932384626433832795
#define MIN_ISECT_DISTANCE 30
#define RADIUS 0.5


uniform vec3 myLightVector;
uniform sampler2D myTexture;
uniform sampler2D myNormalMap;

uniform mat4 myProjectionMatrix;
uniform mat4 myModelMatrix;
uniform mat4 myViewMatrix;
uniform vec3 myLookVector;

uniform int myUseNormalMap;

in vec3 vertexNormal_CameraCoord;
in vec3 vertexPos_CameraCoord;

out vec4 outputColor;

vec2 isectSphere(vec3 point) {
	vec2 coord;

	coord.x = atan(point.x, point.z) / (2.0 * PI) + 0.5f;
	coord.y = -point.y/2.0 + 0.5;

	if (coord.x > 1.0) {
		coord.x = 1.0;
	}
	if (coord.x < 0) {
		coord.x = 0;
	}
	if (coord.y > 1.0) {
		coord.y = 1.0;
	}
	if (coord.y < 0) {
		coord.y = 0;
	}

	return coord;
}

vec3 genRefractRay (vec3 incidentRay, vec3 normal, float index) {
	//for full derivation, see video by Justin Solomon: https://youtu.be/Tyg02tN9oSo?t=2113
	float k = 1.0 - index * index * (1.0 - dot(normal, incidentRay) * dot(normal, incidentRay));
	if (k < 0) {
		//total internal refraction. Abort!
	}
	return index * incidentRay - (index * dot(normal, incidentRay) + sqrt(k)) * normal;
}

void main()
{
	vec3 incidentRay_CameraCoord = normalize(vertexPos_CameraCoord); //since eye position is at the origin in camera space


	//vec3 reflectRay = incidentRay_CameraCoord - 2.0f * (dot(incidentRay_CameraCoord, vertexNormal_CameraCoord)) * vertexNormal_CameraCoord;
	//reflectRay = normalize(reflectRay);

	vec3 reflectRay = genRefractRay(incidentRay_CameraCoord, vertexNormal_CameraCoord, 0.82);
	//vec3 reflectRay = reflect(incidentRay_CameraCoord, vertexNormal_CameraCoord);

	vec3 reflectRay_WorldCoord = vec3(inverse(myViewMatrix) * vec4(reflectRay, 0.0));
	reflectRay_WorldCoord = normalize(reflectRay_WorldCoord);

	outputColor = texture(myTexture, isectSphere(reflectRay_WorldCoord));
}