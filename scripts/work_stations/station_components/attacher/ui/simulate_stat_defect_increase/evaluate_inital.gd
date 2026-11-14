extends Node

@onready var stat_parents: Array[Control] = [
	$"../AttacherBars/Strength",
	$"../AttacherBars/Intelligence",
	$"../AttacherBars/Community"
]

@onready var clean_bars: Array[TextureProgressBar] = [
	$"../AttacherBars/Strength/CleanBar",
	$"../AttacherBars/Intelligence/CleanBar",
	$"../AttacherBars/Community/CleanBar"
]

@onready var defect_bars: Array[TextureProgressBar] = [
	$"../AttacherBars/Strength/DefectBar",
	$"../AttacherBars/Intelligence/DefectBar",
	$"../AttacherBars/Community/DefectBar"
]

@onready var hidden_sprites : Array[Sprite2D] = [
	$"../AttacherBars/Strength/HiddenSprite",
	$"../AttacherBars/Intelligence/HiddenSprite",
	$"../AttacherBars/Community/HiddenSprite"
]

var stats: Array[String] = ['strength', 'intelligence', 'community']


func _evaluate(new_cell: BrainCell, old_cell: BrainCell) -> Dictionary[String, int]:

	var defect_amount_to_increase: Dictionary[String, int] = {
		'strength': 0,
		'intelligence': 0,
		'community': 0,
	}

	for curr_index in range(stats.size()):

		# get data
		var stat_type: String = stats[curr_index]
		var old_stat: BrainCellStat = old_cell.get_stat(stat_type)
		var new_stat: BrainCellStat = new_cell.get_stat(stat_type)

		# get components
		var stat_parent: Control = stat_parents[curr_index]
		var clean_bar: TextureProgressBar = clean_bars[curr_index]
		var defect_bar: TextureProgressBar = defect_bars[curr_index]
		var hidden_sprite : Sprite2D = hidden_sprites[curr_index]

		# calculate defect difference
		var defect_increase: int = int(new_stat.defect - old_stat.defect)

		# hide stats without defect changes
		if defect_increase <= 0:
			stat_parent.visible = false
			hidden_sprite.visible =  false
			continue

		# display old cell stats
		stat_parent.visible = true
		
		if new_stat.hidden :
			hidden_sprite.visible = true
		else :
			hidden_sprite.visible = false

		var max_value: float = IVCellCreator.max_stat_value

		clean_bar.max_value = max_value
		defect_bar.max_value = max_value

		clean_bar.value = old_stat.value
		defect_bar.value = old_stat.defect

		# Store amount to animate
		defect_amount_to_increase[stat_type] = defect_increase

	return defect_amount_to_increase
