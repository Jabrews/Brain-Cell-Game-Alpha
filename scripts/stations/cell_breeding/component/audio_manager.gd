extends Node

@onready var s_drag_dropped : AudioStreamPlayer3D = $DragDropped
@onready var s_box_accepted : AudioStreamPlayer3D = $BoxAccepted
@onready var s_box_removed : AudioStreamPlayer3D = $RemoveFromBox
@onready var s_error : AudioStreamPlayer3D = $Error
@onready var s_reset_btn_enter : AudioStreamPlayer3D = $ResetBtnEnter
@onready var s_skull_warning : AudioStreamPlayer3D = $SkullWarning
@onready var s_cycle_stat : AudioStreamPlayer3D = $CycleStat
@onready var s_invalid_stat : AudioStreamPlayer3D = $InvalidStat
@onready var s_boost_confirm : AudioStreamPlayer3D = $BoostConfirm
@onready var s_breeding_finished : AudioStreamPlayer3D = $BreedingFinishedCharge


func _ready() -> void:
	GLBreedingComponetsBus.connect('breeder_play_sound', _handle_breeder_play_sound)

func _handle_breeder_play_sound(sound_type : String) :
	
	match sound_type : 
		'dropped' :
			s_drag_dropped.play()
		'box_accepted' :
			s_box_accepted.play()
		'box_removed' :
			s_box_removed.play()
		'error' : 
			s_error.play()
		'reset_btn_enter' : 
			s_reset_btn_enter.play()
		'skull_warning' : 
			s_skull_warning.play()
		'cycle_stat' : 
			s_cycle_stat.play()
		'invalid_stat' :
			s_invalid_stat.play()
		'boost_confirm' :
			s_boost_confirm.play()
		'breeding_finished' : 
			s_breeding_finished.play()
		_ : 
			push_error('trouble finding breeder sound : ', sound_type)
			return
