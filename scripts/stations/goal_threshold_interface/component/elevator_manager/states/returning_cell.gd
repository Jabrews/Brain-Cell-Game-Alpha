extends Node

# components
@onready var toggle_elevator_lid_open : Node = $"../../ComponentControllers/ToggleElevatorLidOpen"
@onready var toggle_elevator_up : Node = $"../../ComponentControllers/ToggleElevatorUp"
@onready var toggle_elevator_btns_avaible : Node = $"../../ComponentControllers/ToggleElevatorBtnsAvailable"
@onready var handle_elevator_light_state : Node = $"../../ComponentControllers/HandleElevatorLightState"
@onready var display_accept_cell : Node = $"../../../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay/DisplayAcceptCell"


func _start_state(cell_on_elevator : Node3D) :
	
	if not cell_on_elevator : 
		push_error('unable to start return cell state')
		return
		
	
	handle_elevator_light_state._switch_state('returning_cell')
	
	toggle_elevator_lid_open._toggle_open(true)
	
	await get_tree().create_timer(0.7).timeout
	
	display_accept_cell.hide_accept_cell_screen()
	
	toggle_elevator_up._toggle_up(true)
	
	await get_tree().create_timer(1.5).timeout
	
	GLCellManagerBus.emit_signal('toggle_lock_cell_pickup', cell_on_elevator.designated_brain_cell.name, false)
	
	

func _stop_state() :
	pass
