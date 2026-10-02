extends Node

@onready var confirm_btn_mesh: MeshInstance3D = $"../../ConfirmDenyBtns/ConfirmBtn/MeshInstance3D"
@onready var deny_btn_mesh: MeshInstance3D = $"../../ConfirmDenyBtns/DenyBtn/MeshInstance3D"

const CONFIRM_BTN_AVAILABLE_COLOR: Color = Color("#43a123")
const CONFIRM_BTN_UNAVAILABLE_COLOR: Color = Color("#8aa182")

const DENY_BTN_AVAILABLE_COLOR: Color = Color("#a12020")
const DENY_BTN_UNAVAILABLE_COLOR: Color = Color("#a18282")

var confirm_btn_material: StandardMaterial3D
var deny_btn_material: StandardMaterial3D


func _ready() -> void:
	
	# duplicate materials so changes only affect these buttons
	confirm_btn_material = (
		confirm_btn_mesh.get_active_material(0).duplicate()
	)
	
	deny_btn_material = (
		deny_btn_mesh.get_active_material(0).duplicate()
	)
	
	confirm_btn_mesh.set_surface_override_material(
		0,
		confirm_btn_material
	)
	
	deny_btn_mesh.set_surface_override_material(
		0,
		deny_btn_material
	)


#func _process(_delta: float) -> void:
	#
	## DEBUG - available
	#if Input.is_action_just_pressed("debug1"):
		#_toggle_available(true)
	#
	## DEBUG - unavailable
	#if Input.is_action_just_pressed("debug2"):
		#_toggle_available(false)


func _toggle_available(toggle_value: bool) -> void:
	
	if toggle_value:
		
		confirm_btn_material.albedo_color = (
			CONFIRM_BTN_AVAILABLE_COLOR
		)
		
		deny_btn_material.albedo_color = (
			DENY_BTN_AVAILABLE_COLOR
		)
	
	else:
		
		confirm_btn_material.albedo_color = (
			CONFIRM_BTN_UNAVAILABLE_COLOR
		)
		
		deny_btn_material.albedo_color = (
			DENY_BTN_UNAVAILABLE_COLOR
		)
