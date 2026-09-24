extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community",
]

# components
@onready var get_side_boost_components : Node = $"../GetSideBoostComponents"


func _display(cell : BrainCell, side : String) -> void:
	
	
	
	if not cell:
		return
	
	var boost_components : Dictionary = get_side_boost_components._get_boost_stat(side)
	
	var clean_bars : Array = boost_components["clean_bars"]
	var defect_bars : Array = boost_components["defect_bars"]
	var hidden_sprites : Array = boost_components["hidden_sprites"]
	var off_parents : Array = boost_components["off_parents"]
	var cell_name_label : Label = boost_components["cell_name_label"]
	
	var max_value : float = float(IVCellCreator.max_stat_value)
	
	cell_name_label.text = cell.name
	
	
	# duplicate materials so each bar can have its own shader values
	for clean_bar : Sprite2D in clean_bars:
		clean_bar.material = clean_bar.material.duplicate()
	
	for defect_bar : Sprite2D in defect_bars:
		defect_bar.material = defect_bar.material.duplicate()
	
	
	for i : int in STAT_TYPES.size():
		
		var stat_type : String = STAT_TYPES[i]
		var cell_stat : BrainCellStat = cell.get_stat(stat_type)
		
		if not cell_stat.enabled:
			_display_disabled_stat(
				i,
				clean_bars,
				defect_bars,
				hidden_sprites,
				off_parents
			)
			continue
		
		_display_enabled_stat(
			i,
			clean_bars,
			defect_bars,
			off_parents
		)
		
		_display_hidden_stat(
			i,
			cell_stat,
			hidden_sprites
		)
		
		_display_defect_stat(
			i,
			cell_stat,
			defect_bars,
			max_value
		)
		
		_display_clean_stat(
			i,
			cell_stat,
			clean_bars,
			max_value
		)


func _display_disabled_stat(
	index : int,
	clean_bars : Array,
	defect_bars : Array,
	hidden_sprites : Array,
	off_parents : Array
) -> void:
	
	off_parents[index].visible = true
	
	clean_bars[index].modulate.a = 0.4
	defect_bars[index].modulate.a = 0.4
	
	hidden_sprites[index].visible = false


func _display_enabled_stat(
	index : int,
	clean_bars : Array,
	defect_bars : Array,
	off_parents : Array
) -> void:
	
	off_parents[index].visible = false
	
	clean_bars[index].modulate.a = 1.0
	defect_bars[index].modulate.a = 1.0


func _display_hidden_stat(
	index : int,
	cell_stat : BrainCellStat,
	hidden_sprites : Array
) -> void:
	
	hidden_sprites[index].visible = cell_stat.hidden


func _display_defect_stat(
	index : int,
	cell_stat : BrainCellStat,
	defect_bars : Array,
	max_value : float
) -> void:
	
	defect_bars[index].material.set_shader_parameter(
		"prior_defect_value",
		0.0
	)
	
	defect_bars[index].material.set_shader_parameter(
		"new_defect_value",
		cell_stat.defect / max_value
	)


func _display_clean_stat(
	index : int,
	cell_stat : BrainCellStat,
	clean_bars : Array,
	max_value : float
) -> void:
	
	
	clean_bars[index].material.set_shader_parameter(
		"old_prisoner_value",
		0.0
	)
	
	clean_bars[index].material.set_shader_parameter(
		"new_prisoner_value",
		cell_stat.value / max_value
	)
