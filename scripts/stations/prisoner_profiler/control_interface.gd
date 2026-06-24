extends Node

@onready var prisoner_profiler_parent : Node3D = $".."
@onready var no_stat_selected_label : Label3D = $Control/CurrStatDisplayLabelsl/EnergySpent/NoneLabel
@onready var stat_value_label : Label3D = $Control/CurrStatDisplayLabelsl/EnergySpent/StatValueLabel
@onready var energy_label : Label3D = $Control/CurrStatDisplayLabelsl/EnergySpent/EnergyLabel
@onready var energy_icon : Sprite3D = $Control/CurrStatDisplayLabelsl/EnergySpent/EnergyIcon3
@onready var control_interface_energy_helper : Node = $"../Logic/HandleEnergy/ControlInterfaceEnergyHelper"


func _update_stat(stat_type : String, stat_value : int, stat_enabled : bool) -> void:
	
	if stat_type == '':
		no_stat_selected_label.visible = true
		stat_value_label.visible = false 
		energy_icon.visible = false 
		energy_label.visible = false 
		return
	
	if stat_enabled :
		stat_value_label.visible = true
	else :
		stat_value_label.visible = false
	
	
	no_stat_selected_label.visible = false
	energy_icon.visible = true
	energy_label.visible = true
	
	stat_value_label.text = '+' + str(stat_value)
	handle_energy_label(stat_type)
	
	
func handle_energy_label(stat_type : String) :
	
	var corrisponding_energy_usage : int = control_interface_energy_helper._get_energy(stat_type)
	
	if corrisponding_energy_usage <= 0 :
		energy_icon.modulate = Color.RED
		energy_label.modulate = Color.RED
		energy_label.text = str(corrisponding_energy_usage)
	else :
		energy_icon.modulate = Color.GREEN
		energy_label.modulate = Color.GREEN
		energy_label.text = '+' + str(corrisponding_energy_usage)
	
	
	
	
