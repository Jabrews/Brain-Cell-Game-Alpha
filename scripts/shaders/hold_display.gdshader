shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 selected_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float white_threshold : hint_range(0.0, 1.0) = 0.85;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	bool is_white = (
		tex.r >= white_threshold &&
		tex.g >= white_threshold &&
		tex.b >= white_threshold &&
		tex.a > 0.0
	);

	bool is_selected_area = UV.x <= progress;

	if (is_white && is_selected_area) {
		COLOR = vec4(selected_color.rgb, tex.a);
	} else {
		COLOR = tex;
	}
}