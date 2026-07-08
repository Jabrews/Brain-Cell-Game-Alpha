shader_type canvas_item;

// values (0.0 → 1.0)
uniform float prisoner_value : hint_range(0.0, 1.0); // yellow
uniform float target_value : hint_range(0.0, 1.0);   // red
uniform float charge_value : hint_range(0.0, 1.0);   // striped preview

// colors
uniform vec4 yellow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 red_color : source_color = vec4(0.5, 0.0, 0.0, 1.0);

uniform vec4 charge_color_a : source_color = vec4(1.0, 1.0, 1.0, 1.0); // white
uniform vec4 charge_color_b : source_color = vec4(0.75, 0.75, 0.75, 1.0); // light gray

// opacity controls
uniform float overlap_opacity : hint_range(0.0, 1.0) = 0.3;
uniform float charge_opacity : hint_range(0.0, 1.0) = 0.9;

// stripe styling
uniform float stripe_amount : hint_range(2.0, 80.0) = 28.0;
uniform float stripe_slant : hint_range(-2.0, 2.0) = 0.8;

// edge padding
uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	float usable_width = tex_width - edge_padding * 2.0;

	bool inside_edges = pixel_x >= edge_padding && pixel_x <= tex_width - edge_padding;

	// Remaps the bar so 0.0 starts after the left padding
	// and 1.0 ends before the right padding.
	float bar_x = clamp((pixel_x - edge_padding) / usable_width, 0.0, 1.0);

	float in_yellow = step(bar_x, prisoner_value);
	float in_red = step(bar_x, target_value);

	// Charge goes between prisoner_value and charge_value.
	float charge_start = min(prisoner_value, charge_value);
	float charge_end = max(prisoner_value, charge_value);

	bool in_charge = bar_x >= charge_start && bar_x <= charge_end;

	vec4 result = tex;

	if (inside_edges && tex.a > 0.0) {

		// 1. draw yellow base
		if (in_yellow > 0.5) {
			result = vec4(yellow_color.rgb, tex.a);
		}

		// 2. draw striped charge preview
		if (in_charge) {
			float stripe_pattern = mod((UV.x + UV.y * stripe_slant) * stripe_amount, 1.0);

			vec4 striped_charge_color;

			if (stripe_pattern < 0.5) {
				striped_charge_color = charge_color_a;
			}
			else {
				striped_charge_color = charge_color_b;
			}

			result = mix(result, vec4(striped_charge_color.rgb, tex.a), charge_opacity);
		}

		// 3. draw red target on top
		if (in_red > 0.5) {

			// red over yellow/charge → transparent red
			if (in_yellow > 0.5 || in_charge) {
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