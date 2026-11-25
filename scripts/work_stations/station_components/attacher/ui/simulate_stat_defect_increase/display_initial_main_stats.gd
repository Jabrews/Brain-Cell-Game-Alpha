extends Node

@onready var stat_parents: Array[Control] = [
	$"../Content/MainStats/Strength",
	$"../Content/MainStats/Intelligence",
	$"../Content/MainStats/Community",
]

@onready var clean_bars: Array[TextureProgressBar] = [
	$"../Content/MainStats/Strength/DefaultInfoContainer/CleanBar",
	$"../Content/MainStats/Intelligence/DefaultInfoContainer/CleanBar",
	$"../Content/MainStats/Community/DefaultInfoContainer/CleanBar",
]

@onready var defect_bars: Array[TextureRect] = [
	$"../Content/MainStats/Strength/DefaultInfoContainer/DefectBar",
	$"../Content/MainStats/Intelligence/DefaultInfoContainer/DefectBar",
	$"../Content/MainStats/Community/DefaultInfoContainer/DefectBar",
]

@onready var hidden_rects: Array[TextureRect] = [
	$"../Content/MainStats/Strength/HiddenRect",
	$"../Content/MainStats/Intelligence/HiddenRect",
	$"../Content/MainStats/Community/HiddenRect",
]

@export var inactive_opacity: float = 0.1

var stats: Array[String] = ['strength', 'intelligence', 'community']


func _ready() -> void:
	for defect_bar in defect_bars:
		defect_bar.material = defect_bar.material.duplicate()


func _display(old_cell: BrainCell, new_cell: BrainCell) :

	for curr_index in range(stats.size()):

		# get data
		var stat_type: String = stats[curr_index]
		var old_stat: BrainCellStat = old_cell.get_stat(stat_type)
		var new_stat: BrainCellStat = new_cell.get_stat(stat_type)

		# get components
		var stat_parent: Control = stat_parents[curr_index]
		var clean_bar: TextureProgressBar = clean_bars[curr_index]
		var defect_bar: TextureRect = defect_bars[curr_index]
		var hidden_rect: TextureRect = hidden_rects[curr_index]



		# preserve container layout
		stat_parent.visible = true
		clean_bar.visible = true
		defect_bar.visible = true
		hidden_rect.visible = true
		
		var defect_increase: int = int(new_stat.defect - old_stat.defect)

		# set parent opacity based on defect increase
		if defect_increase <= 0:
			stat_parent.modulate.a = inactive_opacity
		else:
			stat_parent.modulate.a = 1.0

		# handle hidden stat opacity
		hidden_rect.modulate.a = 1.0 if new_stat.hidden else 0.0
		clean_bar.modulate.a = 0.0 if new_stat.hidden else 1.0
		defect_bar.modulate.a = 0.0 if new_stat.hidden else 1.0

		var max_value: float = IVCellCreator.max_stat_value

		# set clean bar value
		clean_bar.max_value = max_value
		clean_bar.value = old_stat.value

		# set defect bar values
		defect_bar.material.set_shader_parameter(
			"prior_defect_value",
			old_stat.defect / max_value
		)

		defect_bar.material.set_shader_parameter(
			"new_defect_value",
			new_stat.defect / max_value
		)
