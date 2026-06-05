extends Node

@onready var stat_control_panel_1_quanity_not_selected: Control = $"../StatControllPanels/StatControlPanel/RangeControl/CapControlTv/SubViewport/CapControll/PrisonerQuanityNotSelected"
@onready var stat_control_panel_2_quanity_not_selected: Control = $"../StatControllPanels/StatControlPanel2/RangeControl/CapControlTv/SubViewport/CapControll/PrisonerQuanityNotSelected"
@onready var stat_control_panel_3_quanity_not_selected: Control = $"../StatControllPanels/StatControlPanel3/RangeControl/CapControlTv/SubViewport/CapControll/PrisonerQuanityNotSelected"


func _player_tried_incrementing_stat() :
	
	stat_control_panel_1_quanity_not_selected.visible = true	
	stat_control_panel_2_quanity_not_selected.visible = true	
	stat_control_panel_3_quanity_not_selected.visible = true	
	
	await get_tree().create_timer(1.5).timeout
	
	stat_control_panel_1_quanity_not_selected.visible = false 
	stat_control_panel_2_quanity_not_selected.visible = false 
	stat_control_panel_3_quanity_not_selected.visible = false 
	
	
	
	
