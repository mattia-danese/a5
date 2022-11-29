#version 120

uniform mat4 myProjectionMatrix;
uniform mat4 myModelviewMatrix;

varying vec3 myNormal;


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
	//Not doing anything crazy with the normals here, so just passing it on to the fragment shader as given (from the VBO).
	myNormal = gl_Normal;

	//float randNum = rand(gl_Vertex.xy);
	//vec3 vertexPos = gl_Vertex.xyz * randNum;
	vec3 vertexPos = gl_Vertex.xyz;

	vec4 finalPosition = myProjectionMatrix * myModelviewMatrix * vec4(vertexPos, 1.0);


	gl_Position = finalPosition;
	//gl_Position = vec4(position, 1.0f);
}

