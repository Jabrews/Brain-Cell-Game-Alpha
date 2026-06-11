extends Node

@onready var s_interpreter_invalid : AudioStreamPlayer3D = $InterpreterInvalidStat
@onready var s_interpreter_finished : AudioStreamPlayer3D = $InterpreterFinished
@onready var s_stat_accepted : AudioStreamPlayer3D = $StatAccepted
@onready var idle_drone : AudioStreamPlayer3D = $IdleDrone

func play_hidden_stat_invalid() :
	s_interpreter_invalid.play()

func play_finished() :
	s_interpreter_invalid.stop() # lil hacky fix
	s_interpreter_finished.play()

func play_stat_accepted() :
	s_stat_accepted.play()

func toggle_play_idle_drone(toggle_value : bool) :
	if toggle_value :
		idle_drone.play() 
	else :
		idle_drone.stop()
