extends Node

# components
@onready var handle_dissolving : Node = $"../HandleDissolving"

var strength_dissolve_stat : DissolveStat 
var intelligence_dissolve_stat : DissolveStat
var community_dissolve_stat : DissolveStat

func _create_inital_stats(threshold_piece : ThresholdPiece ) : 
	
	strength_dissolve_stat = DissolveStat.new('strength', threshold_piece.strength, null, 100)
	intelligence_dissolve_stat = DissolveStat.new('intelligence', threshold_piece.intelligence, null, 150)
	community_dissolve_stat = DissolveStat.new('community', threshold_piece.community, null, 0)
	
	handle_dissolving._refresh()

func _get_dissolving_stats() -> Array[DissolveStat] : 
	return [strength_dissolve_stat, intelligence_dissolve_stat, community_dissolve_stat]
	
	
