extends Node

# components
@onready var parent_defect_decreaser : Node3D = $"../.."
# screen components
@onready var screen_defect_decreaser : Control = $"../../DefectDecreaserTV/TvFrontPannel/SubViewport/ScreenDefectDecreaser"
@onready var screen_defect_scrap_cost : Control = $"../../DefectScrapCostTV/TvFrontPannel/SubViewport/ScreenDefectScrapCost"

func _refresh() : 
	
	var enabled : bool = parent_defect_decreaser.enabled
	var defect_reduction_context = parent_defect_decreaser.defect_reduction_context 
	
	
	screen_defect_decreaser._refresh(enabled, defect_reduction_context) 
	screen_defect_scrap_cost._refresh(enabled, defect_reduction_context) 
