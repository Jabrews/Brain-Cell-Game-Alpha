extends Node


var strength_dissolve_stat : DissolveStat 
var intelligence_dissolve_stat : DissolveStat
var community_dissolve_stat : DissolveStat


func _create_inital_stats(threshold_piece : ThresholdPiece ) : 
	
	strength_dissolve_stat = DissolveStat.new('strength', threshold_piece.strength, null, 0)
	intelligence_dissolve_stat = DissolveStat.new('intelligence', threshold_piece.intelligence, null, 0)
	community_dissolve_stat = DissolveStat.new('community', threshold_piece.community, null, 0)
	
	
