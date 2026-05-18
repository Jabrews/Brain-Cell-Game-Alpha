shader_type canvas_item;

// values (0 → 1)
uniform float prisoner_value : hint_range(0.0, 1.0); // yellow
uniform float target_value : hint_range(0.0, 1.0);   // red

// colors
uniform vec4 yellow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 red_color : source_color = vec4(0.5, 0.0, 0.0, 1.0);

// overlap opacity (red over yellow)
uniform float overlap_opacity : hint_range(0.0, 1.0) = 0.3;

// edge padding
uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges = pixel_x >= edge_padding && pixel_x <= (tex_width - edge_padding);

	float in_yellow = step(UV.x, prisoner_value);
	float in_red = step(UV.x, target_value);

	vec4 result = tex;

	if (inside_edges && tex.a > 0.0) {

		// 1. draw yellow base
		if (in_yellow > 0.5) {
			result = vec4(yellow_color.rgb, tex.a);
		}

		// 2. draw red on top
		if (in_red > 0.5) {

			// overlap → transparent red
			if (in_yellow > 0.5) {
				result = mix(result, vec4(red_color.rgb, tex.a), overlap_opacity);
			}
			// red over empty → full red
			else {
				result = vec4(red_color.rgb, tex.a);
			}
		}
	}

	COLOR = result;
}