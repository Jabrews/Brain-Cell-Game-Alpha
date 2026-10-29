shader_type canvas_item;

uniform vec4 low_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 high_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float flash_speed : hint_range(0.1, 10.0) = 2.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// 0 -> 1 -> 0
	float flash = (sin(TIME * flash_speed) + 1.0) * 0.5;

	vec3 current_color = mix(
		low_color.rgb,
		high_color.rgb,
		flash
	);

	COLOR = vec4(
		tex.rgb * current_color,
		tex.a * opacity
	);
}