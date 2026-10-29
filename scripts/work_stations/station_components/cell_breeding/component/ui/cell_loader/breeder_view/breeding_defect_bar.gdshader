shader_type canvas_item;

// values (0 → 1)
uniform float prior_defect_value : hint_range(0.0, 1.0); // old defect
uniform float new_defect_value : hint_range(0.0, 1.0);   // new defect

// colors
uniform vec4 prior_defect_color : source_color = vec4(0.5, 0.0, 0.0, 1.0);
uniform vec4 new_defect_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 flash_defect_color : source_color = vec4(1.0, 0.7, 0.7, 1.0);

// overlap opacity: new defect over prior defect
uniform float overlap_opacity : hint_range(0.0, 1.0) = 0.3;

// flash
uniform float flash_speed : hint_range(0.1, 10.0) = 3.0;

// edge padding
uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges = pixel_x >= edge_padding && pixel_x <= (tex_width - edge_padding);

	float in_prior_defect = step(UV.x, prior_defect_value);
	float in_new_defect = step(UV.x, new_defect_value);

	// only flash the region where new defect extends past old defect
	float extra_start = prior_defect_value;
	float extra_end = new_defect_value;

	bool has_extra_region = new_defect_value > prior_defect_value;
	bool in_extra_region = has_extra_region && UV.x > extra_start && UV.x <= extra_end;

	// 0 -> 1 -> 0
	float flash = (sin(TIME * flash_speed) + 1.0) * 0.5;

	vec4 result = tex;

	if (inside_edges && tex.a > 0.0) {

		// 1. draw prior defect base
		if (in_prior_defect > 0.5) {
			result = vec4(prior_defect_color.rgb, tex.a);
		}

		// 2. draw new defect
		if (in_new_defect > 0.5) {

			// overlap with prior stays semi-transparent
			if (in_prior_defect > 0.5) {
				result = mix(result, vec4(new_defect_color.rgb, tex.a), overlap_opacity);
			}
			// new-only area
			else {
				result = vec4(new_defect_color.rgb, tex.a);
			}
		}

		// 3. only flash the extra region beyond the old defect
		if (in_extra_region) {
			vec3 flashed_color = mix(
				new_defect_color.rgb,
				flash_defect_color.rgb,
				flash
			);
			result = vec4(flashed_color, tex.a);
		}
	}

	COLOR = result;
}