extends Node

var left_side_direction: String = "none"
var right_side_direction: String = "none"

var left_buttons_inaccessible: bool = true
var right_buttons_inaccessible: bool = true

# components
@onready var btn_color_updater : Node = $BtnColorUpdater
@onready var load_charge_stat : Node = $"../LoadChargeStat"


func _handle_direction_btn_pressed(side: String, direction: String) -> void:
	
	match side:
		"left":
			if left_buttons_inaccessible:
				GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
				return
			
			GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
			left_side_direction = direction
		
		"right":
			if right_buttons_inaccessible:
				GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
				return
				
			GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
			right_side_direction = direction
	
	btn_color_updater._update()
	load_charge_stat._handle_new_direction_chosen('left', left_side_direction)
	load_charge_stat._handle_new_direction_chosen('right', right_side_direction)
		

func _handle_charged_cell_recieved(side: String, charged_brain_cell: BrainCell) -> void:
	
	var has_cell: bool = charged_brain_cell != null
	
	match side:
		"left":
			left_buttons_inaccessible = not has_cell
			
			if not has_cell:
				left_side_direction = "none"
		
		"right":
			right_buttons_inaccessible = not has_cell
			
			if not has_cell:
				right_side_direction = "none"
		
		
	btn_color_updater._update()
	load_charge_stat._handle_new_direction_chosen('left', left_side_direction)
	load_charge_stat._handle_new_direction_chosen('right', right_side_direction)
