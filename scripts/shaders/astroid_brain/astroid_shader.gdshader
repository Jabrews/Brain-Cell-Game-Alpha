shader_type canvas_item;

uniform vec2 ghost_offset = vec2(8.0, 0.0);
uniform vec4 ghost_color : source_color = vec4(0.6, 0.9, 1.0, 0.35);
uniform float ghost_alpha = 0.35;

void fragment() {
	vec4 real_sprite = texture(TEXTURE, UV);

	vec2 ghost_uv = UV + ghost_offset * TEXTURE_PIXEL_SIZE;
	vec4 ghost_sprite = texture(TEXTURE, ghost_uv);

	ghost_sprite.rgb *= ghost_color.rgb;
	ghost_sprite.a *= ghost_alpha;

	COLOR = ghost_sprite + real_sprite;
}
