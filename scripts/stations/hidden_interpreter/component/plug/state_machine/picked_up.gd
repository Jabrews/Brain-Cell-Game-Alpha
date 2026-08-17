extends Node

# components
@onready var parent_plug: RigidBody3D = $"../.."

var player_ray_cast: RayCast3D


func state_start() -> void:
	parent_plug.freeze = false
	parent_plug.gravity_scale = 0.0
	
	parent_plug._toggle_parent_station_plug_status('out') 
	


func state_process(_delta: float) -> void:
	if not player_ray_cast:
		return

	var origin: Vector3 = player_ray_cast.global_position
	var direction: Vector3 = -player_ray_cast.global_basis.z.normalized()

	var target_pos: Vector3 = origin + direction * 2.0

	var to_target: Vector3 = target_pos - parent_plug.global_position
	var distance: float = to_target.length()

	if distance > 0.05:
		var speed: float = clamp(
			distance * 20.0,
			0.0,
			30.0
		)

		parent_plug.linear_velocity = (
			to_target.normalized() * speed
		)

	else:
		parent_plug.linear_velocity = Vector3.ZERO


func state_end() -> void:
	parent_plug.linear_velocity = Vector3.ZERO
	parent_plug.angular_velocity = Vector3.ZERO

	player_ray_cast = null
