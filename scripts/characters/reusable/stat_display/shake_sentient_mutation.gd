extends Node

var shaking_tween: Tween
var flashing_tween: Tween

var starting_position: Vector3
var mutation_mesh_tv_instance: MeshInstance3D

var flash_material: StandardMaterial3D
var previous_overlay_material: Material


func _toggle_sentient_shake(
	toggle_value: bool,
	tv_instance: MeshInstance3D = null
) -> void:
	_stop_sentient_effect()

	if not toggle_value:
		return

	if not is_instance_valid(tv_instance):
		return

	mutation_mesh_tv_instance = tv_instance
	starting_position = mutation_mesh_tv_instance.position

	_create_flash_material()
	_start_shaking()
	_start_flashing()


func _create_flash_material() -> void:
	previous_overlay_material = mutation_mesh_tv_instance.material_overlay

	flash_material = StandardMaterial3D.new()
	flash_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	flash_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	# Start completely transparent.
	flash_material.albedo_color = Color(1.0, 1.0, 1.0, 0.0)

	flash_material.emission_enabled = true
	flash_material.emission = Color.WHITE
	flash_material.emission_energy_multiplier = 2.0

	mutation_mesh_tv_instance.material_overlay = flash_material


func _start_shaking() -> void:
	shaking_tween = create_tween()
	shaking_tween.set_loops()

	shaking_tween.tween_property(
		mutation_mesh_tv_instance,
		"position",
		starting_position + Vector3(0.0, 0.03, 0.0),
		0.08
	)

	shaking_tween.tween_property(
		mutation_mesh_tv_instance,
		"position",
		starting_position + Vector3(0.02, 0.0, 0.0),
		0.05
	)

	shaking_tween.tween_property(
		mutation_mesh_tv_instance,
		"position",
		starting_position + Vector3(-0.02, 0.01, 0.0),
		0.05
	)

	shaking_tween.tween_property(
		mutation_mesh_tv_instance,
		"position",
		starting_position,
		0.08
	)


func _start_flashing() -> void:
	flashing_tween = create_tween()
	flashing_tween.set_loops()

	# Delay between flashes.
	flashing_tween.tween_interval(0.15)

	# Quickly become white.
	flashing_tween.tween_property(
		flash_material,
		"albedo_color",
		Color(1.0, 1.0, 1.0, 1.0),
		0.03
	)

	# Stay white briefly.
	flashing_tween.tween_interval(0.04)

	# Return to normal.
	flashing_tween.tween_property(
		flash_material,
		"albedo_color",
		Color(1.0, 1.0, 1.0, 0.0),
		0.05
	)

	flashing_tween.tween_interval(0.18)


func _stop_sentient_effect() -> void:
	if shaking_tween:
		shaking_tween.kill()
		shaking_tween = null

	if flashing_tween:
		flashing_tween.kill()
		flashing_tween = null

	if is_instance_valid(mutation_mesh_tv_instance):
		mutation_mesh_tv_instance.position = starting_position

		# Restore whatever overlay it had before.
		mutation_mesh_tv_instance.material_overlay = previous_overlay_material

	mutation_mesh_tv_instance = null
	flash_material = null
	previous_overlay_material = null
