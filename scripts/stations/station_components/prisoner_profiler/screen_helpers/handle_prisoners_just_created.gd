extends Node

# componnets
@onready var screen_pick_quanity_just_created : Control = $"../MaxPickQuanityTV/TvFrontPannel/SubViewport/ScreenPickQuanity/PrisonerJustCreated"
@onready var screen_hidden_stat_quanity_just_created: Control = $"../HiddenQuanityTV/TvFrontPannel/SubViewport/ScreenHiddenStatQuanity/PrisonerJustCreated"
@onready var stat_control_panel_1_just_created : Control = $"../StatControllPanels/StatControlPanel/RangeControl/CapControlTv/SubViewport/CapControll/PrisonerJustCreated"
@onready var stat_control_panel_2_just_created : Control = $"../StatControllPanels/StatControlPanel2/RangeControl/CapControlTv/SubViewport/CapControll/PrisonerJustCreated"
@onready var stat_control_panel_3_just_created : Control = $"../StatControllPanels/StatControlPanel3/RangeControl/CapControlTv/SubViewport/CapControll/PrisonerJustCreated"



func _prisoners_just_created() :
	screen_pick_quanity_just_created.visible = true
	screen_hidden_stat_quanity_just_created.visible = true
	stat_control_panel_1_just_created.visible = true
	stat_control_panel_2_just_created.visible = true
	stat_control_panel_3_just_created.visible = true
	
	await get_tree().create_timer(5.0).timeout
	
	screen_pick_quanity_just_created.visible = false 
	screen_hidden_stat_quanity_just_created.visible = false 
	stat_control_panel_1_just_created.visible = false 
	stat_control_panel_2_just_created.visible = false 
	stat_control_panel_3_just_created.visible = false 
	
	
