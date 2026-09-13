extends Node

@export var side : String = 'left'

# components
@export var drag_cell_entry_parent_node: Node
@onready var display_background : TextureRect = $DisplayBackground
@onready var display_mock_cell_entry : Node = $DisplayMockCellEntry
@onready var mock_cell_entry : Control = $MockCellEntry
@onready var add_a_cell_hint : Control = $AddACellHint

@onready var on_bost_border : TextureRect = $InsideBorderEffects/OnBoost
@onready var wanted_boost_border : TextureRect = $InsideBorderEffects/WantedBoost

var loaded_cell : BrainCell 

func _handle_entry_dropped(cell : BrainCell) :
	
	if loaded_cell or not cell : 	
		return
	
	loaded_cell = cell
	
	# TODO
	# look if it is on panel
	wanted_boost_border.visible = true
	
	mock_cell_entry.visible = true
	display_mock_cell_entry._display(loaded_cell)
	add_a_cell_hint.visible = false
	
	# set border
	GLBreedingComponetsBus.emit_signal('toggle_cell_entry_border', loaded_cell.name, 'wanted_boost', true)
	
	# play accept sound
	GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_accepted')
	
	_update_breeding_ui_state()
	
	
func _handle_box_empty() :
	
	# clear border
	if loaded_cell  :
		GLBreedingComponetsBus.emit_signal('toggle_cell_entry_border', loaded_cell.name, 'wanted_boost', false)
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'box_removed')
	
	loaded_cell = null
	mock_cell_entry.visible = false 
	wanted_boost_border.visible = false
	
	_update_breeding_ui_state()

func _update_breeding_ui_state() : 
#	
	var key = side + '_boost'
	
	GLBreedingComponetsBus.breeding_ui_state[key] = loaded_cell	
