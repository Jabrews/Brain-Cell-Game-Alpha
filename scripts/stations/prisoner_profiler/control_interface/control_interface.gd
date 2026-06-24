extends Node

@onready var prisoner_profiler_parent : Node3D = $".."
@onready var no_stat_selected_label : Label3D = $Control/CurrStatDisplayLabelsl/EnergySpent/NoneLabel
@onready var energy_label : Label3D = $Control/CurrStatDisplayLabelsl/EnergySpent/EnergyLabel
@onready var energy_icon : Sprite3D = $Control/CurrStatDisplayLabelsl/EnergySpent/EnergyIcon3

func _update_stat() : 
	pass
	
	
