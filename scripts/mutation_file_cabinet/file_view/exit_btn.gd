extends TextureRect

@export var float_amount: float = 1.2
@export var float_duration: float = 0.5
@export var hover_scale_multiplier: float = 1.1
@export var hover_duration: float = 0.15

var org_pos: Vector2
var org_scale: Vector2

var being_hovered_over: bool = false

var float_tween: Tween
var hover_tween: Tween


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	org_pos = position
	org_scale = scale

	# Makes scaling happen from the center instead of the top-left.
	pivot_offset = size / 2.0

	start_floating()


func _process(_delta: float) -> void:
	if being_hovered_over:
		if Input.is_action_just_pressed("attack"):
			get_parent()._close_file_view()


func start_floating() -> void:
	if float_tween:
		float_tween.kill()

	float_tween = create_tween()
	float_tween.set_loops()

	float_tween.tween_property(self, "position:y", org_pos.y + float_amount, float_duration)
	float_tween.tween_property(self, "position:y", org_pos.y, float_duration)
	float_tween.tween_property(self, "position:y", org_pos.y - float_amount, float_duration)
	float_tween.tween_property(self, "position:y", org_pos.y, float_duration)


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

	hover_tween.tween_property(
		self,
		"position",
		org_pos,
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

	await hover_tween.finished

	start_floating()
