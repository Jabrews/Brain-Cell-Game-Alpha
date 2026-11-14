
extends Control

# components
@onready var input_blocker: ColorRect = $InputBlocker
@onready var evaluate_inital : Node = $EvaluateInital
@onready var display_increment_defect : Node = $DisplayIncrementDefect

func _start(
	new_main_left_cell: BrainCell,
	new_main_right_cell: BrainCell,
	new_left_failure: bool,
	new_right_failure: bool,
) -> void:

	# Mouse stuff
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	Input.warp_mouse(Vector2(viewport_size.x - 1, 1))

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var defect_amount_to_increase : Dictionary[String, Dictionary] = evaluate_inital._evaluate(
		new_main_left_cell,
		new_main_right_cell,
		new_left_failure,
		new_right_failure,
	)

	# Show simulation
	visible = true
	
	display_increment_defect._display(defect_amount_to_increase)

	input_blocker.grab_focus()

	# Start simulation logic here


func _end() -> void:
	visible = false

	# Mouse stuff
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	input_blocker.release_focus()

	GLBreedingComponetsBus.emit_signal('reset_ui_focus')
	GLBreedingComponetsBus.emit_signal('simulation_ended')
