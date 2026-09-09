extends RayCast3D

var hologram_interact_area: Area3D = null


func _process(_delta: float) -> void:

	var collider := get_collider()
	
	# --- NOT LOOKING AT A HOLOGRAM ---
	if collider == null or not collider.is_in_group("hologram_interact_area"):
		_clear_hologram()
		return
		

	# --- SAME HOLOGRAM ---
	if collider == hologram_interact_area:
		
		if Input.is_action_just_pressed('interact') : 		
			hologram_interact_area.	_handle_hologram_interacted()
		
		
		return

	# --- TURN OFF PREVIOUS HOLOGRAM ---
	_clear_hologram()

	# --- SET NEW HOLOGRAM ---
	hologram_interact_area = collider as Area3D
	hologram_interact_area._toggle_hologram_hint(true)
	
	


func _clear_hologram() -> void:

	if hologram_interact_area == null:
		return

	hologram_interact_area._toggle_hologram_hint(false)
	hologram_interact_area = null


func interact() -> void:

	if hologram_interact_area == null:
		return

	hologram_interact_area._handle_hologram_interacted()
