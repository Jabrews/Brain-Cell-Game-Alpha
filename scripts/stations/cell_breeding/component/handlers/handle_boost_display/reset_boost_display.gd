extends Node

# components
@onready var get_side_boost_components : Node = $"../GetSideBoostComponents"
@onready var parent_station : Node3D = $"../.."
@onready var handle_charge_direction : Node = $"../HandleChargeDirection"
@onready var display_validity_label : Node = $"../DisplayValidityLabel"


var stat_parents : Array[Control]
var stat_highlights : Array[Sprite2D]

func _reset(side : String): 
	
	# get components from corresponding side
	var boost_components : Dictionary = get_side_boost_components._get_boost(side)
	
	stat_parents = boost_components["stat_parents"]
	stat_highlights = boost_components["stat_highlights"]

	for stat_parent : Control in stat_parents : 
		stat_parent.selected = false
		stat_parent.hovered = false
	
	for stat_highlight : Sprite2D in stat_highlights : 
		stat_highlight.visible = false
		stat_highlight.modulate.a = 0.6
	
	parent_station.set_boost_stat(side, 'none')
	
	
	display_validity_label._display_type(side, 'none')
	handle_charge_direction._toggle_available(side, false)
	
	
	
