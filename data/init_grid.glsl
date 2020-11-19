#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

uniform vec2 u_resolution;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453);
}
vec3 initRectAgentB(vec2 st)
{
    vec3 c = vec3(0.0, 0.0, 0.0);
    if((st.s < 0.55 && st.s > 0.5) && (st.t < 0.55 && st.t > 0.5))
        c.g += 0.5;
    return c;
}
vec3 initRandom(vec2 st)
{
    vec3 c = vec3(0.0, 0.0, 0.0);
    c.r += 1.0;
    if(random(st) > 0.5)
        c.g += clamp(random(st), 0.0, 0.085);
    return c;
}

void main(void)
{
    vec2 st = vertTexCoord.st;
    vec2 uv = texture2D(texture, st).rg;
    vec3 c = initRandom(st);
    gl_FragColor = vec4(c, 0.0);
}