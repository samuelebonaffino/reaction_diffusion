#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

uniform vec2 u_resolution;
uniform float f;
uniform float k;
uniform float dt;
uniform float dA;
uniform float dB;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float map(float value, float min1, float max1, float min2, float max2) 
{
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main(void)
{
    // Retrieve spatial coordinate from the eight vertex surrounding the current one
    vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s,  -texOffset.t);
    vec2 tc1 = vertTexCoord.st + vec2(         0.0,  -texOffset.t);
    vec2 tc2 = vertTexCoord.st + vec2( texOffset.s,  -texOffset.t);
    vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,           0.0);
    vec2 tc4 = vertTexCoord.st + vec2(         0.0,           0.0);
    vec2 tc5 = vertTexCoord.st + vec2( texOffset.s,           0.0);
    vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s,   texOffset.t);
    vec2 tc7 = vertTexCoord.st + vec2(         0.0,   texOffset.t);
    vec2 tc8 = vertTexCoord.st + vec2( texOffset.s,   texOffset.t);

    // Retrieve color from texture specifying corrispondent spatial coordinates
    vec4 col0 = texture2D(texture, tc0);
    vec4 col1 = texture2D(texture, tc1);
    vec4 col2 = texture2D(texture, tc2);
    vec4 col3 = texture2D(texture, tc3);
    vec4 col4 = texture2D(texture, tc4);
    vec4 col5 = texture2D(texture, tc5);
    vec4 col6 = texture2D(texture, tc6);
    vec4 col7 = texture2D(texture, tc7);
    vec4 col8 = texture2D(texture, tc8);

    // Use (R,G) channels to store (A,B) agents
    vec2 uv = texture2D(texture, tc4.st).rg;
    // Calculate laplacian
    vec4 lapl = (.05 * col0 + .2  * col1 + .05 * col2  +
                 .2  * col3 - 1.0 * col4 + .2  * col5  +
                 .05 * col6 + .2  * col7 + .05 * col8) ;

    // float kk = map(tc4.x, 0.0, 1.0, 0.045, 0.07);
    // float ff = map(tc4.y, 0.0, 1.0, 0.01, 0.1);
    float rate = uv.r * uv.g * uv.g;
    float du = dA * lapl.r - rate + f * (1.0 - uv.r);
    float dv = dB * lapl.g + rate - (f + k) * uv.g;

    float u = clamp(uv.r + du*dt, 0.0, 1.0);
    float v = clamp(uv.g + dv*dt, 0.0, 1.0);

    gl_FragColor = vec4(u, v, 0.0, 1.0);
}