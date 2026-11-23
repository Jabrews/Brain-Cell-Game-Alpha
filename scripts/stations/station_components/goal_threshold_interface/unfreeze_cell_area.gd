extends Area3D

func _ready() -> void:
	connect('body_entered', _handle_body_entered)

func _handle_body_entered(body : Node3D) :
	
	if body.is_in_group('brain_cell_container')	 :
		if body.designated_brain_cell : 
			GLCellManagerBus.emit_signal('toggle_lock_cell_pickup', body.designated_brain_cell.name, false)
