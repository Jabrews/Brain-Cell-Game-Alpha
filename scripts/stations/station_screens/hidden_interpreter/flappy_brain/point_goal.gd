extends Node2D

var point_amount: int = 0

@export var base_shake_amount: float = 1.5
@export var shake_duration: float = 1.5

@onready var visual: ColorRect = $ColorRect

var base_position: Vector2
var shake_amount: float = 0.0
var shake_tween: Tween


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	update_visual_from_points()
	
	base_position = position
	start_shake()


func update_visual_from_points() -> void:
	
	if point_amount <= 2:
		visual.color = Color.WHITE
	elif point_amount <= 4:
		visual.color = Color.YELLOW
	else:
		visual.color = Color.RED
		
	# 1 = light shake, 5 = stronger but still small
	shake_amount = base_shake_amount * float(point_amount)


func start_shake() -> void:
	if shake_tween:
		shake_tween.kill()

	shake_tween = create_tween()
	shake_tween.set_loops()

	shake_tween.tween_property(
		self,
		"position",
		base_position + Vector2(shake_amount, 0.0),
		shake_duration
	)

	shake_tween.tween_property(
		self,
		"position",
		base_position + Vector2(-shake_amount, 0.0),
		shake_duration
	)

	shake_tween.tween_property(
		self,
		"position",
		base_position,
		shake_duration
	)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GLInterpreterGames.emit_signal("brain_collected_points", point_amount)
		queue_free()
