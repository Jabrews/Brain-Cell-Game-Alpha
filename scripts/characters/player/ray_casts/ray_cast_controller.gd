extends Node

var interact_ray_active : bool = false
var usable_item_ray_active : bool = false

# componnets 
@onready var interact_ray : RayCast3D = $InteractRay
@onready var usable_item_ray : RayCast3D = $UseableItemRay


func set_ray_mode(mode: String) -> void:
	
	match mode:
		"interact":
			interact_ray_active = true
			usable_item_ray_active = false
		
		"useable":
			interact_ray_active = false
			usable_item_ray_active = true
		
		"none":
			interact_ray_active = true 
			usable_item_ray_active = true 
		
		_:
			push_error("invalid ray mode: " + mode)
	
	update_rays()

func update_rays() -> void:
	interact_ray.enabled = interact_ray_active
	usable_item_ray.enabled = usable_item_ray_active
