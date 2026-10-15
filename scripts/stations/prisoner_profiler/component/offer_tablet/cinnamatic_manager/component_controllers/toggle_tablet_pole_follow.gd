extends Node

@onready var tablet_holder_pole : StaticBody3D = $"../../../../../OfferTablet/Poles/TabletHolderPole"
@onready var component_controllers: Node = $".."

var pole_follow : bool = false
var player_refrence : CharacterBody3D

func _toggle(toggle_value : bool) :
	
	if pole_follow == toggle_value :
		return
	
	pole_follow = toggle_value
	
	if toggle_value :
		player_refrence = GLPlayerState.player_refrence
		
		await get_tree().create_timer(0.5).timeout
	
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'tablet_start')
		

func _process(delta: float) -> void:
	if not pole_follow or not player_refrence:
		return

	var target_transform := tablet_holder_pole.global_transform.looking_at(
		player_refrence.global_position + Vector3(0, 2, 0),
		Vector3.UP
	)
	var target_rotation: Quaternion = target_transform.basis.get_rotation_quaternion()
	var current_rotation: Quaternion = tablet_holder_pole.global_basis.get_rotation_quaternion()

	var angle := current_rotation.angle_to(target_rotation)
	if angle > 0.001:
		var turn_amount := deg_to_rad(component_controllers.POLE_FOLLOW_SPEED) * delta
		var weight := minf(1.0, turn_amount / angle)

		tablet_holder_pole.global_basis = Basis(
			current_rotation.slerp(target_rotation, weight)
		)
