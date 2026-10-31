extends Node

@onready var breeding_ui : Control = $"../../BreedingUI"

# boost header
@onready var left_boost_exit_btn_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Header/ExitBtn/BtnBG"
@onready var right_boost_exit_btn_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Header/ExitBtn/BtnBG"
@onready var left_exsplain_hint_bg : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/ExsplainHint/BG"
@onready var right_exsplain_hint_bg : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/ExsplainHint/BG"

# boost stats
@onready var left_strength_detect_hover_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/DetectHover"
@onready var right_strength_detect_hover_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/DetectHover"
@onready var left_intelligence_detect_hover_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence/DetectHover"
@onready var right_intelligence_detect_hover_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence/DetectHover"
@onready var left_community_detect_hover_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community/DetectHover"
@onready var right_community_detect_hover_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community/DetectHover"

# change dir btns 
@onready var left_up_btn_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/ChargeDirectionBtns/UpBtn/BtnBG"
@onready var left_down_btn_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/ChargeDirectionBtns/DownBtn/BtnBG"
@onready var right_up_btn_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/ChargeDirectionBtns/UpBtn/BtnBG"
@onready var right_down_btn_rect : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/ChargeDirectionBtns/DownBtn/BtnBG"



func _toggle(toggle_value: bool, side: String, main_cell: BrainCell, boost_cell: BrainCell) -> void:
	match side:
		"left":
			if toggle_value:
				left_boost_exit_btn_rect.focus_mode = Control.FOCUS_ALL
				left_exsplain_hint_bg.focus_mode = Control.FOCUS_ALL

				if main_cell and boost_cell:
					left_boost_exit_btn_rect.focus_neighbor_bottom = left_strength_detect_hover_rect.get_path()
					left_exsplain_hint_bg.focus_neighbor_bottom = left_strength_detect_hover_rect.get_path()

					left_strength_detect_hover_rect.focus_mode = Control.FOCUS_ALL
					left_intelligence_detect_hover_rect.focus_mode = Control.FOCUS_ALL
					left_community_detect_hover_rect.focus_mode = Control.FOCUS_ALL
					left_up_btn_rect.focus_mode = Control.FOCUS_ALL
					left_down_btn_rect.focus_mode = Control.FOCUS_ALL
				else:
					left_boost_exit_btn_rect.focus_neighbor_bottom = left_boost_exit_btn_rect.get_path()
					left_exsplain_hint_bg.focus_neighbor_bottom = left_exsplain_hint_bg.get_path()

					left_strength_detect_hover_rect.focus_mode = Control.FOCUS_NONE
					left_intelligence_detect_hover_rect.focus_mode = Control.FOCUS_NONE
					left_community_detect_hover_rect.focus_mode = Control.FOCUS_NONE
					left_up_btn_rect.focus_mode = Control.FOCUS_NONE
					left_down_btn_rect.focus_mode = Control.FOCUS_NONE

				if left_boost_exit_btn_rect.is_inside_tree() : 
					left_boost_exit_btn_rect.grab_focus()
				
				
			else:
				left_boost_exit_btn_rect.focus_mode = Control.FOCUS_NONE
				left_exsplain_hint_bg.focus_mode = Control.FOCUS_NONE
				left_strength_detect_hover_rect.focus_mode = Control.FOCUS_NONE
				left_intelligence_detect_hover_rect.focus_mode = Control.FOCUS_NONE
				left_community_detect_hover_rect.focus_mode = Control.FOCUS_NONE
				left_up_btn_rect.focus_mode = Control.FOCUS_NONE
				left_down_btn_rect.focus_mode = Control.FOCUS_NONE

				if breeding_ui.is_inside_tree() : 
					breeding_ui.grab_focus()

		"right":
			if toggle_value:
				right_boost_exit_btn_rect.focus_mode = Control.FOCUS_ALL
				right_exsplain_hint_bg.focus_mode = Control.FOCUS_ALL

				if main_cell and boost_cell:
					right_boost_exit_btn_rect.focus_neighbor_bottom = right_strength_detect_hover_rect.get_path()
					right_exsplain_hint_bg.focus_neighbor_bottom = right_strength_detect_hover_rect.get_path()

					right_strength_detect_hover_rect.focus_mode = Control.FOCUS_ALL
					right_intelligence_detect_hover_rect.focus_mode = Control.FOCUS_ALL
					right_community_detect_hover_rect.focus_mode = Control.FOCUS_ALL
					right_up_btn_rect.focus_mode = Control.FOCUS_ALL
					right_down_btn_rect.focus_mode = Control.FOCUS_ALL
				else:
					right_boost_exit_btn_rect.focus_neighbor_bottom = right_boost_exit_btn_rect.get_path()
					right_exsplain_hint_bg.focus_neighbor_bottom = right_exsplain_hint_bg.get_path()

					right_strength_detect_hover_rect.focus_mode = Control.FOCUS_NONE
					right_intelligence_detect_hover_rect.focus_mode = Control.FOCUS_NONE
					right_community_detect_hover_rect.focus_mode = Control.FOCUS_NONE
					right_up_btn_rect.focus_mode = Control.FOCUS_NONE
					right_down_btn_rect.focus_mode = Control.FOCUS_NONE

				if right_boost_exit_btn_rect.is_inside_tree() : 
					right_boost_exit_btn_rect.grab_focus()
					
			else:
				right_boost_exit_btn_rect.focus_mode = Control.FOCUS_NONE
				right_exsplain_hint_bg.focus_mode = Control.FOCUS_NONE
				right_strength_detect_hover_rect.focus_mode = Control.FOCUS_NONE
				right_intelligence_detect_hover_rect.focus_mode = Control.FOCUS_NONE
				right_community_detect_hover_rect.focus_mode = Control.FOCUS_NONE
				right_up_btn_rect.focus_mode = Control.FOCUS_NONE
				right_down_btn_rect.focus_mode = Control.FOCUS_NONE

				if breeding_ui.is_inside_tree() : 
					breeding_ui.grab_focus()

		_:
			push_error("Unknown boost display side: " + side)
	
