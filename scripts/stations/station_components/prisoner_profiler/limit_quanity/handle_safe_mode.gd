extends Node


# main componnets
@onready var parent_prisoner_profiler : Node3D = $"../.."
@onready var safe_mode_lights :  Node3D = $"../../SafeMode/SafeModeLights"
@onready var screen_safe_mode : Node2D = $"../../SafeMode/SafeModeTV/TvFrontPannel/SubViewport/LimitQuanity"


# other componnets safe mode ffects
@onready var prisoner_picks_btn_updater : Node3D = $"../../StatDisplay/PrisonerPicksBtns"
@onready var handle_spare_symbols : Node = $"../Symbols/HandleSpareSymbols"
@onready var handle_cycle_stat : Node = $"../HandleCycleStat"


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_round', _handle_proceed_next_round)

func _safe_mode_lever_switched() :
	
	if parent_prisoner_profiler.safe_mode_used : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	parent_prisoner_profiler._handle_safe_mode_lever_switched()
	
	var safe_mode_active = parent_prisoner_profiler.safe_mode_active == true
	
	safe_mode_lights._toggle_lights(safe_mode_active)
	prisoner_picks_btn_updater._safe_mode_disable_btns(safe_mode_active)
	handle_spare_symbols._toggle_safe_mode_disable_spare_icons(safe_mode_active)
	handle_cycle_stat.reset_active_mesh()
	
	# dealing with safe mode screen
	if safe_mode_active : 
		screen_safe_mode.switch_screen('active')
	else : 
		screen_safe_mode.switch_screen('inactive')

func _safe_mode_used() :
	screen_safe_mode.switch_screen('used')
	safe_mode_lights._toggle_lights(false)
	prisoner_picks_btn_updater._safe_mode_disable_btns(false)
	handle_spare_symbols._toggle_safe_mode_disable_spare_icons(false)
	

func _handle_proceed_next_round() :
	screen_safe_mode.switch_screen('inactive')
	safe_mode_lights._toggle_lights(false)
	prisoner_picks_btn_updater._safe_mode_disable_btns(false)
	handle_spare_symbols._toggle_safe_mode_disable_spare_icons(false)
	
	
	
	
