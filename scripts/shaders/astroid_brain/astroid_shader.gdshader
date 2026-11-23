shader_type canvas_item;

uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_size = 1.0;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);

	vec2 offset = TEXTURE_PIXEL_SIZE * border_size;

	float nearby_alpha = 0.0;

	nearby_alpha += texture(TEXTURE, UV + vec2(offset.x, 0.0)).a;
	nearby_alpha += texture(TEXTURE, UV + vec2(-offset.x, 0.0)).a;
	nearby_alpha += texture(TEXTURE, UV + vec2(0.0, offset.y)).a;
	nearby_alpha += texture(TEXTURE, UV + vec2(0.0, -offset.y)).a;

	nearby_alpha += texture(TEXTURE, UV + vec2(offset.x, offset.y)).a;
	nearby_alpha += texture(TEXTURE, UV + vec2(-offset.x, offset.y)).a;
	nearby_alpha += texture(TEXTURE, UV + vec2(offset.x, -offset.y)).a;
	nearby_alpha += texture(TEXTURE, UV + vec2(-offset.x, -offset.y)).a;

	// If this pixel is part of the asteroid, keep original sprite.
	if (base_color.a > 0.0) {
		COLOR = base_color;
	}
	// If this transparent pixel is beside the asteroid, draw border.
	else if (nearby_alpha > 0.0) {
		COLOR = border_color;
	}
	// Otherwise stay transparent.
	else {
		COLOR = vec4(0.0);
	}
}