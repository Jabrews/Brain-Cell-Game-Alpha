extends Node

@export var stat_type : String = 'strength'

# base stat components (no replacement)
@onready var stat_type_label : Label = $StatTypeLabel
@onready var clean_bar : TextureProgressBar =  $CleanBar
@onready var defect_bar : TextureProgressBar = $DefectBar
@onready var hidden_sprite : Sprite2D = $HiddenSprite
@onready var disabled_parent : Control = $DisabledParent

var main_stat_enabled : bool = false
var active_replacement_stat : bool = false

func _ready() -> void:
	stat_type_label.text = str(stat_type)

func _display(loaded_cell : BrainCell) : 
	
	var cell_stat : BrainCellStat = loaded_cell.get_stat(stat_type)	
	
	if not cell_stat : 
		push_error('main stat of type : ', stat_type, ' unable to find corrisponding cell stat')
		return
	
	display_base_stat(cell_stat)

func display_base_stat(cell_stat : BrainCellStat) :
	
	# reset hidden and disabled parent	
	disabled_parent.visible = false	
	hidden_sprite.visible = false
	
	# reset bar values	
	var max_stat_value : float = IVCellCreator.max_stat_value
	
	clean_bar.max_value = max_stat_value		
	defect_bar.max_value = max_stat_value
	
	clean_bar.value = 0.0
	defect_bar.value = 0.0
	
	if not cell_stat.enabled : 
		disabled_parent.visible = true	
		
		main_stat_enabled = true 
		
		return
	
	if cell_stat.hidden : 
		hidden_sprite.visible = true
		
		main_stat_enabled = false 
		
		return
	
	else : 
		clean_bar.value = cell_stat.value
		defect_bar.value = cell_stat.defect
		
		main_stat_enabled = true
	
	
	
	
	
	
