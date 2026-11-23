extends Node

# visual components
@onready var none_label : Label3D =  $"../../../IdealStatCreator/ControlInterface/EnabledBtns/CurrStatDisplayLabelsl/EnergySpent/NoneLabel"
@onready var energy_spent_label : Label3D = $"../../../IdealStatCreator/ControlInterface/EnabledBtns/CurrStatDisplayLabelsl/EnergySpent/EnergyLabel"
@onready var energy_spent_sprite : Sprite3D = $"../../../IdealStatCreator/ControlInterface/EnabledBtns/CurrStatDisplayLabelsl/EnergySpent/EnergyIcon3"
@onready var stat_value_label : Label3D = $"../../../IdealStatCreator/ControlInterface/EnabledBtns/CurrStatDisplayLabelsl/EnergySpent/StatValueLabel"
# helper components
@onready var energy_manager : Node = $"../EnergyManager"


func _display_interface_labels(selected_ideal_stat : IdealStat) :
	
	none_label.visible = false	
	energy_spent_label.visible = false
	stat_value_label.visible = false
	energy_spent_sprite.visible = false
	
	# when none selected
	if not selected_ideal_stat : 	
		none_label.visible = true
		return
	
	else : 	
		energy_spent_label.visible = true
		stat_value_label.visible = true
		energy_spent_sprite.visible = true
		
		## energy spent
		var stat_type : String = selected_ideal_stat.stat_type
		var energy_spent : int = energy_manager.ideal_stat_energy_spent[stat_type]
		

		
		if energy_spent <= 0:
			energy_spent_label.text = str(energy_spent)
			energy_spent_label.modulate = Color.RED
			energy_spent_sprite.modulate = Color.RED
		else:
			energy_spent_label.text = "+" + str(energy_spent)
			energy_spent_label.modulate = Color.GREEN
			energy_spent_sprite.modulate = Color.GREEN
		
		
		## stat value
		
		if not selected_ideal_stat.enabled	: 
			stat_value_label.text = 'OFF'
		else : 
			stat_value_label.text = str(selected_ideal_stat.value)
		
		
		
	
	
	
	# if selected ideal stat	
	
	
	
	
	
	
	
	pass
