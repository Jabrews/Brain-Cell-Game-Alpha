extends Node

@export var side : String = 'left'
var box_type : String = 'boost'
@export var handle_boost_display : Node


# components
@export var drag_cell_entry_parent_node: Node
@onready var display_background : TextureRect = $DisplayBackground
@onready var mock_cell_entry : Control = $MockCellEntry
@onready var add_a_cell_hint : Control = $AddACellHint

# helper components
@onready var display_mock_cell_entry : Node = $DisplayMockCellEntry
@onready var handle_boost_btn_pressed : Node = $HandleBoostBtnPressed


var loaded_cell : BrainCell 

func _handle_entry_dropped(cell : BrainCell, play_sound : bool = false, refresh : bool = false) :
	
	if loaded_cell or not cell : 	
		return
	
	loaded_cell = cell
	
	mock_cell_entry.visible = true
	display_mock_cell_entry._display(loaded_cell)
	add_a_cell_hint.visible = false
	
	# play accept sound
	if play_sound : 
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_accepted')
	
	_update_breeding_ui_state()
	
	handle_boost_btn_pressed._handle_loaded_cell_changed(loaded_cell)
	
	
	if refresh : 
		GLBreedingComponetsBus.emit_signal('initate_breeder_refresh')
	
	
func _handle_box_empty(play_sound : bool = false, refresh : bool = false) :
	
		
	if play_sound : 
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_removed')
	
	loaded_cell = null
	mock_cell_entry.visible = false 
	
	_update_breeding_ui_state()
	
	handle_boost_btn_pressed._handle_loaded_cell_changed(loaded_cell)
	
	if refresh : 
		GLBreedingComponetsBus.emit_signal('initate_breeder_refresh')

func _update_breeding_ui_state() : 
#	
	var key = side + '_boost'
	
	GLBreedingComponetsBus.breeding_ui_state[key] = loaded_cell	
