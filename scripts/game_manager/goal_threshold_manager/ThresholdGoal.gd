extends Node

class_name ThresholdGoal

var strength : StatThreshold
var intelligence : StatThreshold
var community : StatThreshold

@warning_ignore("shadowed_variable")
func _init(
	strength : StatThreshold,
	intelligence : StatThreshold,
	community : StatThreshold,
) -> void:
	self.strength = strength
	self.intelligence = intelligence 
	self.community= community 
