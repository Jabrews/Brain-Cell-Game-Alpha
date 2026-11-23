shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.15, 0.15, 0.15, 1.0);
uniform vec4 stripe_color : source_color = vec4(0.8, 0.7, 0.1, 1.0);
uniform float stripe_size = 10.0;

void fragment() {
	float stripe = mod(floor((UV.x - UV.y) * stripe_size), 2.0);
	COLOR = mix(bg_color, stripe_color, stripe);
}