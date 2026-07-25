extends RayCast3D 


# parent component
@onready var raycast_manager : Node3D = $".."

@export var ray_cast_direction : Vector3
@export var ray_cast_type : String 





func _process(_delta: float) -> void: 
	
	match raycast_manager.raycast_state  :
		'none': 
			return
		'search' : 
			if is_colliding(): 
				raycast_manager.raycasts_detecting_collision[ray_cast_type] = true
			else : 
				raycast_manager.raycasts_detecting_collision[ray_cast_type] = false 
		'fly' :
			if is_colliding(): 
				raycast_manager.handle_raycast_detected_wall_during_fly()
				
				
			
				
	
