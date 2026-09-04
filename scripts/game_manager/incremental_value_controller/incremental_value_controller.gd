extends Node

var round_incr_values_set = false
var last_round : int = 0

# components
@onready var iv_helper_hidden_stats : Node = $IVHelperHiddenStats
@onready var iv_helper_profiler_spare_progression : Node = $IVHelperProfilerSpareProgression
@onready var iv_helper_cell_stat_creation : Node = $IVHelperCellStatCreation
@onready var iv_helper_shareholder_items : Node = $IVHelperShareholderItems
@onready var iv_helper_mutations : Node = $IVHelperMutations
@onready var iv_helper_mutation_event_trigger : Node = $IVHelperMutationEventTrigger

func _ready() -> void:
	# when energy changes outside of prisoner generation
	# ex. cell defector decrease station
	GLGameManagerBus.connect('energy_changed', _handle_energy_changed)


@warning_ignore("shadowed_global_identifier") # FUCK THIS WTF
func change_progression_step(round : int, curr_energy: int) :
	
	if last_round != round :
		handle_round(round)
		
		# any event calls
		GLUsableItemBus.emit_signal('spawn_new_usable_items')
		
		
		handle_energy(round, GLGameManagerBus.curr_energy)	
		
		GLGameManagerBus.emit_signal('process_next_round')
		
		last_round = round
	
	
	handle_energy(round, GLGameManagerBus.curr_energy)
	
	GLGameManagerBus.emit_signal('proceed_next_energy_turn')
	

@warning_ignore("shadowed_global_identifier")
func handle_round(round : int):
	
	match round :
		1 :
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = false
			## ENERGY ##
			GLGameManagerBus.curr_energy = 100
			GLGameManagerBus.max_energy = 100
			## BREEDING ##
			IVCellBreeding.max_cell_breeding_attempts = 5
			IVCellBreeding.curr_cell_breeding_attempt = 0
			## BREEDING SCALING ##
			IVCellBreeding.clean_stat_increase_case_min = 0.5
			IVCellBreeding.defect_stat_increase_case_min = 0.5
			IVCellBreeding.low_add_percant_scale = 0.7
			IVCellBreeding.high_add_percant_scale = 0.6
			## CELL CREATOR ##
			IVCellCreator.max_stat_value = 300
			## USEABLE ITEMS ##
			IVItemStats.defect_shot_decrease = 50
			IVUseableItemSpawner.defect_shots_to_spawn = 0
			IVUseableItemSpawner.hidden_shots_to_spawn = 0
			IVUseableItemSpawner.steroids_to_spawn = 0
			IVUseableItemSpawner.ice_cube_to_spawn = 0
			IVUseableItemSpawner.scissors_to_spawn = 2
			## SHAREHOLDER OFFERS ##
			IVShareholderOffers.first_item_offer_energy_percant= 80
			IVShareholderOffers.second_item_offer_energy_percant= 45
			## PRISONER PROFILER ##
			IVPrisonerProfiler.stat_increment_amount = 10
			IVPrisonerProfiler.strength_stat_lock_percant_index = 0
			IVPrisonerProfiler.intelligence_stat_lock_percant_index= 0
			IVPrisonerProfiler.community_stat_lock_percant_index= 0
			IVPrisonerProfiler.stat_lock_percantages = [0.10, 0.25, 0.35, 0.55, 0.68, 0.80, 0.84, 0.92, 0.98, 1.01]
			IVPrisonerProfiler.per_stat_increment_energy_decrease = 1
			## DEFECT DECREASER ##
			IVCellDefectDecreaser.station_enabled = false
			## CELL TRASHCAN ##
			IVCellTrashcan.max_capaicty = 6
			
		2 :
			pass




@warning_ignore("shadowed_global_identifier")
func handle_energy(round : int, energy: int) :
	
	iv_helper_hidden_stats._update_hidden_stat_values(round, energy)
	iv_helper_profiler_spare_progression._update_spare_progression(round, energy)
	iv_helper_cell_stat_creation._update_cell_stat_creation(round, energy)
	iv_helper_shareholder_items._update_shareholder_items(round, energy)
	iv_helper_mutations._update_mutations(round, energy)
	iv_helper_mutation_event_trigger._update_mutations_event_trigger(round, energy)
	
	
func _handle_energy_changed() :
	handle_energy(GLGameManagerBus.current_round, GLGameManagerBus.curr_energy)
