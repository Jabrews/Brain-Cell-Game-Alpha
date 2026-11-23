extends Node

# component
@onready var parent_ideal_stat_creator : Node = $".."
# screen components
@onready var energy_manager : Node = $"../EnergyManager"
@onready var screen_ideal_stats: Array[Node2D] = [
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealStrength/IdealTV/SubViewport/IdealStat",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealIntelligence/IdealTV/SubViewport/IdealStat",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealCommunity/IdealTV/SubViewport/IdealStat"
]
@onready var screen_selected_ideal_stat: Node2D = $"../../../IdealStatCreator/ControlInterface/SelectedIdealStatDisplay/TvFrontPanel/SubViewport/SelectedIdealStat"
@onready var screen_energy_display : Node2D = $"../../../IdealStatCreator/EnergyDisplay/TvFrontPannel/SubViewport/EnergyDisplay"
# visual worldspace components
@onready var enabled_btns_parent : Node3D = $"../../../IdealStatCreator/ControlInterface/EnabledBtns"
@onready var disabled_btns_parent : Node3D = $"../../../IdealStatCreator/ControlInterface/DisabledBtns"
@onready var active_stat_lights : Array[SpotLight3D] = [
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/StrengthLight/SpotLight3D",
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/IntelligenceLight/SpotLight3D",
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/CommunityLight/SpotLight3D"
]
@onready var active_stat_highlight_meshes : Array[MeshInstance3D] = [
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/ActiveStatHighlightMeshes/StrengthActive",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/ActiveStatHighlightMeshes/IntelligenceActive",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/ActiveStatHighlightMeshes/CommunityActive"
]
@onready var select_stat_label : Label3D = $"../../../IdealStatCreator/ControlInterface/SelectedIdealStatDisplay/SelectStat"
@onready var corner_lights : Array[SpotLight3D] = [
	$"../../../IdealStatCreator/IdealStatsWall/CornerLights/Light/Light",
	$"../../../IdealStatCreator/IdealStatsWall/CornerLights/Light2/Light",
	$"../../../IdealStatCreator/IdealStatsWall/CornerLights/Light3/Light",
	$"../../../IdealStatCreator/IdealStatsWall/CornerLights/Light4/Light"
]


var active_toggle : bool = true

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed('debug1') :
		#active_toggle = !active_toggle
		#_toggle(active_toggle)
	



func _toggle(toggle_value : bool) :
	
	parent_ideal_stat_creator.enabled = toggle_value
	
	if toggle_value : 	
		parent_ideal_stat_creator._start()
	
	screen_selected_ideal_stat.disabled_display.visible = !toggle_value
	screen_energy_display.disabled_display.visible = !toggle_value

	for corner_light in corner_lights :
		corner_light.visible = toggle_value 
	
	if toggle_value :
		enabled_btns_parent.visible = true 
		enabled_btns_parent.process_mode = Node.PROCESS_MODE_INHERIT
		disabled_btns_parent.visible = false
		disabled_btns_parent.process_mode = Node.PROCESS_MODE_DISABLED
	else : 
		enabled_btns_parent.visible = false 
		enabled_btns_parent.process_mode = Node.PROCESS_MODE_DISABLED
		disabled_btns_parent.visible = true 
		disabled_btns_parent.process_mode = Node.PROCESS_MODE_INHERIT
		
		for stat_highlight_mesh in active_stat_highlight_meshes	:
			stat_highlight_mesh.visible = false
		
	
	select_stat_label.visible = toggle_value

	for active_stat_light in active_stat_lights : 
		active_stat_light.visible = toggle_value
	
	# for stat wall
	# keep it visual so player can see what they made
	for ideal_stat_screen in screen_ideal_stats :
		ideal_stat_screen.handle_toggle_enabled._toggle(toggle_value)
	
	
	
	
	
	
