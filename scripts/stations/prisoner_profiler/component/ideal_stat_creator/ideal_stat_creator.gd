extends Node

# display components
@onready var display_active_stat_highlight : Node = $DisplayActiveStatHighlight
@onready var display_active_stat_label : Node = $DisplayActiveStatLabel
@onready var display_hint_active_stat_light : Node = $DisplayHintActiveStatLight
# componenents
@onready var handle_refresh_screens : Node = $HandleRefreshScreens



var enabled : bool = true
# ideal stats
var ideal_stats_value : Dictionary[String, float] = {
	'strength' : 0,
	'intelligence' : 0,
	'community' : 0,
}

var ideal_stats_lock_max_value : Dictionary[String, float] = {
	'strength' : 100,
	'intelligence' : 100,
	'community' : 100,
}

var ideal_stats_enabled : Dictionary[String, bool] = {
	'strength' : true,
	'intelligence' : true,
	'community' : true,
}

# profiler energy
var total_energy : int = 0
var ideal_stats_energy_spent : Dictionary[String, int] = {
	'strength' : 0,
	'intelligence' : 0,
	'community' : 0,
}


# selected stat
var possible_selected_stats : Array[String] = ['strength', 'intelligence', 'community', 'none']
var selected_stat : String = 'none'
var selected_stat_index : int = 3

func _ready() -> void:
	
	await get_tree().process_frame	
	
	handle_refresh_screens._handle()



func _set_ideal_stat_value(ideal_stat : String, new_value : float) :
	ideal_stats_value[ideal_stat] = new_value
	
	handle_refresh_screens._handle()


func _set_selected_stat(new_selected_stat : String, new_selected_stat_index : int) :
	selected_stat = new_selected_stat
	selected_stat_index = new_selected_stat_index
	
	# call helpers
	display_active_stat_highlight._display_type(selected_stat_index)
	display_hint_active_stat_light._display_type(selected_stat_index)
	display_active_stat_label._display_label(selected_stat)
	handle_refresh_screens._handle()
	
