#version 460

layout (location = 0) in vec3 VertexPosition;
layout (location = 1) in vec3 VertexNormal;

layout (location = 2) in vec2 VertexTexCoord;
layout (location = 3) in vec4 VertexTangent;

uniform struct LightInfo{
    vec4 Position;
    vec3 La;
    vec3 L;
    //vec3 Direction;
    //float Exponent;
    //float Cutoff;

}Light;

out vec3 Position;
out vec3 Normal;

out vec3 LightDir;
out vec3 ViewDir;
//flat out vec3 LightIntensity;
out vec2 TexCoord;
out vec3 Vec;

uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform mat4 projection;
uniform mat4 MVP;

//TrackCamera Position
void GetCameraSpaceValues(out vec3 normal, out vec3 position)
{
	normal = normalize(NormalMatrix * VertexNormal);
	position = (ModelViewMatrix * vec4(VertexPosition, 1.0)).xyz;
}

void main()
{
    Normal = normalize(NormalMatrix * VertexNormal);
    Position = (ModelViewMatrix * vec4(VertexPosition, 1.0)).xyz;
    Vec = VertexPosition;

    vec3 normal = normalize(NormalMatrix * VertexNormal);
    vec3 tangent = normalize(NormalMatrix * vec3(VertexTangent));
    vec3 binormal = normalize(cross(normal, tangent)) * VertexTangent.w;
    Position = (ModelViewMatrix * vec4(VertexPosition, 1.0)).xyz;

    mat3 toObjectLocal = mat3(
        tangent.x, binormal.x, normal.x,
        tangent.y, binormal.y, normal.y,
        tangent.z, binormal.z, normal.z
    
    );

    //New Map Light
    LightDir = toObjectLocal * (Light.Position.xyz - Position);
    ViewDir = toObjectLocal * normalize(-Position);
    TexCoord = VertexTexCoord;

    gl_Position = MVP * vec4(VertexPosition,1.0);
}
