extends Node


signal entity_changed_room(entity_name : String, room_name : String)

# should be state
var entity_room_profiles : Array[EntityRoomProfile]
