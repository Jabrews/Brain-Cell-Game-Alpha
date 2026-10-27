shader_type canvas_item;

uniform float current_value : hint_range(0.0, 1.0) = 0.8;
uniform float dissolve_value : hint_range(0.0, 1.0) = 0.3;
uniform float defect_value : hint_range(0.0, 1.0) = 0.1;

uniform vec4 red_color : source_color = vec4(0.7, 0.0, 0.0, 1.0);
uniform vec4 stripe_color : source_color = vec4(0.4, 0.0, 0.0, 1.0);
uniform vec4 yellow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 blip_color : source_color = vec4(1.0, 0.85, 0.55, 1.0);

uniform vec4 mask_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float mask_tolerance : hint_range(0.0, 1.0) = 0.1;

uniform float defect_flash_speed = 7.0;
uniform float stripe_density = 80.0;
uniform float blip_width = 0.01;
uniform float low_stripe_opacity : hint_range(0.0, 1.0) = 0.15;


void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	bool on_bar = (
		tex.a > 0.0
		&& distance(tex.rgb, mask_color.rgb) <= mask_tolerance
	);

	if (on_bar) {
		float dissolve_start = max(current_value - dissolve_value, 0.0);
		float defect_end = min(dissolve_start + defect_value, current_value);

		if (UV.x <= current_value) {
			result.rgb = red_color.rgb;
		}

		// Striped defect portion.
		if (UV.x >= dissolve_start && UV.x <= defect_end) {
			float stripes = step(
				0.5,
				fract((UV.x + UV.y) * stripe_density)
			);

			float pulse = sin(TIME * defect_flash_speed) * 0.5 + 0.5;
			float stripe_opacity = mix(low_stripe_opacity, 1.0, pulse);

			result.rgb = mix(
				red_color.rgb,
				stripe_color.rgb,
				stripes * stripe_opacity
			);
		}
		// Usable contribution beside the defect stripes.
		else if (UV.x > defect_end && UV.x <= current_value
				&& UV.x >= dissolve_start) {
			result.rgb = yellow_color.rgb;
		}

		// Blip at the current threshold value.
		if (abs(UV.x - current_value) <= blip_width) {
			result.rgb = blip_color.rgb;
		}
	}

	COLOR = result;
}