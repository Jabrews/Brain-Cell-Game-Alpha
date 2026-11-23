shader_type canvas_item;

// values 0.0 → 1.0
uniform float old_prisoner_value : hint_range(0.0, 1.0);
uniform float new_prisoner_value : hint_range(0.0, 1.0);
uniform float target_value : hint_range(0.0, 1.0);

// colors
uniform vec4 old_color : source_color = vec4(0.45, 0.45, 0.0, 1.0); // dark yellow
uniform vec4 new_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);   // bright yellow
uniform vec4 target_color : source_color = vec4(0.5, 0.0, 0.0, 1.0); // red

// target overlap opacity
uniform float overlap_opacity : hint_range(0.0, 1.0) = 0.35;

// edge padding
uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges = pixel_x >= edge_padding && pixel_x <= (tex_width - edge_padding);

	float in_old = step(UV.x, old_prisoner_value);
	float in_new = step(UV.x, new_prisoner_value);
	float in_target = step(UV.x, target_value);

	vec4 result = tex;

	if (inside_edges && tex.a > 0.0) {

		// 1. old prisoner value first
		if (in_old > 0.5) {
			result = vec4(old_color.rgb, tex.a);
		}

		// 2. new prisoner value over old
		if (in_new > 0.5) {
			result = vec4(new_color.rgb, tex.a);
		}

		// 3. target value over both
		if (in_target > 0.5) {
			if (in_old > 0.5 || in_new > 0.5) {
				result = mix(result, vec4(target_color.rgb, tex.a), overlap_opacity);
			}
			else {
				result = vec4(target_color.rgb, tex.a);
			}
		}
	}

	COLOR = result;
}