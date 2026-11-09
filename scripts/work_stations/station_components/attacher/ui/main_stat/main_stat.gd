extends Node

# componets
@onready var display_default_stats : Node = $DisplayDefaultStats
@onready var stat_type_label : Label = $StatTypeLabel
# for detect rect when handling stat_jar_item on drop
@onready var default_detect_rect : ColorRect = $DefaultDetectRect

@export var stat_type : String = 'strength'

var main_stat_enabled : bool = false
var active_replacement_stat : bool = false

func _ready() -> void:
	stat_type_label.text = str(stat_type)

func _display(loaded_cell : BrainCell) : 
	
	var cell_stat : BrainCellStat = loaded_cell.get_stat(stat_type)	
	
	if not cell_stat : 
		push_error('main stat of type : ', stat_type, ' unable to find corrisponding cell stat')
		return
	
	# if hidden. stat isnt enabled 	
	if cell_stat.hidden : 
		main_stat_enabled = false
	else : 
		main_stat_enabled = true
	
	display_default_stats._display(cell_stat)

	
func _handle_stat_jar_item_dropped(stat_jar_item : StatJarItem) :
	print('got stat jar item : ', stat_jar_item)
	pass
