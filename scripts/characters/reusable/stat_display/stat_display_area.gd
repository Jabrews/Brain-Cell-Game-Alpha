extends Node

# componnets
@onready var parent_stat_display : Node3D = $".."

func toggle_display_stat_area(toggleValue : bool, player_refrence : CharacterBody3D) : 
	
	parent_stat_display.player = player_refrence
	parent_stat_display.visible = toggleValue
	
