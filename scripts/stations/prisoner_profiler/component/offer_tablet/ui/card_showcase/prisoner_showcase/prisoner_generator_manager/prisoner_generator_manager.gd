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

var test_cell_pool: Array[BrainCell] = [
	BrainCell.new("Test Cell 1", [], BrainCellStat.new("strength", true, 20.0, 0.0, false), BrainCellStat.new("intelligence", true, 40.0, 0.0, false), BrainCellStat.new("community", true, 60.0, 0.0, false), 0),
	BrainCell.new("Test Cell 2", [], BrainCellStat.new("strength", true, 70.0, 0.0, false), BrainCellStat.new("intelligence", true, 30.0, 0.0, false), BrainCellStat.new("community", true, 50.0, 0.0, false), 0),
	BrainCell.new("Test Cell 3", [], BrainCellStat.new("strength", true, 45.0, 0.0, false), BrainCellStat.new("intelligence", true, 80.0, 0.0, false), BrainCellStat.new("community", true, 25.0, 0.0, false), 0)
]

var active_screen : String = 'prisoner_example'

func _start(_prisoner_card: OfferCard) -> void:
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


func _handle_new_prisoner_advance() -> void:
	active_screen = "loading"
	prisoner_example_parent.visible = false
	loading_parent.visible = true
	advance_light_controller._stop()
	timer_manager._start_loading_timer()


func _stop() -> void:
	timer_manager._stop()
	advance_light_controller._stop()

	active_screen = "loading"
	loading_parent.visible = true
	prisoner_example_parent.visible = false
	playback_btn_manager._reset()
