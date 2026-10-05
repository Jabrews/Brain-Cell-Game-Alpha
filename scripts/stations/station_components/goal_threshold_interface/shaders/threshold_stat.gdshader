shader_type canvas_item;

uniform float current_value : hint_range(0.0, 1.0) = 0.8;
uniform float dissolve_value : hint_range(0.0, 1.0) = 0.3;
uniform float defect_value : hint_range(0.0, 1.0) = 0.1;

uniform vec4 red_color : source_color = vec4(0.7, 0.0, 0.0, 1.0);
uniform vec4 orange_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec4 stripe_color : source_color = vec4(0.4, 0.0, 0.0, 1.0);
uniform vec4 blip_color : source_color = vec4(1.0, 0.85, 0.55, 1.0);

uniform vec4 mask_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float mask_tolerance : hint_range(0.0, 1.0) = 0.1;

uniform float flash_speed = 3.0;
uniform float defect_flash_speed = 7.0;
uniform float stripe_density = 80.0;
uniform float blip_width = 0.01;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	bool on_bar = tex.a > 0.0
		&& distance(tex.rgb, mask_color.rgb) <= mask_tolerance;

	if (on_bar) {
		float dissolve_start = max(current_value - dissolve_value, 0.0);
		float defect_end = min(dissolve_start + defect_value, current_value);

		if (UV.x <= current_value) {
			result.rgb = red_color.rgb;
		}

		// Flashing orange: the intended dissolve area.
		if (UV.x >= dissolve_start && UV.x <= current_value) {
			float flash = sin(TIME * flash_speed) * 0.5 + 0.5;
			result.rgb = mix(
				result.rgb,
				orange_color.rgb,
				mix(0.2, 0.8, flash)
			);
		}

		// Faster flashing stripes: the amount defect blocks.
		if (UV.x >= dissolve_start && UV.x <= defect_end) {
			float stripes = step(
				0.5,
				fract((UV.x + UV.y) * stripe_density)
			);
			float flash = sin(TIME * defect_flash_speed) * 0.5 + 0.5;
			result.rgb = mix(
				result.rgb,
				stripe_color.rgb,
				stripes * mix(0.45, 0.9, flash)
			);
		}

		if (abs(UV.x - current_value) <= blip_width) {
			result.rgb = blip_color.rgb;
		}
	}

	COLOR = result;
}