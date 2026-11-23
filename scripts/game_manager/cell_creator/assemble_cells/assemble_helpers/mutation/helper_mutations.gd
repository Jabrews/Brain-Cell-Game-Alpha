extends Node

var has_served_sentient_cell: bool = false

# Helpers
@onready var roll_to_exit_mutation_loop: Node = $RollToExitMutationEvent
@onready var sort_best_cells: Node = $SortBestCells
@onready var get_batch_mutations: Node = $GetBatchMutations
@onready var all_hidden_event: Node = $AllHiddenEvent
@onready var default_mutation_serving: Node = $DefaultMutationServing


func _handle_create_mutations(
	cell_constructor: CellConstructor,
	prisoner_cells: Array[BrainCell]
) -> Array[BrainCell]:
	var energy_phase: int = get_energy_phase()

	# Exit the mutation loop unless the batch has four cells.
	if cell_constructor.cell_quantity != 4:
		return prisoner_cells

	var exit_mutation_loop: bool = roll_to_exit_mutation_loop._handle_roll(
		energy_phase
	)

	if exit_mutation_loop:
		return prisoner_cells

	prisoner_cells = sort_best_cells._handle_sort(prisoner_cells)

	var batch_mutations: Array[BrainCellMutation] = (
		get_batch_mutations._get_mutations(energy_phase)
	)

	if batch_mutations.is_empty():
		return prisoner_cells

	# Chance to hide all mutations.
	var chance_of_all_hidden_event: int = (
		IVMutations.chance_for_all_hidden_event
	)
	var random_number: int = randi_range(1, 100)

	if random_number <= chance_of_all_hidden_event:
		GLPrisonerSpawnerBus.emit_signal("apply_mutations_all_hidden")

		prisoner_cells = all_hidden_event._apply_all_hidden_event(
			prisoner_cells,
			batch_mutations
		)

		return prisoner_cells

	# Serve mutations normally.
	GLPrisonerSpawnerBus.emit_signal(
		"apply_mutation_regular",
		batch_mutations.size()
	)

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
