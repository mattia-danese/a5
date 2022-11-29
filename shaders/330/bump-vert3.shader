#version 330

#define PI 3.1415926535897932384626433832795


uniform mat4 myProjectionMatrix;
uniform mat4 myModelMatrix;
uniform mat4 myViewMatrix;

in vec3 myNormal;
in vec3 myPosition;

out vec3 vertexNormal_CameraCoord;
out vec3 vertexPos_CameraCoord;


void main()
{
	//Not doing anything crazy with the normals here, so just passing it on to the fragment shader as given (from the VBO).

	vertexPos_CameraCoord = vec3(myViewMatrix * myModelMatrix * vec4(myPosition, 1.0));
	vertexNormal_CameraCoord = vec3(normalize(myViewMatrix * myModelMatrix * vec4(myNormal, 0.0)));

	vec4 vertexWorldCoordPos = myProjectionMatrix * myViewMatrix * myModelMatrix * vec4(myPosition, 1.0);

	gl_Position = vertexWorldCoordPos;
}

