extends Node

# componnet cell managers
@onready var main_cell_manager : Node = $"../MainCellManager"
@onready var energy_boost_cell_manager : Node = $"../MainCellManager/EnergyBoostCellManager"

# main breeding display loader
@onready var screen_loader_handle_display : Node = $"../BreedPreviewTv/TvFrontPannel/SubViewport/ScreenCellBreedingLoader/HandleDisplay"

func sync_breeding_cell_display() :
	
	var main_left_cell = main_cell_manager.main_left_cell
	var main_right_cell = main_cell_manager.main_right_cell
	var energy_boost_left_stat = energy_boost_cell_manager.energy_boost_left_stat 
	var energy_boost_right_stat = energy_boost_cell_manager.energy_boost_right_stat 
	var energy_boost_left_direction = energy_boost_cell_manager.energy_boost_left_direction 
	var energy_boost_right_direction = 	energy_boost_cell_manager.energy_boost_right_direction
	
	screen_loader_handle_display._handle_display(
		main_left_cell, 
		main_right_cell, 
		energy_boost_left_stat, 
		energy_boost_right_stat, 
		energy_boost_left_direction, 
		energy_boost_right_direction
	)
	
	
	
	
	
