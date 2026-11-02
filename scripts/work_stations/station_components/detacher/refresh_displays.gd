extends Node

# components
@onready var parent_station_detacher : Node3D = $"../.."
# screen components
@onready var screen_detacher : Node2D = $"../../DeatcherTV/TvFrontPannel/SubViewport/ScreenDetacher"
@onready var screen_failure_chance : Node2D = $"../../FailureChanceTV/TvFrontPannel/SubViewport/ScreenFailureChance"

func _refresh() : 
	
	var enabled	: bool = parent_station_detacher.enabled
	var stat_selected_index : int = parent_station_detacher.stat_selected_index 
	var selected_stat : String = parent_station_detacher.selected_stat
	var stat_valid : bool = parent_station_detacher.stat_valid
	var failure_rate : int = parent_station_detacher.failure_rate
#	
	var loaded_cell : BrainCell = parent_station_detacher._get_loaded_cell()
	
	screen_detacher._refresh(
		enabled,	
		loaded_cell,
		stat_selected_index,
		stat_valid,
	) 
	
	screen_failure_chance._refresh(
		enabled,
		loaded_cell,
		stat_valid,
		selected_stat,
		failure_rate,
	)
