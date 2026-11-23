extends Area3D

func _ready() -> void:
	connect('body_entered', _handle_body_entered)

func _detect_entitys_in_door() :
	monitoring = true
	
	await get_tree().create_timer(0.5).timeout
	
	monitoring = false 

func _handle_body_entered(body : Node3D) :
	
	if body.is_in_group('player') :
		GLPlayerState.emit_signal('increment_player_health', -1)
		return
	
	elif body.is_in_group('brain_cell_container') :
		body.spawn_flesh_bug_on_death = false
		var designated_brain_cell : BrainCell = body.designated_brain_cell
		GLCellManagerBus.emit_signal('delete_selected_collected_cell', designated_brain_cell )
		return

	elif body.is_in_group('flesh_bug') :
		body.state_machine.switch_state(body.state_machine.State.DYING)		

	
		
	
	

	
	
	
	
	
	
	
		
	
	
