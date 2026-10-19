extends Node

var debug_offer_cards : Array[OfferCard] = [
	PrisonerOfferCard.new(
		PrisonerCardStat.new(30, 100, 0, true),
		PrisonerCardStat.new(50, 80, 25, true),
		PrisonerCardStat.new(0, 0, false),
		25,
		1,
		3,
		'',
		[]
	),
	
	PrisonerOfferCard.new(
		PrisonerCardStat.new(0, 0, false),
		PrisonerCardStat.new(50, 80, 50, true),
		PrisonerCardStat.new(30, 100, 25, true),
		75,
		1,
		4,
		'exsplosive',
		[]
	),
	
	ShareholderItemsCard.new(
		[
			UseableOfferItem.new(
				"defect_shot",
				"Decreases a chosen stat on a cell container by 15 percent, 3 charges total."
			),		
			UseableOfferItem.new(
				"hidden_shot",
				"Reveal a chosen hidden stat on a cell container, 3 charges total"
			),
			UseableOfferItem.new(
				"ice_cube",
				"Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction."
			),
		]
	)
	
	
	
	
	
	
]





func _ready() -> void:
	GLOfferCardCreatorBus.connect('create_offer_cards', _handle_create_offer_cards)

func _handle_create_offer_cards(_ideal_stats : Array[IdealStat]) :
	
	GLOfferCardCreatorBus.emit_signal('recieve_offer_cards', debug_offer_cards)	
