
extends Node


@onready var hint_hack_circle_mesh: MeshInstance3D = $HintHackCircle
@onready var reapply_size_timer: Timer = $ReapplySizeTimer


@export var scale_gain: float = 0.1
@export var max_scale_multiplier: float = 5.0

var initial_scale: Vector3
var increasing_size: bool = true


func _ready() -> void:
	initial_scale = hint_hack_circle_mesh.scale

	reapply_size_timer.timeout.connect(
		_handle_reapply_size_timer_timeout
	)

	hint_hack_circle_mesh.visible = false


func _handle_reapply_size_timer_timeout() -> void:
	var max_scale: Vector3 = (
		initial_scale * max_scale_multiplier
	)

	if increasing_size:
		hint_hack_circle_mesh.scale += (
			initial_scale * scale_gain
		)

		if hint_hack_circle_mesh.scale.x >= max_scale.x:
			hint_hack_circle_mesh.scale = max_scale
			increasing_size = false

	else:
		hint_hack_circle_mesh.scale -= (
			initial_scale * scale_gain
		)

		if hint_hack_circle_mesh.scale.x <= initial_scale.x:
			hint_hack_circle_mesh.scale = initial_scale
			increasing_size = true


func _start() -> void:
	reset_circle_size()

	hint_hack_circle_mesh.visible = true
	reapply_size_timer.start()


func _stop() -> void:
	reapply_size_timer.stop()

	reset_circle_size()
	hint_hack_circle_mesh.visible = false


func reset_circle_size() -> void:
	increasing_size = true
	hint_hack_circle_mesh.scale = initial_scale
