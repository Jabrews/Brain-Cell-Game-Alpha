extends Node

@onready var light_mesh: MeshInstance3D = $LightMesh
@onready var light: SpotLight3D = $Light

var on_color: Color = Color.RED
var off_color: Color = Color.WHITE

var flash_tween: Tween
var wanted_light_energy: float = 1.0


func _toggle_light(toggle_value: bool) -> void:
	_stop_flash()

	if toggle_value:
		light.visible = true
		light.light_color = on_color
		light.light_energy = wanted_light_energy
		_set_mesh_color(on_color)
	else:
		light.visible = false
		light.light_energy = 0.0
		_set_mesh_color(off_color)


func _flash_lights(toggle_value: bool) -> void:
	_stop_flash()

	if not toggle_value:
		light.visible = false
		light.light_energy = 0.0
		_set_mesh_color(off_color)
		return

	light.visible = true
	light.light_color = on_color

	flash_tween = create_tween()
	flash_tween.set_loops()

	flash_tween.tween_method(
		func(value: float):
			light.light_energy = value * wanted_light_energy
			_set_mesh_color(off_color.lerp(on_color, value)),
		0.0,
		1.0,
		0.5
	)

	flash_tween.tween_method(
		func(value: float):
			light.light_energy = value * wanted_light_energy
			_set_mesh_color(off_color.lerp(on_color, value)),
		1.0,
		0.0,
		0.5
	)


func _stop_flash() -> void:
	if flash_tween:
		flash_tween.kill()
		flash_tween = null


func _set_mesh_color(color: Color) -> void:
	var material := light_mesh.get_active_material(0)

	if material is StandardMaterial3D:
		material.albedo_color = color
