extends Node

var has_served_sentient_cell: bool = false

# helpers 
@onready var roll_to_exit_mutation_loop : Node = $RollToExitMutationEvent
@onready var sort_best_cells : Node = $SortBestCells
@onready var get_batch_mutations : Node = $GetBatchMutations
@onready var all_hidden_event : Node = $AllHiddenEvent
@onready var default_mutation_serving : Node = $DefaultMutationServing


func _handle_create_mutations(
	cell_constructor: CellConstructor,
	prisoner_cells: Array[BrainCell],
) -> Array[BrainCell]:

	var energy_phase: int = get_energy_phase()

	## exit loop ##
	if cell_constructor.prisoner_picks != 4 : 	
		return prisoner_cells
	
	var exit_mutation_loop = roll_to_exit_mutation_loop._handle_roll(energy_phase)
	
	if exit_mutation_loop :
		return prisoner_cells
	###############
	
	## sort best cells ##
	prisoner_cells = sort_best_cells._sort(prisoner_cells)
	#####################
	
	## get mutations ##	
	var batch_mutations : Array[BrainCellMutation] = get_batch_mutations._get_mutations()
	
	if batch_mutations.is_empty()	 : 
		return prisoner_cells
	###################
	
	## chance of hiding all mutations ##
	if energy_phase > 0 : # phase 0 has no chance of this
		var chance_of_all_hidden_event = IVMutations.chance_for_all_hidden_event	
		var ran_num = randi_range(0, 101)	
		if chance_of_all_hidden_event >= ran_num : 
			
			prisoner_cells = all_hidden_event._apply_all_hidden_event(batch_mutations, prisoner_cells)
			
			return prisoner_cells			
	## else. default serving ##
	else :	
		prisoner_cells = default_mutation_serving._apply_default_mutation_serving(batch_mutations, prisoner_cells, energy_phase)
	
	# return cells with mutations applied
	return prisoner_cells

func get_energy_phase() -> int:
	var max_energy: float = GLGameManagerBus.max_energy
	var curr_energy: float = GLGameManagerBus.curr_energy

	if max_energy <= 0.0:
		return 2

	var energy_percent: float = clampf(
		curr_energy / max_energy,
		0.0,
		1.0
	)

	if energy_percent >= 2.0 / 3.0:
		return 0 # High energy
	elif energy_percent >= 1.0 / 3.0:
		return 1 # Medium energy
	else:
		return 2 # Low energy
