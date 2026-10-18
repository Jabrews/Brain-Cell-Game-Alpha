extends Node

# visual components
@onready var hint_select_card_label : Label = $"../../../../OfferUi/OfferBody/CardShowcase/HintSelectCardLabel"
# components
@onready var card_showcase_parent : Control = $"../../../../OfferUi/OfferBody/CardShowcase/CardShowcaseParent"


func _refresh(selected_card_index : int) : 
	
	var card_showcases : Array[Node]= card_showcase_parent.get_children()
	
	
	for card_showcase in card_showcases :
		card_showcase._reset()
	
	if selected_card_index == -1 : 
		hint_select_card_label.visible = true
	else : 	
		hint_select_card_label.visible = false 
		# set this one active
		card_showcases[selected_card_index]._display()
	
	
	
	
	
