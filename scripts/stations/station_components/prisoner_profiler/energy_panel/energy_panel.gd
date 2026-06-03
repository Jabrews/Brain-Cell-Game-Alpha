extends Node

@onready var curr_energy_label : Label3D = $CurrEnergy
@onready var used_energy_label : Label3D = $EnergyUsed
@onready var left_over_energy_label : Label3D = $EnerfyLeft


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)
	_handle_next_round() 

func _handle_next_round() :
	curr_energy_label.text = str(GLGameManagerBus.curr_energy)
	used_energy_label.text = str(0)
	left_over_energy_label.text = str(GLGameManagerBus.curr_energy)


func handle_energy_to_spend_change(energy_to_spend: int) :
	
	# update curr energy label
	curr_energy_label.text = str(GLGameManagerBus.curr_energy)
	
	# update energy were spending 
	used_energy_label.text = str(energy_to_spend)
	
	# set left over energy after potential change
	var left_over = GLGameManagerBus.curr_energy - energy_to_spend
	left_over_energy_label.text = str(left_over)
	
		
	
	
