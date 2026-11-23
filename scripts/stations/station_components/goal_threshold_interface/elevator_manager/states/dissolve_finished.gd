extends Node

# components
@onready var toggle_elevator_lid_open : Node = $"../../ComponentControllers/ToggleElevatorLidOpen"
@onready var toggle_elevator_up : Node = $"../../ComponentControllers/ToggleElevatorUp"
@onready var toggle_elevator_btns_avaible : Node = $"../../ComponentControllers/ToggleElevatorBtnsAvailable"
@onready var handle_elevator_light_state : Node = $"../../ComponentControllers/HandleElevatorLightState"
@onready var display_accept_cell : Node = $"../../../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay/DisplayAcceptCell"


func _start_state() :
	handle_elevator_light_state._switch_state('returning_cell') 
	toggle_elevator_btns_avaible._toggle_available(false)
	toggle_elevator_up._toggle_up(true)
	toggle_elevator_lid_open._toggle_open(true)
	
func _stop_state() :
	pass
