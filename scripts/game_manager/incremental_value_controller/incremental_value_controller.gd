extends Node

var last_round : int = 0
var last_threshold_piece_index : int = 0

# components
@onready var iv_helper_hidden_stats : Node = $IVHelperHiddenStats
@onready var iv_helper_profiler_spare_progression : Node = $IVHelperProfilerSpareProgression
@onready var iv_helper_cell_stat_creation : Node = $IVHelperCellStatCreation
@onready var iv_helper_shareholder_items : Node = $IVHelperShareholderItems
@onready var iv_helper_mutations : Node = $IVHelperMutations
@onready var iv_helper_mutation_event_trigger : Node = $IVHelperMutationEventTrigger
@onready var iv_helper_defect_event : Node = $IVHelperDefectEvent


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_goal_piece', _handle_proceed_next_goal_piece)
	GLGameManagerBus.connect('proceed_next_turn', _handle_proceed_next_turn)
	

func _handle_proceed_next_goal_piece() :
	_update_incremental_values() # just cause only round 1 in playtest

func _handle_proceed_next_turn() :
	_update_incremental_values()


func _update_incremental_values() : 
	
	# handle round IVS
	# prevent from running twice
	var current_round : int = GLGameManagerBus.current_round	
	
	if last_round != current_round : 
		handle_round(current_round)
		
		# just some helpers
		GLUsableItemBus.emit_signal('spawn_new_usable_items')
		
		last_round = current_round
		
		GLGameManagerBus.emit_signal('process_new_ivs')
		
	# handle goal piece IVS
	# prevent from running twice
	var current_threshold_piece_index : int = GLGoalThresholdManagerBus.active_goal_threshold.active_piece_index
	
	if current_threshold_piece_index != last_threshold_piece_index : 	
		
		handle_threshold_piece(current_round)
		
		last_threshold_piece_index = current_threshold_piece_index		
		
		GLGameManagerBus.emit_signal('process_new_ivs')
	
		

@warning_ignore("shadowed_global_identifier")
func handle_round(round : int):
	
	match round :
		1 :
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = false
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
			IVUseableItemSpawner.defect_shots_to_spawn = 2
			IVUseableItemSpawner.hidden_shots_to_spawn = 0
			IVUseableItemSpawner.steroids_to_spawn = 0
			IVUseableItemSpawner.ice_cube_to_spawn = 0
			IVUseableItemSpawner.scissors_to_spawn = 0
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
			IVCellTrashcan.max_capaicty = 9
			
		2 :
			pass




@warning_ignore("shadowed_global_identifier")
func handle_threshold_piece(round : int) :
	
	var active_goal_piece_index : int = GLGoalThresholdManagerBus.active_goal_threshold.active_piece_index
	
	
	iv_helper_hidden_stats._update_hidden_stat_values(round, active_goal_piece_index)
	iv_helper_profiler_spare_progression._update_spare_progression(round, active_goal_piece_index)
	iv_helper_cell_stat_creation._update_cell_stat_creation(round, active_goal_piece_index)
	iv_helper_shareholder_items._update_shareholder_items(round, active_goal_piece_index)
	iv_helper_mutations._update_mutations(round, active_goal_piece_index)
	iv_helper_mutation_event_trigger._update_mutations_event_trigger(round, active_goal_piece_index)
	iv_helper_defect_event._update_defect_events(round, active_goal_piece_index)
	
	
