extends Node

# cell manager componnets
@onready var main_cell_manager : Node = $"../../MainCellManager"
@onready var energy_boost_cell_manager : Node = $"../../MainCellManager/EnergyBoostCellManager"

# color/visuals helper
@onready var direction_btn_visuals : Node = $DirectionBtnVisuals

# sync charge boost display 
#@onready var sync_charge_boost_display : Node = $"../../SyncChargeBoostDisplay"
@onready var sync_breeding_display : Node = $"../../SyncBreedingDisplay"


func _handle_direction_btn_pressed(side : String, direction : String) -> void:
	
	# main cell and energy boost cell exist
	var cell_exists : bool = verify_cell_exist(side)
	
	if not cell_exists:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return
	
	# make sure the current stat isnt none 
	var stats_valid : bool = find_energy_boost_stat_valid(side)
		
	if not stats_valid:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return
	
	var current_direction : String = "none"
	
	match side:
		"left":
			current_direction = energy_boost_cell_manager.energy_boost_left_direction
		"right":
			current_direction = energy_boost_cell_manager.energy_boost_right_direction
	
	var toggle_value : bool = true
	var new_direction : String = direction
	
	# if pressing same direction again, turn it off
	if current_direction == direction:
		toggle_value = false
		new_direction = "none"
	
	GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_success")
	
	# set direction on manager
	match side:
		"left":
			energy_boost_cell_manager.energy_boost_left_direction = new_direction
		"right": 
			energy_boost_cell_manager.energy_boost_right_direction = new_direction
	
	# update visuals
	direction_btn_visuals._update_btn_pressed(side, direction, toggle_value)
	sync_breeding_display.sync_breeding_cell_display()
	

func _handle_boost_cell_stat_cycled(side : String) -> void:
	
	# reset the sides because we cycled to new stat
	match side:
		"left":
			energy_boost_cell_manager.energy_boost_left_direction = "none" 
		"right": 
			energy_boost_cell_manager.energy_boost_right_direction = "none"
		_:
			push_error("Invalid side: " + side)
			return
	
	# make sure the current stat isnt none 
	var stats_valid : bool = find_energy_boost_stat_valid(side)
	
	if stats_valid: 	
		direction_btn_visuals._set_unselected(side)
	else:
		direction_btn_visuals._set_innaccessible(side)
	
	sync_breeding_display.sync_breeding_cell_display()
	


func find_energy_boost_stat_valid(side : String) -> bool: 
	
	var stats_valid : bool = false
	
	match side: 
		"left":
			if energy_boost_cell_manager.energy_boost_left_stat != "none":
				stats_valid = true
			else:
				stats_valid = false
		
		"right":
			if energy_boost_cell_manager.energy_boost_right_stat != "none":
				stats_valid = true
			else:
				stats_valid = false
		
		_:
			push_error("Invalid side: " + side)
			stats_valid = false
	
	return stats_valid


	
func _handle_reset_direction_cell_removed(side : String) -> void:
	
	match side:
		"left":
			energy_boost_cell_manager.energy_boost_left_direction = "none"
		"right":
			energy_boost_cell_manager.energy_boost_right_direction = "none"
		_:
			push_error("Invalid side: " + side)
			return
	
	direction_btn_visuals._set_innaccessible(side)
	sync_breeding_display.sync_breeding_cell_display()
	
	



func verify_cell_exist(side : String) -> bool: 
	
	var main_cell : BrainCell = null
	var energy_boost_cell : BrainCell = null
	
	match side:
		"left":
			main_cell = main_cell_manager.main_left_cell
			energy_boost_cell = energy_boost_cell_manager.energy_boost_left_cell
		
		"right":
			main_cell = main_cell_manager.main_right_cell
			energy_boost_cell = energy_boost_cell_manager.energy_boost_right_cell		
		
		_:
			push_error("Invalid side: " + side)
			return false
	
	if not main_cell or not energy_boost_cell: 
		return false
	else: 
		return true
