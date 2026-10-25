extends Node

# visual components
@onready var left_boost_display : Control = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay"
@onready var left_add_main_cell_hint : Control = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/AddMainCellHint"
@onready var right_boost_display : Control = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay"
@onready var right_add_main_cell_hint : Control = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/AddMainCellHint"

# visual components : for controller focus
@onready var left_boost_btn_rect : TextureRect = $"../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewBoostBox/BoostBtn/BoostBtn"
@onready var right_boost_btn_rect : TextureRect = $"../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewBoostBox/BoostBtn/BoostBtn"
@onready var left_boost_exit_btn_rect : ColorRect = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Header/ExitBtn/BtnBG"
@onready var right_boost_exit_btn_rect : ColorRect = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Header/ExitBtn/BtnBG"
@onready var left_strength_detect_hover_rect : ColorRect = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/DetectHover"
@onready var right_strength_detect_hover_rect : ColorRect = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/DetectHover"

# display component
@onready var display_boost_stats : Node = $DisplayBoostStats
@onready var display_boost_debuff : Node = $HandleStatSelected/DisplayBoostDebuff

@onready var toggle_focus : Node = $ToggleFocus

# is called from boost box
func _handle(side : String) :
	
	var boost_cell : BrainCell	
	var main_cell : BrainCell
	var boost_display : Control 
	var add_a_cell_hint : Control
	
	match side : 
		'left' :
			boost_cell = GLBreedingComponetsBus.breeding_ui_state['left_boost']
			main_cell = GLBreedingComponetsBus.breeding_ui_state['left_main']
			boost_display = left_boost_display
			add_a_cell_hint = left_add_main_cell_hint
		'right' :
			boost_cell = GLBreedingComponetsBus.breeding_ui_state['right_boost']
			main_cell = GLBreedingComponetsBus.breeding_ui_state['right_main']
			boost_display = right_boost_display 
			add_a_cell_hint = right_add_main_cell_hint
		_ : 
			push_error('unable to find corrisponding boost cell on side : ', side)
			boost_cell = null
			main_cell = null
	
	if not boost_cell: 
		return
		
	boost_display.visible = true
	

	
	display_boost_stats._display(boost_cell, side)
	
	# display boost on selected stat, if it exist
	var selected_boost_stat : String 
	
	match side : 
		'left' :
			selected_boost_stat = GLBreedingComponetsBus.left_boost_stat
		'right' :
			selected_boost_stat = GLBreedingComponetsBus.right_boost_stat
	
	if selected_boost_stat != 'none' :
		display_boost_debuff._display(side, selected_boost_stat, boost_cell)
	
	
	# add a cell hint	
	if not main_cell : 
		add_a_cell_hint.visible = true
	else : 
		add_a_cell_hint.visible = false 
	
	await get_tree().process_frame
	toggle_focus._toggle(true, side, main_cell, boost_cell)

func _close_boost_display(side : String) :
	
	var boost_display : Control 
	
	match side : 
		'left' :
			boost_display = left_boost_display
		'right' :
			boost_display = right_boost_display 
		_ : 
			push_error('unable to find corrisponding boost cell on side : ', side)
			boost_display = null
	
	toggle_focus._toggle(false, side, null, null)
			
	boost_display.visible = false

	
	
	
	
	
	
	
