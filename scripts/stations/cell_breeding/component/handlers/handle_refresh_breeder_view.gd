extends Node

# components
@onready var reset_btn : Control = $"../BreedingUI/ExitHeader/ResetBtn"

# handle componentd
@onready var handle_wanted_borders : Node = $"../HandleWantedBorders"

func _ready() -> void:
	GLBreedingComponetsBus.connect('initate_breeder_refresh', _handle_refresh)


func _handle_refresh() : 
	
	# called everytime a breeder box changes.
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	
	if panel_state != ui_state :
		reset_btn._toggle_active(true)
	else : 
		reset_btn._toggle_active(false)
	
	handle_wanted_borders._handle()
	
	
	
	
	
