#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const vec3 rgbBalance = vec3(1.0, 1.0, 1.0);
const float vibranceStrength = 0.10;
const float saturationThreshold = 0.15;
const vec3 vibranceCoeffient = rgbBalance * -vibranceStrength;

void main()
{
    vec4 pixelColor = texture(tex, v_texcoord);
    vec3 color = pixelColor.rgb;
    vec3 lumaCoefficent = vec3(0.212656, 0.715158, 0.072186);
    float luma = dot(lumaCoefficent, color);
    float maxColor = max(color.r, max(color.g, color.b));
    float minColor = min(color.r, min(color.g, color.b));
    float saturation = maxColor - minColor;
    vec3 vibranceTransform = (sign(vibranceCoeffient) * saturation - 1.0) * vibranceCoeffient + 1.0;
    vec3 saturatedColor = mix(vec3(luma), color, vibranceTransform);
    float fadeFactor = smoothstep(saturationThreshold, saturationThreshold + 0.3, saturation) * smoothstep(0.05, 0.25, luma);
    vec3 adjustedColor = mix(color, saturatedColor, fadeFactor);
    float shadowMask = smoothstep(0.0, 0.3, luma);
    adjustedColor = pow(adjustedColor, vec3(1.0 + (1.0 - shadowMask) * 0.4));
    fragColor = vec4(adjustedColor, pixelColor.a);
}
