extends Node

@export var is_selected_view_box : bool = false
@export var is_main_box : bool = false

# components
@onready var parent_box : Control = $".."
@onready var display_background: TextureRect = $"../DisplayBackground"
@onready var remove_border : TextureRect = $"../RemoveBorder"
@onready var add_a_cell_hint : Control = $"../AddACellHint"
@onready var selected_border : TextureRect = $"../SelectedBorder"

var hovered: bool = false
var focused: bool = false


func _ready() -> void:
	display_background.mouse_entered.connect(_handle_mouse_entered)
	display_background.mouse_exited.connect(_handle_mouse_exited)

	display_background.focus_entered.connect(_handle_focus_entered)
	display_background.focus_exited.connect(_handle_focus_exited)


func _process(_delta: float) -> void:
	if hovered or focused:
		if parent_box.loaded_cell:
			if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("interact"):

				if not is_selected_view_box:
					parent_box._handle_box_empty(true, true)
				else:
					parent_box._handle_box_empty(true)

				_update_visuals()


func _handle_mouse_entered() -> void:
	hovered = true

	if is_main_box and parent_box.prevent_interact:
		_update_visuals()
		return

	_update_visuals()


func _handle_mouse_exited() -> void:
	hovered = false
	_update_visuals()


func _handle_focus_entered() -> void:
	focused = true

	if is_main_box and parent_box.prevent_interact:
		_update_visuals()
		return

	_update_visuals()


func _handle_focus_exited() -> void:
	focused = false
	_update_visuals()


func _update_visuals() -> void:
	var selected: bool = hovered or focused

	# default everything off
	selected_border.visible = false
	remove_border.visible = false
	add_a_cell_hint.visible = false

	if not selected:
		return

	# if cell exists, remove border has priority
	if parent_box.loaded_cell:
		remove_border.visible = true
		return

	# otherwise ALWAYS show selected border
	selected_border.visible = true

	# empty box hint
	if not is_main_box and not is_selected_view_box:
		if parent_box.side == "right":
			add_a_cell_hint.position = Vector2(-256.0, 24.0)

		add_a_cell_hint.visible = true
