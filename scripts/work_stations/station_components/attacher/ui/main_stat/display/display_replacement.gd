extends Node

# components
@onready var stat_replacement_parent : Control = $"../StatReplacement"
@onready var clean_bar : TextureProgressBar = $"../StatReplacement/ReplacementInfoContainer/DefaultInfoContainer/CleanBar"
@onready var defect_bar : TextureProgressBar =$"../StatReplacement/ReplacementInfoContainer/DefaultInfoContainer/DefectBar"
@onready var penality_failure_rate : Control = $"../StatReplacement/ReplacementInfoContainer/Header/PenalityFailureRate"
@onready var parent_main_stat : Control = $".."


func _display(replacement_stat_jar_item : StatJarItem) :
	
	# NOTICE 
	# there is no possible way (as i know of) for the replacement stat to be hidden or disabled
	
	if replacement_stat_jar_item : 	
		stat_replacement_parent.visible = true
	else :
		stat_replacement_parent.visible = false 
		return
	
	var cell_stat : BrainCellStat = replacement_stat_jar_item.corrisponding_stat
	
	if not cell_stat : 
		push_error('somehow recieved invalid replacement stat  :', replacement_stat_jar_item.print_jar_item())
		return
	
	var max_value : float = IVCellCreator.max_stat_value

	clean_bar.max_value = max_value
	defect_bar.max_value = max_value
	
	clean_bar.value = cell_stat.value
	defect_bar.value = cell_stat.defect
	
	# failure penality
	var loaded_cell_stat: BrainCellStat = parent_main_stat.loaded_cell_stat
	

	penality_failure_rate.visible = (
		loaded_cell_stat != null
		and loaded_cell_stat.enabled
		and GLWorkstationBus.attacher_failure_enabled
	)
