extends Node

# components
@onready var display_turns_left : Node = $DisplayTurnsLeft

var current_offer_cards : Array[OfferCard] = []


func _ready() -> void:
	GLOfferCardCreatorBus.connect('recieve_offer_cards', _handle_recieve_offer_cards)


func _start() :
	
	GLOfferCardCreatorBus.emit_signal('create_offer_cards')		
	
	display_turns_left._display()

func _handle_recieve_offer_cards(offer_cards : Array[OfferCard]) :
	current_offer_cards = offer_cards
