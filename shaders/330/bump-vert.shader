#version 330

#define PI 3.1415926535897932384626433832795


uniform mat4 myProjectionMatrix;
uniform mat4 myModelviewMatrix;
uniform vec3 myLookVector;

in vec3 myNormal;
in vec3 myPosition;

out vec3 sharedNormal;
out vec2 sharedTexCoord;
out vec4 sharedPosition;

vec2 isectSphere(vec3 point) {
	vec2 coord;

	coord.x = atan(point.x, point.z) / (2.0 * PI) + 0.5f;
	coord.y = -point.y + 0.5;

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

void main()
{
	//Not doing anything crazy with the normals here, so just passing it on to the fragment shader as given (from the VBO).
	sharedNormal = myNormal;

	sharedPosition = vec4(myPosition, 1.0);

	sharedTexCoord = isectSphere(myPosition);

	vec4 vertexWorldCoordPos = myProjectionMatrix * myModelviewMatrix * vec4(myPosition, 1.0);

	gl_Position = vertexWorldCoordPos;
}

