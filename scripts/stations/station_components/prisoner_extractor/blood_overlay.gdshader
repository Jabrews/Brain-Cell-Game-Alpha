shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;

uniform sampler2D base_texture : source_color;
uniform sampler2D noise_texture : source_color;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float edge_softness : hint_range(0.0, 0.2) = 0.02;

void fragment() {

	vec2 uv = UV;

	vec4 base = texture(base_texture, uv);
	float noise = texture(noise_texture, uv).r;

	// Pixels disappear according to the noise value.
	float mask = smoothstep(
		progress - edge_softness,
		progress + edge_softness,
		noise
	);

	ALBEDO = base.rgb;
	ALPHA = base.a * mask;
}