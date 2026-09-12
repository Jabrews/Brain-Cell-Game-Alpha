extends Node

# display components
@onready var parent_cell_entry: Control = $".."
@onready var entry_texture: TextureRect = $"../EntryTexture"
@onready var selected_border_texture: TextureRect = $"../OutsideBorderEffects/SelectedBorder"
@onready var dragging_border_texture: TextureRect = $"../OutsideBorderEffects/DraggingBorder"
@onready var create_drag_cell_entry: Node =$CreateDragCellEntry

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
	if not hovered and not dragging:
		return

	if Input.is_action_just_pressed("attack"):
		holding = true
		holding_detect_timer.start()

	if Input.is_action_just_released("attack"):
		
		if holding and not dragging:
			print("normal click")

		_reset_hold()


func _handle_holding_detect_timeout() -> void:
	if not holding:
		return

	dragging = true

	selected_border_texture.visible = false
	dragging_border_texture.visible = true

	create_drag_cell_entry._create(parent_cell_entry.loaded_cell)


func _handle_mouse_enter() -> void:
	hovered = true

	if not dragging:
		selected_border_texture.visible = true


func _handle_mouse_exit() -> void:
	hovered = false

	# don't reset here if currently dragging
	if dragging:
		return

	_reset_hold()

	selected_border_texture.visible = false
	dragging_border_texture.visible = false


func _reset_hold() -> void:
	holding = false
	dragging = false

	holding_detect_timer.stop()
	
	create_drag_cell_entry._delete()

	dragging_border_texture.visible = false

	if hovered:
		selected_border_texture.visible = true
	else:
		selected_border_texture.visible = false
