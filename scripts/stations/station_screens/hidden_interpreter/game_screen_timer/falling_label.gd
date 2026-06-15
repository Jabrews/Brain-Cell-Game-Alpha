
extends RigidBody2D


# componetns
@onready var falling_label : Label = $FallingLabelText

@export var start_gravity: float = 0.05
@export var max_gravity: float = 3.0
@export var gravity_increase_speed: float = 0.3

@export var shake_amount: float = 10
@export var shake_speed: float = 10.0

var shake_time: float = 0.0
var base_x: float


func _ready() -> void:
	gravity_scale = start_gravity
	base_x = position.x

	await get_tree().create_timer(1.7).timeout
	queue_free()


func load_text(point_amount: int) -> void:
	falling_label.text = "-" + str(point_amount)

	if point_amount < 3:
		falling_label.modulate = Color.WHITE

	elif point_amount >= 3 and point_amount < 5:
		falling_label.modulate = Color.YELLOW

	else:
		falling_label.modulate = Color.RED


func _process(delta: float) -> void:
	# Slowly increase fall speed over time
	gravity_scale = min(
		gravity_scale + gravity_increase_speed * delta,
		max_gravity
	)

	# Slight shake left and right
	shake_time += delta * shake_speed
	position.x = base_x + sin(shake_time) * shake_amount
