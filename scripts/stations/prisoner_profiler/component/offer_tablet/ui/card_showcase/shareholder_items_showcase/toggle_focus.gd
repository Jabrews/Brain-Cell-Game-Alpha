extends Node

# visual components
@onready var exit_btn_rect : ColorRect = $"../../../../../ExitHeader/ExitBtn"
@onready var rotate_back_label : Label = $"../ItemGallery/RotateBtns/BackBtn"
@onready var rotate_foward_label : Label = $"../ItemGallery/RotateBtns/FowardBtn"
@onready var preivew_card_detect_areas : Array[ColorRect] = [
	$"../../../../PreviewCardsHover/PreviewCardHover1/DetectArea",
	$"../../../../PreviewCardsHover/PreviewCardHover2/DetectArea",
	$"../../../../PreviewCardsHover/PreviewCardHover3/DetectArea"
]
# components
@onready var handle_preview_card_selected : Node = $"../../../../../../Logic/OfferTablet/HandlePreviewCardSelected"


func _toggle(toggle_value : bool): 
	
	if toggle_value : 	
		
		rotate_foward_label.focus_mode = Control.FOCUS_ALL	
		rotate_back_label.focus_mode = Control.FOCUS_ALL	
		
		exit_btn_rect.focus_neighbor_bottom = rotate_foward_label.get_path()	
		rotate_foward_label.focus_neighbor_top = exit_btn_rect.get_path()
		rotate_back_label.focus_neighbor_top = exit_btn_rect.get_path()
		
		for preview_card : ColorRect in preivew_card_detect_areas : 
			preview_card.focus_neighbor_top = rotate_foward_label.get_path()
			
	else : 
		
		rotate_foward_label.focus_mode = Control.FOCUS_NONE
		rotate_back_label.focus_mode = Control.FOCUS_NONE
		
		exit_btn_rect.focus_neighbor_bottom = preivew_card_detect_areas[1].get_path()
		
		for preview_card : ColorRect in preivew_card_detect_areas : 
			preview_card.focus_neighbor_top = exit_btn_rect.get_path()
		
	
	
	
