extends Node

# NOTE script is slighty reusable. KEEP VAUGE

@onready var parent_jar_item : Control = $".."
@onready var parent_bg : TextureRect = $"../BG"
@onready var hover_border : TextureRect = $"../OutsideBorders/HoverBorder"
@onready var dragging_border : TextureRect = $"../OutsideBorders/DraggingBorder"
@onready var create_drag_jar_item : Node = $CreateDragJarItem

# components
@onready var holding_detect_timer: Timer = $HoldingDetectTimer

var hovered: bool = false
var holding: bool = false
var dragging: bool = false

func _ready() -> void:
	parent_bg.mouse_entered.connect(_handle_mouse_enter)
	parent_bg.mouse_exited.connect(_handle_mouse_exit)
	
	parent_bg.focus_entered.connect(_handle_mouse_enter)
	parent_bg.focus_exited.connect(_handle_mouse_exit)

	holding_detect_timer.timeout.connect(_handle_holding_detect_timeout)


func _process(_delta: float) -> void:
	if not hovered and not dragging:
		return

	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed('interact'):
		holding = true
		holding_detect_timer.start()

	if Input.is_action_just_released("attack") or Input.is_action_just_released('interact'):
		
		if holding and not dragging:
			pass

		_reset_hold()


func _handle_holding_detect_timeout() -> void:
	if not holding:
		return

	dragging = true

	hover_border.visible = false
	dragging_border.visible = true

	create_drag_jar_item._create(parent_jar_item.corrisponding_stat_jar_item)


func _handle_mouse_enter() -> void:
	hovered = true

	if not dragging:
		hover_border.visible = true


func _handle_mouse_exit() -> void:
	hovered = false

	# don't reset here if currently dragging
	if dragging:
		return

	_reset_hold()

	hover_border.visible = false
	dragging_border.visible = false


func _reset_hold() -> void:
	holding = false
	dragging = false

	holding_detect_timer.stop()
	
	create_drag_jar_item._delete()

	dragging_border.visible = false

	if hovered:
		hover_border.visible = true
	else:
		hover_border.visible = false
