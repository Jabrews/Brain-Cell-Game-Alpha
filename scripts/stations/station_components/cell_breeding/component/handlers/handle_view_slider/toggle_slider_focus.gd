extends Node

# visual components
@onready var left_main_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewMainBox/DisplayBackground"
@onready var right_main_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewMainBox/DisplayBackground"

@onready var left_boost_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewBoostBox/DisplayBackground"
@onready var right_boost_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewBoostBox/DisplayBackground"

@onready var slide_handle_bg_rect : ColorRect = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideHandle/SlideBg"

@onready var selected_cell_box_display_background : TextureRect = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/BoxSection/SelectedViewBox/DisplayBackground"

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
	
	GLBreedingComponetsBus.connect('cell_loaded_on_selected_view', _handle_cell_loaded_on_selected_view)	
	GLBreedingComponetsBus.connect('cell_removed_from_selected_view', _handle_cell_removed_from_selected_view)	
	

func _toggle(toggle_value : bool) -> void:
	if toggle_value:
		
		# main boxes have no focus while covered
		left_main_box_display_background.focus_mode = Control.FOCUS_NONE
		right_main_box_display_background.focus_mode = Control.FOCUS_NONE
		
		# boost boxes move down to slider handle
		left_boost_box_display_background.focus_neighbor_bottom = slide_handle_bg_rect.get_path()
		right_boost_box_display_background.focus_neighbor_bottom = slide_handle_bg_rect.get_path()
		
		selected_cell_box_display_background.focus_mode = Control.FOCUS_ALL
		
		# TODO only enable if found selected cell
		
		if selected_cell_box.loaded_cell :
			
			for component : Control in toggle_mode_components : 		
				component.focus_mode = Control.FOCUS_ALL
		
		else : 
			for component : Control in toggle_mode_components : 		
				component.focus_mode = Control.FOCUS_NONE
		
		
	
	else:
		left_main_box_display_background.focus_mode = Control.FOCUS_ALL
		right_main_box_display_background.focus_mode = Control.FOCUS_ALL
		
		left_boost_box_display_background.focus_neighbor_bottom = left_main_box_display_background.get_path()
		right_boost_box_display_background.focus_neighbor_bottom = right_main_box_display_background.get_path()
		
		selected_cell_box_display_background.focus_mode = Control.FOCUS_NONE
#		
		for component : Control in toggle_mode_components : 		
			component.focus_mode = Control.FOCUS_NONE
		
func _handle_cell_loaded_on_selected_view(_loaded_cell : BrainCell) :
	for component : Control in toggle_mode_components : 		
			component.focus_mode = Control.FOCUS_ALL

func _handle_cell_removed_from_selected_view() :
		for component : Control in toggle_mode_components : 		
			component.focus_mode = Control.FOCUS_NONE
