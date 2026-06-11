extends Node

@export var interpreter_type: String


var interpreter_active: bool = false
var active_brain_cell_container: CharacterBody3D = null

var current_screen: String = "INFO_SCREEN"
var current_info_screen_type: String = "NO_CELL_DETECTED"

# components helpers
@onready var timer_increment: Node = $TimerIncrement
@onready var screen_hidden_interpreter: Node2D = $InterpreterTV/TvFrontPannel/SubViewport/ScreenHiddenInterpreter
@onready var audio_manager : Node3D = $AudioManager


func _ready() -> void:
	switch_screen("INFO_SCREEN", "NO_CELL_DETECTED")


#### STATE MACHINE ####
func switch_screen(type: String, info_screen_type: String = "") -> void:
	if type != "INFO_SCREEN" and not active_brain_cell_container:
		type = "INFO_SCREEN"
		info_screen_type = "NO_CELL_DETECTED"

	current_screen = type

	if type == "INFO_SCREEN":
		current_info_screen_type = info_screen_type
		audio_manager.toggle_play_idle_drone(false)
		_handle_info_screen_type(info_screen_type)

	elif type == "IDLE_SCREEN":
		timer_increment._start_timer()

	elif type == "GAME_SCREEN":
		timer_increment._start_timer()

	screen_hidden_interpreter._switch_screen(type, info_screen_type)


func _handle_info_screen_type(info_screen_type: String) -> void:
	
	
	
	match info_screen_type:
		"NO_CELL_DETECTED":
			timer_increment._reset_timer()
		"INVALID_STAT":
			timer_increment._reset_timer()
			audio_manager.play_hidden_stat_invalid()
		"JOLT":
			pass
		"FINISHED":
			timer_increment._reset_timer()
			audio_manager.play_finished()
		_:
			push_error('invalid info screen type for hidden interpreter : ', info_screen_type)
#######################


#### INCREMENT AND FINISHED ####
func _handle_interpreter_timer_increment(current_time_increment: int) -> void:
	if current_screen == "IDLE_SCREEN" or current_screen == "GAME_SCREEN":
		screen_hidden_interpreter._handle_timer_increment(current_time_increment)

func _handle_interpreter_timer_finished() -> void:
	## UNHIDE STAT ON CELL
	GLCellManagerBus.emit_signal('hidden_stat_interpreted',
	 	active_brain_cell_container.designated_brain_cell,
		interpreter_type
	)
	switch_screen("INFO_SCREEN", "FINISHED")

	

func _handle_interpreter_timer_reset() -> void:
	screen_hidden_interpreter._handle_timer_reset()
	
################################


#### RECEIVING CELL BODY ####
func _handle_panel_body_recieved(cell_container: CharacterBody3D) -> void:
	active_brain_cell_container = cell_container

	if not active_brain_cell_container:
		switch_screen("INFO_SCREEN", "NO_CELL_DETECTED")
		return

	var active_designated_brain_cell: BrainCell = active_brain_cell_container.designated_brain_cell

	if not active_designated_brain_cell:
		switch_screen("INFO_SCREEN", "NO_CELL_DETECTED")
		return

	var cell_has_valid_stat: bool = _cell_has_hidden_interpreter_stat(active_designated_brain_cell)

	if cell_has_valid_stat:
		switch_screen("IDLE_SCREEN")
		audio_manager.play_stat_accepted()
		audio_manager.toggle_play_idle_drone(true)
	else:
		switch_screen("INFO_SCREEN", "INVALID_STAT")


func _cell_has_hidden_interpreter_stat(brain_cell: BrainCell) -> bool:
	match interpreter_type:
		"strength":
			return brain_cell.strength.hidden

		"intelligence":
			return brain_cell.intelligence.hidden

		"community":
			return brain_cell.community.hidden

		_:
			push_error("Invalid interpreter_type: " + interpreter_type)
			return false
########################
