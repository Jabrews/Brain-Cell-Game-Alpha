shader_type canvas_item;

uniform float low_opacity : hint_range(0.0, 1.0) = 0.25;
uniform float high_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float fade_speed : hint_range(0.1, 10.0) = 2.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float pulse = (sin(TIME * fade_speed) + 1.0) * 0.5;
	float opacity = mix(low_opacity, high_opacity, pulse);

	COLOR = tex;
	COLOR.a *= opacity;
}