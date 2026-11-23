extends RayCast3D 

# componnets
@onready var ray_cast_controller_parent : Node3D = $".."

func _process(_delta):
	
	var collider = get_collider()
	
	if collider : 
		if collider.is_in_group('axe_mount') : 
			GLPlayerState.emit_signal('toggle_player_looking_at_axe_mount', true)
	else : 
		GLPlayerState.emit_signal('toggle_player_looking_at_axe_mount', false)
	

	if not Input.is_action_just_pressed('interact'):
		return
	

		
	if not  collider :	
		return
	
	if not collider.is_in_group('axe_mount'):
		return
	else :
		collider.on_axe_interacted()
