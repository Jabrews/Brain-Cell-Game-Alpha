extends Node

# Components
@onready var s_drop_failed: AudioStreamPlayer3D = $DropFailed
@onready var s_drop_success: AudioStreamPlayer3D = $DropSuccess
@onready var s_dropped: AudioStreamPlayer3D = $Dropped
@onready var s_item_removed: AudioStreamPlayer3D = $ItemRemoved
@onready var s_enter_ui: AudioStreamPlayer3D = $EnterUi
@onready var s_confirm_success: AudioStreamPlayer3D = $ConfirmSuccess
@onready var s_confirm_failed: AudioStreamPlayer3D = $ConfirmFailed
@onready var s_loop_beat : AudioStreamPlayer3D = $LoopBeep
@onready var s_burst_warning_bug : AudioStreamPlayer3D = $BurstWarningBug
@onready var s_burst_warning_hidden_stat : AudioStreamPlayer3D = $BurstWarningHiddenStat


func _ready() -> void:
	GLAttacherComponentBus.connect('play_sound', _handle_play_sound)


func _handle_play_sound(sound_type: String) -> void:
	var sound: AudioStreamPlayer3D

	match sound_type:
		'drop_failed':
			sound = s_drop_failed

		'drop_success':
			sound = s_drop_success

		'dropped':
			sound = s_dropped

		'item_removed':
			sound = s_item_removed

		'enter_ui':
			sound = s_enter_ui

		'confirm_success':
			sound = s_confirm_success

		'confirm_failed':
			sound = s_confirm_failed
		
		'loop_beep_start' :
			s_loop_beat.play()
			
		'loop_beep_stop' :
			s_loop_beat.stop()
		
		'burst_warning_bug' : 
			sound = s_burst_warning_bug
			
		'burst_warning_hidden_stat' : 
			sound = s_burst_warning_hidden_stat

		_:
			push_warning("Unknown sound type: " + sound_type)
			return

	if sound : 
		sound.stop()
		sound.play()
