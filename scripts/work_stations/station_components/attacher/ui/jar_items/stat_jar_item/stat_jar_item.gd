extends Control

# components
@onready var bg: TextureRect = $BG
@onready var hover_border: TextureRect = $OutsideBorders/HoverBorder
@onready var dragging_border: TextureRect = $OutsideBorders/DraggingBorder
@onready var delete_btn: Control = $DeleteBtn
@onready var display_stat_jar_item: Node = $DisplayStatJarItem

# used components
@onready var on_main_stat_border: TextureRect = $InsideBorders/OnMainStatBorder

var corrisponding_stat_jar_item: StatJarItem

var is_used: bool = false
var dragging: bool = false


func _ready() -> void:
	for control in [bg, delete_btn]:
		control.mouse_entered.connect(_handle_enter)
		control.mouse_exited.connect(_handle_exit)
		control.focus_entered.connect(_handle_enter)
		control.focus_exited.connect(_handle_exit)

	delete_btn.visible = true
	hover_border.visible = false
	dragging_border.visible = false


func _start(stat_jar_item: StatJarItem) -> void:
	corrisponding_stat_jar_item = stat_jar_item
	is_used = false

	on_main_stat_border.visible = false
	display_stat_jar_item._display(stat_jar_item)


# when jar item dropped on main statgg
func _item_used() -> void:
	is_used = true
	on_main_stat_border.visible = true
	delete_btn.visible = false

	hover_border.visible = false
	dragging_border.visible = false
	delete_btn._update_visuals()


func _handle_enter() -> void:
	if is_used or dragging:
		return

	hover_border.visible = true


func _handle_exit() -> void:
	call_deferred("_check_exit")


func _check_exit() -> void:
	if _is_mouse_over(bg) or _is_mouse_over(delete_btn):
		return

	if bg.has_focus() or delete_btn.has_focus():
		return

	hover_border.visible = false


func _is_mouse_over(control: Control) -> bool:
	return control.get_global_rect().has_point(
		control.get_global_mouse_position()
	)


func _set_dragging(value: bool) -> void:
	dragging = value

	dragging_border.visible = value
	hover_border.visible = false

	delete_btn._update_visuals()


func _can_drag() -> bool:
	if is_used or dragging:
		return false

	if _is_mouse_over(delete_btn) or delete_btn.has_focus():
		return false
	
	if GLAttacherComponentBus.showing_delete_modal : 
		return false

	return _is_mouse_over(bg) or bg.has_focus()
