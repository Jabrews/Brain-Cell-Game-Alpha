shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(0.15, 0.15, 0.15, 1.0);
uniform vec4 color_b : source_color = vec4(0.20, 0.20, 0.20, 1.0);
uniform float stripe_size = 12.0;

void fragment() {
	float stripe = mod(floor((UV.x + UV.y) * stripe_size), 2.0);
	COLOR = mix(color_a, color_b, stripe);
}