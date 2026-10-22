extends Node

# components
@onready var handle_preview_card_selected : Node = $"../HandlePreviewCardSelected"
@onready var preview_card_parent : Control = $"../../../OfferUi/OfferBody/PreviewCards/PreviewCardParent"
@onready var toggle_display_offer_ui : Node = $"../ToggleDisplayOfferUi"
# parent comp
@onready var parent_offer_tablet : Node = $".."
@onready var parent_prisoner_profiler : Node3D = $"../../.."
# helper components
@onready var activate_card_animation : Node = $ActivateCardAnimation


	
func _handle() -> void:
	
	if handle_preview_card_selected.selected_card_index == -1 : 
		return
		
	# get sorted preview cards
	var sorted_preview_cards: Dictionary = _get_sorted_confirmation_preview_cards()
	
	# hide mouse and prevent interaction
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# get offer card
	var selected_offer_card : OfferCard = parent_offer_tablet.current_offer_cards[handle_preview_card_selected.selected_card_index ]
	
	# reset selected border	
	handle_preview_card_selected.handle(handle_preview_card_selected.selected_card_index )
	
	
	var animation_completed: bool = await activate_card_animation._activate(sorted_preview_cards)
	
	if animation_completed:

		# close ui and unfreeze time / player
		toggle_display_offer_ui._toggle(false)
		
		# let parent profiler proceed 
		# HACK MUST GO AFTER TOGGLE AS CINNAMATIC HAS ITS OWN LOCK
		parent_prisoner_profiler.handle_offer_picked(selected_offer_card)

	
	
	# TODO 
	# make middle card appear towards middle and shoot towards top. 
	# make other fade
	# deal resetting any tablet state here too 
	# kill all instances of cards and showcase
	# ? get this selected card back to the profiler for finale signal, end cinnamtic, and proceeding in turn
	
	return


func _get_sorted_confirmation_preview_cards() -> Dictionary : 
	
	var selected_card_index : int = handle_preview_card_selected.selected_card_index 
	var preview_cards : Array[Node] = preview_card_parent.get_children()
	
	var sorted_preview_cards : Dictionary[String, Variant]= {
		'confirmed' : null,
		'unselected': [],
	}
	
	var curr_index = 0
	
	while curr_index != len(preview_cards) : 
		
		# set selected card
		if selected_card_index == curr_index : 		
			sorted_preview_cards['confirmed'] = preview_cards[curr_index]
		else : 
			sorted_preview_cards['unselected'].append(preview_cards[curr_index])
		
		curr_index += 1

	# IF NEED CHECK DICT HERE 	
	
	return sorted_preview_cards
