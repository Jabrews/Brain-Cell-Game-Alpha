extends Control

# components
@export var drag_cell_entry_parent_node: Node
@onready var display_background : TextureRect = $DisplayBackground
@onready var on_selected_border : TextureRect = $InsideBorderEffects/OnSelected
@onready var display_mock_cell_entry : Node = $DisplayMockCellEntry
@onready var mock_cell_entry : Control = $MockCellEntry
@onready var add_a_cell_hint : Control = $AddACellHint

var loaded_cell : BrainCell 

func _handle_entry_dropped(cell : BrainCell) :
	
	if loaded_cell or not cell : 	
		return
	
	
	loaded_cell = cell
	on_selected_border.visible = true
	mock_cell_entry.visible = true
	display_mock_cell_entry._display(loaded_cell)
	add_a_cell_hint.visible = false
	
	GLBreedingComponetsBus.emit_signal('toggle_cell_entry_border', loaded_cell.name, 'selected', true)
	
	# play accept sound
	GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_accepted')
	
	GLBreedingComponetsBus.emit_signal('cell_loaded_on_selected_view', loaded_cell)
	
	## Controller
	if GAMEInputTypeDetector.input_type == 'controller' : 		
		
		await get_tree().process_frame
		
		display_background.grab_focus()
	
	
func _handle_box_empty(play_sound : bool = false) :
	
	if loaded_cell : 	
		GLBreedingComponetsBus.emit_signal('toggle_cell_entry_border', loaded_cell.name, 'selected', false)
	
		# clear border
		if play_sound : 
			GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_removed')
	
	loaded_cell = null
	mock_cell_entry.visible = false 
	on_selected_border.visible = false
	
	GLBreedingComponetsBus.emit_signal('cell_removed_from_selected_view')
	
	## Controller
	if GAMEInputTypeDetector.input_type == 'controller' : 		
		
		await get_tree().process_frame
		
		display_background.grab_focus()
