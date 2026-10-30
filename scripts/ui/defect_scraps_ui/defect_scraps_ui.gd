extends Control

# components
@onready var scraps_label: Label = $ScrapsLabel
@onready var next_value_increment_timer: Timer = $NextValueIncrementTimer
@onready var scrap_symbol : TextureRect = $ScrapSymbol

# helper components
@onready var helper_flash_label : Node = $HelperFlashLabel
@onready var helper_opacity : Node = $HelperOpacity


var curr_defect_scrap_value: int = 0
var target_defect_scraps: int = 0


func _ready() -> void:
	GLDefectScrapsBus.connect("update_ui_scraps_changed", _handle_update_ui_scraps_changed)
	next_value_increment_timer.connect("timeout", _handle_next_value_increment_timer_timeout)
	
	GLHideUiBus.connect("toggle_hide_ui", _handle_toggle_hide_ui)
	
	helper_opacity._initate_fade()

func _handle_update_ui_scraps_changed(new_defect_scraps: int, old_defect_scraps: int) -> void:
	
	helper_opacity._reset()
	
	# Initialize from the old value if no count animation is running.
	if next_value_increment_timer.is_stopped():
		curr_defect_scrap_value = old_defect_scraps
		scraps_label.text = str(curr_defect_scrap_value)

	target_defect_scraps = new_defect_scraps

	if curr_defect_scrap_value != target_defect_scraps:
		next_value_increment_timer.start()
		scrap_symbol._toggle_float(true)


func _handle_next_value_increment_timer_timeout() -> void:
	if curr_defect_scrap_value < target_defect_scraps:
		curr_defect_scrap_value += 1
		helper_flash_label._handle(1)
	elif curr_defect_scrap_value > target_defect_scraps:
		curr_defect_scrap_value -= 1
		helper_flash_label._handle(-1)

	scraps_label.text = str(curr_defect_scrap_value)

	if curr_defect_scrap_value != target_defect_scraps:
		next_value_increment_timer.start()
		GLPlayerLocalSoundsBus.emit_signal('play_sound', 'defect_scrap_increment')
	# if its finished increasing / decreasing
	else : 
		helper_flash_label._stop()
		
		GLPlayerLocalSoundsBus.emit_signal('play_sound', 'defect_scrap_finished')
		scrap_symbol._toggle_float(false)
		helper_opacity._initate_fade()

func _handle_toggle_hide_ui(toggle_value: bool) -> void:
	visible = not toggle_value
	
	if toggle_value == false : 
			helper_opacity._initate_fade()	
