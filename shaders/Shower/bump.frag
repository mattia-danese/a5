//fragment shader, create a file for it named fragment.frag
#version 330

uniform vec3 lightVector;
uniform sampler2D brick_image;  // The brick texture
uniform int usingTexture;

in vec4 myNormal;
in vec2 myTexCoord;

out vec4 outputColor;

void main()
{
	
	vec4 texColor = vec4 (1.0, 1.0, 1.0, 0.0);
	
	if (usingTexture == 1) {
		if ((myTexCoord.x < 0) || (myTexCoord.x > 1) || (myTexCoord.y < 0) || (myTexCoord.y > 1)) {
			texColor = vec4 (1.0, 1.0, 1.0, 0.0);
		}
		else {
			texColor = texture(brick_image, myTexCoord);
		}
	}

	vec3 normalizedLight = normalize(lightVector);
	float dotP = max(dot(normalizedLight.xyz, myNormal.xyz), 0);

	vec4 final_color = dotP * texColor;

	//outputColor = vec4(myTexCoord.xy, 0.0, 0.0);
	//outputColor = texColor;
	//outputColor = myNormal;
	outputColor = final_color;
}






