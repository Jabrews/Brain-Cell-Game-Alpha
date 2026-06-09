shader_type canvas_item;

uniform float prisoner_value : hint_range(0.0, 1.0);
uniform float target_value : hint_range(0.0, 1.0);
uniform float start_value : hint_range(0.0, 1.0);

uniform vec4 yellow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 red_color : source_color = vec4(0.5, 0.0, 0.0, 1.0);

uniform vec4 increase_color : source_color = vec4(0.2, 0.8, 1.0, 1.0);
uniform vec4 decrease_color : source_color = vec4(1.0, 0.2, 0.2, 1.0);

uniform float overlap_opacity : hint_range(0.0, 1.0) = 0.3;
uniform float overlay_opacity : hint_range(0.0, 1.0) = 0.7;
uniform float stripe_width : hint_range(0.01, 0.5) = 0.08;
uniform float stripe_speed : hint_range(0.1, 5.0) = 0.5;

// Keeps shader from coloring the white/empty edge pixels.
uniform float edge_padding : hint_range(0.0, 20.0) = 0.0;

void fragment() {

	vec4 tex = texture(TEXTURE, UV);

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges =
		pixel_x >= edge_padding &&
		pixel_x <= (tex_width - edge_padding);

	float in_yellow = step(UV.x, prisoner_value);
	float in_red = step(UV.x, target_value);

	vec4 result = tex;

	if (inside_edges && tex.a > 0.0) {

		// Prisoner bar
		if (in_yellow > 0.5) {
			result = vec4(yellow_color.rgb, tex.a);
		}

		// Target bar
		if (in_red > 0.5) {

			if (in_yellow > 0.5) {
				result = mix(
					result,
					vec4(red_color.rgb, tex.a),
					overlap_opacity
				);
			}
			else {
				result = vec4(red_color.rgb, tex.a);
			}
		}

		// Change stripe
		float left = min(start_value, prisoner_value);
		float right = max(start_value, prisoner_value);

		if (
			right - left > 0.001 &&
			UV.x >= left &&
			UV.x <= right
		) {

			float region_uv = (UV.x - left) / (right - left);

			vec4 overlay_color;
			float stripe_pos;

			if (prisoner_value > start_value) {
				// Increase -> blue -> move right
				overlay_color = increase_color;
				stripe_pos = fract(TIME * stripe_speed);
			}
			else {
				// Decrease -> red -> move left
				overlay_color = decrease_color;
				stripe_pos = 1.0 - fract(TIME * stripe_speed);
			}

			float stripe =
				smoothstep(
					stripe_pos - stripe_width,
					stripe_pos,
					region_uv
				)
				*
				(
					1.0
					-
					smoothstep(
						stripe_pos,
						stripe_pos + stripe_width,
						region_uv
					)
				);

			result.rgb = mix(
				result.rgb,
				overlay_color.rgb,
				stripe * overlay_opacity
			);
		}
	}

	COLOR = result;
}