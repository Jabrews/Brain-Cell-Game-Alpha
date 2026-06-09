shader_type canvas_item;

// values (0 → 1)
uniform float prior_defect_value : hint_range(0.0, 1.0); // old defect
uniform float new_defect_value : hint_range(0.0, 1.0);   // new defect

// colors
uniform vec4 prior_defect_color : source_color = vec4(0.5, 0.0, 0.0, 1.0);
uniform vec4 new_defect_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

// overlap opacity: new defect over prior defect
uniform float overlap_opacity : hint_range(0.0, 1.0) = 0.3;

// edge padding
uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges = pixel_x >= edge_padding && pixel_x <= (tex_width - edge_padding);

	float in_prior_defect = step(UV.x, prior_defect_value);
	float in_new_defect = step(UV.x, new_defect_value);

	vec4 result = tex;

	if (inside_edges && tex.a > 0.0) {

		// 1. draw prior defect base
		if (in_prior_defect > 0.5) {
			result = vec4(prior_defect_color.rgb, tex.a);
		}

		// 2. draw new defect on top
		if (in_new_defect > 0.5) {

			// overlap → transparent new defect color
			if (in_prior_defect > 0.5) {
				result = mix(result, vec4(new_defect_color.rgb, tex.a), overlap_opacity);
			}
			// new defect over empty → full new defect color
			else {
				result = vec4(new_defect_color.rgb, tex.a);
			}
		}
	}

	COLOR = result;
}
