extends Node


@export var curr_side : String 

@onready var s_cycle_sound : AudioStreamPlayer3D = $CycleStat
@onready var s_invalid_stat : AudioStreamPlayer3D = $InvalidStat
@onready var s_feedback_sound : AudioStreamPlayer3D = $FeedbackSound
@onready var s_skull_warning : AudioStreamPlayer3D = $SkullWarning

var can_play_warning_feedback_sound : bool = true

func _ready() -> void:
	GLBreedingComponetsBus.connect('breeding_station_feedback_requested', _handle_feedback_sound)
	GLBreedingComponetsBus.connect('play_sound_skull_warning', _handle_play_sound_skull_warning)

func play_cycle() :
	s_cycle_sound.play()

func play_invalid_stat() :
	s_invalid_stat.play()

func _handle_feedback_sound(side : String, _type : String):

	if can_play_warning_feedback_sound:	
		if side == curr_side:
			s_feedback_sound.play()
			can_play_warning_feedback_sound = false
			await get_tree().create_timer(3.0).timeout
			can_play_warning_feedback_sound = true

func _handle_play_sound_skull_warning(side : String) :
	if side == curr_side : 
		s_skull_warning.play()
	
	
