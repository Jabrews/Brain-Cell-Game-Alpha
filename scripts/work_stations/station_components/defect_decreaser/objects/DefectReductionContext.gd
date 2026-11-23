extends Node

class_name DefectReductionContext

var loaded_cell : BrainCell
var valid : bool
var valid_stats : Array[BrainCellStat]

func _init(
	new_loaded_cell : BrainCell,
	new_valid : bool,
	new_valid_stats : Array[BrainCellStat],
) -> void:
	loaded_cell = new_loaded_cell
	valid = new_valid
	valid_stats = new_valid_stats

func _to_print() :
	print('loaded cell : ', loaded_cell.name)
	print('valid : ', valid)
	print('valid stats : ', valid_stats)
