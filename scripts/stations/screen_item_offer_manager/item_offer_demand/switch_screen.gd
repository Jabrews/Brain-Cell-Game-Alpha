extends Node

@onready var stat_demand_display : Control = $"../StatDemand"
@onready var no_demand_display : Control = $"../NoDemand"


func _toggle_active_offer(toggle_value : bool):
	match toggle_value :
		true :
			stat_demand_display.visible = true
			no_demand_display.visible = false
		false :
			stat_demand_display.visible = true
			no_demand_display.visible = false
			
