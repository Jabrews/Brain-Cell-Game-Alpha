extends Node

@onready var screen_pick_quanity_power_off : Control = $"../MaxPickQuanityTV/TvFrontPannel/SubViewport/ScreenPickQuanity/PowerOff"
@onready var screen_hidden_stat_quanity_power_off : Control = $"../HiddenQuanityTV/TvFrontPannel/SubViewport/ScreenHiddenStatQuanity/PowerOff"
@onready var stat_control_panel_1_power_off: Control = $"../StatControllPanels/StatControlPanel/RangeControl/CapControlTv/SubViewport/CapControll/PowerOff"
@onready var stat_control_panel_2_power_off: Control = $"../StatControllPanels/StatControlPanel2/RangeControl/CapControlTv/SubViewport/CapControll/PowerOff"
@onready var stat_control_panel_3_power_off: Control = $"../StatControllPanels/StatControlPanel3/RangeControl/CapControlTv/SubViewport/CapControll/PowerOff"
@onready var stat_control_panel_parent : Node3D = $"../StatControllPanels"


#_handle_toggle_on_of

func _power_ran_out(toggleValue : bool) :
	
	screen_pick_quanity_power_off.visible = toggleValue
	screen_hidden_stat_quanity_power_off.visible = toggleValue

	stat_control_panel_1_power_off.visible = toggleValue
	stat_control_panel_2_power_off.visible = toggleValue
	stat_control_panel_3_power_off.visible = toggleValue
	
	for stat_control in stat_control_panel_parent.get_children():
		stat_control._handle_toggle_on_off(!toggleValue)
