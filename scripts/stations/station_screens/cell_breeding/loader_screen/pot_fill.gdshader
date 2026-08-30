shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform float tolerance : hint_range(0.0, 1.0) = 0.05;

uniform float current_value : hint_range(0.0, 1.0) = 0.5;
uniform float secondary_value : hint_range(0.0, 1.0) = 0.7;

uniform vec4 current_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 secondary_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

uniform float pulse_speed : hint_range(0.1, 10.0) = 2.0;


void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Detect the selected grey color
	float difference = distance(tex.rgb, target_color.rgb);

	float target_mask = 1.0 - smoothstep(
		0.0,
		tolerance,
		difference
	);

	// Fill from bottom to top
	float height = 1.0 - UV.y;

	float current_mask = step(height, current_value);
	float secondary_mask = step(height, secondary_value);

	// Pulsing opacity for secondary value
	float pulse = (sin(TIME * pulse_speed * 3.14159) + 1.0) / 2.0;
	float secondary_alpha = mix(0.25, 0.75, pulse);

	// Selected grey is transparent by default
	vec4 result = tex;

	if (target_mask > 0.0) {
		result.a = 0.0;
	}

	// Secondary fill
	if (secondary_mask > 0.0) {
		result = mix(
			result,
			vec4(secondary_color.rgb, secondary_alpha),
			target_mask
		);
	}

	// Current fill
	if (current_mask > 0.0) {
		result = mix(
			result,
			current_color,
			target_mask
		);
	}

	COLOR = result;
}