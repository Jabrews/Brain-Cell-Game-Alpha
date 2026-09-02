extends Node

class_name GoalThreshold

var strength : ThresholdStat
var intelligence : ThresholdStat
var community : ThresholdStat

@warning_ignore("shadowed_variable")
func _init(
	strength : ThresholdStat,
	intelligence : ThresholdStat,
	community : ThresholdStat,
) -> void:
	self.strength = strength
	self.intelligence = intelligence 
	self.community= community 
