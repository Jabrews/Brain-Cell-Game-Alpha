extends Node

# components
@onready var reset_btn : Control = $"../BreedingUI/ExitHeader/ResetBtn"

# handle componentd
@onready var handle_wanted_borders : Node = $HandleWantedBorders
@onready var handle_confirm_btn : Node = $HandleConfirmBtn
@onready var handle_wanted_highlight : Node = $HandleWantedHighlight
@onready var handle_breeding_view : Node = $"../HandleBreedingView"
@onready var handle_boost_display : Node = $HandleBoostDisplay

# helper component
@onready var helper_verify_ui_state : Node = $HelperVerifyUiState

var last_ui_state : Dictionary[String, BrainCell] = {}

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		
		var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
		var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()

		for key: String in ["right_main"]:
			var ui_cell: BrainCell = ui_state.get(key)
			var panel_cell: BrainCell = panel_state.get(key)

			print("ui ", key, ": ", ui_cell.name if ui_cell != null else "null")
			print("panel ", key, ": ", panel_cell.name if panel_cell != null else "null")
		





func _ready() -> void:
	GLBreedingComponetsBus.connect('initate_breeder_refresh', _handle_refresh)

func _handle_refresh() : 
	
	handle_wanted_highlight._handle(last_ui_state)
	
	
	helper_verify_ui_state._verify()	
	
	# called everytime a breeder box changes.
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	
	if panel_state != ui_state :
		reset_btn._toggle_active(true)
	else : 
		reset_btn._toggle_active(false)
	
	handle_wanted_borders._handle()
	handle_confirm_btn._handle()
	handle_breeding_view._handle()
	handle_boost_display._handle()
	
	last_ui_state = ui_state 
	
	
