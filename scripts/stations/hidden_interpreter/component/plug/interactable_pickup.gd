extends InteractablePickup 

# components
@onready var plug_parent : RigidBody3D = $".."

func _on_pickup_interacted(player_ray_cast : RayCast3D):
	
	# handle pickup end
	if plug_parent.state_machine.curr_state.name == 'PickedUp' : 
		if not player_ray_cast:
			plug_parent.state_machine.switch_state(plug_parent.state_machine.State.IDLE)
			plug_parent.state_machine.picked_up_state.player_ray_cast = player_ray_cast
			
			
	# handle pickup from idle
	if plug_parent.state_machine.curr_state.name == 'Idle' : 
		if player_ray_cast : 	
			plug_parent.state_machine.switch_state(plug_parent.state_machine.State.PICKED_UP)
			plug_parent.state_machine.picked_up_state.player_ray_cast = player_ray_cast
	
	if plug_parent.state_machine.curr_state.name == 'PluggedIn' : 
		if player_ray_cast : 	
			plug_parent.state_machine.switch_state(plug_parent.state_machine.State.PICKED_UP)
			plug_parent.state_machine.picked_up_state.player_ray_cast = player_ray_cast
			
	
