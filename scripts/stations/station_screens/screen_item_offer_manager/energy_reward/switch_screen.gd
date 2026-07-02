extends Node

@onready var no_demand_display : Control = $"../NoDemand"
@onready var reward_display : Control = $"../Reward"


func _toggle_active_offer(toggle_value : bool):
	match toggle_value :
		true :
			reward_display.visible = true
			no_demand_display.visible = false
		false :
			reward_display.visible = false 
			no_demand_display.visible = true 
			
