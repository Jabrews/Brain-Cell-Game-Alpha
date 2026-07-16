extends Node

# componnet apply helpers
@onready var apply_all_hidden_event : Node = $ApplyAllHiddenEvent
@onready var apply_mutations_default : Node = $ApplyMutationsDefault

var avaible_good_mutations : Array[BrainCellMutation] = []
var avaible_bad_mutations : Array[BrainCellMutation] = []


func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)


func _handle_mutations(cell_constructor : CellConstructor, prisoner_cells : Array[BrainCell]):
	
	### EXIT EVENTS ####	
	if avaible_good_mutations.is_empty() and avaible_bad_mutations.is_empty():
		return prisoner_cells
	
	# if using safe mode
	if cell_constructor.cell_quantity < 4 : 
		print('not enough quanity')
		return prisoner_cells
		
	# if no mutations wanted
	var max_mutations_per_batch : int = IVMutations.max_mutations_per_batch
	if max_mutations_per_batch <= 0 :
		print('max mutations per batch = 0 : ', IVMutations.max_fake_mutations_per_batch )
		return prisoner_cells
		
	# chance to not do mutations
	var ran_num = randi_range(0, 100)
	var chance_to_exit_mutation_loop = IVMutations.chance_to_exit_mutation_loop
	if ran_num <= chance_to_exit_mutation_loop : 
		print('exit via chance : ', IVMutations.chance_to_exit_mutation_loop)
		return prisoner_cells
		
	#####################
	
	
	### GET MUTATIONS ####
	
	# pick mutations for batch
	var batch_mutations : Array[BrainCellMutation] = []	
	
	# TODO check for shareholder mutation wanted	
	# IF found then roll 50/50 ran_num for adding it
	# make sure it doesnt already exist
	
	
	batch_mutations = get_batch_mutations(batch_mutations)
	
	if len(batch_mutations) == 0 : 
		return prisoner_cells
	
	######################
	
	
	### DECIDE HELPER ####
	
	## TODO if less than 50% energy and no mutations in deck force event
	
	# decide if all hidden event	
	var event_num = randi_range(0, 100)
	var chance_for_all_hidden_event = IVMutations.chance_for_all_hidden_event
	
	if event_num <= chance_for_all_hidden_event : 	
		prisoner_cells = apply_all_hidden_event._handle_apply(prisoner_cells, batch_mutations)
	else : 
		prisoner_cells = apply_mutations_default._handle_apply(prisoner_cells, batch_mutations)		
	######################
	
	return prisoner_cells	
		
# only continue loop if not past max total 
# must continue untill min is met
func get_batch_mutations(batch_mutations : Array[BrainCellMutation]) :
	
	var max_mutations_per_batch : int = IVMutations.max_mutations_per_batch
	var min_mutations_per_batch: int = IVMutations.min_mutations_per_batch

	if batch_mutations.size() >= max_mutations_per_batch:
		return batch_mutations

	var should_force_mutation: bool = batch_mutations.size() < min_mutations_per_batch


	# TODO boost or decrease chance depending on prisoner profiler symbols active

	var good_mutation_chance: int = IVMutations.good_mutation_chance
	var bad_mutation_chance: int = IVMutations.bad_mutation_chance

	if should_force_mutation:
		var all_available_mutations: Array = []
		all_available_mutations.append_array(avaible_good_mutations)
		all_available_mutations.append_array(avaible_bad_mutations)

		if all_available_mutations.is_empty():
			return batch_mutations

		batch_mutations.append(all_available_mutations.pick_random())
		return batch_mutations

	var good_num: int = randi_range(1, 100)

	if good_num <= good_mutation_chance:
		if not avaible_good_mutations.is_empty():
			batch_mutations.append(avaible_good_mutations.pick_random())
		return batch_mutations

	var bad_num: int = randi_range(1, 100)

	if bad_num <= bad_mutation_chance:
		if not avaible_bad_mutations.is_empty():
			batch_mutations.append(avaible_bad_mutations.pick_random())
		return batch_mutations
	
	
func _handle_process_next_round() :
	fill_avaible_mutations()

	
func fill_avaible_mutations() :
	avaible_good_mutations = IVMutations.good_mutations
	avaible_bad_mutations = IVMutations.bad_mutations

	
