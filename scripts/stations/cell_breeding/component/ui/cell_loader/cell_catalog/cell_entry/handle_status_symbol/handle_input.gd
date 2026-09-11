extends Node

# display components
@onready var entry_texture: TextureRect = $"../EntryTexture"
@onready var selected_border_texture: TextureRect = $"../OutsideBorderEffects/SelectedBorder"
@onready var dragging_border_texture: TextureRect = $"../OutsideBorderEffects/DraggingBorder"

# components
@onready var holding_detect_timer: Timer = $HoldingDetectTimer

var hovered: bool = false
var holding: bool = false
var dragging: bool = false


func _ready() -> void:
	entry_texture.mouse_entered.connect(_handle_mouse_enter)
	entry_texture.mouse_exited.connect(_handle_mouse_exit)

	holding_detect_timer.timeout.connect(_handle_holding_detect_timeout)


func _process(_delta: float) -> void:
	if not hovered:
		return

	# start checking for hold
	if Input.is_action_just_pressed("attack"):
		holding = true
		holding_detect_timer.start()

	# released before timer finished = normal click
	if Input.is_action_just_released("attack"):
		
		if holding and not dragging:
			print("normal click")

		_reset_hold()


func _handle_holding_detect_timeout() -> void:
	if not holding:
		return

	# mouse has been held long enough
	dragging = true

	selected_border_texture.visible = false
	dragging_border_texture.visible = true



func _handle_mouse_enter() -> void:
	hovered = true

	if not dragging:
		selected_border_texture.visible = true


func _handle_mouse_exit() -> void:
	hovered = false
	_reset_hold()

	selected_border_texture.visible = false
	dragging_border_texture.visible = false


func _reset_hold() -> void:
	holding = false
	dragging = false

	holding_detect_timer.stop()

	dragging_border_texture.visible = false

	if hovered:
		selected_border_texture.visible = true
