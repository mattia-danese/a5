#version 330 //Most current OpenGL version avaible in BGE at this shader creation time

uniform mat4 projectionMatrix, modelviewMatrix;
uniform ivec4 mouseScreenInfo;

in vec4 position;
in vec4 normal; //local space

out vec4 myNormal;
out vec2 myTexCoord;

void main()
{

	vec4 finalPosition = projectionMatrix * modelviewMatrix * position;

	//Not doing anything crazy with the normals here, so just passing it on to the fragment shader as given (from the VBO).
	myNormal = normal;

	//NOTE: usually you will need to transform the normal from local space into global space.
	//This, of course, is done by taking the transpose of the inverse of the object's (object to world) 
	//  transform matrix. Then this normal_WorldSpace will need to be passed to the fragment shader.
	//However, since in this lab we are not moving the object at all, I'm omitting that step for simplicity.

	int mouseX = mouseScreenInfo[0];
	int mouseY = mouseScreenInfo[1];
	int screenWidth = mouseScreenInfo[2];
	int screenHeight = mouseScreenInfo[3];

	float mouseXPercent = float(screenWidth - mouseX)/float(screenWidth);
	float mouseYPercent = float(mouseY)/float(screenHeight);

	//hacky stuff to show the "shower door" effect
	float texCoordX = (finalPosition.x + mouseXPercent);
	float texCoordY = (finalPosition.y + mouseYPercent);

	myTexCoord = vec2(texCoordX, texCoordY);

	gl_Position = finalPosition;
}



