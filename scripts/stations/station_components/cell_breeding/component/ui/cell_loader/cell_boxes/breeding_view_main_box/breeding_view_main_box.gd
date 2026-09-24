extends Control

@export var side : String = 'left'
var box_type : String = 'main'

var prevent_interact : bool = false

# components
@export var drag_cell_entry_parent_node: Node
@onready var display_background : TextureRect = $DisplayBackground
@onready var display_mock_cell_entry : Node = $MainBoxDisplayMockCellEntry #is diffrent from other display cell entries
@onready var mock_cell_entry : Control = $MockCellEntry
@onready var add_a_cell_hint : Control = $AddACellHint
@onready var unavaible_lock : Control = $MockCellEntry/UnavaibleLock

var loaded_cell : BrainCell 

func _handle_entry_dropped(cell : BrainCell, play_sound : bool = false, refresh : bool = false) :
	
	if loaded_cell or not cell : 	
		return
	
	if prevent_interact :
		return
	
	loaded_cell = cell
	
	# TODO
	
	mock_cell_entry.visible = true
	add_a_cell_hint.visible = false
	display_mock_cell_entry._display(loaded_cell)
	
	# play accept sound
	if play_sound : 
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_accepted')
	
	_update_breeding_ui_state()
	
	if refresh : 
		GLBreedingComponetsBus.emit_signal('initate_breeder_refresh')
	
	
func _handle_box_empty(play_sound : bool = false, refresh : bool = false) :
	
	if prevent_interact == true : 	
		return
	
	if play_sound  :
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_removed')
	
	loaded_cell = null
	mock_cell_entry.visible = false 
	unavaible_lock._toggle_lock(false)
	
	_update_breeding_ui_state()
	
	if refresh : 
		GLBreedingComponetsBus.emit_signal('initate_breeder_refresh')


func _update_breeding_ui_state() : 
#	
	var key = side + '_main'
	
	GLBreedingComponetsBus.breeding_ui_state[key] = loaded_cell	
	
	
	
	
		
	
	
