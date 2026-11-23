shader_type canvas_item;

uniform float base_value : hint_range(0.0, 1.0) = 0.0;
uniform vec4 base_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float base_opacity : hint_range(0.0, 1.0) = 0.35;

uniform float yellow_min_value : hint_range(0.0, 1.0) = 0.0;
uniform float yellow_max_value : hint_range(0.0, 1.0) = 0.0;
uniform vec4 yellow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float yellow_opacity : hint_range(0.0, 1.0) = 0.85;

uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges = pixel_x >= edge_padding
		&& pixel_x <= tex_width - edge_padding;

	float fill_start = min(yellow_min_value, yellow_max_value);
	float fill_end = max(yellow_min_value, yellow_max_value);

	if (inside_edges && tex.a > 0.0) {
		if (UV.x <= base_value) {
			result.rgb = mix(result.rgb, base_color.rgb, base_opacity);
		}

		if (UV.x >= fill_start && UV.x <= fill_end) {
			result.rgb = mix(result.rgb, yellow_color.rgb, yellow_opacity);
		}
	}

	COLOR = result;
}