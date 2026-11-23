extends Node

# box components
@onready var left_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewMainBox"
@onready var right_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewMainBox"

# visual components
@onready var slide_content : Control = $"../BreedingUI/CellLoader/SelectedViewSlider/SlideContent"
@onready var slide_handle : Control = $"../BreedingUI/CellLoader/SelectedViewSlider/SlideHandle"
@onready var slide_bg_rect : ColorRect = $"../BreedingUI/CellLoader/SelectedViewSlider/SlideHandle/SlideBg"

# handle components
@onready var handle_btn_section : Node = $HandleBtnSection
@onready var handle_information_section : Node = $HandleInformationSection
@onready var handle_boost_display : Node = $"../HandleBoostDisplay"
@onready var toggle_slider_focus : Node = $ToggleSliderFocus


const SLIDE_CONTENT_CLOSE_POS : Vector2 = Vector2(0.0, 280.0)
const SLIDE_HANDLE_CLOSE_POS : Vector2 = Vector2(432.0, 240.0)
const SLIDE_CONTENT_OPEN_POS : Vector2 = Vector2(0.0, 24.0)
const SLIDE_HANDLE_OPEN_POS : Vector2 = Vector2(432.0, -16.0)


func _ready() -> void:
	# we use signals as opposed to refresh seen in breeding view
	GLBreedingComponetsBus.connect('cell_loaded_on_selected_view', _handle_cell_loaded_on_selected_view)
	GLBreedingComponetsBus.connect('cell_removed_from_selected_view', _cell_removed_from_selected_view)
	
	handle_btn_section._toggle_active(false)
	handle_information_section._toggle_active(false)


# called by slider when opened / closed
func _handle(toggle_value : bool) :
	
	# we do this to prevent them from getting dropped into
	# HACKY
	left_main_box.prevent_interact = toggle_value
	right_main_box.prevent_interact = toggle_value
	
	if toggle_value : 	
		slide_content.position = SLIDE_CONTENT_OPEN_POS
		slide_handle.position = SLIDE_HANDLE_OPEN_POS
	
		# close boost display
		handle_boost_display._close_boost_display('left')
		handle_boost_display._close_boost_display('right')
	
	
	else : 
		slide_content.position =  SLIDE_CONTENT_CLOSE_POS
		slide_handle.position = SLIDE_HANDLE_CLOSE_POS 
	
	toggle_slider_focus._toggle(toggle_value)
	
	if toggle_value : 	
		
		if GAMEInputTypeDetector.input_type == 'controller' :
			
			await get_tree().process_frame
			
			slide_bg_rect.grab_focus()
		
		
		
	
	
	
	
	
func _handle_cell_loaded_on_selected_view(cell : BrainCell) :
	handle_btn_section._toggle_active(true)
	handle_information_section._toggle_active(true)
	handle_information_section._display_information_section(cell)
	
	
func _cell_removed_from_selected_view() :
	handle_btn_section._toggle_active(false)
	handle_information_section._toggle_active(false)
	
