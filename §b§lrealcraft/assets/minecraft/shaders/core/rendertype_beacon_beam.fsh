#version 150

// Import necessary fog functions
#moj_import <fog.glsl>

uniform sampler2D Sampler0;    // Texture sampler
uniform mat4 ProjMat;          // Projection matrix
uniform vec4 ColorModulator;   // Color modulator
uniform float FogStart;        // Fog start distance
uniform float FogEnd;          // Fog end distance
uniform vec4 FogColor;         // Fog color
uniform vec4 BeamColor;        // Color for the beam glow
uniform float BeamIntensity;   // Intensity of the beam glow
uniform float BeamFalloff;     // Falloff factor for beam edge softness
uniform float Time;            // Time variable for flicker effect
uniform float BumpFrequency;   // Frequency of small bumps
uniform float BumpAmplitude;   // Amplitude of small bumps
uniform float BumpSpeed;       // Speed of bump movement
uniform float PyramidSize;     // Size of the pyramid base (3x3 is default)

in vec4 vertexColor;           // Color from the vertex shader
in vec2 texCoord0;             // Texture coordinate from the vertex shader

out vec4 fragColor;            // Final color output

void main() {
    
    
    // Sample the texture color
    vec4 textureColor = texture(Sampler0, texCoord0);
    
    // Modulate the texture color with vertex color and color modulator
    vec4 color = textureColor * vertexColor * ColorModulator;
    
    // Calculate the fragment's distance from the center of the beam
    vec2 center = vec2(0.5, 0.5); // Assuming the beam is centered in the texture
    float distanceFromCenter = length(texCoord0 - center);
    
    // Calculate bump effects
    float bumpEffect = sin(texCoord0.y * BumpFrequency + Time * BumpSpeed) * BumpAmplitude;
    float baseGlowIntensity = smoothstep(0.0, BeamFalloff, 1.0 - distanceFromCenter);
    float glowIntensity = baseGlowIntensity + bumpEffect;
    
    // Apply the flicker effect
    float flicker = 0.5 + 0.5 * sin(Time * 20.0); // Increase flicker frequency
    glowIntensity *= flicker * BeamIntensity;
    
    // Combine the beam color with the calculated intensity
    vec4 glowColor = mix(color, BeamColor, glowIntensity);
    
    // Scale the beam intensity based on the PyramidSize
    float sizeFactor = PyramidSize / 3.0; // Normalize 3x3 pyramid as default (sizeFactor = 1.0)
    glowColor *= sizeFactor;
    
    // Calculate the fragment's distance from the camera for fog
    float fragmentDistance = length((ProjMat * gl_FragCoord.xyzw).xyz);
    
    // Apply linear fog effect
    vec4 foggedColor = linear_fog(glowColor, fragmentDistance, FogStart, FogEnd, FogColor);
    
    // Set the final fragment color
    fragColor = foggedColor;
}