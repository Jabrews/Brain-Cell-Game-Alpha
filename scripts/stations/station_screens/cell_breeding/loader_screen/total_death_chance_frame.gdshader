shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 fill_color : source_color = vec4(1.0);

uniform float tolerance : hint_range(0.0, 1.0) = 0.05;
uniform float progress : hint_range(0.0, 1.0) = 0.0;


void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Find pixels matching the selected color
	float difference = distance(tex.rgb, target_color.rgb);

	float target_mask = 1.0 - smoothstep(
		0.0,
		tolerance,
		difference
	);

	// Perimeter position
	float perimeter;

	if (UV.y < 0.5 && UV.x < 0.5) {
		perimeter = UV.x * 0.5;
	}
	else if (UV.y < 0.5) {
		perimeter = 0.25 + UV.y * 0.5;
	}
	else if (UV.x > 0.5) {
		perimeter = 0.5 + (1.0 - UV.x) * 0.5;
	}
	else {
		perimeter = 0.75 + (1.0 - UV.y) * 0.5;
	}

	// Has the white fill reached this pixel?
	float fill_mask = step(perimeter, progress);

	// Selected color is transparent until the fill reaches it
	float alpha = tex.a * (1.0 - target_mask);
	alpha += target_mask * fill_mask;

	vec3 final_color = mix(tex.rgb, fill_color.rgb, target_mask * fill_mask);

	COLOR = vec4(final_color, alpha);
}