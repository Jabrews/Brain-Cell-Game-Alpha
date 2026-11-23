extends Area3D


@onready var parent_exsplosive_mutation_node : Node3D = $".."


func _ready() -> void:
	connect('body_entered', _handle_body_entered)
	

func _handle_body_entered(body : Node3D) :
	if body.is_in_group('player') : 
		GLPlayerState.player_refrence.queue_free()
		
	if body.is_in_group('brain_cell_container') :
		
		# prevent killing exsplosive parent cell container
		var cell_name : String = body.designated_brain_cell.name
		if cell_name == parent_exsplosive_mutation_node.parent_cell_container.designated_brain_cell.name : 
			return
		
		body.spawn_flesh_bug_on_death = false
		GLCellManagerBus.emit_signal('delete_selected_collected_cell', body.designated_brain_cell)
		
		
	if body.is_in_group('flesh_bug') : 
		body.queue_free()
	
	
		
		
		
		
		
	
	
	
		
		
		
	
	
