
shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable;

uniform float reveal_progress : hint_range(0.0, 1.0) = 0.0;
uniform float noise_scale = 4.0;
uniform float edge_softness : hint_range(0.001, 0.2) = 0.03;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float noise = texture(noise_texture, UV * noise_scale).r;

	float reveal = smoothstep(
		noise - edge_softness,
		noise + edge_softness,
		reveal_progress
	);

	if (reveal_progress <= 0.0) {
		reveal = 0.0;
	} else if (reveal_progress >= 1.0) {
		reveal = 1.0;
	}

	COLOR = vec4(tex.rgb, tex.a * reveal);
}
