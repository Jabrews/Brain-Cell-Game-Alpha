extends Node

class_name DemandItem


var demand_type: String
var demand_id: int
var demand_name: String
var demand_text: String
var demand_energy: int


@warning_ignore("shadowed_variable")
func _init(
	demand_type: String,
	demand_id: int,
	demand_name: String,
	demand_text: String,
	demand_energy: int
) -> void:
	self.demand_type = demand_type
	self.demand_id = demand_id
	self.demand_name = demand_name
	self.demand_text = demand_text
	self.demand_energy = demand_energy


func _to_string() -> String:
	return (
		"DemandItem(" +
		"type=" + demand_type +
		", id=" + str(demand_id) +
		", name=" + demand_name +
		", text=" + demand_text +
		", energy=" + str(demand_energy) +
		")"
	)
