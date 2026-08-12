extends Node

class_name EntityRoomProfile 

var entity_type: String
var entity_name: String
var room_name: String


@warning_ignore("shadowed_variable")
func _init(
	entity_type : String,
	entity_name : String,
	room_name : String,
) -> void:
	self.entity_type = entity_type
	self.entity_name = entity_name
	self.room_name = room_name

@warning_ignore("shadowed_global_identifier")
func _to_string() -> String:
	return "[entity room profile] | entity type : %s | entity name : %s | room name : %s " % [
		entity_type,
		entity_name,
		room_name,
	]
