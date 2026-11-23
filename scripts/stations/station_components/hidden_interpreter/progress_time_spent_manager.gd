extends Node

# components
@onready var parent_hidden_interpreter : Node3D = $".."
@onready var increment_time_spent_timer : Timer = $IncrementTimeSpent
@onready var progress_screen : Control = $"../TvFrontPannel/SubViewport/ScreenHiddenInterpreter/ProgressScreen"

var time_spent : int = 0

func _ready() -> void:
	increment_time_spent_timer.connect('timeout', _handle_increment_time_spent_timer_timeout)


func _update(action: String) -> void:
	match action:
		"start":
			increment_time_spent_timer.paused = false
			increment_time_spent_timer.start()
		"pause":
			increment_time_spent_timer.paused = true
		"stop":
			increment_time_spent_timer.stop()
			time_spent = 0
			progress_screen._toggle_loading(true)

func _handle_increment_time_spent_timer_timeout() : 
	time_spent += 1
	
	var time_to_discover_hidden = IVHiddenStats.max_time_to_discover_hidden
	
	progress_screen._update_progress(time_spent)
	
	
	if time_spent >= time_to_discover_hidden : 
		parent_hidden_interpreter._handle_discover_hidden()
		_update('stop')
	
