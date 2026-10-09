extends Node

@onready var active_stat_label : Label3D = $"../../../IdealStatCreator/ControlInterface/SelectedIdealStatDisplay/SelectStat"

func _display_label(stat_type : String) : 
	active_stat_label.text = str(stat_type)
