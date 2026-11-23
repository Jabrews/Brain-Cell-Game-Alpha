extends Node

# components (not replacement)
@onready var clean_bar : TextureProgressBar =  $"../DefaultInfoContainer/CleanBar"
@onready var defect_bar : TextureProgressBar = $"../DefaultInfoContainer/DefectBar"
@onready var hidden_rect : TextureRect = $"../HiddenRect"
@onready var disabled_parent : Control = $"../DisabledParent"

func _display(cell_stat : BrainCellStat) :
		
	# reset hidden and disabled parent	
	disabled_parent.visible = false	
	hidden_rect.visible = false
	clean_bar.modulate.a = 0.0
	defect_bar.modulate.a = 0.0
	
	# reset bar values	
	var max_stat_value : float = IVCellCreator.max_stat_value
	
	clean_bar.max_value = max_stat_value		
	defect_bar.max_value = max_stat_value
	
	clean_bar.value = 0.0
	defect_bar.value = 0.0
	
	if not cell_stat.enabled : 
		disabled_parent.visible = true	
		
		return
	
	if cell_stat.hidden : 
		hidden_rect.visible = true
		return
	
	else : 
		
		clean_bar.modulate.a = 1.0
		defect_bar.modulate.a = 1.0
		
		clean_bar.value = cell_stat.value
		defect_bar.value = cell_stat.defect
		
	
	
	
	
