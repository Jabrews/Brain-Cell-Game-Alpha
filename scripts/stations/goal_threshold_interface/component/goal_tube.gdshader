shader_type spatial;
render_mode blend_mix, cull_disabled, shadows_disabled, unshaded;

uniform sampler2D water_texture : source_color, repeat_enable;

uniform vec4 red_color : source_color = vec4(0.75, 0.08, 0.04, 1.0);
uniform vec4 yellow_color : source_color = vec4(0.9, 0.72, 0.08, 1.0);

uniform float opacity : hint_range(0.0, 1.0) = 0.45;
uniform float yellow_fill : hint_range(0.0, 1.0) = 0.0;

uniform float bottom_y = 0.0;
uniform float top_y = 2.0;
uniform float edge_softness : hint_range(0.0, 0.5) = 0.05;

uniform float texture_scale = 1.0;
uniform float scroll_speed = 0.08;
uniform float texture_strength : hint_range(0.0, 1.0) = 0.25;

varying float local_y;

void vertex() {
	local_y = VERTEX.y;
}

void fragment() {
	// Scroll two copies of the texture in different directions.
	vec2 uv_a = UV * texture_scale
		+ vec2(TIME * scroll_speed, TIME * scroll_speed * 0.35);

	vec2 uv_b = UV * texture_scale * 1.37
		+ vec2(-TIME * scroll_speed * 0.47, TIME * scroll_speed * 0.63);

	float detail = (
		texture(water_texture, uv_a).r
		+ texture(water_texture, uv_b).r
	) * 0.5;

	// Yellow rises from bottom_y toward top_y.
	float yellow_line = mix(bottom_y, top_y, yellow_fill);
	float red_amount = smoothstep(
		yellow_line - edge_softness,
		yellow_line + edge_softness,
		local_y
	);

	vec3 tint = mix(yellow_color.rgb, red_color.rgb, red_amount);
	float texture_shading = mix(0.8, 1.2, detail);

	vec3 pattern = mix(
		texture(water_texture, uv_a).rgb,
		texture(water_texture, uv_b).rgb,
		0.5
	);

	ALBEDO = tint * mix(vec3(1.0), pattern, texture_strength);
	ALPHA = opacity;
}