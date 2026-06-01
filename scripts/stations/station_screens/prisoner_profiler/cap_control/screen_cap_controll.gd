extends Node

# componnets
@onready var help_shake_symbols : Node = $HelpShakeSymbols
@onready var bar : Sprite2D = $Bar
@onready var off_display : Control = $OffDisplay

func _ready() -> void:
	bar.material = bar.material.duplicate()
	
	
func _toggle_display_off_screen(toggleValue : bool) :
	if toggleValue :
		off_display.visible = true
	else : 
		off_display.visible = false

func update_target_stat(target_stat_value : float) :
	
	var max_val = IVCellCreator.max_stat_value

	# prisoner (yellow)
	var target_stat_norm = float(target_stat_value) / max_val
	
	bar.material.set_shader_parameter("target_value", target_stat_norm)
	

func update_current_stat_value(current_stat_value : float, current_clean_range : String) :
	var max_val = IVCellCreator.max_stat_value

	# prisoner (yellow)
	var stat_norm = float(current_stat_value) / max_val
	
	help_shake_symbols.	_handle_update_shake_symbols(current_clean_range)
	
	bar.material.set_shader_parameter("prisoner_value", stat_norm)
