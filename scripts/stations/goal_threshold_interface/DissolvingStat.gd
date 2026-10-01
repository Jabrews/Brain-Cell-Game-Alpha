extends RefCounted

class_name DissolvingStat


var stat_type: String
var amount_to_decrease: float
var defect_ignore: float
var corresponding_threshold_stat : ThresholdStat


func _init(
	new_stat_type: String,
	new_amount_to_decrease: float,
	new_defect_ignore: float,
	new_corresponding_threshold_stat  : ThresholdStat
) -> void:
	
	stat_type = new_stat_type
	amount_to_decrease = new_amount_to_decrease
	defect_ignore = new_defect_ignore
	corresponding_threshold_stat = new_corresponding_threshold_stat


func print_info() -> void:
	print("---- DISSOLVING STAT ----")
	print("Stat Type: ", stat_type)
	print("Amount To Decrease: ", amount_to_decrease)
	print("Defect Ignore: ", defect_ignore)
	print('Corrisponding Threshold Stat : ', corresponding_threshold_stat)
	print("-------------------------")
