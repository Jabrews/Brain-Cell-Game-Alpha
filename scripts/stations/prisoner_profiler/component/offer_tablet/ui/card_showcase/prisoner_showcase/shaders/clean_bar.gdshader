shader_type canvas_item;

uniform float base_value : hint_range(0.0, 1.0) = 0.0;
uniform vec4 base_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float base_opacity : hint_range(0.0, 1.0) = 0.35;

uniform float prisoner_value : hint_range(0.0, 1.0) = 0.0;
uniform vec4 prisoner_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float prisoner_opacity : hint_range(0.0, 1.0) = 0.85;

uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges = pixel_x >= edge_padding
		&& pixel_x <= tex_width - edge_padding;

	if (inside_edges && tex.a > 0.0) {
		if (UV.x <= base_value) {
			result.rgb = mix(result.rgb, base_color.rgb, base_opacity);
		}

		if (UV.x <= prisoner_value) {
			result.rgb = mix(result.rgb, prisoner_color.rgb, prisoner_opacity);
		}
	}

	COLOR = result;
}