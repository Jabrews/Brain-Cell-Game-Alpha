extends Node

var debug_offer_cards : Array[OfferCard] = [
	
]





func _ready() -> void:
	GLOfferCardCreatorBus.connect('create_offer_cards', _handle_create_offer_cards)

func _handle_create_offer_cards(
	strength_ideal_stat : IdealStat,
	intelligence_ideal_stat : IdealStat,
	community_ideal_stat : IdealStat
) :
	
	GLOfferCardCreatorBus.emit_signal('recieve_offer_cards', [])	
