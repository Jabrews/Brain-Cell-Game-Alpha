extends Node

# components
@onready var parent_cell_container : CharacterBody3D = $".."
@onready var boost_wanted_mesh : MeshInstance3D = $BoostWanted
@onready var main_wanted_mesh : MeshInstance3D = $MainWanted

var flash_tween : Tween

# percentage opacity
var finale_mat_albedo_transparency : float = 50.0
var finale_next_pass_albedo_transparency : float = 75.0


func _ready() -> void:
	
	GLBreedingComponetsBus.connect(
		"toggle_wanted_highlight",
		_handle_toggle_wanted_highlight
	)
	
	_make_material_unique(boost_wanted_mesh)
	_make_material_unique(main_wanted_mesh)
	
	_reset_highlight()


func _reset_highlight() -> void:
	
	if flash_tween:
		flash_tween.kill()
	
	_set_flash_opacity(boost_wanted_mesh, 0.0)
	_set_flash_opacity(main_wanted_mesh, 0.0)
	
	boost_wanted_mesh.visible = false
	main_wanted_mesh.visible = false


func _handle_toggle_wanted_highlight(
	toggle_value : bool,
	cell_name : String,
	highlight_type : String
) -> void:
	
	var parent_cell_name : String = (
		parent_cell_container.designated_brain_cell.name
	)
	
	if cell_name != parent_cell_name:
		return
	
	_reset_highlight()
	
	if not toggle_value:
		return
	
	match highlight_type:
		
		"main":
			main_wanted_mesh.visible = true
			_play_flash_tween(main_wanted_mesh)
		
		"boost":
			boost_wanted_mesh.visible = true
			_play_flash_tween(boost_wanted_mesh)


func _play_flash_tween(selected_mesh : MeshInstance3D) -> void:
	
	_set_flash_opacity(selected_mesh, 0.0)
	
	flash_tween = create_tween()
	flash_tween.set_loops()
	
	flash_tween.tween_method(
		func(value : float):
			_set_flash_opacity(selected_mesh, value),
		0.0,
		1.0,
		1.0
	)
	
	flash_tween.tween_method(
		func(value : float):
			_set_flash_opacity(selected_mesh, value),
		1.0,
		0.0,
		1.0
	)


func _set_flash_opacity(mesh_instance : MeshInstance3D, value : float) -> void:
	
	var material := mesh_instance.get_active_material(0) as StandardMaterial3D
	
	if not material:
		return
	
	# base material
	var base_color : Color = material.albedo_color
	base_color.a = value * (finale_mat_albedo_transparency / 100.0)
	material.albedo_color = base_color
	
	# next pass material
	var next_material := material.next_pass as StandardMaterial3D
	
	if next_material:
		var next_color : Color = next_material.albedo_color
		next_color.a = value * (finale_next_pass_albedo_transparency / 100.0)
		next_material.albedo_color = next_color


func _make_material_unique(mesh_instance : MeshInstance3D) -> void:
	
	var original_material := (
		mesh_instance.get_active_material(0) as StandardMaterial3D
	)
	
	if not original_material:
		push_error("Wanted highlight has no StandardMaterial3D")
		return
	
	var new_material := original_material.duplicate() as StandardMaterial3D
	
	# Next Pass also needs its own copy
	if new_material.next_pass:
		new_material.next_pass = new_material.next_pass.duplicate()
	
	mesh_instance.set_surface_override_material(
		0,
		new_material
	)
