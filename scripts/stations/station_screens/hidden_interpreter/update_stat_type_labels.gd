extends Node

@onready var stat_type_labels : Array[Label] = [
	$"../ProgressScreen/StatName",
	$"../NoCellDetectScreen/StatName",
	$"../JoltDetected/StatName",
]



func _update(stat_type : String) : 
	for label : Label in stat_type_labels : 
		label.text = stat_type
