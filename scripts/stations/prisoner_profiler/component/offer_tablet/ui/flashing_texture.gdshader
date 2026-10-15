shader_type canvas_item;

uniform float flash_speed = 2.0;
uniform float min_opacity : hint_range(0.0, 1.0) = 0.2;
uniform float max_opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	float pulse = (sin(TIME * flash_speed) + 1.0) * 0.5;
	float opacity = mix(min_opacity, max_opacity, pulse);

	COLOR = tex_color;
	COLOR.a *= opacity;
}