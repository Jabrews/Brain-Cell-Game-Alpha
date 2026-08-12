extends StaticBody3D

class_name InteractablePickup

func _ready() -> void:
	set_collision_layer_value(6, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	add_to_group('interactable')

func handle_pickup_interacted(player_ray_cast : RayCast3D):
	_on_pickup_interacted(player_ray_cast)

# over-ride this method on the buttons script
@warning_ignore("unused_parameter")
func _on_pickup_interacted(player_ray_cast : RayCast3D):
	pass
