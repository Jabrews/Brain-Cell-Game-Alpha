extends Node

# component screens
@onready var progress: Control = $ProgressScreen
@onready var no_cell_detected : Control = $NoCellDetectScreen
@onready var no_hidden_stat_detected : Control =$NoHiddenStatDetected
@onready var jolt_detected : Control = $JoltDetected
@onready var finished : Control = $Finished
# component station parent
@onready var interpreter_station_parent : Node3D = $"../../.."
# component helpers
@onready var update_stat_type_labels : Node = $UpdateStatTypeLabels

# component disruptor
@onready var disrupt_progress_blocker : Control = $DisruptorManagerInterpreter/ProgressBlocker

func _ready() -> void:
	var stat_type = interpreter_station_parent.stat_type
	update_stat_type_labels._update(stat_type)


func _switch_screen(type : String) : 
	reset_screens()	
	
	match type : 	
		'progress_screen' :
			progress.visible = true
			disrupt_progress_blocker.visible = true
		'no_cell_detected' :
			no_cell_detected.visible = true
		'no_hidden_stat_detected' :
			no_hidden_stat_detected.visible = true
		'jolt_detected' : 
			jolt_detected.visible = true
			jolt_detected._toggle_active(true)
		'finished' :
			finished.visible = true

func _update_progress_bar(time_spent : float) :
	progress._update_progress_bar(time_spent)

func reset_screens() :
	# stop blink on jolt	
	jolt_detected._toggle_active(false)
	# stop showing disrupter stuff ONLY for progress blocker
	disrupt_progress_blocker.visible = false
	
	
	progress.visible = false	
	no_cell_detected.visible = false
	no_hidden_stat_detected.visible = false
	jolt_detected.visible = false
	finished.visible = false
