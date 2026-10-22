extends Node

# components
@onready var cinnamatic_manager : Node = $"../CinnamaticManager"
@onready var parent_offer_tablet : Node = $".."
@onready var tablet_interact_area : Area3D = $"../../../OfferTablet/Poles/TabletHolderPole/TabletInteractArea"
# disable reset components
@onready var parent_preview_cards : Control = $"../../../OfferUi/OfferBody/PreviewCards/PreviewCardParent"
@onready var parent_showcase : Control = $"../../../OfferUi/OfferBody/CardShowcase/CardShowcaseParent"


func _toggle(toggle_value : bool) :
	
	if toggle_value : 	
		
		cinnamatic_manager._start_cinnamatic()
		
		parent_offer_tablet._start()
		
		tablet_interact_area.set_collision_layer_value(18, true)
		
	
	else : 
		cinnamatic_manager._end_cinnamatic()
		
		tablet_interact_area.set_collision_layer_value(18, false)
		
		for preview_card : Node in parent_preview_cards.get_children() : 
			preview_card.queue_free()
		
		for showcase : Node in parent_showcase.get_children() : 
			showcase.queue_free()
		
	
	
