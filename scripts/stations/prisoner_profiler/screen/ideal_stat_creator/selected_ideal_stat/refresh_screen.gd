extends Node

# components
@onready var stat_display_bar : Sprite2D = $"../StatDisplay/Bar"
@onready var parent_off_display : Control = $"../OffDisplay"
@onready var parent_stat_display : Control = $"../StatDisplay"
@onready var parent_none_display : Control = $"../NoneDisplay"
# lock components
@onready var locked_bg_rect : ColorRect = $"../StatDisplay/Locked/LockedBG"
@onready var locked_symbol_sprite : Sprite2D = $"../StatDisplay/Locked/SymbolSprite"

const LOCK_MAX_WIDTH : float = 840.0

func _refresh(
	selected_stat : String,
	stat_value : float, 
	stat_enabled : bool,
	lock_max_value : float,
) :
	
	parent_off_display.visible = false	
	parent_stat_display.visible = false
	parent_none_display.visible = false
	
	if selected_stat == 'none' :
		parent_none_display.visible = true
		return
	
	if stat_enabled == false : 
		parent_off_display.visible = true
		return
	
	parent_stat_display.visible = true
	
	## set bar shader value
	var max_stat_value : float = IVCellCreator.max_stat_value	
	
	stat_display_bar.material.set_shader_parameter("prisoner_value", stat_value / max_stat_value)
	
	
	## set lock bg
	_load_lock_bg(lock_max_value)


func _load_lock_bg(lock_max_value: float) -> void:
	var max_stat_value: float = IVCellCreator.max_stat_value

	if max_stat_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	var lock_percent: float = clampf(
		lock_max_value / max_stat_value,
		0.0,
		1.0
	)

	var lock_x: float = LOCK_MAX_WIDTH * lock_percent

	locked_bg_rect.position.x = lock_x - 10.0
	locked_bg_rect.size.x = maxf(LOCK_MAX_WIDTH - lock_x, 0.0) + 10.0

	locked_symbol_sprite.position.x = (
		locked_bg_rect.position.x + locked_bg_rect.size.x / 2.0
	)
	
	
	
	

	
