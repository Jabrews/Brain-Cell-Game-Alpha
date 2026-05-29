extends Node

# components
@onready var cell_manager : Node = $"../CellManager"
@onready var name_manager : Node = $NameManager
@onready var observe_player_hand : Node = $ObservePlayerHand
@onready var assemble_cells : Node = $AssembleCells
@onready var assemble_target : Node = $AssembleTarget
@onready var incrmental_value_controller : Node = $"../IncrementalValueController"
# offer helpers 
@onready var offer_one : Node = $OfferHelpers/OfferOne
@onready var offer_three : Node = $OfferHelpers/OfferThree

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
	
	##### shareholder CASES (offers) #######
	# prevent creation the first time when it is  
	if GLShareholderOfferState.await_user_choose_shareholder_offer_before_create:
		return
	
	## offer 1
	# we only return 3 cells when this happens.
	new_prisoner_cells = offer_one.handle_offer_1(new_prisoner_cells)

	## offer 3
	# all cells have no defect but one spider is generated
	# ONESHOT (end after this round)
	new_prisoner_cells = offer_three.handle_offer_3(new_prisoner_cells)
	
	#########################################
	
	cell_manager.set_prisoner_cells(new_prisoner_cells)
	GLCellCreatorBus.emit_signal('get_newest_prisoner_cells', new_prisoner_cells)
	
	
# this happens after the user chooses a shareholder offer	
func _handle_create_prisoner_cells_user_chose_shareholder_offer() :
	# never include target in this
	GLShareholderOfferState.await_user_choose_shareholder_offer_before_create = false
	handle_create_cells(false, true)
	
	
	
	
