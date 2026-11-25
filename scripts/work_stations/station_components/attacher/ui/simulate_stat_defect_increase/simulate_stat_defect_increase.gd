extends Control 

# components
@onready var evaluate_inital : Node = $EvaluateInital
@onready var display_increment_defect : Node = $DisplayIncrementDefect
@onready var input_blocker : ColorRect = $Content/InputBlocker
# fail parents
@onready var default_failed_parent : Control = $Content/DefaultFailedParent
@onready var extreme_failed_parent : Control = $Content/ExtremeFailedParent

var displaying_simulation : bool = false


func _ready() -> void:
	visible = false

func _start(old_cell : BrainCell, new_cell : BrainCell, is_extreme_fail : bool) : 
	
	displaying_simulation = true
	
	# mouse stuff
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	Input.warp_mouse(Vector2(viewport_size.x - 1, 1))
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var defect_amount_to_increase : Dictionary[String, int] = evaluate_inital._evaluate(new_cell, old_cell)	
	
	visible = true
	
	# extreme parent	
	extreme_failed_parent.visible = false	
	default_failed_parent.visible = false
	
	if is_extreme_fail : 
		extreme_failed_parent.visible = true
	else :
		default_failed_parent.visible = true 
	
	
	
	display_increment_defect._display(defect_amount_to_increase)
	
	await get_tree().process_frame
	
	input_blocker.grab_focus()

func _end() :
	
	
	
	visible = false
	
	# mouse stuff
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	input_blocker.release_focus()
	
	GLAttacherComponentBus.emit_signal('reset_ui_focus')
	
	GLAttacherComponentBus.emit_signal('simulation_ended')
	
	displaying_simulation = false 
	

	
