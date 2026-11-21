
extends TextureRect

@onready var parent_file_view: Control = $"../.."

@export var float_amount: float = 1.2
@export var float_duration: float = 0.5
@export var hover_scale_multiplier: float = 1.1
@export var hover_duration: float = 0.15

var org_scale: Vector2
var float_offset: float = 0.0

var being_hovered_over: bool = false

var float_tween: Tween
var hover_tween: Tween


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	focus_entered.connect(_on_mouse_entered)
	focus_exited.connect(_on_mouse_exited)

	org_scale = scale

	resized.connect(_update_pivot)
	_update_pivot()

	start_floating()


func _process(_delta: float) -> void:
	if being_hovered_over:
		if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("drop_item"):
			parent_file_view._close_file_view()


func _update_pivot() -> void:
	pivot_offset = size / 2.0


func _set_float_offset(value: float) -> void:
	position.y += value - float_offset
	float_offset = value


func start_floating() -> void:
	if float_tween:
		float_tween.kill()

	float_tween = create_tween()
	float_tween.set_loops()

	float_tween.tween_method(
		_set_float_offset, float_offset, float_amount, float_duration
	)
	float_tween.tween_method(
		_set_float_offset, float_amount, 0.0, float_duration
	)
	float_tween.tween_method(
		_set_float_offset, 0.0, -float_amount, float_duration
	)
	float_tween.tween_method(
		_set_float_offset, -float_amount, 0.0, float_duration
	)


func stop_floating() -> void:
	if float_tween:
		float_tween.kill()
		float_tween = null


func _on_mouse_entered() -> void:
	being_hovered_over = true

	stop_floating()

	if hover_tween:
		hover_tween.kill()

	hover_tween = create_tween()
	hover_tween.set_parallel(true)

	hover_tween.tween_property(
		self,
		"scale",
		org_scale * hover_scale_multiplier,
		hover_duration
	)

	hover_tween.tween_method(
		_set_float_offset,
		float_offset,
		0.0,
		hover_duration
	)


func _on_mouse_exited() -> void:
	being_hovered_over = false

	if hover_tween:
		hover_tween.kill()

	hover_tween = create_tween()

	hover_tween.tween_property(
		self,
		"scale",
		org_scale,
		hover_duration
	)

	hover_tween.tween_callback(start_floating)
