extends Control 

# components
@onready var display_inital_main_stats : Node =$DisplayInitalMainStats
@onready var display_increment_defect : Node = $DisplayIncrementDefect
@onready var display_replacements_invalid : Node = $DisplayReplacementsInvalid
# util
@onready var get_amount_to_increase : Node = $Util/GetAmountToIncrease

# visual components
@onready var input_blocker : ColorRect = $Content/InputBlocker
@onready var default_failed_parent : Control = $Content/DefaultFailedParent
@onready var extreme_failed_parent : Control = $Content/ExtremeFailedParent

var displaying_simulation : bool = false

var saved_old_cell : BrainCell
var saved_new_cell : BrainCell


func _ready() -> void:
	visible = false

func _start(old_cell : BrainCell, new_cell : BrainCell, is_extreme_fail : bool) : 
	
	## scene / display lock	
	
	# move mouse
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	Input.warp_mouse(Vector2(viewport_size.x - 1, 1))
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	await get_tree().process_frame
	
	# start focus on controller
	input_blocker.grab_focus()
	
	
	## state and visibilty
	saved_old_cell = old_cell
	saved_new_cell = new_cell

	displaying_simulation = true
	visible = true
	
	## deal with extreme parents
	extreme_failed_parent.visible = false	
	default_failed_parent.visible = false
	
	if is_extreme_fail : 
		extreme_failed_parent.visible = true
	else :
		default_failed_parent.visible = true 
	
	## display 
	# should : show stats with opacity and everything, no animation
	display_inital_main_stats._display(saved_old_cell, saved_new_cell)
	
	display_replacements_invalid._display()

## REPLACEMENT ENDED
func _handle_replacement_cinnamtic_ended() :
	
	var defect_amount_to_increase : Dictionary[String, int] = get_amount_to_increase._get_amount(saved_old_cell, saved_new_cell)
	
	display_increment_defect._display(defect_amount_to_increase)

## INCREMENT ENDED
func _handle_increment_cinnamatic_ended() :
	
	displaying_simulation = false 
	
	visible = false
	
	# mouse stuff
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	input_blocker.release_focus()
	
	GLAttacherComponentBus.emit_signal('reset_ui_focus')
	
	GLAttacherComponentBus.emit_signal('simulation_ended')
	
	

	
