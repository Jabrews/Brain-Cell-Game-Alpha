extends Node

# components
@onready var clean_bar : TextureProgressBar = $"../Stat/CleanBar"
@onready var defect_bar : TextureProgressBar = $"../Stat/DefectBar"


func _display(stat_jar_item : StatJarItem) :
	
	var max_stat_value : float = IVCellCreator.max_stat_value
	
	clean_bar.max_value = max_stat_value	
	defect_bar.max_value = max_stat_value	
	
	clean_bar.value = stat_jar_item.corrisponding_stat.value
	defect_bar.value = stat_jar_item.corrisponding_stat.defect
	
	
	
