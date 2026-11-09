extends Node

# components
@onready var parent_jar_item: Control = $".."
@onready var create_drag_jar_item: Node = $CreateDragJarItem
@onready var holding_detect_timer: Timer = $HoldingDetectTimer

var holding: bool = false
var dragging: bool = false


func _ready() -> void:
	holding_detect_timer.timeout.connect(_handle_holding_detect_timeout)


func _process(_delta: float) -> void:
	if parent_jar_item.is_finished:
		return

	if parent_jar_item._can_drag():
		if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("interact"):
			holding = true
			holding_detect_timer.start()

	if holding:
		if Input.is_action_just_released("attack") or Input.is_action_just_released("interact"):
			_reset_hold()


func _handle_holding_detect_timeout() -> void:
	if not holding:
		return

	dragging = true

	parent_jar_item._set_dragging(true)
	create_drag_jar_item._create(parent_jar_item.corrisponding_stat_jar_item)


func _reset_hold() -> void:
	holding = false
	holding_detect_timer.stop()

	if dragging:
		create_drag_jar_item._delete()

	dragging = false
	parent_jar_item._set_dragging(false)
