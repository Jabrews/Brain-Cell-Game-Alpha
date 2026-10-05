shader_type canvas_item;

uniform float prisoner_value : hint_range(0.0, 1.0) = 0.6;
uniform float flash_value : hint_range(0.0, 1.0) = 0.3;

uniform vec4 mask_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float mask_tolerance : hint_range(0.0, 1.0) = 0.1;

uniform vec4 yellow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 flash_color : source_color = vec4(1.0, 0.55, 0.0, 1.0);

uniform float flash_speed = 3.0;
uniform float edge_padding : hint_range(0.0, 20.0) = 5.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	float tex_width = float(textureSize(TEXTURE, 0).x);
	float pixel_x = UV.x * tex_width;

	bool inside_edges =
		pixel_x >= edge_padding &&
		pixel_x <= tex_width - edge_padding;

	bool inside_mask =
		tex.a > 0.0 &&
		distance(tex.rgb, mask_color.rgb) <= mask_tolerance;

	if (inside_edges && inside_mask) {
		if (UV.x <= prisoner_value) {
			result.rgb = yellow_color.rgb;
		}

		if (UV.x <= flash_value) {
			float flash = sin(TIME * flash_speed) * 0.5 + 0.5;
			result.rgb = mix(result.rgb, flash_color.rgb, flash);
		}
	}

	COLOR = result;
}