extends Node

class_name ItemOfferDemandConstructor

var demand_type: String
var demand_cell: BrainCell
var energy_reward: int
var energy_left_to_claim: int


func _init(
	_demand_type: String,
	_energy_reward: int,
	_energy_left_to_claim: int,
	_demand_cell: BrainCell = null
) -> void:
	demand_type = _demand_type
	demand_cell = _demand_cell
	energy_reward = _energy_reward
	energy_left_to_claim = _energy_left_to_claim
