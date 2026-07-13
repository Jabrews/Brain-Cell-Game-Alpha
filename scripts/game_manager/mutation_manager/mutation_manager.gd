extends Node

var mutations : Array[BrainCellMutation] = [
	BrainCellMutation.new('airborne', false),
	BrainCellMutation.new('teleportation', false),
	BrainCellMutation.new('sentient', false),
	BrainCellMutation.new('lonley', false),
	#BrainCellMutation.new('none', false),
]

var mutations_seen : Dictionary = {
	'airborne' : true,
	'teleportation' : true,
	'sentient' : true,
	'lonley' : true,
}
