extends Area3D

# components
@onready var station_detacher : Node3D = $"../.."


func _ready() -> void:
	connect('body_entered', _handle_body_entered)
	connect('body_exited', _handle_body_exited)

func _handle_body_entered(body : Node3D) : 
	
	if not station_detacher.enabled : 
		return
	
	if body.is_in_group('brain_cell_container') : 
		
		# prevent over-riding
		if station_detacher.loaded_cell_container :
			return 
		
		else : 
			station_detacher._recieve_cell_container(body)
		
		
	

func _handle_body_exited(body : Node3D) : 
	
	if not station_detacher.enabled : 
		return
	
	if body.is_in_group('brain_cell_container') : 
		
		if station_detacher.loaded_cell_container == body : 	
			station_detacher._removed_cell_container(body)
	
