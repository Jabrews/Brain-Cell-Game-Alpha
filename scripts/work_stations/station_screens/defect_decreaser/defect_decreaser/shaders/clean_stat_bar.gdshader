
shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 fill_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	if (UV.x <= progress) {
		COLOR = fill_color;
	} else {
		COLOR = vec4(0.0);
	}
}
