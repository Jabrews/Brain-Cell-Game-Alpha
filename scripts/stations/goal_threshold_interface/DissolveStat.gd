extends RefCounted

class_name DissolveStat


var stat_type : String
var corresponding_threshold_stat : ThresholdStat
var dissolving_cell : BrainCell
var amount_to_decrease : float


func _init(
	new_stat_type : String,
	new_corresponding_threshold_stat : ThresholdStat,
	new_dissolving_cell : BrainCell,
	new_amount_to_decrease : float
) -> void:
	
	stat_type = new_stat_type
	corresponding_threshold_stat = new_corresponding_threshold_stat
	dissolving_cell = new_dissolving_cell
	amount_to_decrease = new_amount_to_decrease


func print_info() -> void:
	print("---- DISSOLVE STAT ----")
	print("Stat Type: ", stat_type)
	print("Threshold Stat: ", corresponding_threshold_stat)
	print("Dissolving Cell: ", dissolving_cell)
	print("Amount To Decrease: ", amount_to_decrease)
	print("-----------------------")
