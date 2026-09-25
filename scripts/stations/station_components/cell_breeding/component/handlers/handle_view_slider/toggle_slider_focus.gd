extends Node

# visual components
@onready var left_main_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewMainBox/DisplayBackground"
@onready var right_main_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewMainBox/DisplayBackground"

@onready var left_boost_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewBoostBox/DisplayBackground"
@onready var right_boost_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewBoostBox/DisplayBackground"

@onready var slide_handle_bg_rect : ColorRect = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideHandle/SlideBg"

@onready var selected_cell_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/BoxSection/SelectedViewBox/DisplayBackground"

@onready var confirm_btn_bg : ColorRect = $"../../BreedingUI/InteractFooter/ConfirmBtn/BtnBg"
@onready var back_btn_bg : ColorRect = $"../../BreedingUI/InteractFooter/BackBtn/BtnBg"


# basic toggle mode components
@onready var toggle_mode_components : Array[Control] = [
	$"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/ViewBtnSection/BtnParent/StatsViewBtn/BG2",
	$"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/ViewBtnSection/BtnParent/DeathChangeViewBtn/BG2",
	$"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/ViewBtnSection/BtnParent/BloodTypeViewBtn/BG2",
	$"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/ViewBtnSection/BtnParent/MutationsViewBtn/BG2"
]

@onready var selected_cell_box : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/BoxSection/SelectedViewBox"


func _ready() -> void:
	_toggle(false)

	GLBreedingComponetsBus.connect(
		"cell_loaded_on_selected_view",
		_handle_cell_loaded_on_selected_view
	)

	GLBreedingComponetsBus.connect(
		"cell_removed_from_selected_view",
		_handle_cell_removed_from_selected_view
	)


func _toggle(toggle_value : bool) -> void:
	
	if toggle_value:
		
		# main boxes have no focus while covered
		left_main_box_display_background.focus_mode = Control.FOCUS_NONE
		right_main_box_display_background.focus_mode = Control.FOCUS_NONE

		# boost boxes move down to slider handle
		left_boost_box_display_background.focus_neighbor_bottom = slide_handle_bg_rect.get_path()
		right_boost_box_display_background.focus_neighbor_bottom = slide_handle_bg_rect.get_path()

		# slider handle moves down to selected view box
		slide_handle_bg_rect.focus_neighbor_bottom = selected_cell_box_display_background.get_path()

		# selected box can now be focused
		selected_cell_box_display_background.focus_mode = Control.FOCUS_ALL

		# selected box moves down to confirm
		selected_cell_box_display_background.focus_neighbor_bottom = confirm_btn_bg.get_path()

		# confirm + back move UP to selected box
		confirm_btn_bg.focus_neighbor_top = selected_cell_box_display_background.get_path()
		back_btn_bg.focus_neighbor_top = selected_cell_box_display_background.get_path()

		# last toggle component bottom goes to confirm
		toggle_mode_components.back().focus_neighbor_bottom = confirm_btn_bg.get_path()

		if selected_cell_box.loaded_cell:
			for component : Control in toggle_mode_components:
				component.focus_mode = Control.FOCUS_ALL
		else:
			for component : Control in toggle_mode_components:
				component.focus_mode = Control.FOCUS_NONE


	else:
		
		# main boxes focus normally again
		left_main_box_display_background.focus_mode = Control.FOCUS_ALL
		right_main_box_display_background.focus_mode = Control.FOCUS_ALL

		# boost boxes move down to main boxes
		left_boost_box_display_background.focus_neighbor_bottom = left_main_box_display_background.get_path()
		right_boost_box_display_background.focus_neighbor_bottom = right_main_box_display_background.get_path()

		# selected slider content disabled
		selected_cell_box_display_background.focus_mode = Control.FOCUS_NONE

		for component : Control in toggle_mode_components:
			component.focus_mode = Control.FOCUS_NONE

		# slider handle bottom goes directly to confirm
		slide_handle_bg_rect.focus_neighbor_bottom = confirm_btn_bg.get_path()

		# confirm + back move UP to slider handle
		confirm_btn_bg.focus_neighbor_top = slide_handle_bg_rect.get_path()
		back_btn_bg.focus_neighbor_top = slide_handle_bg_rect.get_path()


func _handle_cell_loaded_on_selected_view(_loaded_cell : BrainCell) -> void:
	for component : Control in toggle_mode_components:
		component.focus_mode = Control.FOCUS_ALL


func _handle_cell_removed_from_selected_view() -> void:
	for component : Control in toggle_mode_components:
		component.focus_mode = Control.FOCUS_NONE
