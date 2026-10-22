extends Node

@onready var tablet_holder_pole: StaticBody3D = \
	$"../../../../../OfferTablet/Poles/TabletHolderPole"
@onready var component_controllers: Node = $".."

var pole_follow: bool = false
var player_reference: CharacterBody3D
var original_global_basis: Basis


func _ready() -> void:
	original_global_basis = tablet_holder_pole.global_basis


func _toggle(toggle_value: bool) -> void:
	if pole_follow == toggle_value:
		return

	pole_follow = toggle_value

	if toggle_value:
		player_reference = GLPlayerState.player_refrence
		await get_tree().create_timer(0.5).timeout
		GLPrisonerProfilerComponentsBus.emit_signal("play_sound", "tablet_start")
	else:
		tablet_holder_pole.global_basis = original_global_basis
		player_reference = null


func _process(delta: float) -> void:
	if not pole_follow or not is_instance_valid(player_reference):
		return

	var target_position: Vector3 = player_reference.global_position + Vector3.UP * 2.0
	var target_basis: Basis = tablet_holder_pole.global_transform \
		.looking_at(target_position, Vector3.UP) \
		.basis.orthonormalized()

	var current_basis: Basis = tablet_holder_pole.global_basis.orthonormalized()
	var current_rotation: Quaternion = current_basis.get_rotation_quaternion()
	var target_rotation: Quaternion = target_basis.get_rotation_quaternion()

	var angle: float = current_rotation.angle_to(target_rotation)
	if angle <= 0.001:
		return

	var turn_amount: float = deg_to_rad(component_controllers.POLE_FOLLOW_SPEED) * delta
	var weight: float = minf(1.0, turn_amount / angle)
	var new_rotation: Quaternion = current_rotation.slerp(target_rotation, weight)

	var scale: Vector3 = tablet_holder_pole.global_basis.get_scale()
	tablet_holder_pole.global_basis = Basis(new_rotation).scaled(scale)
