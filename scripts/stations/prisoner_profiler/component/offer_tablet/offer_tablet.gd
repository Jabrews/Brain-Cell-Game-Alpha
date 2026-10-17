extends Node

# components
@onready var parent_prisoner_profiler : Node3D = $"../.."
@onready var display_turns_left : Node = $DisplayTurnsLeft
@onready var card_creation_factory : Node = $CardCreationFactory

var current_offer_cards : Array[OfferCard] = []


func _ready() -> void:
	GLOfferCardCreatorBus.connect('recieve_offer_cards', _handle_recieve_offer_cards)

func _start() :
	
	var ideal_stats : Array[IdealStat] = parent_prisoner_profiler.get_finalized_ideal_stats()
	GLOfferCardCreatorBus.emit_signal('create_offer_cards', ideal_stats)		
	
	display_turns_left._display()

func _handle_recieve_offer_cards(offer_cards : Array[OfferCard]) :
	current_offer_cards = offer_cards
	
	card_creation_factory._create_cards(current_offer_cards)
	
