extends Node

@onready var left_button_increase_mesh: MeshInstance3D = $"../../ChargeSeats/LeftSeat/ControlPanel/Direction/Increase/MeshInstance3D"
@onready var left_button_decrease_mesh: MeshInstance3D = $"../../ChargeSeats/LeftSeat/ControlPanel/Direction/Decrease/MeshInstance3D"

@onready var right_button_increase_mesh: MeshInstance3D = $"../../ChargeSeats/RightSeat/ControlPanel/Direction/Increase/MeshInstance3D"
@onready var right_button_decrease_mesh: MeshInstance3D = $"../../ChargeSeats/RightSeat/ControlPanel/Direction/Decrease/MeshInstance3D"

var inaccessible_color: Color = Color.html("#707060")
var unselected_color: Color = Color.html("#e0e0c1")
var selected_color: Color = Color.BLUE


func _ready() -> void:
	_make_unique_material(left_button_increase_mesh)
	_make_unique_material(left_button_decrease_mesh)
	_make_unique_material(right_button_increase_mesh)
	_make_unique_material(right_button_decrease_mesh)
	
	_update()


func _update() -> void:
	var left_buttons_inaccessible: bool = get_parent().left_buttons_inaccessible
	var right_buttons_inaccessible: bool = get_parent().right_buttons_inaccessible
	
	var left_side_direction: String = get_parent().left_side_direction
	var right_side_direction: String = get_parent().right_side_direction
	
	_update_side_buttons(
		left_buttons_inaccessible,
		left_side_direction,
		left_button_increase_mesh,
		left_button_decrease_mesh
	)
	
	_update_side_buttons(
		right_buttons_inaccessible,
		right_side_direction,
		right_button_increase_mesh,
		right_button_decrease_mesh
	)


func _update_side_buttons(
	buttons_inaccessible: bool,
	side_direction: String,
	increase_mesh: MeshInstance3D,
	decrease_mesh: MeshInstance3D
) -> void:
	if buttons_inaccessible:
		_set_mesh_color(increase_mesh, inaccessible_color)
		_set_mesh_color(decrease_mesh, inaccessible_color)
		return
	
	match side_direction:
		"increase":
			_set_mesh_color(increase_mesh, selected_color)
			_set_mesh_color(decrease_mesh, unselected_color)
		
		"decrease":
			_set_mesh_color(increase_mesh, unselected_color)
			_set_mesh_color(decrease_mesh, selected_color)
		
		"none":
			_set_mesh_color(increase_mesh, unselected_color)
			_set_mesh_color(decrease_mesh, unselected_color)
		
		_:
			push_error("Invalid side_direction: " + side_direction)
			_set_mesh_color(increase_mesh, unselected_color)
			_set_mesh_color(decrease_mesh, unselected_color)


func _make_unique_material(mesh_instance: MeshInstance3D) -> void:
	var material := mesh_instance.get_active_material(0)
	
	if material:
		mesh_instance.material_override = material.duplicate()
	else:
		mesh_instance.material_override = StandardMaterial3D.new()


func _set_mesh_color(mesh_instance: MeshInstance3D, color: Color) -> void:
	var material := mesh_instance.material_override as StandardMaterial3D
	
	if not material:
		material = StandardMaterial3D.new()
		mesh_instance.material_override = material
	
	material.albedo_color = color
