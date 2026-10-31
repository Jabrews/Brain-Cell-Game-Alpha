extends Node

# components
# display components 

@onready var cell_name_label : Label = $"../MockCellEntry/CellName"
@onready var clean_bars : Array[TextureProgressBar] = [
	$"../MockCellEntry/StatDisplay/Strength/CleanBar",
	$"../MockCellEntry/StatDisplay/Intelligence/CleanBar",
	$"../MockCellEntry/StatDisplay/Community/CleanBar"
]
@onready var defect_bars : Array[TextureProgressBar] = [
	$"../MockCellEntry/StatDisplay/Strength/DefectBar",
	$"../MockCellEntry/StatDisplay/Intelligence/DefectBar",
	$"../MockCellEntry/StatDisplay/Community/DefectBar"
]
@onready var off_parents : Array[Control] = [
	$"../MockCellEntry/StatDisplay/Strength/Off",
	$"../MockCellEntry/StatDisplay/Intelligence/Off",
	$"../MockCellEntry/StatDisplay/Community/Off"
]
@onready var hidden_sprites : Array[Sprite2D] = [
	$"../MockCellEntry/StatDisplay/Strength/Hide",
	$"../MockCellEntry/StatDisplay/Intelligence/Hide",
	$"../MockCellEntry/StatDisplay/Community/Hide"
]

func _display(loaded_cell : BrainCell) :
	
	if not loaded_cell :
		push_error('tried creating cell entry without cell')
		return
	
	cell_name_label.text = loaded_cell.name
	
	load_stat_bars(loaded_cell)
	
	
func load_stat_bars(cell : BrainCell) :	
	
	var stats : Array[String] = ['strength', 'intelligence', 'community']
	
	var index = -1
	
	for stat : String in stats :
		
		index += 1
		
		var clean_bar : TextureProgressBar = clean_bars[index]
		var defect_bar : TextureProgressBar = defect_bars[index]
		var off_parent : Control =  off_parents[index]
		var hidden_sprite : Sprite2D = hidden_sprites[index]
		
		var cell_stat : BrainCellStat = cell.get_stat(stat)		
		
		if not cell_stat.enabled : 
			off_parent.visible = true
		else : 
			off_parent.visible = false 
		
		if cell_stat.hidden : 
			hidden_sprite.visible = true
		else : 
			hidden_sprite.visible = false 
		
		var max_stat : float = IVCellCreator.max_stat_value
		
		clean_bar.max_value = max_stat
		defect_bar.max_value = max_stat
		
		
		clean_bar.value = cell_stat.value
		defect_bar.value = cell_stat.defect
		
		
		
		
		
		
		
		
	
	
	
		
		
		
	
	
	
	
	
	
	
	
	
