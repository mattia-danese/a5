#version 120

uniform vec3 lightVector;

varying vec3 myNormal;


void main()
{
	
	//vec3 normalizedLight = normalize(lightVector);
	//float dotP = max(dot(normalizedLight, myNormal), 0);

	//vec4 final_color = dotP * vec4(1.0, 1.0, 1.0, 0.0);
	//vec4 final_color = dotP * vec4(myNormal, 0.0);

	//outputColor = vec4(myTexCoord.xy, 0.0, 0.0);
	//outputColor = texColor;
	//outputColor = myNormal;
	//outputColor = final_color;
	gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
	//gl_FragColor = final_color;
}