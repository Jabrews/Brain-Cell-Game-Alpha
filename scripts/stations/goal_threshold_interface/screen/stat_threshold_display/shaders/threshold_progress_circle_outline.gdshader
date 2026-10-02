shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.5;

uniform vec4 base_color : source_color = vec4(0.15, 0.15, 0.15, 1.0);
uniform vec4 progress_color : source_color = vec4(0.2, 1.0, 0.8, 1.0);

// only pixels close to this color get affected
uniform vec4 mask_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// increase if anti-aliased pixels are being missed
uniform float mask_tolerance : hint_range(0.0, 1.0) = 0.1;


void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	// check if this pixel matches the chosen mask color
	float color_distance = distance(tex.rgb, mask_color.rgb);

	bool inside_mask =
		tex.a > 0.0 &&
		color_distance <= mask_tolerance;

	if (inside_mask) {

		// Center UV around 0,0
		vec2 centered_uv = UV - vec2(0.5);

		// Get angle around circle
		float angle = atan(centered_uv.y, centered_uv.x);

		// Convert -PI..PI into 0..1
		float circle_progress = (angle + PI) / (2.0 * PI);

		// Start at top
		circle_progress = fract(circle_progress + 0.25);

		float filled = step(circle_progress, progress);

		vec4 final_color = mix(
			base_color,
			progress_color,
			filled
		);

		result = vec4(
			final_color.rgb,
			tex.a
		);
	}

	COLOR = result;
}