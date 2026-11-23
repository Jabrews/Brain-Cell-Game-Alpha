extends Node

# components
@onready var mock_cell_entry_parent : Control =$"../MockCellEntryParent"
@onready var cell_name_label : Label = $"../MockCellEntryParent/MarginContainer/ContentVBox/CellName"
@onready var clean_bars : Array[TextureProgressBar] = [
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Strength/StatVBox/CleanBar",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Intelligence/StatVBox/CleanBar",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Community/StatVBox/CleanBar",
]
@onready var defect_bars : Array[TextureProgressBar] = [
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Strength/StatVBox/DefectBar",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Intelligence/StatVBox/DefectBar",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Community/StatVBox/DefectBar",
]
@onready var off_parents : Array[Control] = [
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Strength/Off",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Intelligence/Off",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Community/Off",
]
@onready var hidden_rects :  Array[TextureRect] = [
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Strength/Hide",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Intelligence/Hide",
	$"../MockCellEntryParent/MarginContainer/ContentVBox/StatDisplayVBox/Community/Hide",	
]


func _display(cell : BrainCell) :
	
	# no cell found in box
	if not cell :
		mock_cell_entry_parent.visible = false
		return
	
	mock_cell_entry_parent.visible = true
	
	cell_name_label.text = cell.name
	
	load_stat_bars(cell)
	
func load_stat_bars(cell : BrainCell) :
	
	var stats : Array[String] = ['strength', 'intelligence', 'community']
	
	var index = -1
	
	for stat : String in stats :
		
		index += 1
		
		var clean_bar : TextureProgressBar = clean_bars[index]
		var defect_bar : TextureProgressBar = defect_bars[index]
		var off_parent : Control =  off_parents[index]
		var hidden_rect : TextureRect = hidden_rects[index]
		
		var cell_stat : BrainCellStat = cell.get_stat(stat)
		
		if not cell_stat.enabled :
			off_parent.visible = true
		else :
			off_parent.visible = false
		
		if cell_stat.hidden :
			hidden_rect.visible = true
		else :
			hidden_rect.visible = false
		
		var max_stat : float = IVCellCreator.max_stat_value
		
		clean_bar.max_value = max_stat
		defect_bar.max_value = max_stat
		
		
		clean_bar.value = cell_stat.value
		defect_bar.value = cell_stat.defect
		
		
		
	
	
	
	
