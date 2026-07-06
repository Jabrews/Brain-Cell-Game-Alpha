extends Node
#
#
#@onready var s_cycle_sound : AudioStreamPlayer3D = $CycleStat
#@onready var s_invalid_stat : AudioStreamPlayer3D = $InvalidStat
#@onready var s_feedback_sound : AudioStreamPlayer3D = $"../../RightSeat/AudioManager/FeedbackSound"
#
#
#var can_play_warning_feedback_sound : bool = true
#
#func _ready() -> void:
	#GLBreedingComponetsBus.connect('breeding_station_feedback_requested', _handle_feedback_sound)
#
#func play_cycle() :
	#s_cycle_sound.play()
#
#func play_invalid_stat() :
	#s_invalid_stat.play()
#
#func _handle_feedback_sound(side : String, _type : String):
#
	#if can_play_warning_feedback_sound:	
		#if side == get_parent().side :
			#s_feedback_sound.play()
			#can_play_warning_feedback_sound = false
			#await get_tree().create_timer(3.0).timeout
			#can_play_warning_feedback_sound = true
	#
	#
