#version 150

in vec3 Position;    // Vertex position
in vec4 Color;       // Vertex color
in vec2 UV0;         // Texture coordinate

uniform mat4 ModelViewMat;   // Model-View matrix
uniform mat4 ProjMat;        // Projection matrix

out vec4 vertexColor;        // Pass color to fragment shader
out vec2 texCoord0;          // Pass texture coordinate to fragment shader

void main() {
    // Transform the vertex position into clip space
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    
    // Pass color and texture coordinates to the fragment shader
    vertexColor = Color;
    texCoord0 = UV0;
}
