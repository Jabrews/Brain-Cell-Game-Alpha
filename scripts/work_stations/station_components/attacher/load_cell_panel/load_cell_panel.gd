extends Area3D

# components
@onready var station_attacher : Node3D = $"../.."


func _ready() -> void:
	connect('body_entered', _handle_body_entered)
	connect('body_exited', _handle_body_exited)

func _handle_body_entered(body : Node3D) :
	if not station_attacher.enabled : 
		return
	
	if body.is_in_group('brain_cell_container') : 
		
		# prevent over-riding
		if station_attacher.loaded_cell_container :
			return 
		
		else : 
			station_attacher._recieve_cell_container(body)
	
func _handle_body_exited(body : Node3D) :
	
	if not station_attacher.enabled : 
		return
	
	if body.is_in_group('brain_cell_container') : 
		
		if station_attacher.loaded_cell_container == body : 	
			station_attacher._removed_cell_container(body)
