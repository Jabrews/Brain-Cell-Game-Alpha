extends RefCounted

class_name ThresholdPiece


var total_turns : int
var turns_remaining : int

var early_completion_reward_energy : int
var early_completion_turn_limit : int
var early_reward_claimed : bool 

var strength : ThresholdStat
var intelligence : ThresholdStat
var community : ThresholdStat


func _init(
	new_total_turns : int,
	new_early_completion_reward_energy : int,
	new_early_completion_turn_limit : int,
	new_early_reward_claimed : bool,
	new_strength : ThresholdStat,
	new_intelligence : ThresholdStat,
	new_community : ThresholdStat
) -> void:
	
	total_turns = new_total_turns
	turns_remaining = new_total_turns
	
	early_completion_reward_energy = new_early_completion_reward_energy
	early_completion_turn_limit = new_early_completion_turn_limit
	early_reward_claimed = new_early_reward_claimed
	
	strength = new_strength
	intelligence = new_intelligence
	community = new_community

func get_stat(stat_type: String) -> ThresholdStat:
	match stat_type:
		"strength":
			return strength
		"intelligence":
			return intelligence
		"community":
			return community
		_:
			push_error("Unknown threshold stat: " + stat_type)
			return null

func print_info() -> void:
	print("------ THRESHOLD PIECE ------")
	print("Total Turns: ", total_turns)
	print("Turns Remaining: ", turns_remaining)
	print("Early Completion Reward Energy: ", early_completion_reward_energy)
	print("Early Completion Turn Limit: ", early_completion_turn_limit)
	print('Early Reward Claimed : ', early_reward_claimed)
	print("Strength: ", strength)
	print("Intelligence: ", intelligence)
	print("Community: ", community)
	print("-----------------------------")
