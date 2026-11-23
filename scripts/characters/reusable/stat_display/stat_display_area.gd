extends Node

# componnets
@onready var parent_stat_display: Node3D = $".."

@export var is_cell_container : bool = false

func toggle_display_stat_area(toggle_value: bool, player_reference: CharacterBody3D) -> void:
	
	
	parent_stat_display.visible = toggle_value
	
	if parent_stat_display.has_method("set_player_reference"):
		parent_stat_display.set_player_reference(player_reference)
	
	# hacky idc
	if is_cell_container:
		var cell_name_label := get_node_or_null("../../CellNameLabel") as Label3D
		if cell_name_label:
			cell_name_label._toggle_showing_stat_display(toggle_value)
		
	else:
		return
