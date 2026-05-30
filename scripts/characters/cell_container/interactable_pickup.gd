extends InteractablePickup 

# components
@onready var cell_container_parent : CharacterBody3D = $".."

func _on_pickup_interacted(player_ray_cast : RayCast3D):
	
	if cell_container_parent.state_machine.curr_state.name == 'Froze' : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	# handle pickup end
	if cell_container_parent.state_machine.curr_state.name == 'PickedUp' : 
		if not player_ray_cast:
			cell_container_parent.switch_cell_state('idle')
	
	# handle pickup
	if player_ray_cast : 	
		cell_container_parent.switch_cell_state('picked_up', player_ray_cast)
	
