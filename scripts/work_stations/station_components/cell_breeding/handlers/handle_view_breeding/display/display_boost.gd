extends Node

var stats : Array[String] = [
	"strength",
	"intelligence",
	"community"
]

func _display(stat_components : Dictionary, main_cell : BrainCell, boost_stat : String, boost_direction : String) -> void:
	
	if not main_cell:
		return
	
	if boost_stat == "none" or boost_direction == "none":
		return
	
	var clean_bars : Array[Sprite2D] = stat_components["clean_bars"]
	
	var stat_index : int = stats.find(boost_stat)
	
	if stat_index == -1:
		push_error("Unable to find stat: ", boost_stat)
		return
	
	var clean_bar : Sprite2D = clean_bars[stat_index]
	
	# get selected stat
	var selected_stat : BrainCellStat = main_cell.get_stat(boost_stat)
	
	if not selected_stat:
		push_error("Unable to get stat: ", boost_stat)
		return
	
	var max_stat_value : float = IVCellCreator.max_stat_value
	var selected_stat_value : float = selected_stat.value
	

	
	# boost direction
	var direction_multiplier : float
	
	match boost_direction:
		"up":
			direction_multiplier = 1.0
		
		"down":
			direction_multiplier = -1.0
		
		_:
			push_error("Invalid boost direction: ", boost_direction)
			return
	
	# calculate preview value
	var boost_difference : float = (
		direction_multiplier *
		(max_stat_value * 0.15)
	)
	
	var boost_value : float = clamp(
		selected_stat_value + boost_difference,
		0.0,
		max_stat_value
	)
	
	# normal/current stat value
	clean_bar.material.set_shader_parameter(
		"prisoner_value",
		selected_stat_value / max_stat_value
	)
	
	# boosted preview value
	clean_bar.material.set_shader_parameter(
		"charge_value",
		boost_value / max_stat_value
	)
	
