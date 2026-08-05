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
	
	if GameAdminPanel.enabled :
		GameAdminPanel.updater_admin_batch_mutation.energy_phase = energy_phase
		GameAdminPanel.updater_admin_batch_mutation.min_mutations= IVMutations.min_mutations_per_batch 
		GameAdminPanel.updater_admin_batch_mutation.max_mutations= IVMutations.max_fake_mutations_per_batch
		for mutation: BrainCellMutation in get_batch_mutations.available_mutations:
			GameAdminPanel.updater_admin_batch_mutation.mutations_available.append(
				mutation.type
			)
	

	## exit loop ##
	if cell_constructor.cell_quantity != 4 : 	
		
		if GameAdminPanel.enabled :
			GameAdminPanel.updater_admin_batch_mutation.skipped = true 
			GameAdminPanel.updater_admin_batch_mutation.why_skipped = "quanity != 4"
		
		return prisoner_cells
	
	var exit_mutation_loop = roll_to_exit_mutation_loop._handle_roll(energy_phase)
	
	if exit_mutation_loop :
		return prisoner_cells
	###############
	
	## sort best cells ##
	prisoner_cells = sort_best_cells._handle_sort(prisoner_cells)
	#####################
	
	## get mutations ##	
	var batch_mutations : Array[BrainCellMutation] = get_batch_mutations._get_mutations(energy_phase)
	
	if batch_mutations.is_empty()	 : 
		return prisoner_cells
	###################
	
	## Chance of hiding all mutations ##
	var chance_of_all_hidden_event: int = (
		IVMutations.chance_for_all_hidden_event
	)
	
	if GameAdminPanel.enabled : 
		GameAdminPanel.updater_admin_batch_mutation.all_hidden_event_chance = IVMutations.chance_for_all_hidden_event

	var ran_num: int = randi_range(1, 100)


	if ran_num <= chance_of_all_hidden_event:
			
		GLPrisonerSpawnerBus.emit_signal('apply_mutations_all_hidden')			
				
		prisoner_cells = all_hidden_event._apply_all_hidden_event(
			prisoner_cells,
			batch_mutations
		)
		
		if GameAdminPanel.enabled :
			GameAdminPanel.updater_admin_batch_mutation.all_hidden_event_applied = true
			

		return prisoner_cells

	## Default serving ##
	
	GLPrisonerSpawnerBus.emit_signal('apply_mutation_regular', len(batch_mutations))	
	
	prisoner_cells = default_mutation_serving._apply_default_mutation_serving(
		prisoner_cells,
		batch_mutations,
		energy_phase
	)

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
