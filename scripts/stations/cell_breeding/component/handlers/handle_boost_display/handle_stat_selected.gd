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
@onready var display_boost_debuff : Node= $DisplayBoostDebuff

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
		
	# get boost cell
	var boost_cell : BrainCell
	
	match side:
		"left":
			boost_cell = GLBreedingComponetsBus.breeding_ui_state["left_boost"]
		
		"right":
			boost_cell = GLBreedingComponetsBus.breeding_ui_state["right_boost"]
	
	# ALWAYS reset stat for buff preview
	display_boost_debuff._reset(side, boost_cell)
	
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
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'cycle_stat')
		GLBreedingComponetsBus.emit_signal('refresh_stat_display')
		return
	
	
	# visually select clicked stat
	stat_parents[stat_index].selected = true
	stat_highlights[stat_index].visible = true
	stat_highlights[stat_index].modulate.a = 1.0
	
	# no boost cell
	if not boost_cell:
		handle_charge_direction._toggle_available(side, false)
		parent_station.set_boost_stat(side, "none")
		GLBreedingComponetsBus.emit_signal('refresh_stat_display')
		return
	
	
	var cell_stat : BrainCellStat = boost_cell.get_stat(stat)
	
	
	# selected visually, but unusable
	if not cell_stat.enabled or cell_stat.hidden:
		handle_charge_direction._toggle_available(side, false)
		parent_station.set_boost_stat(side, "none")
		display_validity_label._display_type(side, 'invalid')
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'invalid_stat')
		GLBreedingComponetsBus.emit_signal('refresh_stat_display')
		return
	
	
	# valid usable stat
	handle_charge_direction._toggle_available(side, true)

	parent_station.set_boost_stat(side, stat)
	display_boost_debuff._display(side, stat, boost_cell)
	
	# check if we have boost direction selected
	var boost_direction : String	
	match side : 
		'left': 
			boost_direction = GLBreedingComponetsBus.left_boost_direction
		'right' : 
			boost_direction = GLBreedingComponetsBus.right_boost_direction
	
	if boost_direction != 'none' :
		display_validity_label._display_type(side, 'valid_chosen')
	else : 
		display_validity_label._display_type(side, 'valid')
	
	
	GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'cycle_stat')
	
	GLBreedingComponetsBus.emit_signal('refresh_stat_display')
	
	
