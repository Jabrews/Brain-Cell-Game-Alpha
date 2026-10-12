extends Node

# audio components
@onready var s_cycle_stat : AudioStreamPlayer3D = $CycleStat
@onready var s_feedback: AudioStreamPlayer3D = $FeedbackSound
@onready var s_increment : AudioStreamPlayer3D = $Increment
@onready var s_increment_hold : AudioStreamPlayer3D = $IncrementHold
@onready var s_lock_shake : AudioStreamPlayer3D = $LockShake
@onready var s_on_off_click : AudioStreamPlayer3D = $OnOffClick
@onready var s_generate : AudioStreamPlayer3D = $Generate
@onready var s_energy_alert_beep : AudioStreamPlayer3D = $EnergyAlertBeep
@onready var s_finished_ideal_creator : AudioStreamPlayer3D = $FinishedIdealCreator



func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('play_sound', _handle_play_sound)
	GLPrisonerProfilerComponentsBus.connect('display_feedback', _handle_display_feedback)

func _handle_play_sound(sound_type: String) -> void:
	match sound_type:
		"cycle_stat":
			s_cycle_stat.play()
		"feedback":
			s_feedback.play()
		"increment":
			s_increment.play()
		"increment_hold" :
			s_increment_hold.play()
		"lock_shake":
			s_lock_shake.play()
		"on_off_click":
			s_on_off_click.play()
		"generate":
			s_generate.play()
		'energy_alert_beep' :
			s_energy_alert_beep.play()
		'finished_ideal_creator' :
			s_finished_ideal_creator.play()
		_:
			push_error("Unknown sound type: " + sound_type)

func _handle_display_feedback(type : String, _data : Dictionary) : 
	
	if type == 'lock_alert' :
		return
	
	_handle_play_sound('feedback')
