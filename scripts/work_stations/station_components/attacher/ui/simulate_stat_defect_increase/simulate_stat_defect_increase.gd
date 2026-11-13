extends Control 

@onready var attacher_bars : Control = $AttacherBars
@onready var evaluate_inital : Node = $EvaluateInital
@onready var display_increment_defect : Node = $DisplayIncrementDefect
@onready var input_blocker : ColorRect = $InputBlocker


func _ready() -> void:
	visible = false

func _start(old_cell : BrainCell, new_cell : BrainCell) : 
	
	# mouse stuff
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	Input.warp_mouse(Vector2(viewport_size.x - 1, 1))
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
	var defect_amount_to_increase : Dictionary[String, int] = evaluate_inital._evaluate(new_cell, old_cell)	
	
	visible = true
	
	input_blocker.grab_focus()
	
	display_increment_defect._display(defect_amount_to_increase)

func _end() :
	
	visible = false
	
	# mouse stuff
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	input_blocker.release_focus()
	
	GLAttacherComponentBus.emit_signal('reset_ui_focus')
	
	GLAttacherComponentBus.emit_signal('simulation_ended')
	

	
