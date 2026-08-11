shader_type canvas_item;

uniform bool hologram_enabled = false;

uniform float shimmer_speed : hint_range(0.0, 5.0) = 1.2;
uniform float shimmer_strength : hint_range(0.0, 1.0) = 0.15;

uniform float scanline_strength : hint_range(0.0, 1.0) = 0.08;
uniform float scanline_density : hint_range(1.0, 300.0) = 90.0;

uniform vec4 hologram_tint : source_color = vec4(0.7, 0.9, 1.0, 1.0);


void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (hologram_enabled) {
		float shimmer_position =
			UV.x +
			UV.y * 0.35 +
			TIME * shimmer_speed;

		float shimmer =
			sin(shimmer_position * 12.0) * 0.5 + 0.5;

		shimmer = pow(shimmer, 8.0);

		float scanline =
			sin(UV.y * scanline_density + TIME * 3.0);

		scanline = scanline * 0.5 + 0.5;

		vec3 final_color = COLOR.rgb * hologram_tint.rgb;

		final_color += shimmer * shimmer_strength;
		final_color *= 1.0 - scanline * scanline_strength;

		COLOR = vec4(
			final_color,
			tex.a * COLOR.a
		);
	}
	else {
		COLOR = vec4(
			COLOR.rgb,
			tex.a * COLOR.a
		);
	}
}
