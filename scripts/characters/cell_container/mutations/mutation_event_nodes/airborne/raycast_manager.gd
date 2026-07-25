extends Node


var raycast_state : String = 'none'

@onready var raycasts: Array[RayCast3D] = [
	$FlyDetectRaycast,
	$FlyDetectRaycast2,
	$FlyDetectRaycast3,
	$FlyDetectRaycast4
]
@onready var upward_detect_raycast : RayCast3D = $UpwardDetectRaycast
@onready var parent_airborne_mutation : Node3D = $".."

var raycasts_detecting_collision : Dictionary = {
	'+x' : false,
	'-x' : false,
	'+z' : false,
	'-z' : false,
}

func switch_raycast_state(new_state : String) :
	
	raycast_state = new_state
	
	set_raycasts_size(new_state)	
	set_raycasts_enabled(new_state)

	

func set_raycasts_size(new_state : String) : 
	
	var target_position : Vector3
	
	match new_state : 	
		'none': 
			target_position = Vector3(0.0, 0.0, 0.0)
		'fly' : 
			target_position = Vector3(1.00, 0.5, 0.0)
		'search' :
			target_position = Vector3(1.485, 2.0, 0.0)
	
	for raycast : RayCast3D in raycasts: 
		raycast.target_position = target_position
	

func set_raycasts_enabled(new_state : String) : 
	
	for raycast : RayCast3D in raycasts: 
		raycast.enabled = false 
	
	match new_state : 
		'none': 
			return
		'fly' : 
			await get_tree().create_timer(0.2).timeout
			for raycast : RayCast3D in raycasts: 
				raycast.enabled = true 
			upward_detect_raycast.enabled = true
		'search' :
			for raycast : RayCast3D in raycasts: 
				raycast.enabled = true
				
				
func raycast_key_to_direction(raycast_key : String) -> Vector3 :
	match raycast_key : 
		'+x' :
			return raycasts[0].ray_cast_direction
		'-x' :
			return raycasts[1].ray_cast_direction
		'+z' :
			return raycasts[3].ray_cast_direction
		'-z' :
			return raycasts[2].ray_cast_direction
		_ : 
			push_error('non valid raycast found : ', raycast_key)
			return Vector3(0.0, 0.0, 0.0)
		
func handle_raycast_detected_wall_during_fly() :
	parent_airborne_mutation.handle_flight_interrupted()
		
	



	
