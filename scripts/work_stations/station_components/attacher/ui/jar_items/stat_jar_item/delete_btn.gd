extends Control

# components
@onready var delete_btn_bg: ColorRect = $BG
@onready var hover_border: ColorRect = $HoverBorder
@onready var delete_hint: Control = $DeleteHint

# parent
@onready var parent_stat_jar_item: Control = $".."

# handlers
@onready var handle_delete_jar_btn: Node = $"../../../../../../../Logic/BtnHandlers/HandleJarDeleteBtn"


func _ready() -> void:
	mouse_entered.connect(_update_visuals)
	mouse_exited.connect(_update_visuals)
	focus_entered.connect(_update_visuals)
	focus_exited.connect(_update_visuals)

	_update_visuals()


func _process(_delta: float) -> void:
	if parent_stat_jar_item.is_finished or parent_stat_jar_item.dragging:
		return

	if _is_active():
		if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("interact"):
			handle_delete_jar_btn._handle(
				parent_stat_jar_item.corrisponding_stat_jar_item
			)


func _is_active() -> bool:
	return get_global_rect().has_point(get_global_mouse_position()) or has_focus()


func _update_visuals() -> void:
	var active: bool = _is_active()

	if parent_stat_jar_item.is_finished or parent_stat_jar_item.dragging:
		active = false

	hover_border.visible = active
	delete_hint.visible = active
