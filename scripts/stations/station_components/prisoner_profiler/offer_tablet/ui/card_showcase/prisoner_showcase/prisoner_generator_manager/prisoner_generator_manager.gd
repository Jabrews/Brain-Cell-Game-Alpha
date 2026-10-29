extends Node

# visual components
@onready var loading_parent : Control = $"../PrisGenerator/Loading"
@onready var prisoner_example_parent : Control = $"../PrisGenerator/PrisonerExample"
# component controllers / helpers (hacky! idc)
@onready var display_prisoner_example : Node = $ComponentControllers/DisplayPrisonerExample
@onready var advance_light_controller : Node = $ComponentControllers/AdvanceLightController
# components
@onready var timer_manager : Node = $TimerManager
@onready var playback_btn_manager : Node = $PlaybackBtnManager
@onready var parent_prisoner_showcase : Control = $".."

var prisoner_example : BrainCell


var active_screen : String = 'prisoner_example'

func _start(_prisoner_card: OfferCard) -> void:
	prisoner_example = generate_example_prisoner()

	active_screen = "loading"
	loading_parent.visible = true
	prisoner_example_parent.visible = false
	playback_btn_manager._reset()
	timer_manager._start()

	


func _toggle_pause(toggle_value: bool) -> void:
	timer_manager._toggle_pause(toggle_value)

	if active_screen == "prisoner_example":
		if toggle_value:
			advance_light_controller._pause()
		else:
			advance_light_controller._start()


func _handle_loading_advance() -> void:


	active_screen = "prisoner_example"
	loading_parent.visible = false
	prisoner_example_parent.visible = true
	advance_light_controller._start()
	timer_manager._start_prisoner_timer()
	
	var prisoner_card: PrisonerOfferCard = parent_prisoner_showcase.loaded_prisoner_card

	if prisoner_card == null : 
		push_error("Cannot show prisoner example display on screen : card is missing.")
		return 

	display_prisoner_example._display(prisoner_example, prisoner_card)


func _handle_new_prisoner_advance() -> void:
	active_screen = "loading"
	prisoner_example_parent.visible = false
	loading_parent.visible = true
	advance_light_controller._stop()
	timer_manager._start_loading_timer()
	
	prisoner_example = generate_example_prisoner()
	


func _stop() -> void:
	timer_manager._stop()
	advance_light_controller._stop()

	active_screen = "loading"
	loading_parent.visible = true
	prisoner_example_parent.visible = false
	playback_btn_manager._reset()
	
	prisoner_example = null

func generate_example_prisoner() -> BrainCell :
	
	var prisoner_card: PrisonerOfferCard = parent_prisoner_showcase.loaded_prisoner_card

	if prisoner_card == null : 
		push_error("Cannot generate example prisoner : card is missing.")
		return null
	
	
	var helper_generate_example_prisoner := get_tree().get_first_node_in_group("generate_example_prisoner")
	
	return helper_generate_example_prisoner._generate(prisoner_card)

		
