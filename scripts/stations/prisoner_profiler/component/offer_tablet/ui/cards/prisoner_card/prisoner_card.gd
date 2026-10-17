extends Control

# components
@onready var display_card : Node = $DisplayCard

var active_prisoner_card : PrisonerOfferCard

func _initate_card(prisoner_card : PrisonerOfferCard) :

	active_prisoner_card = prisoner_card
	
	display_card._display(active_prisoner_card)
