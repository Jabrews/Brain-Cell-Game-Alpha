extends Node

# components
@onready var parent_main_stat: Control = $".."

# default
@onready var default_detect_rect: ColorRect = $"../DefaultDetectRect"
@onready var drag_valid_border: TextureRect = $"../DragBorders/DragValidBorder"
@onready var drag_invalid_border: TextureRect = $"../DragBorders/DragInvalidBorder"

# replacement
@onready var replacement_drag_invalid_border: TextureRect = $"../StatReplacement/Borders/DragInvalidBorder"

# hints
@onready var stat_unable_to_drag_hint: Control = $"../HoverHints/StatUnableToDragHint"
@onready var already_occupied_hint: Control = $"../HoverHints/AlreadyOccupiedHint"

# detection radius
@export var stat_drop_radius: float = 20.0


func _process(_delta: float) -> void:
	var currently_hovered: bool = false

	var detect_rect: Rect2 = default_detect_rect.get_global_rect().grow(
		stat_drop_radius
	)

	for child in parent_main_stat.parent_stat_item_drag_node.get_children():
		if child is Control:
			var drag_rect: Rect2 = child.display_background.get_global_rect()
			var drag_center: Vector2 = drag_rect.get_center()

			if detect_rect.has_point(drag_center):
				currently_hovered = true
				break

	if currently_hovered:
		_handle_hover_on()
	else:
		_handle_hover_off()


func _handle_hover_on() -> void:
	# Reset previous effects
	_handle_hover_off()

	if not parent_main_stat.main_stat_enabled:
		drag_invalid_border.visible = true
		stat_unable_to_drag_hint.visible = true

	elif parent_main_stat.replacement_stat_jar_item:
		replacement_drag_invalid_border.visible = true
		already_occupied_hint.visible = true

	else:
		drag_valid_border.visible = true


func _handle_hover_off() -> void:
	drag_invalid_border.visible = false
	stat_unable_to_drag_hint.visible = false
	replacement_drag_invalid_border.visible = false
	already_occupied_hint.visible = false
	drag_valid_border.visible = false
