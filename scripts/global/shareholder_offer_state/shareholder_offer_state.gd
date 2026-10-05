extends Node

## ITEM OFFER SIGNALS ##
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
