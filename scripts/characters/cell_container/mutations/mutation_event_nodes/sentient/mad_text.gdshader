shader_type canvas_item;

uniform bool shake_enabled = false;

uniform float horizontal_strength = 1.0;
uniform float vertical_strength = 1.0;
uniform float shake_speed = 35.0;

void vertex() {
	if (shake_enabled) {
		float horizontal_offset = sin(
			TIME * shake_speed + VERTEX.y * 0.25
		) * horizontal_strength;

		float vertical_offset = cos(
			TIME * shake_speed * 1.17 + VERTEX.x * 0.20
		) * vertical_strength;

		VERTEX += vec2(
			horizontal_offset,
			vertical_offset
		);
	}
}