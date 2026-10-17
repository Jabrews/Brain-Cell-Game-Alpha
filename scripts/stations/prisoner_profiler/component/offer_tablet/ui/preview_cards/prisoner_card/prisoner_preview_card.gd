extends Control

# components
@onready var display_card : Node = $DisplayCard
@onready var display_alteration : Node = $DisplayAlteration
@onready var parent_prisoner_profiler : Node3D = $"../../../../.."

var active_prisoner_card : PrisonerOfferCard

func _initate_card(prisoner_card : PrisonerOfferCard) :

	active_prisoner_card = prisoner_card
	
	
	var finalized_ideal_stats : Array[IdealStat] = parent_prisoner_profiler.get_finalized_ideal_stats()
	display_card._display(active_prisoner_card, finalized_ideal_stats)
	
	display_alteration._display(active_prisoner_card)
	
	
	
