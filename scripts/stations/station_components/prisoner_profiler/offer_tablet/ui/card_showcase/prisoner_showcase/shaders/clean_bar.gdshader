shader_type canvas_item;

uniform float prisoner_value : hint_range(0.0, 1.0) = 0.0;
uniform vec4 prisoner_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float prisoner_opacity : hint_range(0.0, 1.0) = 0.85;

uniform float base_min_value : hint_range(0.0, 1.0) = 0.0;
uniform float base_max_value : hint_range(0.0, 1.0) = 0.0;
uniform vec4 base_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);

uniform float low_opacity : hint_range(0.0, 1.0) = 0.25;
uniform float high_opacity : hint_range(0.0, 1.0) = 0.85;
uniform float fade_speed : hint_range(0.1, 10.0) = 2.0;

uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges = pixel_x >= edge_padding
		&& pixel_x <= tex_width - edge_padding;

	float flash = (sin(TIME * fade_speed) + 1.0) * 0.5;
	float flash_opacity = mix(low_opacity, high_opacity, flash);

	float range_start = min(base_min_value, base_max_value);
	float range_end = max(base_min_value, base_max_value);

	if (inside_edges && tex.a > 0.0) {
		// Static prisoner value fills from the left.
		if (UV.x <= prisoner_value) {
			result.rgb = mix(result.rgb, prisoner_color.rgb, prisoner_opacity);
		}

		// The min-to-max range flashes over the prisoner value.
		if (UV.x >= range_start && UV.x <= range_end) {
			result.rgb = mix(result.rgb, base_color.rgb, flash_opacity);
		}
	}

	COLOR = result;
}