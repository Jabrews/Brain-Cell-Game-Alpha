shader_type canvas_item;

uniform vec2 ghost_offset = vec2(-0.04, 0.0);
uniform vec4 ghost_color : source_color = vec4(0.6, 0.8, 1.0, 0.35);
uniform float ghost_strength : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 main_tex = texture(TEXTURE, UV);

	// Sample the texture again, slightly offset
	vec2 ghost_uv = UV + ghost_offset;
	vec4 ghost_tex = texture(TEXTURE, ghost_uv);

	// Prevent ghost from wrapping weirdly outside the texture
	if (ghost_uv.x < 0.0 || ghost_uv.x > 1.0 || ghost_uv.y < 0.0 || ghost_uv.y > 1.0) {
		ghost_tex = vec4(0.0);
	}

	ghost_tex *= ghost_color;
	ghost_tex.a *= ghost_strength;

	// Draw ghost behind main sprite
	COLOR = ghost_tex + main_tex;
}