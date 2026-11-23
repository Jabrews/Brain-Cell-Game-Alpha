shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

uniform vec4 target_color : source_color = vec4(1.0, 0.0, 1.0, 1.0);
uniform float tolerance = 0.1;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float flash_strength = 0.5;
uniform float flash_speed = 4.0;

uniform float bounce_height = 6.0;
uniform float bounce_speed = 3.0;


void vertex()
{
	// bounce sprite up/down
	VERTEX.y += sin(TIME * bounce_speed) * bounce_height;
}


void fragment() 
{
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 sprite_color = texture(TEXTURE, UV);

	// compare screen color to target color
	float color_distance = distance(screen_color.rgb, target_color.rgb);

	// only show sprite on matching colors
	if (color_distance <= tolerance)
	{
		// flashing effect
		float flash = (sin(TIME * flash_speed) + 1.0) * 0.5;

		vec3 flashed_color = mix(
			sprite_color.rgb,
			flash_color.rgb,
			flash * flash_strength
		);

		COLOR = vec4(flashed_color, sprite_color.a);
	}
	else
	{
		discard;
	}
}