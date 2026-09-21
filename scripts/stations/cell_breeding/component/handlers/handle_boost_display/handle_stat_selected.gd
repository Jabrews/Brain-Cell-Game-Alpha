extends Node

var stats : Array[String] = [
	"strength",
	"intelligence",
	"community"
]

# components
@onready var get_side_boost_components : Node = $"../GetSideBoostComponents"
@onready var parent_station : Node3D = $"../.."
@onready var handle_charge_direction : Node = $"../HandleChargeDirection"
@onready var display_validity_label : Node = $"../DisplayValidityLabel"

var stat_parents : Array[Control]
var stat_highlights : Array[Sprite2D]


func _handle(side : String, stat : String) -> void:
	
	var boost_components : Dictionary = get_side_boost_components._get_boost(side)
	
	stat_parents = boost_components["stat_parents"]
	stat_highlights = boost_components["stat_highlights"]
	
	var stat_index : int = stats.find(stat)
	
	if stat_index == -1:
		push_error("Invalid stat: ", stat)
		return
	
	# remember if clicked stat was already selected
	var was_selected : bool = stat_parents[stat_index].selected
	
	
	# reset all stat visuals
	for index : int in range(stats.size()):
		stat_parents[index].selected = false
		stat_highlights[index].visible = false
		stat_highlights[index].modulate.a = 0.5
	
	
	# clicked already selected stat -> unselect
	if was_selected:
		handle_charge_direction._toggle_available(side, false)
		parent_station.set_boost_stat(side, "none")
		display_validity_label._display_type(side, 'none')
		return
	
	
	# visually select clicked stat
	stat_parents[stat_index].selected = true
	stat_highlights[stat_index].visible = true
	stat_highlights[stat_index].modulate.a = 1.0
	
	
	# get boost cell
	var boost_cell : BrainCell
	
	match side:
		"left":
			boost_cell = GLBreedingComponetsBus.breeding_ui_state["left_boost"]
		
		"right":
			boost_cell = GLBreedingComponetsBus.breeding_ui_state["right_boost"]
	
	
	# no boost cell
	if not boost_cell:
		handle_charge_direction._toggle_available(side, false)
		parent_station.set_boost_stat(side, "none")
		return
	
	
	var cell_stat : BrainCellStat = boost_cell.get_stat(stat)
	
	
	# selected visually, but unusable
	if not cell_stat.enabled or cell_stat.hidden:
		handle_charge_direction._toggle_available(side, false)
		parent_station.set_boost_stat(side, "none")
		display_validity_label._display_type(side, 'invalid')
		return
	
	
	# valid usable stat
	handle_charge_direction._toggle_available(side, true)
	display_validity_label._display_type(side, 'valid')
	parent_station.set_boost_stat(side, stat)
