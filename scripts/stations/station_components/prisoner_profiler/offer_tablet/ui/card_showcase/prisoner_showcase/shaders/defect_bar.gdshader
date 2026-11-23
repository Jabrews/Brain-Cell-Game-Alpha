shader_type canvas_item;

uniform float defect_value : hint_range(0.0, 1.0) = 0.5;
uniform float fill_duration : hint_range(0.1, 5.0) = 0.8;

uniform vec4 fill_color : source_color = vec4(1.0, 0.2, 0.1, 1.0);
uniform float fill_opacity : hint_range(0.0, 1.0) = 0.85;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float progress = clamp(TIME / fill_duration, 0.0, 1.0);
	float eased_progress = 1.0 - pow(1.0 - progress, 3.0);
	float endpoint = defect_value * eased_progress;

	vec4 result = tex;

	if (tex.a > 0.0 && UV.x <= endpoint) {
		result.rgb = mix(tex.rgb, fill_color.rgb, fill_opacity);
	}

	COLOR = result;
}