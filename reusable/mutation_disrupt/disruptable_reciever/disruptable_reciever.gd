extends Area3D

@export var parent_disruptable_screen : Node2D

#func _process(delta: float) -> void:	
	#if Input.is_action_just_pressed('debug1') :
		#_toggle_disrupt_manager(true)
	#elif Input.is_action_just_pressed('debug2') :
		#_toggle_disrupt_manager(false)
	
func _toggle_disrupt_manager(toggle_value : bool) :
	
	var disrupt_managers : Array[Node] = get_manager_node()
	
	for disrupt_manager : Node in disrupt_managers : 
		disrupt_manager._display_interuption(toggle_value)
	
func get_manager_node() :
	
	var disrupt_managers : Array[Node] = []	
	
	for node : Node in parent_disruptable_screen.get_children() :
		if node.name.contains('Manager')  and node.name.contains('Disruptor') :  
			disrupt_managers.append(node)
	
	return disrupt_managers
			
			
			
			
