extends Node

# components
@onready var parent_offer_tablet : Node = $".."
@onready var preview_card_hover_parents : Array[Control] = [
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover1",
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover2",
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover3"
]
@onready var refresh_card_showcase : Node = $RefreshCardShowcase
@onready var refresh_confirm_btn : Node = $RefreshConfirmBtn

var selected_card_index : int = -1

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
	
	# find if it was selected on/off
	if selected_hover_parent.border_state == 'selected' :
		selected_card_index = card_index
	else : 
		selected_card_index = -1

	# reset all other cards
	for index in range(preview_card_hover_parents.size()):
		if index == card_index:
			continue

		preview_card_hover_parents[index]._reset()
	
	# handle offer showcase	
	refresh_card_showcase._refresh(selected_card_index)
	# handle confirm btn
	refresh_confirm_btn._refresh(selected_card_index)
