shader_type canvas_item;

uniform vec4 final_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float duration = 2.0;
uniform float distortion_strength = 0.02;
uniform float distortion_speed = 1.0;

uniform sampler2D noise_texture;
uniform float noise_scale = 4.0;

varying vec4 inherited_modulate;


void vertex() {
	inherited_modulate = COLOR;
}


void fragment() {

	vec2 uv = UV;

	// time-based dissolve
	float t = fract(TIME / duration);

	// distortion
	vec2 noise_uv = uv * noise_scale + vec2(TIME * distortion_speed);
	vec2 noise = texture(noise_texture, noise_uv).rg;

	uv += (noise - 0.5) * distortion_strength;

	vec4 tex = texture(TEXTURE, uv);

	// dissolve mask
	float dissolve_noise = texture(noise_texture, uv * noise_scale).r;

	// smooth dissolve edge
	float edge = smoothstep(t - 0.1, t + 0.1, dissolve_noise);

	// blend into final color
	vec3 final_rgb = mix(tex.rgb, final_color.rgb, edge);

	// apply inherited modulation
	COLOR = vec4(final_rgb, tex.a) * inherited_modulate;
}