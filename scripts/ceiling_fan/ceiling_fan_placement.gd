extends Node


class_name CeilingFanPlacement

var room : String
var coords: Vector3 

@warning_ignore("shadowed_variable")
func _init(
	room : String,
	coords : Vector3,
):
	self.room = room
	self.coords = coords

func _to_string() -> String:
	return "[ceiling fan placement] | room: %s | coords : %s" % [
		room,
		coords,
	]
