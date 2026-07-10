extends Node

var mutations : Array[BrainCellMutation] = [
	BrainCellMutation.new('airborne', false),
	BrainCellMutation.new('teleport', false),
	BrainCellMutation.new('sentient', false),
	BrainCellMutation.new('lonley', false),
	# TODO add all mutation
]

var mutations_seen : Dictionary = {
	'airborne' : true,
	'teleport' : true,
	'sentient' : true,
	'lonley' : true,
}
