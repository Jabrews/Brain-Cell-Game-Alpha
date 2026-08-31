extends Node

# component helpers
@onready var clean_stat_helper : Node = $CleanStatHelper
@onready var defect_stat_helper : Node = $DefectStatHelper
@onready var reduced_cell_charge_stat_helper : Node = $ReducedCellChargeStatHelper
@onready var reduced_cell_charge_helper : Node = $ReducedCellChargeHelper
@onready var increase_cell_charge_helper : Node = $IncreaseCellChargeHelper
@onready var mutation_helper : Node = $MutationHelper
@onready var death_chance_helper : Node = $DeathChanceHelper

func _ready() -> void:
	connect_signals()
	create_class_refrences()

##### INIT HELPERS #####
func connect_signals() : 
	GLCellBreederBus.connect('player_breeded_cells', _handle_player_breeded_cells)

func create_class_refrences() : 
	pass
########################

# directly called by breeding_loader_screen
# these cells have already had energy_boost cells applied to them
func _handle_player_simulate_breeded_cells(cell_1 : BrainCell, cell_2 : BrainCell) -> BrainCell:
	return _create_breeded_cell(cell_1, cell_2, false)


func _handle_player_breeded_cells(
	main_left_cell: BrainCell,
	main_right_cell: BrainCell,
	boost_left_cell: BrainCell,
	boost_right_cell: BrainCell,
	boost_left_stat: String,
	boost_right_stat: String,
	boost_left_direction: String,
	boost_right_direction: String,
) -> void:
	var updated_boost_left_cell: BrainCell = null
	var updated_boost_right_cell: BrainCell = null

	# Apply boosts only when a boost cell exists.
	if boost_left_cell:
		main_left_cell = increase_cell_charge_helper._get_increased(
			boost_left_stat,
			boost_left_direction,
			main_left_cell
		)

		var boost_left_copy: BrainCell = boost_left_cell.copy()

		updated_boost_left_cell = reduced_cell_charge_helper._get_reduced(
			boost_left_stat,
			boost_left_direction,
			boost_left_copy
		)

	if boost_right_cell:
		main_right_cell = increase_cell_charge_helper._get_increased(
			boost_right_stat,
			boost_right_direction,
			main_right_cell
		)

		var boost_right_copy: BrainCell = boost_right_cell.copy()

		updated_boost_right_cell = reduced_cell_charge_helper._get_reduced(
			boost_right_stat,
			boost_right_direction,
			boost_right_copy
		)

	var new_cell: BrainCell = _create_breeded_cell(
		main_left_cell,
		main_right_cell,
		true
	)

	# The boost cell existed, but reducing its charge destroyed it.
	if boost_left_cell and not updated_boost_left_cell:
		GLCellManagerBus.emit_signal(
			"delete_selected_collected_cell",
			boost_left_cell
		)

	if boost_right_cell and not updated_boost_right_cell:
		GLCellManagerBus.emit_signal(
			"delete_selected_collected_cell",
			boost_right_cell
		)
	
		
	
	# check death chance of cell 1 & 2
	var cell_1_death_chance : float = death_chance_helper._get_total_death_chance(main_left_cell, true)
	var cell_2_death_chance : float = death_chance_helper._get_total_death_chance(main_right_cell, true)
	
	var kill_old_1 : bool = false
	var kill_old_2 : bool = false
	
	# roll to kill old cells
	var ran_num_1 : int = randi_range(0, 100)
	if cell_1_death_chance >= ran_num_1 :
		kill_old_1 = true
		
	var ran_num_2 : int = randi_range(0, 100)
	if cell_2_death_chance >= ran_num_2 :
		kill_old_2 = true
	
	# if we dont kill old cell, apply decrease
	if not kill_old_1 :
		main_left_cell = death_chance_helper.decrease_old_cell._decrease(main_left_cell)
		main_left_cell.mutations = []
	if not kill_old_2 : 
		main_right_cell = death_chance_helper.decrease_old_cell._decrease(main_right_cell)
		main_right_cell.mutations = []
	
	GLCellManagerBus.emit_signal(
		"cell_breeded",
		main_left_cell,
		main_right_cell,
		new_cell,
		updated_boost_left_cell,
		updated_boost_right_cell,
		kill_old_1,
		kill_old_2,
	)


func _create_breeded_cell(
	cell_1 : BrainCell,
	cell_2 : BrainCell,
	generate_name : bool = true
) -> BrainCell:
	
	
	var clean_stat_array = clean_stat_helper.generate_clean_stats(
		cell_1,
		cell_2
	)

	var defect_stat_array = defect_stat_helper.generate_defect_stats(
		cell_1,
		cell_2
	)

	var cell_name = "Simulation"

	if generate_name:
		cell_name = GAMENameManager.pick_prisoner_names()

	var new_cell = BrainCell.new(
		cell_name,
		mutation_helper._create_mutations(
			cell_1.mutations,
			cell_2.mutations
		),
		_create_stat(
			"strength",
			clean_stat_array[0],
			defect_stat_array[0]
		),
		_create_stat(
			"intelligence",
			clean_stat_array[1],
			defect_stat_array[1]
		),
		_create_stat(
			"community",
			clean_stat_array[2],
			defect_stat_array[2]
		),
		3
	)

	_apply_disabled_stats(new_cell)

	return new_cell


func _create_stat(
	stat_type : String,
	clean_value : float,
	defect_value : float
) -> BrainCellStat:

	return BrainCellStat.new(
		stat_type,
		true,
		clean_value,
		defect_value,
		false
	)


func _apply_disabled_stats(cell : BrainCell) -> void:

	if cell.strength.value == 0:
		cell.strength.enabled = false
		cell.strength.defect = 0

	if cell.intelligence.value == 0:
		cell.intelligence.enabled = false
		cell.intelligence.defect = 0

	if cell.community.value == 0:
		cell.community.enabled = false
		cell.community.defect = 0
