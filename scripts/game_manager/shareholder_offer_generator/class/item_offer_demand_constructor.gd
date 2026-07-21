extends Node

class_name ItemOfferDemandConstructor

var demand_type: String
var energy_reward: int
var energy_left_to_claim: int
var demand_cell: BrainCell
var demand_mutation : BrainCellMutation


func _init(
	_demand_type: String,
	_energy_reward: int,
	_energy_left_to_claim: int,
	_demand_cell: BrainCell = null,
	_demand_mutation : BrainCellMutation = null
) -> void:
	demand_type = _demand_type
	energy_reward = _energy_reward
	energy_left_to_claim = _energy_left_to_claim
	demand_cell = _demand_cell
	demand_mutation = _demand_mutation
