extends Node

@onready var load_panel_left : Area3D = $"../LoadPanelLeft"
@onready var load_panel_right : Area3D = $"../LoadPanelRight"
@onready var screen_main_cell_loader : Node = $"../BreedPreviewTv/TvFrontPannel/SubViewport/ScreenCellBreedingLoader/HandleDisplay/MainCellLoader"


func _reset() -> void:
	# note we only reset left because that should re-do both cells
	_reset_left()
	
func _reset_left() -> void:
	
	screen_main_cell_loader.last_left_cell = null
	
	load_panel_left.set_deferred("monitoring", false)
	
	await get_tree().process_frame
	
	load_panel_left.set_deferred("monitoring", true)
