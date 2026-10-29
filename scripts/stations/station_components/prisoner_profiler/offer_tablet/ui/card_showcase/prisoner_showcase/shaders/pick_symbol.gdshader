shader_type canvas_item;

uniform float bob_amount : hint_range(0.0, 32.0) = 4.0;
uniform float bob_speed : hint_range(0.1, 5.0) = 0.8;

void vertex() {
	VERTEX.y += sin(TIME * bob_speed) * bob_amount;
}