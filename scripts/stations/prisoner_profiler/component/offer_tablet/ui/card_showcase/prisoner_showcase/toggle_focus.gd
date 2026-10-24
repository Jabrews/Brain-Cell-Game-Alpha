extends Node

# visual components
@onready var total_defect_hint_rect : ColorRect = $"../DefectRateDisplay/TotalDefectRate/DetectHintRect"
@onready var pris_gen_playback_btn_textue_rect : TextureRect = $"../PrisGenerator/Header/PlaybackBtn/BtnTextureRect"
@onready var lifespan_hint_rect : ColorRect = $"../PropertyInfo/AverageLifespan/LifespanHintRect"
@onready var bloodtype_hint_rect : ColorRect = $"../PropertyInfo/BloodType/BloodTypeHintRect"
@onready var preivew_card_detect_areas : Array[ColorRect] = [
	$"../../../../PreviewCardsHover/PreviewCardHover1/DetectArea",
	$"../../../../PreviewCardsHover/PreviewCardHover2/DetectArea",
	$"../../../../PreviewCardsHover/PreviewCardHover3/DetectArea"
]
@onready var exit_btn_rect : ColorRect = $"../../../../../ExitHeader/ExitBtn"


func _toggle(toggle_value : bool): 
	
	
	# turn on top focus for playback btn to exit btn
	
	if toggle_value	: 
		
		# turn on valid mode for all showcase specific component
		total_defect_hint_rect.focus_mode = Control.FOCUS_ALL		
		pris_gen_playback_btn_textue_rect.focus_mode = Control.FOCUS_ALL
		lifespan_hint_rect.focus_mode = Control.FOCUS_ALL
		bloodtype_hint_rect.focus_mode = Control.FOCUS_ALL
		
		# prview cards focus to showcase
		for preview_card : ColorRect in preivew_card_detect_areas : 
			preview_card.focus_neighbor_top = total_defect_hint_rect.get_path()
			
		# turn on bottom focus for defect rate hint and bloodtype hint
		total_defect_hint_rect.focus_neighbor_bottom = preivew_card_detect_areas[1].get_path()	
		bloodtype_hint_rect.focus_neighbor_bottom = preivew_card_detect_areas[1].get_path()	
		
		pris_gen_playback_btn_textue_rect.focus_neighbor_top = exit_btn_rect.get_path()
		exit_btn_rect.focus_neighbor_bottom = pris_gen_playback_btn_textue_rect.get_path()
		
	else : 
		total_defect_hint_rect.focus_mode = Control.FOCUS_NONE
		pris_gen_playback_btn_textue_rect.focus_mode = Control.FOCUS_NONE
		lifespan_hint_rect.focus_mode = Control.FOCUS_NONE
		bloodtype_hint_rect.focus_mode = Control.FOCUS_NONE
		
		# prview cards focus to showcase
		for preview_card : ColorRect in preivew_card_detect_areas : 
			preview_card.focus_neighbor_top = exit_btn_rect.get_path()
		
		exit_btn_rect.focus_neighbor_bottom = preivew_card_detect_areas[1].get_path()
		
