extends InteractablePickup 

# components
@onready var cell_container_parent : CharacterBody3D = $".."
@onready var hoverable_mesh : StaticBody3D = $"../HoverableMesh"
@onready var stat_display_area : Area3D = $"../StatDisplay/StatDisplayArea"

func _ready() -> void:
	is_cell_container = true
	
	GLCellManagerBus.connect('toggle_lock_cell_pickup', _handle_toggle_lock_cell_pickup)

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
	

func _handle_toggle_lock_cell_pickup(cell_name : String, toggle_value : bool) :
	if cell_name == cell_container_parent.designated_brain_cell.name : 
		
		# if locking, get rid of layer
		
		set_collision_layer_value(6, !toggle_value)
		hoverable_mesh.set_collision_layer_value(5, !toggle_value)
		stat_display_area.set_collision_layer_value(7, !toggle_value)
		
		
		if toggle_value : 	
			cell_container_parent.switch_cell_state('idle')
			stat_display_area.toggle_display_stat_area(false, null)
		
		
		
