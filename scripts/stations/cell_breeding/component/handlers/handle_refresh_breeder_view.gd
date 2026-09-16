extends Node

# components
@onready var reset_btn : Control = $"../BreedingUI/ExitHeader/ResetBtn"

# handle componentd
@onready var handle_wanted_borders : Node = $HandleWantedBorders
@onready var handle_confirm_btn : Node = $HandleConfirmBtn
@onready var handle_wanted_highlight : Node = $HandleWantedHighlight

var last_ui_state : Dictionary[String, BrainCell] = {}


func _ready() -> void:
	GLBreedingComponetsBus.connect('initate_breeder_refresh', _handle_refresh)

func _handle_refresh() : 
	
	handle_wanted_highlight._handle(last_ui_state)
	
	# called everytime a breeder box changes.
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	
	if panel_state != ui_state :
		reset_btn._toggle_active(true)
	else : 
		reset_btn._toggle_active(false)
	
	handle_wanted_borders._handle()
	handle_confirm_btn._handle()
	
	last_ui_state = ui_state 
	
	
