shader_type canvas_item;

uniform float red_value : hint_range(0.0, 1.0) = 0.8;
uniform float yellow_value : hint_range(0.0, 1.0) = 0.3;

uniform vec4 red_color : source_color = vec4(0.7, 0.0, 0.0, 1.0);
uniform vec4 yellow_color : source_color = vec4(1.0, 0.9, 0.0, 1.0);
uniform vec4 blip_color : source_color = vec4(1.0, 0.85, 0.55, 1.0);

// color on the sprite that this effect is allowed to replace
uniform vec4 mask_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// how close a pixel has to be to mask_color
uniform float mask_tolerance : hint_range(0.0, 1.0) = 0.1;

uniform float flash_speed : hint_range(0.0, 10.0) = 3.0;
uniform float yellow_low_opacity : hint_range(0.0, 1.0) = 0.2;
uniform float yellow_high_opacity : hint_range(0.0, 1.0) = 0.8;

uniform float blip_width : hint_range(0.001, 0.05) = 0.01;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	// distance between current pixel color and chosen mask color
	float color_distance = distance(tex.rgb, mask_color.rgb);

	bool inside_mask =
		tex.a > 0.0 &&
		color_distance <= mask_tolerance;

	if (inside_mask) {

		// -------------------------
		// RED BAR
		// -------------------------

		if (UV.x <= red_value) {
			result = vec4(red_color.rgb, tex.a);
		}


		// -------------------------
		// YELLOW BAR
		// starts at red_value
		// and extends left
		// -------------------------

		float yellow_start = max(
			red_value - yellow_value,
			0.0
		);

		bool in_yellow =
			UV.x >= yellow_start &&
			UV.x <= red_value;

		if (in_yellow) {
			float flash =
				sin(TIME * flash_speed) * 0.5 + 0.5;

			float opacity = mix(
				yellow_low_opacity,
				yellow_high_opacity,
				flash
			);

			result.rgb = mix(
				result.rgb,
				yellow_color.rgb,
				opacity
			);
		}


		// -------------------------
		// RED VALUE BLIP
		// -------------------------

		float dist_to_blip =
			abs(UV.x - red_value);

		if (dist_to_blip <= blip_width) {
			result.rgb = blip_color.rgb;
		}
	}

	COLOR = result;
}