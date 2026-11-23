shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.5;

uniform vec4 base_color : source_color = vec4(0.15, 0.15, 0.15, 1.0);
uniform vec4 progress_color : source_color = vec4(0.2, 1.0, 0.8, 1.0);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Center UV around 0,0
	vec2 centered_uv = UV - vec2(0.5);

	// Get angle around circle
	float angle = atan(centered_uv.y, centered_uv.x);

	// Convert angle from -PI..PI into 0..1
	float circle_progress = (angle + PI) / (2.0 * PI);

	// Rotate starting point so progress begins at top
	circle_progress = fract(circle_progress + 0.25);

	// Determine whether this part of ring is filled
	float filled = step(circle_progress, progress);

	vec4 final_color = mix(
		base_color,
		progress_color,
		filled
	);

	COLOR = vec4(
		final_color.rgb,
		final_color.a * tex.a
	);
}