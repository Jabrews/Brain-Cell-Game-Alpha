extends Area3D 


func _ready() -> void:
	connect('body_entered', _handle_body_entered)
	connect('body_exited', _handle_body_exited)

func _handle_body_entered(body : Node3D) :
	if body.is_in_group('brain_cell_container') :
		var designated_brain_cell : BrainCell = body.designated_brain_cell
		GLMutationSentientState.emit_signal('toggle_cell_near_death_event', true, designated_brain_cell.name)

func _handle_body_exited(body : Node3D) :
	if body.is_in_group('brain_cell_container') :
		var designated_brain_cell : BrainCell = body.designated_brain_cell
		GLMutationSentientState.emit_signal('toggle_cell_near_death_event', false, designated_brain_cell.name)
