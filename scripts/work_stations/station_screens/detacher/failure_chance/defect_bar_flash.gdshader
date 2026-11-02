shader_type canvas_item;

uniform bool flash_enabled = false;
uniform float flash_speed = 5.0;
uniform float min_opacity : hint_range(0.0, 1.0) = 0.25;

void fragment() {
	vec4 color = texture(TEXTURE, UV) * COLOR;

	if (flash_enabled) {
		float pulse = sin(TIME * flash_speed) * 0.5 + 0.5;
		float opacity = mix(min_opacity, 1.0, pulse);
		color.a *= opacity;
	}

	COLOR = color;
}