extends Node

# display components
@onready var display_active_stat_highlight : Node = $DisplayActiveStatHighlight
@onready var display_active_stat_label : Node = $DisplayActiveStatLabel
@onready var display_hint_active_stat_light : Node = $DisplayHintActiveStatLight
# componenents
@onready var handle_refresh_screens : Node = $HandleRefreshScreens


var enabled : bool = true

var strength_ideal_stat : IdealStat = IdealStat.new('strength')
var intelligence_ideal_stat : IdealStat = IdealStat.new('intelligence')
var community_ideal_stat : IdealStat = IdealStat.new('community')

# profiler energy
var total_energy : int = 0

# selected stat
var possible_selected_stats : Array[String] = ['strength', 'intelligence', 'community', 'none']
var selected_stat : String = 'none'
var selected_stat_index : int = 3

func _ready() -> void:
	
	await get_tree().process_frame	
	
	handle_refresh_screens._handle()
	


func _set_ideal_stat_value(ideal_stat_type : String, new_value : float) :
	
	var selected_ideal_stat : IdealStat = get_ideal_stat_bt_type(ideal_stat_type)
	
	if selected_ideal_stat : 	
		
		selected_ideal_stat.value = new_value
	
		handle_refresh_screens._handle()


func _set_selected_stat(new_selected_stat : String, new_selected_stat_index : int) :
	selected_stat = new_selected_stat
	selected_stat_index = new_selected_stat_index
	
	# call helpers
	display_active_stat_highlight._display_type(selected_stat_index)
	display_hint_active_stat_light._display_type(selected_stat_index)
	display_active_stat_label._display_label(selected_stat)
	handle_refresh_screens._handle()
	
# helpers
func get_ideal_stat_bt_type(ideal_stat_type : String) -> IdealStat : 
	match ideal_stat_type : 	
		'strength' :
			return strength_ideal_stat
		'intelligence' :
			return intelligence_ideal_stat
		'community' :
			return community_ideal_stat
		_ : 
			return null
	
func get_ideal_stats() -> Array[IdealStat] : 
	return [strength_ideal_stat, intelligence_ideal_stat, community_ideal_stat]
	
