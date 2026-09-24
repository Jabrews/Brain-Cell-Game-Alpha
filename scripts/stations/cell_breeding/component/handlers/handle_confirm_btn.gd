extends Node

# components
@onready var parent_station : Node3D = $".."
@onready var handle_display_ui : Node = $"../HandleDisplayUi"
@onready var display_new_cell_preview : Node = $"../DisplayNewCellPreview"

var current_screen : String = 'cell_loader'

func _handle() :  
	
	if current_screen == 'cell_loader' :
		
		display_new_cell_preview._display()
		
		current_screen = 'new_cell_preview'
		
	elif current_screen == 'new_cell_preview' :
		
		finale_breeding_request()
		
		current_screen = 'cell_loader'

	

func finale_breeding_request() :
	
	var main_left_cell : BrainCell = parent_station.left_main_cell
	var main_right_cell : BrainCell = parent_station.right_main_cell
	var boost_left_cell : BrainCell = parent_station.left_boost_cell
	var boost_right_cell : BrainCell = parent_station.right_boost_cell
	var boost_left_stat : String = GLBreedingComponetsBus.left_boost_stat
	var boost_right_stat : String = GLBreedingComponetsBus.right_boost_stat
	var boost_left_direction : String = GLBreedingComponetsBus.left_boost_direction
	var boost_right_direction : String = GLBreedingComponetsBus.right_boost_direction
	
	GLCellBreederBus.emit_signal('player_breeded_cells', 
		main_left_cell ,
		main_right_cell ,
		boost_left_cell ,
		boost_right_cell ,
		boost_left_stat,
		boost_right_stat,
		boost_left_direction,
		boost_right_direction,
	)
	
	# close
	handle_display_ui._toggle_display(false)
	
	# reset ui cells
	for key in GLBreedingComponetsBus.breeding_ui_state : 
		GLBreedingComponetsBus.breeding_ui_state[key] = null
	
	
	
