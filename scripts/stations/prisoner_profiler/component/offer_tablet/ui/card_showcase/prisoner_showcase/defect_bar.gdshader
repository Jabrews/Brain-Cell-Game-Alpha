shader_type canvas_item;

uniform float value : hint_range(0.0, 1.0) = 0.5;
uniform float fill_duration : hint_range(0.1, 5.0) = 0.8;

uniform float wander_amount : hint_range(0.0, 0.2) = 0.04;
uniform float wander_speed : hint_range(0.1, 5.0) = 1.0;
uniform float random_seed = 1.0;

uniform vec4 fill_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float fill_opacity : hint_range(0.0, 1.0) = 0.85;

float random_value(float seed) {
	return fract(sin(seed * 127.1 + random_seed * 311.7) * 43758.5453);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float elapsed = TIME;

	float endpoint;

	if (elapsed < fill_duration) {
		// Ease the fill from 0 to the target value.
		float progress = clamp(elapsed / fill_duration, 0.0, 1.0);
		float eased_progress = 1.0 - pow(1.0 - progress, 3.0);
		endpoint = value * eased_progress;
	} else {
		// Pick new random endpoints around the target and ease between them.
		float wander_time = (elapsed - fill_duration) * wander_speed;
		float segment = floor(wander_time);
		float blend = smoothstep(0.0, 1.0, fract(wander_time));

		float offset_a = 0.0;
		if (segment > 0.0) {
			offset_a = random_value(segment) * 2.0 - 1.0;
		}

		float offset_b = random_value(segment + 1.0) * 2.0 - 1.0;

		float offset = mix(offset_a, offset_b, blend) * wander_amount;
		endpoint = clamp(value + offset, 0.0, 1.0);
	}

	vec4 result = tex;

	if (tex.a > 0.0 && UV.x <= endpoint) {
		result.rgb = mix(tex.rgb, fill_color.rgb, fill_opacity);
	}

	COLOR = result;
}