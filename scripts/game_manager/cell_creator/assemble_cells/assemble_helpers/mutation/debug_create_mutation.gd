extends Node

@export var mutation_manager : Node 


func _debug_create() -> BrainCellMutation :
	
	var chance_for_no_mutation = 25	
	var no_mutation_ran_num = randi_range(0, 100)
	if chance_for_no_mutation >= no_mutation_ran_num: 
		return null
		
		
	var hide_mutation : bool = false
	var chance_for_hiding_mutation = 50
	var hide_mutation_ran_num = randi_range(0, 100)
	if chance_for_hiding_mutation >= hide_mutation_ran_num : 
		hide_mutation = true
	
	var mutations_possible : Array[BrainCellMutation] = mutation_manager.mutations
	var mutation_picked : BrainCellMutation = mutations_possible.pick_random() 
	
	var mutation = BrainCellMutation.new(
		mutation_picked.type,
		hide_mutation,
	)
	
	return mutation
	
		

	
	#
	#
	#
	#
	#
	#
