#version 330

#define PI 3.1415926535897932384626433832795
#define MIN_ISECT_DISTANCE 30
#define RADIUS 0.5


uniform vec3 myLightVector;
uniform sampler2D myTexture;
uniform sampler2D myNormalMap;

uniform mat4 myProjectionMatrix;
uniform mat4 myModelviewMatrix;
uniform vec3 myLookVector;

uniform int myUseNormalMap;

in vec3 sharedNormal;
in vec2 sharedTexCoord;
in vec4 sharedPosition;

out vec4 outputColor;

vec4 findIsectNormal(vec4 eyePoint, vec4 ray, float dist) {
	vec4 tmpP = eyePoint + (dist * ray);
	return tmpP;
}

float intersectSphere (vec4 eyePointP, vec4 rayV, mat4 transformMatrix) {
	mat4 inverseTransform = inverse(transformMatrix);
	vec4 eyePoint = inverseTransform * eyePointP;
	vec4 ray = inverseTransform * rayV;

	float t = MIN_ISECT_DISTANCE;
	float a = ray[0] * ray[0] + ray[1] * ray[1] + ray[2] * ray[2];
	float b = 2 * (ray[0] * eyePoint[0] + ray[1] * eyePoint[1] + ray[2] * eyePoint[2]);
	float c = eyePoint[0] * eyePoint[0] + eyePoint[1] * eyePoint[1] + eyePoint[2] * eyePoint[2] - RADIUS * RADIUS;

	float det = b * b - 4 * a * c;
	if (det < 0) {
		return -1;
	}

	float t1 = (-b - sqrt(det)) / (2 * a);
	float t2 = (-b + sqrt(det)) / (2 * a);

	if ((t1 > 0) && (t2 > 0))
		t1 < t2 ? (t = t1) : (t = t2);
	else if (t1 < 0)
		t = t2;
	else if (t2 < 0)
		t = t1;
	else
		return -1;

	return t;
}

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
	vec4 texColor = vec4(1.0, 1.0, 1.0, 0.0);
	vec3 normalVec = sharedNormal;

	vec3 normalizedLight = normalize(myLightVector);

	vec4 final_color = vec4(1.0, 1.0, 1.0, 0.0);


	vec4 vertexWorldCoordPos = myModelviewMatrix * sharedPosition;
	//vec4 eyeWorldCoordPos = vertexWorldCoordPos - myLookVector4;
	//vec4 myLookVector4 = vec4(myLookVector, 0.0);
	vec4 eyeWorldCoordPos = vec4(0.0, 0.0, 1.0, 0.0);
	vec4 myLookVector4 = normalize(vertexWorldCoordPos - eyeWorldCoordPos);

	float isectT = intersectSphere(eyeWorldCoordPos, myLookVector4, myModelviewMatrix);
	vec4 isectPoint = eyeWorldCoordPos + isectT * myLookVector4;

	vec4 isectNormalVec = findIsectNormal(eyeWorldCoordPos, myLookVector4, isectT);
	
	isectNormalVec = normalize(isectNormalVec);

	vec4 reflectRay = myLookVector4 - 2.0f * (dot(myLookVector4, isectNormalVec)) * isectNormalVec;
	reflectRay = normalize(reflectRay);


	mat4 bigSphereTransform = 
		mat4(10.0, 0.0, 0.0, 0.0,  // 1. column
		     0.0, 10.0, 0.0, 0.0,  // 2. column
		     0.0, 0.0, 10.0, 0.0,  // 3. column
		     0.0, 0.0, 0.0, 1.0); // 4. column

	float isectT2 = intersectSphere(isectPoint, reflectRay, bigSphereTransform);
	vec4 isectPoint2 = isectPoint + isectT2 * reflectRay;
	isectPoint2 = normalize(vec4(isectPoint2.xyz, 0.0));

	//vec3 normalizedNormal = normalize(sharedNormal);
	//float dotP = max(dot(normalizedLight, normalizedNormal), 0);
	//final_color = dotP * texColor;
	//final_color = vec4(1.0, sharedTexCoord, 1.0);


	if (isectT > 0) {
		final_color = vec4(1.0, 0.0, 0.0, 1.0);
	}
	else {
		final_color = vec4(0.0, 1.0, 0.0, 1.0);
	}


	texColor = texture(myTexture, isectSphere(normalize(isectPoint.xyz)));

	final_color = texColor;

	//final_color = vec4(isectNormalVec.xyz, 1.0);

	//final_color = clamp(final_color, 0.0, 1.0);

	//outputColor = texColor;
	//outputColor = vec4(sharedTexCoord.y, 0.0, 0.0, 1.0);
	final_color = vec4(sharedPosition);
	outputColor = final_color;
	//outputColor = vec4(1.0, 1.0, 1.0, 1.0);
}