extends Node

# stat parents
@onready var l_stat_parents : Array[Control] = [
	$"../BreederBars/Left/Strength", 
	$"../BreederBars/Left/Intelligence", 
	$"../BreederBars/Left/Community"
]
@onready var r_stat_parents : Array[Control] = [
	$"../BreederBars/Right/Strength", 
	$"../BreederBars/Right/Intelligence", 
	$"../BreederBars/Right/Community"
]
# clean bars
@onready var l_clean_bars : Array[Sprite2D] = [
	$"../BreederBars/Left/Strength/CleanBar", 
	$"../BreederBars/Left/Intelligence/CleanBar", 
	$"../BreederBars/Left/Community/CleanBar"
]
@onready var r_clean_bars : Array[Sprite2D] = [
	$"../BreederBars/Right/Strength/CleanBar", 
	$"../BreederBars/Right/Intelligence/CleanBar", 
	$"../BreederBars/Right/Community/CleanBar"
]
# defect bars
@onready var l_defect_bars : Array[Sprite2D] = [
	$"../BreederBars/Left/Strength/DefectBar", 
	$"../BreederBars/Left/Intelligence/DefectBar", 
	$"../BreederBars/Left/Community/DefectBar"
]
@onready var r_defect_bars : Array[Sprite2D] = [
	$"../BreederBars/Right/Strength/DefectBar",
	$"../BreederBars/Right/Intelligence/DefectBar",
	$"../BreederBars/Right/Community/DefectBar"
]
# hidden sprites
@onready var l_hidden_sprites : Array[Sprite2D] = [
	$"../BreederBars/Left/Strength/HiddenSprite",
	$"../BreederBars/Left/Intelligence/HiddenSprite",
	$"../BreederBars/Left/Community/HiddenSprite"
]
@onready var r_hidden_sprites : Array[Sprite2D] = [
	$"../BreederBars/Right/Strength/HiddenSprite",
	$"../BreederBars/Right/Intelligence/HiddenSprite",
	$"../BreederBars/Right/Community/HiddenSprite"
]
# failed parents
@onready var l_failed_parent : Control = $"../FailedParents/FailedParentLeft"
@onready var r_failed_parent : Control = $"../FailedParents/FailedParentRight"


var stats: Array[String] = [
	"strength",
	"intelligence",
	"community"
]


func _ready() -> void:
	for bar in l_clean_bars + r_clean_bars:
		if bar.material:
			bar.material = bar.material.duplicate()

	for bar in l_defect_bars + r_defect_bars:
		if bar.material:
			bar.material = bar.material.duplicate()


func _evaluate(
	new_main_left_cell: BrainCell,
	new_main_right_cell: BrainCell,
	new_left_failure: bool,
	new_right_failure: bool
) -> Dictionary[String, Dictionary]:
	
	l_failed_parent.visible = new_left_failure
	r_failed_parent.visible = new_right_failure 
	

	var l_defect_amount_to_increase: Dictionary[String, int] = {
		"strength": 0,
		"intelligence": 0,
		"community": 0
	}

	var r_defect_amount_to_increase: Dictionary[String, int] = {
		"strength": 0,
		"intelligence": 0,
		"community": 0
	}

	var max_value: float = float(IVCellCreator.max_stat_value)

	# Evaluate both sides
	for side_index in range(2):
		var cell: BrainCell
		var failed: bool

		var stat_parents: Array[Control]
		var clean_bars: Array[Sprite2D]
		var defect_bars: Array[Sprite2D]
		var hidden_sprites: Array[Sprite2D]

		if side_index == 0:
			cell = new_main_left_cell
			failed = new_left_failure

			stat_parents = l_stat_parents
			clean_bars = l_clean_bars
			defect_bars = l_defect_bars
			hidden_sprites = l_hidden_sprites
		else:
			cell = new_main_right_cell
			failed = new_right_failure

			stat_parents = r_stat_parents
			clean_bars = r_clean_bars
			defect_bars = r_defect_bars
			hidden_sprites = r_hidden_sprites

		# Evaluate each stat
		for index in range(stats.size()):
			var stat_name: String = stats[index]
			var cell_stat: BrainCellStat = cell.get_stat(stat_name)

			var stat_parent: Control = stat_parents[index]
			var clean_bar: Sprite2D = clean_bars[index]
			var defect_bar: Sprite2D = defect_bars[index]
			var hidden_sprite: Sprite2D = hidden_sprites[index]

			# Disabled stats
			if not cell_stat.enabled:
				stat_parent.visible = false
				continue

			stat_parent.visible = true

			# Normal defect increase
			var new_defect_value: float = float(
				GAMECellBreeder.decrease_old_cell._get_increased_defect_stat(
					cell_stat.defect
				)
			)

			# Additional 15% defect on failure
			if failed:
				new_defect_value += max_value * 0.15

			# Clamp to maximum
			new_defect_value = clampf(
				new_defect_value,
				0.0,
				max_value
			)

			# Calculate actual increase
			var defect_increase: int = maxi(
				0,
				roundi(new_defect_value) - int(cell_stat.defect)
			)

			# Store increase
			if side_index == 0:
				l_defect_amount_to_increase[stat_name] = defect_increase
			else:
				r_defect_amount_to_increase[stat_name] = defect_increase


			# Update defect shader
			
			defect_bar.material.set_shader_parameter(
				"prior_defect_value",
				cell_stat.defect / max_value
			)
			
			defect_bar.material.set_shader_parameter(
				"new_defect_value",
				new_defect_value / max_value
			)
			
			

			# Update clean bar shader
			clean_bar.material.set_shader_parameter(
				"prisoner_value",
				float(cell_stat.value) / max_value
			)
			
			clean_bar.material.set_shader_parameter(
				"charge_value",
				float(cell_stat.value) / max_value
			)

			# Hidden stat indicator
			hidden_sprite.visible = cell_stat.hidden

	return {
		"left": l_defect_amount_to_increase,
		"right": r_defect_amount_to_increase
	}
