extends Node3D

# components
@onready var parent_hidden_interpreter: Node3D = $".."
@onready var start_point_mesh: MeshInstance3D = $StartPointMesh

@export var segment_count: int = 20
@export var cord_radius: float = 0.05

var start_point: Node3D
var end_point: Node3D

var segments: Array[MeshInstance3D] = []


func _ready() -> void:
	
	await get_tree().physics_frame
	
	start_point = start_point_mesh
	end_point = parent_hidden_interpreter.plug

	_create_segments()


func _process(_delta: float) -> void:
	if end_point == null:
		return

	_update_cord()


func _create_segments() -> void:
	for i in segment_count:
		var mesh := MeshInstance3D.new()

		var cylinder := CylinderMesh.new()
		cylinder.top_radius = cord_radius
		cylinder.bottom_radius = cord_radius

		mesh.mesh = cylinder

		add_child(mesh)
		segments.append(mesh)


func _update_cord() -> void:
	var start := start_point.global_position
	var end := end_point.global_position

	for i in segment_count:
		var t1 := float(i) / segment_count
		var t2 := float(i + 1) / segment_count

		var p1 := start.lerp(end, t1)
		var p2 := start.lerp(end, t2)

		_position_segment(
			segments[i],
			p1,
			p2
		)


func _position_segment(
	segment: MeshInstance3D,
	a: Vector3,
	b: Vector3
) -> void:

	var center := (a + b) * 0.5
	var direction := b - a

	segment.global_position = center

	var cylinder := segment.mesh as CylinderMesh
	cylinder.height = direction.length()

	segment.look_at(b, Vector3.UP)
	segment.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
