extends Node

# components
@onready var parent_elevator_manager : Node = $"../.."

@onready var toggle_elevator_lid_open : Node = $"../../ComponentControllers/ToggleElevatorLidOpen"
@onready var toggle_elevator_up : Node = $"../../ComponentControllers/ToggleElevatorUp"
@onready var toggle_elevator_btns_avaible : Node = $"../../ComponentControllers/ToggleElevatorBtnsAvailable"
@onready var handle_elevator_light_state : Node = $"../../ComponentControllers/HandleElevatorLightState"
@onready var display_accept_cell : Node = $"../../../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay/DisplayAcceptCell"


func _start_state(cell_on_elevator: Node3D) -> void:
	if not cell_on_elevator:
		push_error("Unable to start cell received state")
		return

	parent_elevator_manager.buttons_avaible = false

	cell_on_elevator.switch_cell_state("idle")
	GLCellManagerBus.emit_signal(
		"toggle_lock_cell_pickup",
		cell_on_elevator.designated_brain_cell.name,
		true
	)

	toggle_elevator_up._toggle_up(false)

	await get_tree().create_timer(1.0).timeout
	if parent_elevator_manager.active_state != self:
		return

	toggle_elevator_lid_open._toggle_open(false)
	handle_elevator_light_state._switch_state("on")
	
	# show accept cell screen
	display_accept_cell.show_accept_cell_screen(cell_on_elevator.designated_brain_cell)

	await get_tree().create_timer(1.0).timeout

	# finally make btns avaible to player
	# HACK, but if this timing is diffrent its a hard fix.
	toggle_elevator_btns_avaible._toggle_available(true)
	parent_elevator_manager.buttons_avaible = true

func _stop_state() :
	parent_elevator_manager.buttons_avaible = false
