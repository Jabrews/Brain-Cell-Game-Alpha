extends Node

# components
@onready var create_cards : Node = $CreateCards
@onready var prisoner_generator : Node = $PrisonerGenerator




func _ready() -> void:
	GLOfferCardCreatorBus.connect('create_offer_cards', _handle_create_offer_cards)

func _handle_create_offer_cards(ideal_stats : Array[IdealStat]) :
	
	var offer_cards : Array[OfferCard] = create_cards._create(ideal_stats)
	
	## create prisoners
	for offer_card : OfferCard in offer_cards : 
		
		if offer_card.card_type == 'prisoner' : 
			
			offer_card.prisoner_cells = prisoner_generator._generate_prisoner_cells(ideal_stats, offer_card)
	
	GLOfferCardCreatorBus.emit_signal('recieve_offer_cards', offer_cards)	
