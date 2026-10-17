extends Node

# components 
@onready var card_spawn_positions : Array[Node2D] = [
	$"../../../OfferUi/OfferBody/PreviewCards/SpawnPos1",
	$"../../../OfferUi/OfferBody/PreviewCards/SpawnPos2",
	$"../../../OfferUi/OfferBody/PreviewCards/SpawnPos3"
]
@onready var cards_parent_node : Control = $"../../../OfferUi/OfferBody/PreviewCards/PreviewCardParent"
# packed scenes
@onready var prisoner_preview_card_p_s : PackedScene = preload("res://scenes/stations/prisoner_profiler/component/offer_tablet/preview_cards/prisoner_preview_card.tscn")
@onready var shareholder_items_preview_card_p_s : PackedScene = preload("res://scenes/stations/prisoner_profiler/component/offer_tablet/preview_cards/shareholder_items_preview_card.tscn")


func _create_cards(offer_cards : Array[OfferCard]) : 
	
	if len(offer_cards) > 3 : 	
		push_error('trying to create more than 3 offer cards')
		return
	
	var curr_index = 0	
	
	while curr_index != len(offer_cards):
		
		var offer_card : OfferCard	 = offer_cards[curr_index]
		
		var current_spawn_pos : Node2D = card_spawn_positions[curr_index]
		
		
		match offer_card.card_type :
			'prisoner' :
				
				var prisoner_card_instance : Control = prisoner_preview_card_p_s.instantiate()
				cards_parent_node.add_child(prisoner_card_instance)
				prisoner_card_instance.global_position = current_spawn_pos.global_position
				prisoner_card_instance._initate_card(offer_card)
				
			'shareholder_items' :
				var shareholder_items_card_instance : Control = shareholder_items_preview_card_p_s.instantiate()
				cards_parent_node.add_child(shareholder_items_card_instance)
				shareholder_items_card_instance.global_position = current_spawn_pos.global_position
		
		
		curr_index += 1
		
		
		
		
	
	
	
	
