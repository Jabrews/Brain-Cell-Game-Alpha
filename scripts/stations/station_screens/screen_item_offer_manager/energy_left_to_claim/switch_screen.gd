extends Node

@onready var no_demand_display : Control = $"../NoDemand"
@onready var energy_left_display : Control = $"../EnergyLeft"

func _toggle_active_offer(toggle_value : bool):
	match toggle_value :
		true :
			energy_left_display.visible = true
			no_demand_display.visible = false
		false :
			energy_left_display.visible = false
			no_demand_display.visible = true 
			
