extends Control

# components
@onready var display_stat_jar_item: Node = $DisplayStatJarItem
@onready var dragging_border: TextureRect = $DraggingBorder
@onready var handle_drop: Node = $HandleDrop
@onready var display_background: TextureRect = $DisplayBG

# drag settings
@export var mouse_offset: Vector2 = Vector2(-100, -50)

var loaded_stat_jar_item: StatJarItem
var mode: String = ""
var is_dropping: bool = false

func _ready() -> void:
	mode = GAMEInputTypeDetector.input_type


func _process(_delta: float) -> void:
	if is_dropping:
		return

	if mode == "keyboard":
		global_position = (
			get_global_mouse_position()
			+ mouse_offset
		)

	else:
		var focused_control: Control = get_viewport().gui_get_focus_owner()

		if focused_control:
			var focus_rect: Rect2 = focused_control.get_global_rect()

			global_position = (
				focus_rect.position
				+ focus_rect.size / 6.0
				- size / 6.0
			)


func _load_jar_item(stat_jar_item: StatJarItem) -> void:
	loaded_stat_jar_item = stat_jar_item
	display_stat_jar_item._display(loaded_stat_jar_item)
	dragging_border.visible = true


func _delete() -> void:
	if is_dropping:
		return

	is_dropping = true
	dragging_border.visible = false

	var scale_tween: Tween = create_tween()
	scale_tween.tween_property(
		self,
		"scale",
		Vector2(0.1, 0.1),
		0.15
	)

	await scale_tween.finished

	handle_drop._handle()
	queue_free()
