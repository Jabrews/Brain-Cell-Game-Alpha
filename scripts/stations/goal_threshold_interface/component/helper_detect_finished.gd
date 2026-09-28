extends Node

@onready var parent_station : Node3D = $".."

func _detect(): 
	var active_threshold_piece : ThresholdPiece  = parent_station.active_threshold_piece
	
	if not active_threshold_piece : 
		push_error('trying to detect finished when no threshold piece')
		return
	
	var strength_threshold_stat : ThresholdStat = active_threshold_piece.strength
	var intelligence_threshold_stat : ThresholdStat = active_threshold_piece.intelligence
	var community_threshold_stat : ThresholdStat = active_threshold_piece.community
	
