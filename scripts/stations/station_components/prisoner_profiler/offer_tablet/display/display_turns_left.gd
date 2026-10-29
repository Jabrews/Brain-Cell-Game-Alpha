extends Node

# component parents
@onready var default_turn_parent : Control = $"../../../OfferUi/OfferBody/TurnsLeftDisplay/DefaultTurn"
@onready var last_turn_parent : Control = $"../../../OfferUi/OfferBody/TurnsLeftDisplay/LastTurn"
# default turn components
@onready var curr_turn_label : Label = $"../../../OfferUi/OfferBody/TurnsLeftDisplay/DefaultTurn/CurrTurn"
@onready var next_turn_label : Label = $"../../../OfferUi/OfferBody/TurnsLeftDisplay/DefaultTurn/NextTurn"

func _display() :
	
	var active_goal_piece : ThresholdPiece = GLGoalThresholdManagerBus.active_goal_threshold.get_active_piece()
	
	var turns_remaining : int = active_goal_piece.turns_remaining
	
	if turns_remaining == 0 : 
		last_turn_parent.visible = true
		default_turn_parent.visible = false
	
	else : 
		last_turn_parent.visible = false 
		default_turn_parent.visible = true 
		
		curr_turn_label.text = str(turns_remaining)		
		next_turn_label.text = str(turns_remaining - 1)
		
