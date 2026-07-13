extends Node

var mutations : Array[BrainCellMutation] = [
	BrainCellMutation.new('airborne', false),
	BrainCellMutation.new('teleportation', false),
	BrainCellMutation.new('sentient', false),
	BrainCellMutation.new('lonley', false),
	BrainCellMutation.new('disrupter', false),
	BrainCellMutation.new("exsplosive", false),
	BrainCellMutation.new('infectious', false),
	BrainCellMutation.new('cognisance', false),
	BrainCellMutation.new('telekinetic', false),
	BrainCellMutation.new('unstable', false),
	
	#BrainCellMutation.new('none', false),
]

var mutations_seen : Dictionary = {
	'airborne' : true,
	'teleportation' : true,
	'sentient' : true,
	'lonley' : true,
	'disrupter' : true,
	"exsplosive" : true, 
	'infectious' : true,
	'cognisance' : true, 
	'telekinetic' : true,
	'unstable' : true,
}
