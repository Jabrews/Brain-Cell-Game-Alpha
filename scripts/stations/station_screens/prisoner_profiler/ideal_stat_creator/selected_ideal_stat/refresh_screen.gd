extends Node

# components
@onready var stat_display_bar : Sprite2D = $"../StatDisplay/Bar"
@onready var parent_off_display : Control = $"../OffDisplay"
@onready var parent_stat_display : Control = $"../StatDisplay"
@onready var parent_none_display : Control = $"../NoneDisplay"
# lock components
@onready var locked_bg_rect : ColorRect = $"../StatDisplay/Locked/LockedBG"
@onready var locked_symbol_sprite : Sprite2D = $"../StatDisplay/Locked/LockedSprite"
# unreachable components
@onready var unreachable_bg_rect : ColorRect = $"../StatDisplay/Unreachable/UnreachableBG"

const LOCK_MAX_WIDTH : float = 840.0

func _refresh(
	ideal_stat : IdealStat
) :
	
	parent_off_display.visible = false	
	parent_stat_display.visible = false
	parent_none_display.visible = false
	
	if not ideal_stat : 
		parent_none_display.visible = true
		return
	
	if ideal_stat.enabled == false : 
		parent_off_display.visible = true
		return
	
	parent_stat_display.visible = true
	
	## set bar shader value
	var max_stat_value : float = IVCellCreator.max_stat_value	
	
	stat_display_bar.material.set_shader_parameter("prisoner_value", ideal_stat.value / max_stat_value)
	
	
	## set lock bg
	_load_lock_bg(ideal_stat.lock_max_value)
	
	var min_unreachable_value : float = IVPrisonerProfiler.uncreachable_min_value
	_load_unreachable_bg(min_unreachable_value)



func _load_lock_bg(lock_max_value: float) -> void:
	var max_stat_value: float = IVCellCreator.max_stat_value

	if max_stat_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	var available_max_value: float = clampf(
		IVPrisonerProfiler.uncreachable_min_value,
		0.0,
		max_stat_value
	)

	var clamped_lock_value: float = clampf(
		lock_max_value,
		0.0,
		available_max_value
	)

	# No locked area remains inside the available range.
	if clamped_lock_value >= available_max_value:
		locked_bg_rect.visible = false
		locked_symbol_sprite.visible = false
		return

	locked_bg_rect.visible = true
	locked_symbol_sprite.visible = true

	var lock_x: float = (
		LOCK_MAX_WIDTH * clamped_lock_value / max_stat_value
	)
	var available_end_x: float = (
		LOCK_MAX_WIDTH * available_max_value / max_stat_value
	)

	# Match the start of the unreachable background.
	var unreachable_start_x: float = available_end_x - 10.0
	var lock_start_x: float = lock_x - 10.0

	locked_bg_rect.position.x = lock_start_x
	locked_bg_rect.size.x = maxf(
		unreachable_start_x - lock_start_x,
		0.0
	)

	locked_symbol_sprite.position.x = (
		locked_bg_rect.position.x + locked_bg_rect.size.x * 0.5
	)
	
	
func _load_unreachable_bg(unreachable_min_value: float) -> void:
	var max_stat_value: float = IVCellCreator.max_stat_value

	if max_stat_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	var min_percent: float = clampf(
		unreachable_min_value / max_stat_value,
		0.0,
		1.0
	)
	var min_x: float = LOCK_MAX_WIDTH * min_percent

	if min_x >= LOCK_MAX_WIDTH:
		unreachable_bg_rect.visible = false
		return

	unreachable_bg_rect.visible = true
	unreachable_bg_rect.position.x = min_x - 10.0
	unreachable_bg_rect.size.x = LOCK_MAX_WIDTH - min_x + 10.0
	
