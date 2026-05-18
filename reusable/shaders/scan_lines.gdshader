shader_type canvas_item;

uniform float line_opacity : hint_range(0.0, 1.0) = 0.12;
uniform float line_thickness : hint_range(0.1, 4.0) = 1.0;
uniform float line_spacing : hint_range(2.0, 12.0) = 4.0;
uniform float scroll_speed : hint_range(0.0, 5.0) = 0.2;

void fragment() {
	vec2 uv = UV;
	
	// slight scrolling makes it feel more alive
	float y = uv.y * 600.0 + TIME * scroll_speed * 60.0;
	
	// repeating horizontal lines
	float line = step(1.0 - line_thickness / line_spacing, fract(y / line_spacing));
	
	// black scanlines
	COLOR = vec4(0.0, 0.0, 0.0, line * line_opacity);
}