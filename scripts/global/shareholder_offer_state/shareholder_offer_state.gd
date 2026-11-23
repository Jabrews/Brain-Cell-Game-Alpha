extends Node

# lets shareholder offer manager know to serve card
signal serve_shareholder_offer_cards(usable_offer_items : Array[UseableOfferItem])


# lets useable item spawner know to spawn an item
signal spawn_item_to_offer(useable_offer_item : UseableOfferItem)

##### item offer #####
var items_to_offer = [
	UseableOfferItem.new('defect_shot','Decreases a chosen stat on a cell container by 15 percant, 3 charges total' ),
	UseableOfferItem.new('hidden_shot', 'Reveals all hidden stats on a cell container.'),
	UseableOfferItem.new('steroid', 'Increases the clean and defect values of a cell container by 30 percant'),
	UseableOfferItem.new('ice_cube', 'Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction.'),
	UseableOfferItem.new('scissors', 'Cut off a chosen stat or mutation from a cell.'),
]
######################


var all_items = [
	UseableOfferItem.new(
		"defect_shot",
		"Decreases a chosen stat on a cell container by 15 percent, 3 charges total."
	),
	UseableOfferItem.new(
		"hidden_shot",
		"Reveal a chosen hidden stat on a cell container, 3 charges total"
	),
	UseableOfferItem.new(
		"steroid",
		"Increases the clean and defect values of a cell container by 30 percent."
	),
	UseableOfferItem.new(
		"ice_cube",
		"Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction."
	),
	UseableOfferItem.new(
		"scissors",
		"Cut off a chosen stat from a cell."
		)
]
