
extends Node

# Components
@onready var toggle_elevator_lid_open: Node = $"../../ComponentControllers/ToggleElevatorLidOpen"
@onready var toggle_elevator_up: Node = $"../../ComponentControllers/ToggleElevatorUp"
@onready var toggle_elevator_btns_available: Node = $"../../ComponentControllers/ToggleElevatorBtnsAvailable"
@onready var handle_elevator_light_state: Node = $"../../ComponentControllers/HandleElevatorLightState"
@onready var display_accept_cell: Node = $"../../../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay/DisplayAcceptCell"

@onready var bubble_manager: Node3D = $"../../../GoalTube/BubbleManager"
@onready var tube_progress_manager : Node3D = $"../../../GoalTube/TubeProgressManager"
@onready var goal_tube_inside_mesh: MeshInstance3D = $"../../../GoalTube/GoalTubeInside"


func _start_state() -> void:
	handle_elevator_light_state._switch_state("dissolving_cell")
	display_accept_cell.hide_accept_cell_screen()
	toggle_elevator_btns_available._toggle_available(false)

	bubble_manager._toggle_bubbles(true)
	tube_progress_manager.toggle_update_tube_progress(true)
	_set_tube_scroll_speed(0.3)

	GLGoalThresholdManagerBus.emit_signal("play_sound", "start_dissolve_loop")


func _stop_state() -> void:
	GLGoalThresholdManagerBus.emit_signal("play_sound", "stop_dissolve_loop")

	_set_tube_scroll_speed(0.1)
	bubble_manager._toggle_bubbles(false)
	tube_progress_manager.toggle_update_tube_progress(false)


func _set_tube_scroll_speed(speed: float) -> void:
	var tube_material := goal_tube_inside_mesh.get_active_material(0) as ShaderMaterial

	if tube_material == null:
		push_warning("GoalTubeInside surface 0 does not have a ShaderMaterial.")
		return

	tube_material.set_shader_parameter("scroll_speed", speed)
