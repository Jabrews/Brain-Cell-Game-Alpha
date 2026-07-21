extends Node

var all_mutations : Array[BrainCellMutation] = [
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
]

var good_mutations : Array[BrainCellMutation] = []
var bad_mutations : Array[BrainCellMutation] = []

var min_mutations_per_batch : int = 1
var max_mutations_per_batch : int = 1

var chance_to_exit_mutation_loop : int = 50

var good_mutation_chance : int = 25
var bad_mutation_chance : int = 25

var chance_for_all_hidden_event = 1

var amount_of_best_cells_sorted = 2

## apply mutation default ##
var chance_to_hide_mutation : int = 25
var min_fake_mutations_per_batch : int = 1
var max_fake_mutations_per_batch : int = 1

## sientient mutation ##
# toggled after first selected by user
var picked_sentient_mutation_first_round : bool = false
# toggled after giving user chance to grab sentient cell
var served_sentient_cell : bool = false
