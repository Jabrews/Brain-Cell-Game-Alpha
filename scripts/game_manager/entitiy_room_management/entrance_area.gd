extends Area3D

@export var room_type : String = 'none'


func _ready() -> void:
	connect('body_entered', _handle_body_entered)
	
func _handle_body_entered(body : Node3D) :
	if body.is_in_group('brain_cell_container') : 
		var designated_brain_cell = body.designated_brain_cell
		GLEntityRoomManagementBus.emit_signal('entity_changed_room', designated_brain_cell.name, room_type)
	elif body.is_in_group('player') :
		GLEntityRoomManagementBus.emit_signal('entity_changed_room', 'player', room_type)
	
