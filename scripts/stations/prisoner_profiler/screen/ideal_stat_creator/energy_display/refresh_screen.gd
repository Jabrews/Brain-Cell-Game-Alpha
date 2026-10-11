extends Node

# components
@onready var total_energy_value_label : Label = $"../CurrEnergy/EnergyValueLabel"
@onready var total_energy_spent_label : Label = $"../UsedEnergy/EnergyValueLabel"
@onready var hint_invalid_energy_left_parent : Control = $"../HintInvalidEnergyLeft"

func _refresh(total_energy : int, total_energy_spent : int) : 
	## energy spent 
	
	total_energy_spent_label.visible = true
	
	if total_energy_spent > 0 :
		total_energy_spent_label.text = 	'( +' + str(total_energy_spent) + ' )'
		total_energy_spent_label.add_theme_color_override("font_color", Color.GREEN)
	elif total_energy_spent < 0 : 
		total_energy_spent_label.text = '( ' + str(total_energy_spent) + ' )'
		total_energy_spent_label.add_theme_color_override("font_color", Color.RED)
	# if it is 0
	else : 
		total_energy_spent_label.visible = false
		
	## total energy
	total_energy_value_label.text = str(total_energy + total_energy_spent)
		
	if total_energy + total_energy_spent < 0 : 	
		total_energy_value_label.add_theme_color_override("font_color", Color.RED)
		hint_invalid_energy_left_parent._activate(true)
		
	else : 
		total_energy_value_label.add_theme_color_override("font_color", Color.WHITE)
		hint_invalid_energy_left_parent._activate(false)
	
