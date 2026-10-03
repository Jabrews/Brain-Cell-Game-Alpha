extends Node

# components
@onready var accept_cell_parent : Control = $"../AcceptCell"


#### SHOW ####

func show_accept_cell_screen(elevator_cell : BrainCell) :
	
	if not elevator_cell : 
		push_error('attempting to show accept cell screen without cell')
		return
	
	var curr_threshold_piece : ThresholdPiece = GLGoalThresholdManagerBus.active_goal_threshold.get_active_piece()
	
	var stats : Array[BrainCellStat] = []
	stats.append(elevator_cell.strength)
	stats.append(elevator_cell.intelligence)
	stats.append(elevator_cell.community)
	
	
	
	accept_cell_parent.visible = true


func _display_threshold_bars(
	
) : 
	pass

func _display_defect_ignored_percant(
	
) :
	pass

func _display_defect_ignored_bars(
	
) :
	pass




#### HIDE #####

func hide_accept_cell_screen() :
	accept_cell_parent.visible = false 
