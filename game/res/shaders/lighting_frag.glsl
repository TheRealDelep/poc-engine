#version 330

// Input vertex attributes (from vertex shader)
in vec3 fragPosition;
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragNormal;

// Output fragment color
out vec4 finalColor;

void main() {
    vec3 objectColor = vec3(1, 0, 0);
    vec3 lightColor = vec3(1, 1, 1);
    vec3 lightDir = normalize(vec3(.5, .75, .5));

    float ambientStrength = 0.2;

    vec3 ambient = ambientStrength * vec3(1, 1, 1);
    vec3 norm = normalize(fragNormal);
    float diff = max(dot(norm, lightDir), 0);
    vec3 diffuse = diff * lightColor;

    vec3 result = (ambient + diffuse) * objectColor;
    finalColor = vec4(result, 1);
}
