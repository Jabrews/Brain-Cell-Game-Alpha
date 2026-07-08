extends Node

# component stat displays
@onready var left_clean_bars : Array[Sprite2D] = [
	$"../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/StrengthBar",
	$"../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/IntelligenceBar",
	$"../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/CommunityBar"
]
@onready var right_clean_bars : Array[Sprite2D] = [
	$"../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/StrengthBar",
	$"../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/IntelligenceBar",
	$"../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/CommunityBar"
]

func _handle_recieve_energy_boost( 
	main_left_cell, main_right_cell,
	energy_boost_left_stat ,energy_boost_right_stat,
	energy_boost_left_direction, energy_boost_right_direction
) :
	if main_left_cell  :
		if energy_boost_left_direction != 'none' and energy_boost_left_stat != 'none' :
			var clean_bar = get_clean_bar('left', energy_boost_left_stat)
			display_charge_preview(clean_bar, main_left_cell, energy_boost_left_stat, energy_boost_left_direction)
	
	if main_right_cell  :
		if energy_boost_right_direction != 'none' and energy_boost_right_stat != 'none' :
			var clean_bar = get_clean_bar('right', energy_boost_right_stat)
			display_charge_preview(clean_bar, main_right_cell, energy_boost_right_stat, energy_boost_right_direction)
		
func get_clean_bar(side : String, selected_stat : String) :	
	
	# get correct sides parent of bars
	var clean_bars : Array[Sprite2D]	
	match side :	
		'left' :
			clean_bars = left_clean_bars
		'right' :
			clean_bars = right_clean_bars
	
	var stats = ['strength', 'intelligence', 'community']
	var stat_index = stats.find(selected_stat)
	
	var clean_bar = clean_bars[stat_index]
	
	return clean_bar


func display_charge_preview(clean_bar : Sprite2D, main_cell : BrainCell, selected_stat : String, selected_direction : String ) :
	
	var selected_stat_value	 : float
	var target_stat_value : float
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	match selected_stat : 
		'strength' :
			selected_stat_value = main_cell.strength.value
			target_stat_value = target_cell.strength.value
		'intelligence' :		
			selected_stat_value = main_cell.intelligence.value
			target_stat_value = target_cell.intelligence.value
		'community' :
			selected_stat_value = main_cell.community.value
			target_stat_value = target_cell.community.value
			
	var max_stat_value : float = IVCellCreator.max_stat_value
	
	
	### set prisoner and target value as normally ##
	clean_bar.material.set_shader_parameter(
		"prisoner_value",
		selected_stat_value / max_stat_value
	)

	clean_bar.material.set_shader_parameter(
		"target_value",
		target_stat_value / max_stat_value
	)
	###############################################
	
	
	# get direction 
	var direction_multiplier 	
	match selected_direction : 
		'increase' :
			direction_multiplier = 1
		'decrease' : 
			direction_multiplier = -1
	
	var boost_diffrence = direction_multiplier * (IVCellCreator.max_stat_value * 0.15)
	var boost_value = selected_stat_value + boost_diffrence
	boost_value = clamp(boost_value, 0, IVCellCreator.max_stat_value)
	
	clean_bar.material.set_shader_parameter(
		"charge_value",
		boost_value / max_stat_value
	)

	


	

	
	
	
	



	
	
	
