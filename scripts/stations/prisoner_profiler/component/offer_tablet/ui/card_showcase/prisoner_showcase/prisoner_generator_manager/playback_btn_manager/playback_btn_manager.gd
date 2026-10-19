extends Node

# btn ui components
@onready var btn_texture_rect : TextureRect = $"../../PrisGenerator/Header/PlaybackBtn/BtnTextureRect"
# textures
@onready var play_texture: Texture = preload("res://models/prisoner_profiler/prisoner_showcase/pris_generator/media_control_start.png")
@onready var pause_texture: Texture = preload("res://models/prisoner_profiler/prisoner_showcase/pris_generator/media_control_stop.png")
# components
@onready var parent_pris_gen_manager : Node = $".."

var curr_playback_type : String = 'play'

func _handle_btn_pressed() : 
	
	if parent_pris_gen_manager.active_screen == 'loading' : 
		return
	
	if curr_playback_type == "play":
		curr_playback_type = "pause"
	else:
		curr_playback_type = "play"
	
	update_btn_texture()
	
	var is_paused : bool = curr_playback_type == 'pause'
	parent_pris_gen_manager._toggle_pause(is_paused)
	

func _reset() : 
	curr_playback_type = 'play'
	update_btn_texture()

func update_btn_texture() : 
	match curr_playback_type : 
		'play' :
			btn_texture_rect.texture = play_texture 
		'pause' : 
			btn_texture_rect.texture = pause_texture
