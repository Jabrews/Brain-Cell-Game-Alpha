extends Node

# components
@onready var parent_offer_tablet : Node = $".."
@onready var preview_card_hover_parents : Array[Control] = [
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover1",
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover2",
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover3"
]

func handle(card_index: int) -> void:
	
	if card_index < 0 or card_index >= preview_card_hover_parents.size():
		push_error('trying to select invalid index : ', card_index)
		return

	if card_index >= parent_offer_tablet.current_offer_cards.size():
		push_error('trying to select invalid index : ', card_index)
		return

	# handle selected border
	var selected_hover_parent: Control = preview_card_hover_parents[card_index]

	selected_hover_parent._handle_selected()

	for index in range(preview_card_hover_parents.size()):
		if index == card_index:
			continue

		preview_card_hover_parents[index]._reset()
	
	# handle offer showcase	
	#var corresponding_offer_card: OfferCard = parent_offer_tablet.current_offer_cards[card_index]
	
	
	
	
	
	
	
	
