extends Node

# components
@onready var cell_manager : Node = $"../CellManager"
@onready var name_manager : Node = $NameManager
@onready var observe_player_hand : Node = $ObservePlayerHand
@onready var assemble_cells : Node = $AssembleCells
@onready var assemble_target : Node = $AssembleTarget
@onready var incrmental_value_controller : Node = $"../IncrementalValueController"

func _ready() -> void:
	connect_signals()
	

func connect_signals() : 
	GLCellCreatorBus.connect('create_cells', handle_create_cells)
	GLShareholderOfferState.connect('create_prisoner_cells_user_chose_shareholder_offer', _handle_create_prisoner_cells_user_chose_shareholder_offer)
	
func handle_create_cells(include_target : bool = false, prevent_update_incr_update : bool = false) -> void:
	
	# we stop incremental values sometimes becasuse we rerun this func after
	# -updating for shareholder offer (look below)
	if not prevent_update_incr_update  :
		# update incremental values
		var curr_round = GLGameManagerBus.current_round
		var curr_turn = GLGameManagerBus.current_turn
		incrmental_value_controller.change_progression_step(curr_round, curr_turn)
	
	if include_target :
		var target_cell = assemble_target.assemble()
		cell_manager.set_target_cell(target_cell)
	
	var new_prisoner_cells : Array[BrainCell]
	var creation_case = observe_player_hand.find_case()
	
	if creation_case == 'none' :
		new_prisoner_cells = assemble_cells.assemble()
	
	##### shareholder CASES #######
	# prevent creation the first time when it is  
	if GLShareholderOfferState.await_user_choose_shareholder_offer_before_create:
		return
	
	## TODO move offers into better place ##
	
	## offer one ##
	# we only return 3 cells when this happens.
	if GLShareholderOfferState.offer_1_active :
		if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			print_debug('offer 1')
		# we return 3 not because it is getting farther from org. pos but for the trickery
		var cell_to_delete = new_prisoner_cells.pick_random()
		new_prisoner_cells.erase(cell_to_delete)
	###############

	## offer three ##
	# all cells have no defect but one spider is generated
	# ONESHOT (end after this round)
	if GLShareholderOfferState.offer_3_active	:
		if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			print_debug('offer 3')
		# set defect to 0 in all cells
		for cell : BrainCell in new_prisoner_cells :
			cell.strength_defect = 0
			cell.intelligence_defect = 0
			cell.community_defect = 0
		# pick random cell to become the spider	
		var random_prisoner : BrainCell = new_prisoner_cells.pick_random()
		random_prisoner.turn_into_flesh_bug = true
		print('choose ', random_prisoner.name, ' to become slug bug')
		# after this make sure we turn off active... oneshot
		GLShareholderOfferState.offer_3_active = false
	
	cell_manager.set_prisoner_cells(new_prisoner_cells)
	GLCellCreatorBus.emit_signal('get_newest_prisoner_cells', new_prisoner_cells)
	
	
# this happens after the user chooses a shareholder offer	
func _handle_create_prisoner_cells_user_chose_shareholder_offer() :
	# never include target in this
	GLShareholderOfferState.await_user_choose_shareholder_offer_before_create = false
	handle_create_cells(false, true)
	
	
	
	
