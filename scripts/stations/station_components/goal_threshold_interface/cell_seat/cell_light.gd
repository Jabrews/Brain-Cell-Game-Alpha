extends Node

@export var inital_light_stat : String = 'inactive'

# Components
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var light: SpotLight3D = $SpotLight3D


var seat_unfilled : Color = Color.RED
var seat_filled : Color = Color.GREEN
var seat_inactive : Color = Color.WHITE

func _ready() -> void:
	_switch_light_state(inital_light_stat)



func _switch_light_state(state: String) -> void:

	match state:

		"seat_filled":
			light.light_color = seat_filled
			light.light_energy = 1.0
			_set_mesh_color(seat_filled)

		"seat_unfilled":
			light.light_color = seat_unfilled
			light.light_energy = 1.0
			_set_mesh_color(seat_unfilled)

		"inactive":
			light.light_color = seat_inactive
			light.light_energy = 0.0
			_set_mesh_color(seat_inactive)

		_:
			push_error("Unknown seat light state: " + state)


func _set_mesh_color(color: Color) -> void:

	var material := StandardMaterial3D.new()
	material.albedo_color = color

	mesh.material_override = material
