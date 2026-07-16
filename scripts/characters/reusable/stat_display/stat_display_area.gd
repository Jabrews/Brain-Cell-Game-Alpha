extends Node

# componnets
@onready var parent_stat_display: Node3D = $".."


func toggle_display_stat_area(toggle_value: bool, player_reference: CharacterBody3D) -> void:
	parent_stat_display.visible = toggle_value
	
	if parent_stat_display.has_method("set_player_reference"):
		parent_stat_display.set_player_reference(player_reference)
	else:
		return
