extends Node

@onready var left_button_increase_mesh: MeshInstance3D =$"../../../ChargeSeats/ChargeSeatLeft/ControlPanel/Direction/Increase/MeshInstance3D"
@onready var left_button_decrease_mesh: MeshInstance3D = $"../../../ChargeSeats/ChargeSeatLeft/ControlPanel/Direction/Decrease/MeshInstance3D"

@onready var right_button_increase_mesh: MeshInstance3D =$"../../../ChargeSeats/ChargeSeatRight/ControlPanel/Direction/Increase/MeshInstance3D"
@onready var right_button_decrease_mesh: MeshInstance3D =$"../../../ChargeSeats/ChargeSeatRight/ControlPanel/Direction/Decrease/MeshInstance3D"

var inaccessible_color: Color = Color.html("#707060")
var unselected_color: Color = Color.html("#e0e0c1")
var selected_color: Color = Color.BLUE


func _ready() -> void:
	_make_unique_material(left_button_increase_mesh)
	_make_unique_material(left_button_decrease_mesh)
	_make_unique_material(right_button_increase_mesh)
	_make_unique_material(right_button_decrease_mesh)


func _update_btn_pressed(side: String, direction: String, toggle_value: bool) -> void:
	var increase_mesh: MeshInstance3D
	var decrease_mesh: MeshInstance3D
	
	match side:
		"left":
			increase_mesh = left_button_increase_mesh
			decrease_mesh = left_button_decrease_mesh
		"right":
			increase_mesh = right_button_increase_mesh
			decrease_mesh = right_button_decrease_mesh
	
	# If toggled off, unselect both buttons for that side.
	if not toggle_value:
		_set_mesh_color(increase_mesh, unselected_color)
		_set_mesh_color(decrease_mesh, unselected_color)
		return
	
	# If toggled on, select one and unselect the other.
	match direction:
		"increase":
			_set_mesh_color(increase_mesh, selected_color)
			_set_mesh_color(decrease_mesh, unselected_color)
		"decrease":
			_set_mesh_color(increase_mesh, unselected_color)
			_set_mesh_color(decrease_mesh, selected_color)
			
func _set_innaccessible(side : String):
	
	var increase_mesh : MeshInstance3D
	var decrease_mesh : MeshInstance3D
	
	match side : 
		'left' :
			increase_mesh = left_button_increase_mesh
			decrease_mesh = left_button_decrease_mesh
		'right' :		
			increase_mesh = right_button_increase_mesh 
			decrease_mesh = right_button_decrease_mesh
			
	_set_mesh_color(increase_mesh, inaccessible_color)
	_set_mesh_color(decrease_mesh, inaccessible_color)
	
func _set_unselected(side : String) :

	var increase_mesh : MeshInstance3D
	var decrease_mesh : MeshInstance3D
	
	match side : 
		'left' :
			increase_mesh = left_button_increase_mesh
			decrease_mesh = left_button_decrease_mesh
		'right' :		
			increase_mesh = right_button_increase_mesh 
			decrease_mesh = right_button_decrease_mesh
			
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
