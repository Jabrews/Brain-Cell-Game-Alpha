extends Node

# components 
@onready var card_showcase_parent : Control = $"../../../OfferUi/OfferBody/CardShowcase/CardShowcaseParent"
# packed scenes
@onready var prisoner_showcase_p_s : PackedScene = preload("res://scenes/stations/station_components/prisoner_profiler/offer_tablet/card_showcases/prisoner_showcase.tscn")
@onready var shareholder_items_showcase_p_s : PackedScene = preload("res://scenes/stations/station_components/prisoner_profiler/offer_tablet/card_showcases/shareholder_items_showcase.tscn")


func _create_showcases(offer_cards : Array[OfferCard]) : 
	
	if len(offer_cards) > 3 : 	
		push_error('trying to create more than 3 offer cards')
		return
	
	var curr_index = 0	
	
	while curr_index != len(offer_cards):
		
		var offer_card : OfferCard	 = offer_cards[curr_index]
		
		match offer_card.card_type :
			'prisoner' :
				var prisoner_showcase_instance : Control = prisoner_showcase_p_s.instantiate()
				card_showcase_parent.add_child(prisoner_showcase_instance)
				prisoner_showcase_instance._stop()
				prisoner_showcase_instance._load_offer(offer_card)
				
			'shareholder_items' :
				var shareholder_items_showcase_instance : Control = shareholder_items_showcase_p_s.instantiate()
				card_showcase_parent.add_child(shareholder_items_showcase_instance)
				shareholder_items_showcase_instance._stop()
				shareholder_items_showcase_instance._load_offer(offer_card)
		
		
		curr_index += 1
		
		
		
