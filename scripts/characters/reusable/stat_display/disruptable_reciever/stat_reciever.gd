extends Area3D

@export var parent_disruptable_screen : Node2D
@onready var parent_stat_display :Node3D =$"../.."
	
	
func _toggle_disrupt_manager(toggle_value : bool) :
	
	var is_disruptor : bool = verify_cell_is_not_disruptor()
	if is_disruptor : 
		return
	
	var disrupt_managers : Array[Node] = get_manager_node()
	
	for disrupt_manager : Node in disrupt_managers : 
		disrupt_manager._display_interuption(toggle_value)
	
func get_manager_node() :
	
	var disrupt_managers : Array[Node] = []	
	
	for node : Node in parent_disruptable_screen.get_children() :
		if node.name.contains('Manager')  and node.name.contains('Disruptor') :  
			disrupt_managers.append(node)
	
	return disrupt_managers


func verify_cell_is_not_disruptor() -> bool : 
	var parent_cell : BrainCell = parent_stat_display.parent_body.designated_brain_cell
	for mutation in parent_cell.mutations : 
		if mutation.type == 'disrupter' : 
			return true
	return false	
	
	
			
			
			
			
