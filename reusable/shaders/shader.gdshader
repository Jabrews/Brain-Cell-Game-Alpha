shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_nearest;

uniform float darkness_start = 0.65; // lower = affects more of image
uniform float darkness_end = 0.25;   // darkest point
uniform float pattern_scale = 1.0;   // bigger = larger pattern
uniform float strength = 1.0;        // how much black gets added

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 screen_col = texture(screen_tex, uv);

	// basic luminance
	float light = dot(screen_col.rgb, vec3(0.299, 0.587, 0.114));

	// only affect dark areas
	float dark_mask = 1.0 - smoothstep(darkness_end, darkness_start, light);

	// screen-space pixel coords
	vec2 p = floor(FRAGCOORD.xy / pattern_scale);

	// diagonal cross / zig-zag style pattern
	float diag1 = mod(p.x + p.y, 4.0);
	float diag2 = mod(p.x - p.y, 4.0);

	float pattern = 0.0;

	// make little crossing diagonal bands
	if (diag1 == 0.0 || diag2 == 0.0) {
		pattern = 1.0;
	}

	// apply darkening only where pattern exists and image is dark
	float amt = pattern * dark_mask * strength;

	vec3 final_col = mix(screen_col.rgb, vec3(0.0), amt);

	COLOR = vec4(final_col, 1.0);
}