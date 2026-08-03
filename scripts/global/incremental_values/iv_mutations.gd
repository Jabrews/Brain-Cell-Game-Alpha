extends Node

var all_mutations : Array[BrainCellMutation] = [
	# AIRBORNE
	BrainCellMutation.new('airborne', false, [
		MutationEvent.new('airborne_fly', 'random_event', 'airborne',0 )
	]),
	# SENTIENT
	BrainCellMutation.new('sentient', false, [
		MutationEvent.new('sentient_talk', 'constant', 'sentient', 0)
	]),
	# LONLEY
	BrainCellMutation.new('lonley', false, [
		MutationEvent.new('lonley_starvation', 'constant', 'lonley', 0)
	]),
	# DISRUPTOR
	BrainCellMutation.new('disrupter', false, [
		MutationEvent.new('disrupter_disrupt', 'random_event', 'disrupter', 0)
	]),
	# TELEPORTATION 
	BrainCellMutation.new('teleportation', false, []),
	# EXSPLOSIVE
	BrainCellMutation.new("exsplosive", false, []),
	# INFECTIOUS
	BrainCellMutation.new('infectious', false, []),
	# COGNISANCE
	BrainCellMutation.new('cognisance', false, []),
	# TELEKINETIC
	BrainCellMutation.new('telekinetic', false, []),
	# UNSTABLE
	BrainCellMutation.new('unstable', false, []),
]

var mutations : Array[BrainCellMutation] = []

var min_mutations_per_batch : int = 1
var max_mutations_per_batch : int = 1

var chance_to_exit_mutation_loop : int = 50

var chance_for_all_hidden_event = 1

var amount_of_best_cells_sorted = 2

## apply mutation default ##
var chance_to_hide_mutation : int = 25
var min_fake_mutations_per_batch : int = 1
var max_fake_mutations_per_batch : int = 1
