extends Node

var mutations : Array[BrainCellMutation] = [
	BrainCellMutation.new('airborne', false),
	BrainCellMutation.new('teleport', false),
	BrainCellMutation.new('sentient', false),
	BrainCellMutation.new('lonley', false),
	#BrainCellMutation.new('none', false),
]

var mutations_seen : Dictionary = {
	'airborne' : false,
	'teleport' : false,
	'sentient' : false,
	'lonley' : true,
}
