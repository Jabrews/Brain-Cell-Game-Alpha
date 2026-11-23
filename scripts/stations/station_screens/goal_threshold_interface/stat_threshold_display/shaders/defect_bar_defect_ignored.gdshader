shader_type canvas_item;

uniform float defect_value : hint_range(0.0, 1.0) = 0.3;

uniform vec4 mask_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float mask_tolerance : hint_range(0.0, 1.0) = 0.1;

uniform vec4 defect_color : source_color = vec4(0.8, 0.0, 0.0, 1.0);
uniform float flash_speed : hint_range(0.0, 20.0) = 6.0;
uniform float low_opacity : hint_range(0.0, 1.0) = 0.25;
uniform float high_opacity : hint_range(0.0, 1.0) = 1.0;

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

	if (inside_edges && inside_mask && UV.x <= defect_value) {
		float flash = sin(TIME * flash_speed) * 0.5 + 0.5;
		float opacity = mix(low_opacity, high_opacity, flash);

		result.rgb = mix(tex.rgb, defect_color.rgb, opacity);
	}

	COLOR = result;
}