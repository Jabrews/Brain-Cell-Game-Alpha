extends Node

# cell manager componnets
@onready var main_cell_manager : Node = $"../../MainCellManager"
@onready var energy_boost_cell_manager : Node = $"../../MainCellManager/EnergyBoostCellManager"

# color/visuals helper
@onready var direction_btn_visuals : Node = $DirectionBtnVisuals


# TODO 
# implement getting cycled stat and checking if its valid for direction
# implement when main cell is removed turning reseting 


func _handle_direction_btn_pressed(side : String, direction : String) :
	
	# main cell and energy boost cell exist
	var cell_exists = verify_cell_exist(side)
	
	if not cell_exists :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	# make sure the current stat isnt none 
	var stats_valid : bool = find_energy_boost_stat_valid(side)
		
	if not stats_valid :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
		
	
	# set direction on manager
	match side :
		'left' :
			energy_boost_cell_manager.energy_boost_left_direction = direction
		'right' : 
			energy_boost_cell_manager.energy_boost_right_direction = direction
	
	# update visuals
	direction_btn_visuals._update_btn_pressed(side, direction)
	

func _handle_boost_cell_stat_cycled(side : String) :
	
	# make sure the current stat isnt none 
	var stats_valid : bool = find_energy_boost_stat_valid(side)
	
	if stats_valid : 	
		direction_btn_visuals._set_unselected(side)
	else :
		direction_btn_visuals._set_innaccessible(side)
	


func find_energy_boost_stat_valid(side : String) : 
	
	var stats_valid : bool
	match side : 
		'left' :
			if energy_boost_cell_manager.energy_boost_left_stat != 'none':
				stats_valid = true
			else :
				stats_valid = false
		'right' :
			if energy_boost_cell_manager.energy_boost_right_stat != 'none':
				stats_valid = true
			else :
				stats_valid = false
	
	return stats_valid


	
func _handle_reset_direction_cell_removed(side : String) :	
	direction_btn_visuals._set_innaccessible(side)
	
	



func verify_cell_exist(side : String) -> bool : 
	
	var main_cell : BrainCell
	var energy_boost_cell : BrainCell
	
	match side :
		'left' :
			main_cell = main_cell_manager.main_left_cell
			energy_boost_cell = energy_boost_cell_manager.energy_boost_left_cell
		'right' :
			main_cell = main_cell_manager.main_right_cell
			energy_boost_cell = energy_boost_cell_manager.energy_boost_right_cell		
	
	if not main_cell or not energy_boost_cell: 
		return false
	else : 
		return true
