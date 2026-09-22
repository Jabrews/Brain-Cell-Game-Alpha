extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community",
]

var no_cell_loaded_label: Label
var stat_display_parent: Control
var cell_name_label: Label
var clean_bars: Array[Sprite2D]
var defect_bars: Array[TextureProgressBar]
var hidden_sprites: Array[Sprite2D]
var off_labels: Array[Label]


func _display(cell: BrainCell, components: Dictionary) -> void:
	
	
	no_cell_loaded_label = components["no_cell_loaded_label"]
	stat_display_parent = components["stat_display_parent"]
	cell_name_label = components["cell_name_label"]
	clean_bars = components["clean_bars"]
	defect_bars = components["defect_bars"]
	hidden_sprites = components["hidden_sprites"]
	off_labels = components["off_labels"]
	
	if cell:
		no_cell_loaded_label.visible = false
		stat_display_parent.visible = true
		
		cell_name_label.text = cell.name
		
		load_stat_bars(cell)
	
	else:
		no_cell_loaded_label.visible = true
		stat_display_parent.visible = false


func load_stat_bars(cell: BrainCell) -> void:
	
	var max_value: float = float(IVCellCreator.max_stat_value)
	
	for i: int in STAT_TYPES.size():
		
		var stat_type: String = STAT_TYPES[i]
		var cell_stat: BrainCellStat = cell.get_stat(stat_type)
		
		if not cell_stat.enabled:
			
			_display_disabled_stat(i)
			
			clean_bars[i].material.set_shader_parameter(
				"prisoner_value",
				0,
			)
			
			clean_bars[i].material.set_shader_parameter(
				"charge_value",
				0,
			)
			continue
		
		_display_enabled_stat(i)
		_display_hidden_stat(i, cell_stat)
		_display_defect_stat(i, cell_stat)
		_display_clean_stat(i, cell_stat, max_value)


func _display_disabled_stat(index: int) -> void:
	off_labels[index].visible = true
	
	defect_bars[index].visible = false
	clean_bars[index].modulate.a = 0.4
	hidden_sprites[index].visible = false


func _display_enabled_stat(index: int) -> void:
	off_labels[index].visible = false
	
	defect_bars[index].visible = true
	clean_bars[index].modulate.a = 1.0


func _display_hidden_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	hidden_sprites[index].visible = cell_stat.hidden


func _display_defect_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	defect_bars[index].max_value = IVCellCreator.max_stat_value
	defect_bars[index].value = cell_stat.defect


func _display_clean_stat(
	index: int,
	cell_stat: BrainCellStat,
	max_value: float
) -> void:
	clean_bars[index].material.set_shader_parameter(
		"prisoner_value",
		cell_stat.value / max_value
	)

	clean_bars[index].material.set_shader_parameter(
		"charge_value",
		cell_stat.value / max_value
	)
