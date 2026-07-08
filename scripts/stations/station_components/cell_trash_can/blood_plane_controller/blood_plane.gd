extends MeshInstance3D

@export var speed: float = 0.25
@export var direction_change_time: float = 0.6
@export var direction_smoothness: float = 4.0

var current_velocity: Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO
var direction_timer: float = 0.0

var mat: StandardMaterial3D


func _ready() -> void:
	mat = get_surface_override_material(0)
	
	if mat:
		mat = mat.duplicate()
		set_surface_override_material(0, mat)
	
	_pick_new_direction()


func _process(delta: float) -> void:
	if not mat:
		return
	
	direction_timer -= delta
	
	if direction_timer <= 0.0:
		_pick_new_direction()
	
	current_velocity = current_velocity.lerp(
		target_velocity,
		delta * direction_smoothness
	)
	
	mat.uv1_offset.x += current_velocity.x * delta
	mat.uv1_offset.y += current_velocity.y * delta
	
	mat.uv1_offset.x = wrapf(mat.uv1_offset.x, 0.0, 1.0)
	mat.uv1_offset.y = wrapf(mat.uv1_offset.y, 0.0, 1.0)


func _pick_new_direction() -> void:
	direction_timer = direction_change_time
	
	target_velocity = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized() * speed
