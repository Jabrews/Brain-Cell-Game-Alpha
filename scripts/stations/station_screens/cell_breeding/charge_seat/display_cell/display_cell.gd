extends Node

# display parents
@onready var no_cell_display: Control = $"../NoCell"
@onready var cell_stat_display: Control = $"../StatDisplay"

# indiv cell stat display componnets
@onready var defect_bars: Array[Sprite2D] = [
	$"../StatDisplay/DefectBars/DefectStrengthBar",
	$"../StatDisplay/DefectBars/DefectIntelligenceBar",
	$"../StatDisplay/DefectBars/DefectCommunityBar"
]

@onready var progress_bars: Array[Sprite2D] = [
	$"../StatDisplay/ProgressBars/StrengthBar",
	$"../StatDisplay/ProgressBars/IntelligenceBar",
	$"../StatDisplay/ProgressBars/CommunityBar"
]

# helpers
@onready var reset_cell_display : Node = $ResetCellDisplay
@onready var display_exclude_charge : Node = $DisplayExcludeCharge
@onready var display_include_charge : Node = $DisplayIncludeCharge

var active_brain_cell: BrainCell

func _ready() -> void:
	for progress_bar: Sprite2D in progress_bars:
		progress_bar.material = progress_bar.material.duplicate()
	
	for defect_bar: Sprite2D in defect_bars:
		defect_bar.material = defect_bar.material.duplicate()


func _handle_cell_recieved(brain_cell: BrainCell, energy_stat : BrainCellStat = null) -> void:
	
	handle_visible_display_parent(brain_cell)
	reset_cell_display.reset()
	
	if brain_cell : 
		if not energy_stat : 
			display_exclude_charge.display(brain_cell)
		else :
			display_include_charge.display(brain_cell, energy_stat)
	

func handle_visible_display_parent(brain_cell: BrainCell) -> void:
	if not brain_cell:
		no_cell_display.visible = true
		cell_stat_display.visible = false
	else:
		no_cell_display.visible = false
		cell_stat_display.visible = true
