extends Area3D

@export var parent_disruptable_screen : Node2D

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


	
	
			
			
			
			
