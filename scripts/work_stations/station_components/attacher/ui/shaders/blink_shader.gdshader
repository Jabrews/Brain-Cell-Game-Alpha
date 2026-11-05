shader_type canvas_item;

uniform float low_opacity : hint_range(0.0, 1.0) = 0.2;
uniform float high_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float blink_speed : hint_range(0.1, 5.0) = 1.0;

void fragment() {
	COLOR = texture(TEXTURE, UV) * COLOR;

	float pulse = (sin(TIME * blink_speed * TAU) + 1.0) * 0.5;
	COLOR.a *= mix(low_opacity, high_opacity, pulse);
}