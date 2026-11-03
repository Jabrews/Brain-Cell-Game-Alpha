extends Node3D


# components
@onready var sprite: Sprite3D = $Sprite3D
@onready var t_increase_5 : Texture = preload("res://models/workstations/defect_scraps_ui/increase_defect_scrap_5.png")
@onready var t_increase_10 : Texture = preload("res://models/workstations/defect_scraps_ui/increase_defect_scrap_10.png")
@onready var t_increase_15 : Texture = preload("res://models/workstations/defect_scraps_ui/increase_defect_scrap_15.png")

@export var time_alive: float = 5.0
const FLOAT_DISTANCE: float = 1.0
const FADE_START_PERCENT: float = 1.0


func start(increase_amount : int) -> void:
	
	match increase_amount : 
		5 : 
			sprite.texture = t_increase_5
		10 : 
			sprite.texture = t_increase_10 
		15 : 
			sprite.texture = t_increase_15
	
	
	var start_position: Vector3 = global_position
	var end_position: Vector3 = start_position + Vector3(0.0, FLOAT_DISTANCE, 0.0)

	var fade_start_time: float = time_alive * FADE_START_PERCENT
	var fade_duration: float = time_alive - fade_start_time

	var move_tween: Tween = create_tween()
	move_tween.tween_property(self, "global_position", end_position, time_alive)

	var fade_tween: Tween = create_tween()
	fade_tween.tween_interval(fade_start_time)

	if sprite:
		fade_tween.tween_property(sprite, "modulate:a", 0.0, fade_duration)

	fade_tween.tween_callback(queue_free)
