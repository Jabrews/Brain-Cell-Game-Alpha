
shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.8;
uniform float new_value : hint_range(0.0, 1.0) = 0.5;

uniform vec4 fill_color : source_color = vec4(1.0, 0.1, 0.1, 1.0);
uniform vec4 hologram_color : source_color = vec4(0.2, 0.85, 1.0, 1.0);

uniform float hologram_opacity : hint_range(0.0, 1.0) = 0.45;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.3;
uniform float scanline_density : hint_range(10.0, 300.0) = 120.0;
uniform float animation_speed : hint_range(0.0, 10.0) = 2.0;


float random(vec2 uv) {
	return fract(
		sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453
	);
}


void fragment() {
	vec2 uv = UV;

	COLOR = vec4(0.0);

	// Solid red fill
	if (uv.x <= progress) {
		COLOR = fill_color;
	}

	// Hologram overlay between new_value and progress
	if (uv.x > new_value && uv.x <= progress) {
		float time = TIME * animation_speed;

		// Animated noise
		float noise = random(
			floor(uv * vec2(180.0, 90.0) + vec2(time * 15.0, time * 7.0))
		);

		// Scanlines
		float scanlines = sin(
			uv.y * scanline_density + time * 6.0
		);

		// Flicker
		float flicker = 0.85 + 0.15 * sin(time * 12.0);

		// Hologram intensity
		float intensity = 0.75;
		intensity += (noise - 0.5) * noise_strength;
		intensity += scanlines * 0.12;

		intensity = clamp(intensity * flicker, 0.0, 1.0);

		// Blend hologram over red
		float blend_amount = intensity * hologram_opacity;

		COLOR.rgb = mix(
			fill_color.rgb,
			hologram_color.rgb,
			blend_amount
		);

		COLOR.a = fill_color.a;
	}
}
