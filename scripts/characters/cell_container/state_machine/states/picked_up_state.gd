extends Node



# components
@onready var stat_display : Node3D = $"../../StatDisplay"
@onready var parent_cell_container : CharacterBody3D = $"../.."
var player_ray_cast : RayCast3D

func state_start() -> void :
	# hide stat display
	stat_display.visible = false
	
func state_process(_delta) -> void:
	
	
	# move with raycast
	if player_ray_cast:
		var origin = player_ray_cast.global_transform.origin
		var direction = -player_ray_cast.global_transform.basis.z.normalized()
		var target_pos = origin + direction * 2.0

		var to_target = target_pos - parent_cell_container.global_position
		var distance = to_target.length()

		if distance > 0.05:
			var speed = clamp(distance * 20.0, 0.0, 30.0)
			parent_cell_container.velocity = to_target.normalized() * speed
		else:
			parent_cell_container.velocity = Vector3.ZERO

		parent_cell_container.move_and_slide()
		
func state_end() -> void :
	
	parent_cell_container.velocity = Vector3.ZERO
	parent_cell_container.move_and_slide()
	
	# show stat display
	stat_display.visible = true 
	
	# reset ray cast
	player_ray_cast = null
