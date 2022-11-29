#version 330

#define PI 3.1415926535897932384626433832795

uniform mat4 myProjectionMatrix;
uniform mat4 myModelviewMatrix;

in vec3 myNormal;
in vec3 myPosition;

void main() {
	gl_Position = vec4(myPosition, 1.0);
}

